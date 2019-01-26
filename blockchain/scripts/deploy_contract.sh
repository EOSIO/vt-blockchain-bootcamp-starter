#!/usr/bin/env bash
set -o errexit

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd -P )"

if [ ! -e "${SOURCE_DIR}/first_time_setup.sh" ]
then
   printf "\n\tScript moved from blockchain/scripts directory.\n\n"
   exit -1
fi

CONTRACTSPATH="${SOURCE_DIR}/blockchain/contracts"

# make new directory for compiled contract files
mkdir -p "${SOURCE_DIR}/blockchain/compiled_contracts/$1"

COMPILEDCONTRACTSPATH="${SOURCE_DIR}/blockchain/compiled_contracts"

# unlock the wallet, ignore error if already unlocked
if [ ! -z $3 ]; then cleos wallet unlock -n $3 --password $4 || true; fi

# compile smart contract to wasm and abi files using EOSIO.CDT (Contract Development Toolkit)
# https://github.com/EOSIO/eosio.cdt
(
  eosio-cpp -abigen "$CONTRACTSPATH/$1/$1.cpp" -o "$COMPILEDCONTRACTSPATH/$1/$1.wasm" --contract "$1"
) &&

# set (deploy) compiled contract to blockchain
cleos set contract $2 "$COMPILEDCONTRACTSPATH/$1/" --permission $2
