#!/bin/bash

# Ensure root permissions
if [ "$(id -u)" -ne 0 ]; then
        printf "\n\tThis requires sudo. Please run with sudo.\n\n"
        exit -1
fi

# Install Dependencies
apt install -y curl sed jq

# Install Node.js and NPM
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs

# Get Binary Packages Information
UBUNTU_VERSION=$(lsb_release --release | cut -f2)
if [ "18.04" -eq "$UBUNTU_VERSION" ]; then
  EOSIO_DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/EOSIO/eos/releases/latest" | grep "browser_download_url.*ubuntu-18.04_amd64.deb" | cut -d ":" -f 2,3 | tr -d \")
elif [ "16.04" -eq "$UBUNTU_VERSION" ]; then
  EOSIO_DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/EOSIO/eos/releases/latest" | grep "browser_download_url.*ubuntu-16.04_amd64.deb" | cut -d ":" -f 2,3 | tr -d \")
else
  printf "\n\tEosio binaries are only available for Ubuntu 16.04 and 18.04.\n\n"
  exit -1
fi

EOSIO_FILENAME=$(echo $EOSIO_DOWNLOAD_URL | sed 's:.*/::')

CDT_DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/EOSIO/eosio.cdt/releases/latest" | grep "browser_download_url.*amd64.deb" | cut -d ":" -f 2,3 | tr -d \")
CDT_FILENAME=$(echo $CDT_DOWNLOAD_URL | sed 's:.*/::')

# Download and install packages

echo "Downloading and installing EOSIO package"
curl -sOL $EOSIO_DOWNLOAD_URL && dpkg -i $EOSIO_FILENAME || true
apt -f -y install
rm -f $EOSIO_FILENAME

echo "Downloading and installing EOSIO CDT package"
curl -sOL $CDT_DOWNLOAD_URL && dpkg -i $CDT_FILENAME
rm -f $CDT_FILENAME
