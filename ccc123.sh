#!/bin/bash

# Colors for prompts
BLUE='\033[0;44m'   # Blue background
GREEN='\033[0;42m'  # Green background
WHITE='\033[1;37m'  # White text
BLINK='\033[5m'     # Blinking effect
NC='\033[0m'        # No Color

# Counter to alternate colors
COUNTER=0

# Function to get alternating background color
get_bg_color() {
    if [ $((COUNTER % 2)) -eq 0 ]; then
        echo "$BLUE"
    else
        echo "$GREEN"
    fi
    ((COUNTER++))
}

# Update package list and install required packages
echo "Installing required packages..."
sudo apt update
sudo apt install -y zip msmtp cron mutt ca-certificates

# Enable cron service
sudo systemctl enable cron
sudo systemctl start cron

# Get folder selection from user with alternating background and blinking colon
BG_COLOR=$(get_bg_color)
echo -e "${BG_COLOR}${WHITE}Please select folder backup option${NC}"
echo -e "${BG_COLOR}${WHITE}1. Enter custom folders (separated by spaces)${NC}"
echo -e "${BG_COLOR}${WHITE}2. marzneshin${NC}"
echo -e -n "${BG_COLOR}${WHITE}Enter your choice (1 or 2)${BLINK}:${NC} "
read -r choice

case $choice in
    1)
        BG_COLOR=$(get_bg_color)
        echo -e -n "${BG_COLOR}${WHITE}Enter folders to backup (separate with spaces)${BLINK}:${NC} "
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
        ;;
    2)
        folders="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
        echo "Selected predefined marzneshin folders: $folders"
        # Verify predefined folders exist
        for folder in $folders; do
            if [ ! -d "$folder" ]; then
                echo "Warning: Folder '$folder' does not exist but will be included if created later"
            fi
        done
        ;;
    *)
        echo "Error: Invalid choice!"
        exit 1
        ;;
esac

# Get password for zip file
BG_COLOR=$(get_bg_color)
echo -e -n "${BG_COLOR}${WHITE}Enter password for zip file${BLINK}:${NC} "
read -s zip_password
echo ""
if [ -z "$zip_password" ]; then
    echo "Error: Password cannot be empty!"
    exit 1
fi

# Get email address
BG_COLOR=$(get_bg_color)
echo -e -n "${BG_COLOR}${WHITE}Enter your Gmail address${BLINK}:${NC} "
read -r email
if [ -z "$email" ]; then
    echo "Error: Email cannot be empty!"
    exit 1
fi

# Get email password
BG_COLOR=$(get_bg_color)
echo -e -n "${BG_COLOR}${WHITE}Enter your Gmail password (App Password if 2FA enabled)${BLINK}:${NC} "
read -s email_password
echo ""
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

chmod 600 "$MSMTP_CONFIG"

# Verify msmtp is installed and get its path
MSMTP_PATH=$(which msmtp)
if [ -z "$MSMTP_PATH" ]; then
    echo "Error: msmtp not found! Please ensure it is installed correctly."
    exit 1
fi

# Configure mutt to use msmtp explicitly
echo "set sendmail=\"$MSMTP_PATH\"" > ~/.muttrc

# Test email configuration
echo "Testing email configuration..."
echo "Test email from backup script" | mutt -s "Test Email" "$email" 2>/tmp/email_test_error
if [ $? -eq 0 ]; then
    echo "Email test successful!"
else
    echo "Email test failed! Check your credentials or configuration."
    echo "Detailed error:"
    cat /tmp/email_test_error
    rm -f /tmp/email_test_error
    exit 1
fi

# Get backup filename and email subject
BG_COLOR=$(get_bg_color)
echo -e -n "${BG_COLOR}${WHITE}Enter backup filename (without extension) and email subject${BLINK}:${NC} "
read -r backup_name
if [ -z "$backup_name" ]; then
    echo "Error: Backup name cannot be empty!"
    exit 1
fi

# Perform initial backup and send it
echo "Creating and sending initial backup..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
INITIAL_BACKUP_FILE="/tmp/${backup_name}_${TIMESTAMP}.zip"
zip -r -P "$zip_password" "$INITIAL_BACKUP_FILE" $folders >/tmp/initial_backup_log 2>&1
if [ $? -eq 0 ]; then
    echo "Initial backup created successfully on $TIMESTAMP" | mutt -s "${backup_name} $TIMESTAMP" -a "$INITIAL_BACKUP_FILE" -- "$email" >>/tmp/initial_backup_log 2>&1
    if [ $? -eq 0 ]; then
        echo "Initial backup sent successfully to $email"
    else
        echo "Failed to send initial backup! Check /tmp/initial_backup_log for details."
        cat /tmp/initial_backup_log
        rm -f /tmp/initial_backup_log
        exit 1
    fi
else
    echo "Failed to create initial backup! Check /tmp/initial_backup_log for details."
    cat /tmp/initial_backup_log
    rm -f /tmp/initial_backup_log
    exit 1
fi
rm -f "$INITIAL_BACKUP_FILE" /tmp/initial_backup_log

# Get cron interval
BG_COLOR=$(get_bg_color)
echo -e -n "${BG_COLOR}${WHITE}How often to run backup (in minutes)${BLINK}:${NC} "
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
BACKUP_FILE="/tmp/${backup_name}_\$TIMESTAMP.zip"
LOG_FILE="/tmp/backup_log_\$TIMESTAMP.txt"

# Create zip file with password
zip -r -P "$zip_password" "\$BACKUP_FILE" $folders > "\$LOG_FILE" 2>&1

if [ \$? -eq 0 ]; then
    # Send backup via email
    echo "Backup created successfully on \$TIMESTAMP" | mutt -s "${backup_name} \$TIMESTAMP" -a "\$BACKUP_FILE" -- "$email" >> "\$LOG_FILE" 2>&1
    
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

chmod +x "$BACKUP_SCRIPT"

# Add to cron
(crontab -l 2>/dev/null; echo "*/$minutes * * * * $BACKUP_SCRIPT") | crontab -

# Final message
if [ $? -eq 0 ]; then
    echo "Backup system setup successfully!"
    echo "Initial backup has been sent."
    echo "Future backups will run every $minutes minutes"
    echo "Files will be named: ${backup_name}_[TIMESTAMP].zip"
    echo "Email subject: ${backup_name} [TIMESTAMP]"
    echo "Sent to: $email"
    echo "Files are encrypted with ZIP password"
else
    echo "Failed to setup backup system!"
    exit 1
fi
