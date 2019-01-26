#!/usr/bin/env bash
set -o errexit

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e "${SOURCE_DIR}/blockchain/data/initialized" ]
then
    "${SOURCE_DIR}/blockchain/scripts/continue_blockchain.sh"
else
    "${SOURCE_DIR}/blockchain/scripts/init_blockchain.sh"
fi