# Make Data Directory
mkdir -p "$(pwd)/blockchain/data"

curl --output /dev/null \
    --silent \
    --head \
    --fail \
    localhost:8888

retval=$?
if [ $retval == 0 ]; then
    echo "You have a process already using port 8888, which is preventing nodeos from starting"
    exit 1
fi

# Start Nodeos
nodeos -e -p eosio -d "$(pwd)/blockchain/data" \
    --config-dir "$(pwd)/blockchain/data/config" \
    --http-validate-host=false \
    --plugin eosio::chain_plugin \
    --plugin eosio::producer_plugin \
    --plugin eosio::chain_api_plugin \
    --plugin eosio::http_plugin \
    --http-server-address=0.0.0.0:8888 \
    --access-control-allow-origin=* \
    --contracts-console \
    --verbose-http-errors > "$(pwd)/blockchain/data/nodeos.log" 2>&1 </dev/null &

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

# Sleep for 2 to allow time 4 blocks to be created so we have blocks to reference when sending transactions
sleep 2s
echo "=== setup wallet: eosiomain ==="
# First key import is for eosio system account
cleos wallet create -n eosiomain --to-console | tail -1 | sed -e 's/^"//' -e 's/"$//' > "$(pwd)/blockchain/data/eosiomain_wallet_password.txt"
cleos wallet import -n eosiomain --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

echo "=== setup wallet: notechainwal ==="
# key for eosio account and export the generated password to a file for unlocking wallet later
cleos wallet create -n notechainwal --to-console | tail -1 | sed -e 's/^"//' -e 's/"$//' > "$(pwd)/blockchain/data/notechain_wallet_password.txt"
# Owner key for notechainwal wallet
cleos wallet import -n notechainwal --private-key 5JpWT4ehouB2FF9aCfdfnZ5AwbQbTtHBAwebRXt94FmjyhXwL4K
# Active key for notechainwal wallet
cleos wallet import -n notechainwal --private-key 5JD9AGTuTeD5BXZwGQ5AtwBqHK21aHmYnTetHgk1B3pjj7krT8N

# * Replace "notechainwal" by your own wallet name when you start your own project

# create account for notechainacc with above wallet's public keys
cleos create account eosio notechainacc EOS6PUh9rs7eddJNzqgqDx1QrspSHLRxLMcRdwHZZRL4tpbtvia5B EOS8BCgapgYA2L4LJfCzekzeSr3rzgSTUXRXwNi8bNRoz31D14en9

# * Replace "notechainacc" by your own account name when you start your own project

echo "=== deploy smart contract ==="
# $1 smart contract name
# $2 account holder name of the smart contract
# $3 wallet for unlock the account
# $4 password for unlocking the wallet
$(pwd)/blockchain/scripts/deploy_contract.sh notechain notechainacc notechainwal $(cat ./blockchain/data/notechain_wallet_password.txt)

echo "=== create user accounts ==="
# script for create data into blockchain
$(pwd)/blockchain/scripts/create_accounts.sh

# * Replace the script with different form of data that you would pushed into the blockchain when you start your own project

echo "=== end of setup blockchain accounts and smart contract ==="
# create a file to indicate the blockchain has been initialized
touch "$(pwd)/blockchain/data/initialized"

tail -f "$(pwd)/blockchain/data/nodeos.log"
