#!/bin/bash

# GitHub repo: https://github.com/haithamaouati/Termux.git

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
