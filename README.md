# Overview
NoteChain demonstrates the eosio platform running a blockchain as a local single node test net with a simple web app, NoteChain. NoteChain allows users to create and update notes. This guide uses scripts, containing relevant commands, which will show you how to install, build and run NoteChain, and by doing so will demonstrate:

- Setting up and running a local single node testnet;
- Setting up wallets, keys, and accounts;
- Writing and deploying a smart contract;
- Implementing a web based UI using React;
- Connecting the UI to the blockchain using eosjs;
- Styling the UI using Material-UI.

vt-blockchain-bootcamp-starter (https://github.com/EOSIO/vt-blockchain-bootcamp-starter) contains the UI and Smart Contract code, as well as setup scripts which will initialise and start all the necessary components.

The sample web app demonstrates storing data in multi index table and retrieving this data into the web based UI. NoteChain is a simple note taking application, where notes are tied to user accounts. For this example, all accounts are pre-created by scripts and the account details are displayed at the bottom of the NoteChain UI.

Each account can then be used to add a note to the blockchain. The individual notes are saved in a multi-index table and for simplicity are of fixed width. Each account may have one note attached to it, adding a note to an account with an existing note will replace the existing note with a new note.

**Any private keys you see in this repository are for demo purposes only. For a real web app NEVER expose the private keys.**

# Prerequisites

Make sure Node.js is installed

* Install Node.js: https://nodejs.org/en/

The web app and eosio will occupy the ports 3000, 8888 and 9876. Make sure nothing else is already running on these ports.

Clone the repository:
```sh
git clone https://github.com/EOSIO/vt-blockchain-bootcamp-starter
```

The following guide assumes you are using macOS.

# Detailed guide

In this section we will describe in detail each script used to run the NoteChain environment in details.

## Initial setup

```sh
./first_time_setup.sh
```

Executing the above shell script verifies that all dependencies are installed. It then downloads and installs the eosio and eosio.cdt binary packages, and installs node packages for the frontend react app.

## Initialise and start blockchain and web app

After the initialisation, two terminal windows are required, both opened in the repository directory

- The **first terminal window** is for **blockchain** process.
- The **second terminal window** is for **frontend** react app.

**running the blockchain**

For the first (blockchain) terminal window, running
```sh
./start_blockchain.sh
```
will:

- Start the eosio blockchain
- Create smart contract owner account,
- Deploy smart contract
- Pre-create 7 user accounts with hard coded keys.

eosio is now running and starts producing blocks.

**running the web app**

For the second (frontend) terminal window, running
```sh
./start_frontend.sh
```
will open a browser session connecting to http://localhost:3000/ showing the react app. You can try to add or remove notes using one of the pre-created accounts with its key on the website. This react app will interact with the smart contract, performing transactions, which are written to the blockchain, which stores note data in the multi index table of the smart contract running on your local nodeos.

## Stopping blockchain or web app

**stopping the blockchain**

In the (blockchain) terminal window, simply execute:
```sh
killall nodeos
```

This action will take a few seconds. The blockchain will be stopped.

**stopping the web app**

In the (frontend) terminal window, press `ctrl+c` on your keyboard. The frontend react app will be stopped.

## Restarting blockchain or web app

**restarting the blockchain**

In the (blockchain) terminal window, execute this command:
```sh
./start_blockchain.sh
```

The blockchain will be resumed automatically and the log will be output to data/nodeos.log.

**restarting the web app**

In the second (frontend) terminal window, you can restart the frontend react app by executing:
```sh
./start_frontend.sh
```

## Reset blockchain and data. Remove installed packages.

First, you need to stop the blockchain (as above) and then execute:
```sh
./reset_everything.sh
```

This removes all data on the blockchain, including accounts, deployed smart contracts, etc... The block count will be reset when you start the blockchain again.

## Project structure

```js
vt-blockchain-bootcamp-starter // project directory
└── blockchain
│   └── contracts // this folder contains the smart contracts
│   │   └── notechain
│   │   │   └── notechain.cpp // the main smart contract
│   └── data // blockchain data, generated after first_time_setup.sh
│   │   └── blocks
│   │   ├── config
│   │   ├── state
│   │   ├── initialized // to indicate whether the blockchain has been initialized or not
│   └── scripts // scripts and utilities
│       └── accounts.json // pre-create account names, public and private keys (for demo only)
│       ├── continue_blockchain.sh // continue the stopped blockchain
│       ├── create_accounts.sh // create account data
│       ├── deploy_contract.sh // deploy contract
│       └── init_blockchain.sh // script for creating accounts and deploying contract on blockchain
└── scripts
│   └── install_darwin.sh // Installs dependencies and packages for MacOS
│   └── install_debian.sh // Installs dependencies and packages for Debian based OS's
└── frontend
│   ├── node_modules // generated after npm install
│   ├── public
│   │   └── index.html // html skeleton for create react app
│   ├── src
│   │   ├── pages
│   │   │   └── index.jsx // an one-pager jsx, include react component and Material-UI
│   │   └── index.js // for react-dom to render the app
│   ├── package-lock.json // generated after npm install
│   └── package.json // for npm packages
└── first_time_setup.sh // Run this to install all required software to make this project function
├── README.md // This document
├── reset_everything.sh // Run this to reset blockchain and wallet state, as well as remove installed packages
├── start_blockchain.sh // Run this to start/resume the blockchain
└── start_frontend.sh // Run this to start the frontend, and launch it in a browser

```

## DApp development

The DApp consists of two parts. eosio blockchain and frontend react app. These can be found in:

- blockchain
    - eosio block producing node (local node)
        - 1 smart contract
        - auto smart contract deployment
        - auto create 7 user accounts
- frontend
    - node.js development environment
        - create-react-app: http://localhost:3000/

Users interact with the UI in client and sign the transaction in frontend. The signed transaction (which is an `update` action in this demo DApp) is sent to the blockchain directly. After the transaction is accepted in blockchain, the note is added into the multi index table in blockchain.

The UI, index.jsx, reads the notes data directly from nodeos using 'getTableRows()'. The smart contract, notechain.cpp, stores these notes in the multi index table using 'emplace()'' and 'modify()'.

## Smart contract (Blockchain):

The smart contract can be found at `blockchain/contracts/notechain/notechain.cpp`(host environment), you can edit this smart contract. You will then need to compile and deploy the contract to the blockchain.

To save time, we prepared some scripts for you. Execute the scripts in the container bash (see above.)

The following script will help you to unlock the wallet, compile the modified contract and deploy to blockchain. 1st parameter is the contract name; 2nd parameter is the account name of the contract owner, 3rd and 4th parameter references  wallet related information that was created during the `Initial setup`:

```sh
./blockchain/scripts/deploy_contract.sh notechain notechainacc notechainwal $(cat ./blockchain/data/notechain_wallet_password.txt)
```

After running this script the modified smart contract will be deployed on the blockchain.

Remember to redeploy the NoteChain contract each time you modify it using the steps above!

## Frontend:

The UI code can be found at `frontend/src/pages/index.jsx`(host environment), once you have edited this code the frontend react app compile automatically and the page on browser will be automatically refreshed. You can see the change on the browser once the browser finishes loading.
