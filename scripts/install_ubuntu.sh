#!/bin/bash

# Ensure root permissions
if [ "$(id -u)" -ne 0 ]; then
        printf "\n\tThis requires sudo. Please run with sudo.\n\n"
        exit -1
fi 

# Install Dependencies
apt install -y curl sed

# Install jq
mkdir -p ~/bin && curl -sSL -o ~/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ~/bin/jq && export PATH=$PATH:~/bin

# Install Node.js and NPM
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs

# Get Binary Packages Information
EOSIO_DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/EOSIO/eos/releases/latest" | grep "browser_download_url.*ubuntu-18.04_amd64.deb" | cut -d ":" -f 2,3 | tr -d \")
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