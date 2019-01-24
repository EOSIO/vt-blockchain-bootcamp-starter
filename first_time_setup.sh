#!/usr/bin/env bash
set -o errexit

ARCH=$( uname )
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$ARCH" == "Linux" ]; then

    if [ ! -e /etc/os-release ]; then
        printf "\\n\\tThis boilerplate only supports MacOS and Debian based operating systems.\\n"
        printf "\\tPlease install on the latest version of one of these Linux distributions.\\n"
        printf "\\thttps://linuxmint.com/\\n"
        printf "\\thttps://www.ubuntu.com/\\n"
        printf "\\tExiting now.\\n"
        exit 1
    fi

    OS_NAME=$( cat /etc/os-release | grep ^NAME | cut -d'=' -f2 | sed 's/\"//gI' )

    case "$OS_NAME" in
        "elementary OS")
        FILE="${SOURCE_DIR}/scripts/install_ubuntu.sh"
        ;;
        "Linux Mint")
        FILE="${SOURCE_DIR}/scripts/install_ubuntu.sh"
        ;;
        "Ubuntu")
        FILE="${SOURCE_DIR}/scripts/install_ubuntu.sh"
        ;;
        "Debian GNU/Linux")
        FILE="${SOURCE_DIR}/scripts/install_ubuntu.sh"
        ;;
        *)
        printf "\\n\\tUnsupported Linux Distribution. Exiting now.\\n\\n"
        exit 1
    esac
fi

if [ "$ARCH" == "Darwin" ]; then
    FILE="${SOURCE_DIR}/scripts/install_darwin.sh"
fi

echo "=== start of first time setup ==="

. "$FILE"

# set up node_modules for frontend
echo "=== npm install package for frontend react app ==="
# change directory to ./frontend
cd "./frontend"
npm install

echo "First time setup is complete."
