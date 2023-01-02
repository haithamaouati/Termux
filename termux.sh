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

#!/bin/bash

# Check if the --version flag was passed
if [[ $1 == "--version" ]]; then
  # Read the version from the VERSION file
  version=$(cat VERSION)

  # Print the version of the script
  $0
  echo "Version $version"
  exit 0
fi

main_menu() {
  while true; do
    echo "Main menu:"
    echo "1. Update packages"
    echo "2. Upgrade packages"
    echo "3. Install packages"
    echo "4. Update repo
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
  pkg install -y termux-tools android-tools ncurses-utils proot tsu git wget curl nano htop python python2 python3 openssh neofetch screenfetch cpufetch zip unzip unrar figlet cowsay
  pkg update -y
  pkg upgrade -y
}

update_repo() {
  # Check if a repository URL was provided
  if [ -z "$1" ]; then
    echo "Error: No repository URL provided."
    return 1
  fi

  # Clone the repository if it doesn't exist locally
  if [ ! -d .git ]; then
    git clone "$1" .
  fi

  # Navigate to the directory where the repository is located
  cd "$(dirname "$0")"

  # Check if the repository is a Git repository
  if [ ! -d .git ]; then
    echo "Error: This is not a Git repository."
    return 1
  fi

  # Download the latest version number from the repository
  remote_version=$(wget -qO- https://raw.githubusercontent.com/haithamaouati/Termux/main/VERSION)

  # Read the local version number from the VERSION file
  local_version=$(cat VERSION)

  # Compare the version numbers
  if [ "$remote_version" = "$local_version" ]; then
    # The local version is up to date
    echo "No updates available."
    return 0
  fi

  # Print a message indicating that an update is available
  echo "An update is available. Do you want to update now? (y/n)"
  read -r confirm

  if [ "$confirm" = "y" ]; then
    # Fetch the latest changes from the repository
    git fetch

    # Perform the update
    git pull

    # Overwrite the local VERSION file with the updated version number
    echo "$remote_version" > VERSION

    echo "Update complete."
  else
    echo "Update canceled."
  fi
}

exit_script() {
  read -p "Are you sure you want to exit? (y/n) " confirm
  if [ "$confirm" = "y" ]; then
    exit 0
  fi
}

main_menu
