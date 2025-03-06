# Test email configuration
echo "Testing email configuration..."
MSMTP_PATH=$(which msmtp)
if [ -z "$MSMTP_PATH" ]; then
    echo "Error: msmtp not found! Please ensure it is installed."
    exit 1
fi

# Set mutt to use msmtp explicitly
echo "set sendmail=\"$MSMTP_PATH\"" > ~/.muttrc
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
