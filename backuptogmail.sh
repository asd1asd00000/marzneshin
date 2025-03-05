#!/bin/bash

# Grant execute permission to this script (optional, only needed if copied to a new system without execute permission)
# chmod +x "$0"  # $0 refers to the current script (setup_backup.sh)

# Define color codes
YELLOW='\033[33m'
NC='\033[0m' # No Color

# Function to install required packages
install_requirements() {
    echo "Checking and installing required packages..."
    sudo apt update > /dev/null 2>&1
    for package in p7zip-full ssmtp mutt cron gpgsm nano; do
        if ! command -v ${package%-*} >/dev/null 2>&1; then
            echo "Installing $package..."
            sudo apt install -y "$package" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "$package installed successfully."
            else
                echo "Failed to install $package! Please install it manually and rerun the script."
                exit 1
            fi
        else
            echo "$package is already installed."
        fi
    done
}

# Install required packages
install_requirements

# Get user input with numbered prompts in yellow
echo -e "${YELLOW}1 - Please select the folder(s) to back up:${NC}"
echo "  1) Enter folder paths manually (separate with spaces)"
echo "  2) MARZNESHIN"
read -p "Enter 1 or 2: " folder_choice
case $folder_choice in
    1)
        echo "Please enter the folder paths to back up (separate with spaces):"
        read folders
        ;;
    2)
        folders="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
        echo "Selected folder: /etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
        ;;
    *)
        echo "Invalid choice! Defaulting to /etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
        folders="/etc/opt/marzneshin/ /var/lib/marzneshin/ /var/lib/marznode/"
        ;;
esac
echo -e "${YELLOW}2 - Please enter the sender's email address (Gmail):${NC}"
read email
echo -e "${YELLOW}3 - Please enter the Gmail App Password:${NC}"
read -s password
echo -e "${YELLOW}4 - Please enter the name for the backup file and email subject (without extension):${NC}"
read backup_name
echo -e "${YELLOW}5 - Please enter the password for compressing the backup file:${NC}"
read -s zip_password
echo "Backup password set successfully!"
echo -e "${YELLOW}6 - Please enter the backup sending interval in minutes (e.g., 60 for every hour):${NC}"
read backup_interval

# Configure ssmtp
sudo bash -c "cat > /etc/ssmtp/ssmtp.conf << EOL
root=$email
mailhub=smtp.gmail.com:587
AuthUser=$email
AuthPass=$password
UseSTARTTLS=YES
EOL"

# Configure muttrc
cat > ~/.muttrc << EOL
set ssl_starttls=yes
set ssl_force_tls=yes
set smtp_url="smtp://$email@smtp.gmail.com:587/"
set smtp_pass="$password"
set from="$email"
set realname="Backup Script"
EOL

# Create backup script
cat > ~/backup_script.sh << EOL
#!/bin/bash
TIMESTAMP=\$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$backup_name-\$TIMESTAMP.7z"
ZIP_PASS="$zip_password"
SUBJECT="$backup_name - \$TIMESTAMP"

# Compressing with full path
echo "Compressing..."
7z a -spf -p"\$ZIP_PASS" "\$BACKUP_FILE" $folders > /dev/null 2>&1
if [ \$? -ne 0 ]; then
    echo "Compression failed!"
    exit 1
fi

# Testing compressed file
echo "Testing compressed file..."
7z t -p"\$ZIP_PASS" "\$BACKUP_FILE" > /dev/null 2>&1
if [ \$? -ne 0 ]; then
    echo "Compressed file is corrupted or password is incorrect!"
    rm "\$BACKUP_FILE"
    exit 1
fi

# Sending to email
echo "Sending to email..."
echo "Backup file \$TIMESTAMP created successfully" | mutt -s "\$SUBJECT" -a "\$BACKUP_FILE" -- $email
if [ \$? -ne 0 ]; then
    echo "Email sending failed!"
    exit 1
fi

# Remove temporary file
rm "\$BACKUP_FILE"
echo "Backup successfully sent!"
EOL

# Grant execute permission to the backup script
chmod +x ~/backup_script.sh

# Run the backup script immediately
echo "Creating and sending the first backup..."
bash ~/backup_script.sh

# Set up cron job for future runs
(crontab -l 2>/dev/null; echo "*/$backup_interval * * * * /bin/bash ~/backup_script.sh") | crontab -

echo "Script successfully set up!"
echo "The first backup has been sent to $email. Future backups will be sent every $backup_interval minutes."
