#!/bin/bash

# Author: Haitham Aouati
# GitHub: https://github.com/haithamaouati

clear

if [ "$EUID" -eq 0 ]; then
  echo "This script should not be run as root. Exiting."
  exit 1
fi

# Check if script is running on Termux
if [ -n "$TERMUX" ]; then
  termux-setup-storage
  main_menu
else
  exit
fi

# Check if figlet package is installed
if ! command -v figlet > /dev/null; then
  pkg install -y figlet
fi

# Print "Termux" using figlet and the standard font
figlet -f standard "Termux"

main_menu() {
  while true; do
    echo "Main menu:"
    echo "1. Update packages"
    echo "2. Upgrade packages"
    echo "3. Install packages"
    echo "4. Update repo"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
      1) update_packages;;
      2) upgrade_packages;;
      3) install_packages;;
      4) update_repo https://github.com/haithamaouati/Termux.git;;
      5) exit_script;;
      *)
        # Invalid input
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

update_packages() {
  pkg update -y
}

upgrade_packages() {
  pkg upgrade -y
}

install_packages() {
  pkg install -y termux-tools android-tools ncursed-utils proot tsu git wget curl nano htop python python2 python3 openssh neofetch screenfetch cpufetch zip unzip unrar figlet cowsay
  pkg update -y
  pkg upgrade -y
}

exit_script() {
  read -p "Are you sure you want to exit? (y/n) " confirm
  if [ "$confirm" = "y" ]; then
    exit 0
  fi
}

main_menu
