#!/usr/bin/env bash
set -o errexit

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )"

if [ ! -e "${SOURCE_DIR}/first_time_setup.sh" ]
then
   printf "\n\tScript moved from blockchain/scripts directory.\n\n"
   exit -1
fi

# this file is used to continue the stopped blockchain

echo "=== continuing existing blockchain ==="

# set -m leads nodeos process running in the background on control+C
# which means subsequent runs fail due to an "Address already in use" error.
# And that is the best case. Worst case if two nodeos instances run, they
# can corrupt the block log.
#set -m

# start nodeos ( local node of blockchain )
# run it in a background job such that docker run could continue
nodeos -e -p eosio -d "${SOURCE_DIR}/blockchain/data" \
  --config-dir "${SOURCE_DIR}/blockchain/data/config" \
  --hard-replay \
  --http-validate-host=false \
  --plugin eosio::producer_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::http_plugin \
  --http-server-address=0.0.0.0:8888 \
  --access-control-allow-origin=* \
  --contracts-console \
  --verbose-http-errors > "${SOURCE_DIR}/blockchain/data/nodeos.log" 2>&1 </dev/null &

# `--hard-replay` option is needed
# because the docker stop signal is not being passed to nodeos process directly
# as we run the init_blockchain.sh as PID 1.

# QUESTION: Can we avoid the --hard-replay since vt-blockchain-bootcamp-server is not meant to be run in a Docker container?
# Running --hard-replay each time is inefficient and pollutes the data directory with many copies of the blocks database.


until $(curl --output /dev/null \
            --silent \
            --head \
            --fail \
            localhost:8888/v1/chain/get_info)
do
    echo "Waiting for EOSIO blockchain to be started..."
    sleep 2s
done

echo "EOSIO Blockchain Started"

tail -f "${SOURCE_DIR}/blockchain/data/nodeos.log"
