#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y zip

# Get user's desktop path
desktop="$HOME/Desktop"

# Function to create backup
create_backup() {
    local backup_name="$1"
    local dirs=("${@:2}")
    local timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
    local zip_file="$desktop/${backup_name}_${timestamp}.zip"
    
    # Check if all directories exist
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Error: Directory $dir does not exist. Skipping..."
            exit 1
        fi
    done
    
    # Create zip file
    zip -r "$zip_file" "${dirs[@]}"
    
    if [ $? -eq 0 ]; then
        echo "Backup created successfully at: $zip_file"
    else
        echo "Backup failed!"
        exit 1
    fi
}

# Main menu
echo "Select backup option:"
echo "1. Enter custom folder addresses"
echo "2. Backup Marzneshin on local (predefined paths)"

read -p "Enter your choice (1/2): " choice

case $choice in
    1)
        read -p "Enter folder paths separated by spaces: " -a custom_dirs
        create_backup "custom_backup" "${custom_dirs[@]}"
        ;;
    2)
        predefined_dirs=("/etc/opt/marzneshin/" "/var/lib/marzneshin/" "/var/lib/marznode/")
        create_backup "marzneshin" "${predefined_dirs[@]}"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
