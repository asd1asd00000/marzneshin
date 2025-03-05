#!/bin/bash

# Update package list and install required packages
echo "Installing required packages..."
sudo apt update
sudo apt install -y zip msmtp cron mutt

# Enable cron service
sudo systemctl enable cron
sudo systemctl start cron

# Get folders to backup from user
echo "Please enter the folders you want to backup (separate multiple paths with spaces):"
read -r folders
if [ -z "$folders" ]; then
    echo "Error: No folders specified!"
    exit 1
fi

# Verify folders exist
for folder in $folders; do
    if [ ! -d "$folder" ]; then
        echo "Error: Folder '$folder' does not exist!"
        exit 1
    fi
done

# Get password for zip file
echo "Please enter a password for the zip file:"
read -s zip_password
if [ -z "$zip_password" ]; then
    echo "Error: Password cannot be empty!"
    exit 1
fi

# Get email address
echo "Please enter your Gmail address:"
read -r email
if [ -z "$email" ]; then
    echo "Error: Email cannot be empty!"
    exit 1
fi

# Get email password
echo "Please enter your Gmail password (App Password if 2FA is enabled):"
read -s email_password
if [ -z "$email_password" ]; then
    echo "Error: Email password cannot be empty!"
    exit 1
fi

# Create msmtp configuration file
MSMTP_CONFIG="$HOME/.msmtprc"
cat > "$MSMTP_CONFIG" << EOL
# Gmail SMTP configuration
account gmail
host smtp.gmail.com
port 587
auth on
user $email
password $email_password
from $email
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default : gmail
EOL

# Set appropriate permissions
chmod 600 "$MSMTP_CONFIG"

# Test email configuration
echo "Testing email configuration..."
echo "Test email from backup script" | mutt -s "Test Email" "$email" 2>/tmp/email_test_error
if [ $? -eq 0 ]; then
    echo "Email test successful!"
else
    echo "Email test failed! Check your credentials."
    cat /tmp/email_test_error
    rm -f /tmp/email_test_error
    exit 1
fi

# Get cron interval in minutes
echo "How often do you want to run the backup (in minutes)?"
read -r minutes
if ! [[ "$minutes" =~ ^[0-9]+$ ]] || [ "$minutes" -lt 1 ]; then
    echo "Error: Please enter a valid number of minutes!"
    exit 1
fi

# Create backup script
BACKUP_SCRIPT="$HOME/backup_script.sh"
cat > "$BACKUP_SCRIPT" << EOL
#!/bin/bash

TIMESTAMP=\$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="/tmp/backup_\$TIMESTAMP.zip"
LOG_FILE="/tmp/backup_log_\$TIMESTAMP.txt"

# Create zip file with password
zip -r -P "$zip_password" "\$BACKUP_FILE" $folders > "\$LOG_FILE" 2>&1

if [ \$? -eq 0 ]; then
    # Send backup via email
    echo "Backup created successfully on \$TIMESTAMP" | mutt -s "Backup \$TIMESTAMP" -a "\$BACKUP_FILE" -- "$email" >> "\$LOG_FILE" 2>&1
    
    if [ \$? -eq 0 ]; then
        echo "Backup sent successfully to $email" >> "\$LOG_FILE"
    else
        echo "Failed to send backup to $email" >> "\$LOG_FILE"
    fi
else
    echo "Failed to create backup!" >> "\$LOG_FILE"
fi

# Cleanup
rm -f "\$BACKUP_FILE"
EOL

# Make backup script executable
chmod +x "$BACKUP_SCRIPT"

# Add to cron
(crontab -l 2>/dev/null; echo "*/$minutes * * * * $BACKUP_SCRIPT") | crontab -

# Final message
if [ $? -eq 0 ]; then
    echo "Backup system setup successfully!"
    echo "Backups will run every $minutes minutes"
    echo "Files will be sent to: $email"
    echo "Check your email for the test message"
else
    echo "Failed to setup backup system!"
    exit 1
fi
