#!/usr/bin/env bash
set -o errexit

# this file is used to continue the stopped blockchain

echo "=== continuing existing blockchain ==="

set -m

# start nodeos ( local node of blockchain )
# run it in a background job such that docker run could continue
nodeos -e -p eosio -d "$(pwd)/blockchain/data" \
  --config-dir "$(pwd)/blockchain/data/config" \
  --hard-replay \
  --http-validate-host=false \
  --plugin eosio::producer_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::http_plugin \
  --http-server-address=0.0.0.0:8888 \
  --access-control-allow-origin=* \
  --contracts-console \
  --verbose-http-errors > "$(pwd)/blockchain/data/nodeos.log" 2>&1 </dev/null &

# `--hard-replay` option is needed
# because the docker stop signal is not being passed to nodeos process directly
# as we run the init_blockchain.sh as PID 1.

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

tail -f "$(pwd)/blockchain/data/nodeos.log"
