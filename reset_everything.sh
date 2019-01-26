#!/usr/bin/env bash
set -o errexit

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function removeDeps {
    echo "=== removing binary packages ==="
    ARCH=$( uname )

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
            "elementary OS" | "Linux Mint" | "Ubuntu" | "Debian GNU/Linux")
                dpkg -r eosio
                dpkg -r eosio.cdt
                apt -f install
                apt -y autoremove
            ;;
            *)
            printf "\\n\\tUnsupported Linux Distribution. Exiting now.\\n\\n"
            exit 1
        esac
    fi

    if [ "$ARCH" == "Darwin" ]; then
        brew remove eosio
        brew remove eosio.cdt
        brew remove node
        brew remove jq
    fi
}

echo "=== Stopping all running processes ==="

killall nodeos || true
killall keosd || true
echo "All processes have been terminated."

echo "=== removing wallet information ==="

cleos wallet stop || true
rm ~/eosio-wallet/eosiomain.wallet || true
rm ~/eosio-wallet/notechainwal.wallet || true

echo "Wallet has been reset."

echo "=== removing blockchain data ==="

rm -rf "${SOURCE_DIR}/blockchain/data" || true

echo "=== removing frontend node modules ==="

rm -rf "${SOURCE_DIR}/frontend/node_modules" || true
rm "${SOURCE_DIR}/frontend/package-lock.json" || true

echo "Would you like to remove the binary packages that were installed?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) removeDeps; break;;
        No ) break;;
    esac
done

echo "Reset complete."