#!/bin/bash
nodeos_is_started=$(pgrep nodeos)

if [[ nodeos_is_started -ne 0 ]]; then
    echo 'Nodeos is already started!'
else
    nodeos --config-dir ~/eosio/chain/config --data-dir ~/eosio/chain/data -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_plugin --plugin eosio::history_api_plugin --contracts-console
fi