#!/bin/zsh

source install/common.sh

print_note "Installing webapps"

webapp-install "Gmail" "https://mail.google.com/mail" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/gmail.png"
webapp-install "Messages" "https://messages.google.com/web/" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-messages.png"
