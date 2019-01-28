#!/bin/bash
set -o errexit

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )"

if [ ! -e "${SOURCE_DIR}/first_time_setup.sh" ]
then
   printf "\n\tScript moved from blockchain/scripts directory.\n\n"
   exit -1
fi

# loop through the array in the json file, import keys and create accounts
# these pre-created accounts will be used for saving / erasing notes
# we hardcoded each account name, public and private key in the json.
# NEVER store the private key in any source code in your real life developmemnt
# This is just for demo purpose

jq -c '.[]' "${SOURCE_DIR}/blockchain/scripts/accounts.json" | while read i; do
  name=$(jq -r '.name' <<< "$i")
  pub=$(jq -r '.publicKey' <<< "$i")

  # to simplify, we use the same key for owner and active key of each account
  cleos create account eosio $name $pub $pub
done
