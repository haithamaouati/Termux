#!/bin/bash

# Author: Haitham Aouati
# GitHub: https://github.com/haithamaouati

clear

if [ "$EUID" -eq 0 ]; then
  echo "This script should not be run as root. Exiting."
  exit 1
fi

main_menu() {
  while true; do
    echo "Main menu:"
    echo "1. Update packages"
    echo "2. Upgrade packages"
    echo "3. Install needed packages"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
      1) update_packages;;
      2) upgrade_packages;;
      3) install_packages;;
      4) exit_script;;
      *)
        # Invalid input
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

update_packages() {
  pkg update
}

upgrade_packages() {
  pkg upgrade
}

install_packages() {
  pkg install -y git wget curl nano htop python python2 python3
}

exit_script() {
  read -p "Are you sure you want to exit? (y/n) " confirm
  if [ "$confirm" = "y" ]; then
    exit 0
  fi
}

main_menu
