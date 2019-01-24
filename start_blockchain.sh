#!/usr/bin/env bash
set -o errexit

if [ -e "$(pwd)/blockchain/data/initialized" ]
then
    "$(pwd)/blockchain/scripts/continue_blockchain.sh"
else
    "$(pwd)/blockchain/scripts/init_blockchain.sh"
fi