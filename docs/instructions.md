# Before we Begin

## Terminal

Throughout this guide we will be referring to the CLI (Command Line Interface) as "Terminal." Depending upon your system of choice, your "Terminal" will be located in one of three places.

1. If on Mac OS X or Linux, open the application "Terminal"
2. If using Windows Subsystem for Linux your "Terminal" is the **Ubuntu 18.04** application. 
3. If using a VM through VirtualBox on older versions of Windows 10, your terminal is the "Terminal" application inside the Ubuntu 18.04 VM.

Please open your "Terminal" now.

## C++ coding environment setup

We can use any text editor that, preferrably, supports c++ highlighting. If you already have an editor/IDE that you are familiar and comfortable with, please use it.

However, if you do not presently have an Editor, we suggest downloading [VS Code](), it's free, simple to use and works well with C++ development. 

**Remember: If you're using Ubuntu from a VirtualBox Virtual Machine, download your editor from _inside the VM_**

# Create a Project Directory

You'll need a project to work from for the duration of this guide. To make things easy, we're asking that you follow our directory naming exactly, as it will enable you to follow our guide far more easily.

## Windows Subsystem for Linux ##

From your Ubuntu 18.04 terminal, enter the following

```bash
mkdir /mnt/c/VTBootCamp
cd ~
ln -s /mnt/c/VTBootCamp
cd ~/VTBootCamp
```

Some instructions below will ask you to create and modify files. You can either use a terminal based editor (vim, nano, etc) within the Ubuntu 18.04 terminal, or you can use a gui based editor within Windows. All the files can be found at `C:\VTBootCamp`. You may edit them there, and then resume the tutorial in the Ubuntu 18.04 terminal.

## MacOS and Ubuntu 18.04 ##

Enter the following into terminal

```bash
mkdir ~/VTBootCamp
```

To create the *VTBootCamp* directory in your home directory. 

Change to the home directory.

```bash
cd ~/VTBootCamp
``` 

# Start your dev environment:

## Download VT Blockchain Bootcamp Starter Kit 

The starter kit repository contains an example contract, a frontend that exposes the functionality of the contract and some convenience scripts for managing the blockchain. For more information about the starter kit, see the [Github Repo](https://github.com/EOSIO/vt-blockchain-bootcamp-starter)

```bash
cd ~/VTBootCamp
git clone https://github.com/EOSIO/vt-blockchain-bootcamp-starter.git
cd vt-blockchain-bootcamp-starter
```

## First Time Setup

To install EOSIO binaries and their dependencies run the `first_time_setup.sh` script located in the `vt-blockchain-bootcamp-starter` directory

### If on Mac OS X

```bash
./first_time_setup.sh
```

### If on Ubuntu 18.04

```bash
sudo ./first_time_setup.sh
```
Enter your system password when the password prompt appears. 

## Start the Blockchain

Next, start the blockchain

```bash
./start_blockchain.sh
```

This script creates all the accounts and sets up the wallet for most of the accounts used within this guide. 

Once you see the __"EOSIO Blockchain Started" message__, your EOSIO Node (nodeos) is successfully started. 

## Example Application

Inside of the starter kit are the components of a very simple example application. This application, "NoteChain," allows users to create and update notes. 

Open a new terminal window, and start the frontend server. 

*If you're using Ubuntu 18.04 on Windows Subsystem for Linux* simply open another *Ubuntu 18.04* application window. 

```bash
cd ~/VTBootCamp/vt-blockchain-bootcamp-starter
./start_frontend.sh
```
After a short setup process your browser should automatically open a new tab on `http://localhost:3000/`

![NoteChain GUI](https://i.imgur.com/Czvlqss.png)

The lower-half of the interface contains *accounts, public keys and private keys* for users that were created when you ran the `first_time_setup.sh` script in a previous step.

Copy one of the example account's information into the UI of the NoteChain application.

Add some text in the "Note" field and press 'Add/Update Note'. As a result you should see the note appear at the top of the page.

More in-depth documentation for the example app with additional commands can be found here: [https://github.com/EOSIO/vt-blockchain-bootcamp-starter](https://github.com/EOSIO/vt-blockchain-bootcamp-starter)

# Cleos

Open a new terminal window and execute the following

```bash
cd ~/VTBootCamp
``` 

`cleos` is a _command line interface_ (CLI) to interact with the blockchain and to manage wallets.

Execute `cleos --help` in your terminal to get a top-level help text. You can also just call `cleos` or `cleos subcomand` without any parameters to output help text. For example `cleos wallet`, will output help text in the context of `wallet` 

If you would like to view the command reference for `cleos`, you can find it here: [https://developers.eos.io/eosio-cleos/reference](https://developers.eos.io/eosio-cleos/reference). 

Before getting to the next section, please also read [https://developers.eos.io/eosio-nodeos/docs/accounts-and-permissions](https://developers.eos.io/eosio-nodeos/docs/accounts-and-permissions) to familiarize yourself with the concepts of **accounts, wallets and permissions** in EOSIO.

## Wallets

The wallet can be thought of as a repository of public-private key pairs. These are needed to sign actions performed on the blockchain. Wallets and their content are managed by `keosd`. Wallets are accessed using `cleos`.

Create our first wallet:

```bash
cleos wallet create --to-console
```

The output of this command will give you a password. *Save this password* - you will need it throughout the remainder of this guide. 

To work with a wallet, it first opened and unlock it.

```bash
cleos wallet open
cleos wallet unlock
```

Moments ago you save your password, enter it when prompted. 

Next create a key in your wallet. 

```bash
cleos wallet create_key
Created new private key with a public key of: "EOS74GhNdMRYtej..."
```
Your key is now imported into the wallet. We will be using this key a few more times throughout the guide, so copy it somewhere easy to access. For convenience, store it as a variable:

```bash
PUBLICKEY="the-public-key-from-above"
```

```bash
cleos wallet list
```

The output should be following:

```
Wallets:
[
  "default *",
  "eosiomain *",
  "notechainwal *"
]
```

The `*` shows which wallets are open.

```bash
cleos wallet list keys
```

This will output your `public key` 

```
[
  "EOS74GhNdMRYtejhr1mBBTkK21x33thf4cD2i3ndfeNnBq9s72WK5"
  ...
]
```

Every EOSIO blockchain has a default user, called `eosio`. This account has full privileges over the network, and can essentially do whatever it wants. On a public network, control over this account is resigned as one of prerequisite signals that any particular EOSIO blockchain is sufficient for public use. For development purposes `eosio`'s control is retained to enable more efficient development processes.

We'll need to import the `eosio` account's private key so we can sign transactions on it's behalf. Run the following in your available terminal window and press enter,.

```bash
cleos wallet import
```

You'll be presented with a password prompt, copy the key below and paste it into the prompt. 

```bash
5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
```

**Important** The key above is a publicly known private key. You should never use this key on a production network.

## User account

Now lets create some user accounts.

To create a new account on your single-node testnet, use [cleos create account](https://developers.eos.io/eosio-cleos/reference#cleos-create-account) as demonstrated below.

```bash
cleos create account eosio helloworld $PUBLICKEY -p eosio@active
```

Let's explore what just happened in the interaction between cleos (your CLI client) and keosd (the wallet process)

- `cleos create account` created a transaction that includes an action called "createaccount" which instructs the blockchain to *create an account* by the *eosio* account named *helloworld* with the same *PUBLICKEY* assigned to both the *owner* and *active* permission of the account. 
- cleos passes this created transaction to keosd to be signed, along with some extra data. 
- The `-p eosio@active` part at the end of the command instructs cleos to explicitly ask keosd (again, the wallet process) to search for a key that fulfills the authorization requirements for the `active` permission  of the `eosio` account. 
- We imported the eosio account's key earlier in this guide. So when keosd has confirmed this, keosd signs the provided transaction without exposing the private keys and returns the signed transaction to cleos.
- Cleos then broadcasts the signed transaction to the blockchain. 

We can view that this process was success executed by calling the following. 

```bash
cleos get account helloworld -j
```

You'll now recieve a response that outlines the account's details.

# "Hello World" Smart Contract

This first contract is extremely simple. It contains a single action that accepts a single parameter as an argument. The argument is used to print out a message in the log on nodeos process. Your nodeos process was started when you executed `start_blockchain.sh` earlier in this guide. 

The `helloworld` contract is useless by design. It's primary purpose is to demonstrate the motions of authoring, compiling and deploying the contract to an EOSIO blockchain.

We need to navigate to the directory you created earlier.

```bash
cd ~/VTBootCamp
```

Next, create and navigate into a directory to store the contract. 

```bash
mkdir helloworld
cd helloworld
```

Create the file that will contain the logic for our simple contract.

```bash
touch helloworld.cpp
```

Open `helloworld.cpp` file in your editor and paste following code. 

*Note: If you're using WSL on Windows 10, then open the file with Windows Explorer, if you're using a VM on Windows 10, stay inside you VM.*

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class [[eosio::contract]] helloworld : public contract {
  public:
      using contract::contract;

      [[eosio::action]]
      void hi( name user ) {
         print( "Hello, ", name{user});
      }
};
EOSIO_DISPATCH( helloworld, (hi))

```

Let's go through this contract piece by piece. 

First, we need to include the EOSIO libraries necessary to expose the smart contract C++ APIs, as well EOSIO's print wrapper. 

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
```

EOSIO contracts extend the contract class. 

```cpp
class [[eosio::contract]] helloworld : public contract {
  public:
      using contract::contract;
};
```

This is a standard implementation of a contract structure that has one method called `hi` that takes a `user` parameter of type `name`. Then it prints out a name of this user.

```cpp

  [[eosio::action]]
  void hi( name user ) {
     print( "Hello, ", name{user});
  }
```


```cpp
EOSIO_DISPATCH( helloworld, (hi))
```

`EOSIO_DISPATCH` is a C++ macro that expands into a dispatcher. Requests to a smart contract are sent to compiled WASM as a binary blob which are then unpacked, and routed to your action based on the logic inside your pre-compilation smart contract logic. ABI files are a programatic and portable representation of the actions and data types accepted by your smart contract. An ABI simplifies the process of interfacing with any provided smart contract. 

## eosio.cdt

eosio.cdt is a toolchain for WebAssembly (WASM) and set of tools to facilitate contract writing and compilation for the EOSIO platform. We installed `eosio.cdt` for you when you ran the `first_time_setup.sh` script.

## Compile the smart contract

First we need to generate a WASM file. A WASM file is a compiled smart contract ready to be uploded to EOSIO network.

`eosio-cpp` is the WASM compiler and an ABI generator utility. Before uploading the smart contract to the network we will need to compile it from C++ to WASM.

```
eosio-cpp -o ~/VTBootCamp/helloworld/helloworld.wasm ~/VTBootCamp/helloworld/helloworld.cpp --abigen --contract helloworld
```

Run the following:

```bash
ls ~/VTBootCamp/helloworld
```

Now in the folder `~/VTBootCamp/helloworld` you will see three files:

```bash
helloworld.cpp  # this is source code of the example contract
helloworld.abi  # this is the ABI file - describes the interface of the smart contract
helloworld.wasm # this is the compiled WASM file
```

Congratulations, You have created your first smart contract. Time to deploy this contract to the blockchain.

```bash
cleos set contract helloworld ~/VTBootCamp/helloworld --permission helloworld@active
```

Run the transaction:

```bash
cleos push action helloworld hi '["helloworld"]' -p helloworld@active
```

## EOSIO token contract

EOSIO has a standard token interface that we'll now explore. But before we begin, we'll need pull that source from the repository 

```bash
cd ~/VTBootCamp
git clone https://github.com/EOSIO/eosio.contracts.git
```

Change directories...

```bash
cd eosio.contracts/eosio.token
```

First, we need to create an account for the contract. Earlier, you created a variable named `PUBLICKEY` with the public key. We'll use that again. If you cannot find it, no worries, just use `cleos wallet list` to list your public keys. 

```bash
cleos create account eosio eosio.token $PUBLICKEY
```

Next we need to compile the `eosio.token` contract. Enter the following in your terminal

```bash
eosio-cpp -I include -o eosio.token.wasm src/eosio.token.cpp --abigen
```

_If you're curious about the parameters used for `eosio.cdt` you can use `eosio-cpp -help` or view the `eosio-cpp` [reference documentation](https://eosio.github.io/eosio.cdt/1.5.0/tools/eosio-cpp.html)_

Then we need to deploy the `eosio.token` smart contract:

```bash
cleos set contract eosio.token ~/VTBootCamp/eosio.contracts/eosio.token -p eosio.token
```

Once that is complete, issue the a token. We're going to call this token "SYS" 

```bash
cleos push action eosio.token create '{"issuer":"eosio", "maximum_supply":"1000000000.0000 SYS"}' -p eosio.token@active
```

This command created a new token `SYS` with a precision of 4 decimals and a maximum supply of `1000000000.0000 SYS`. We pass `-p eosio.token@active` to inform `cleos` to tell `keosd` to sign the transaction using a key that authorizes with the `active` permission of the `eosio.token` account.

## Issue Tokens to Account "helloworld"

Now that we have created the token, the issuer (eosio) can issue new tokens to the account user we created earlier.

```
cleos push action eosio.token issue '[ "helloworld", "100.0000 SYS", "memo" ]' -p eosio@active
```

This time the output contains several different actions: one issue and three transfers. While the only action we signed was issue, the issue action performed an "inline transfer" and the "inline transfer" notified the sender and receiver accounts. The output indicates all of the action handlers that were called, the order they were called in, and whether or not any output was generated by the action.

Check `helloworld`'s balance now:

```bash
cleos get table eosio.token helloworld accounts
```

You should see following output:

```json
{
  "rows": [{
      "balance": "100.0000 SYS"
    }
  ],
  "more": false
}
```

Now, send some tokens to another user: 

```bash
cleos push action eosio.token transfer '[ "helloworld", "bob", "25.0000 SYS", "m" ]' -p helloworld@active
```

Nailed it! Let's check the balance is correct:

```bash
cleos get table eosio.token bob accounts
```

Should give you: 

```json
{
  "rows": [{
      "balance": "25.0000 SYS"
    }
  ],
  "more": false
}
```

```bash
cleos get table eosio.token helloworld accounts
```

Should give you: 

```json
{
  "rows": [{
      "balance": "75.0000 SYS"
    }
  ],
  "more": false
}
```

Awesome! Let's move to the next part.

## Persistence API

Now we want to store our information in a table-like structure, similar to a database. 

Let's imagine we are building an address book where users can add their social security number, age and name. 

First, create a directory

```bash
cd ~/VTBootCamp
mkdir addressbook
cd addressbook
```

And create a new `.cpp` file:

```bash
touch addressbook.cpp
```

Now this file in your code editor.

Let's create a standard structure for a contract file:

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class addressbook : public eosio::contract {
  public:
       
  private: 
  
};
```

Before a table can be configured and instantiated, a struct that represents the data structure of the address book needs to be written. Since it's an address book, the table will contain people, so create a struct called "person"

```cpp
struct person {};
```

When defining the struct for a `multi_index` table, you will require a unique value to use as the primary key.

For this contract, use a field called "key" with type name. This contract will have one unique entry per user, so this key will be a consistent and guaranteed unique value based on the user's name.

```cpp
struct person {
	name key;
};
```

Since this contract is an address book it probably should store some relevant details for each entry or person.

```cpp
struct person {
  name key;
  std::string full_name;
  std::string street;
  std::string city;
  uint32_t phone;
};
```

The data structure for *person* is now complete. Next, define a `primary_key` member function, which will be used by `multi_index` iterator. Every multi_index struct requires a primary key. To accomplish this you simply create a member function called `primary_key()` and return a value, in this case, the `key` member function as defined in the struct.

```cpp
struct person {
  name key;
  std::string full_name;
  std::string street;
  std::string city;
  uint32_t phone;

  uint64_t primary_key() const { return key.value;}
};
```

*Note: A table's data structure cannot be modified while it has data in it. If you need to make changes to a table's schema in any way, you first need to remove all its rows. Thus, it's important to design your multi_index data structures carefully*

Add the `struct` in the `private` namespace.

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

class addressbook : public eosio::contract {
   public:
   	using contract::contract;
       
   private:
   	struct person {
		 name key;
		 std::string full_name;
		 std::string street;
		 std::string city;
		 uint32_t phone;
		 
		 uint64_t primary_key() const { return key.value;}
	};
};
```

Now that the data structure of the table has been defined with a struct we need to configure the table. The `eosio::multi_index` constructor needs to be named and configured to use the struct we previously defined.

```cpp
// We setup the table usin multi_index container:
typedef eosio::multi_index<"people"_n, person> addressbook_type;
```

We need to initialize the class in the constructor and pass the name as a parameter in the constructor. This name will be set to the account that deploys the contract

```cpp
addressbook(name receiver, name code,  datastream<const char*> ds):contract(receiver, code, ds) {}
```

Let's sum it all up in one file so far: 

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

class addressbook : public eosio::contract
{
  public:
    using contract::contract;
    
    addressbook(name receiver, name code, datastream<const char *> ds) : contract(receiver, code, ds) {}

  private:
    struct person
    {
        name key;
        std::string full_name;
        std::string street;
        std::string city;
	uint32_t phone;

        uint64_t primary_key() const { return key.value; }
    };

    typedef eosio::multi_index<"people"_n, person> addressbook_type;

};	
```

Next, define an action for the user to add or update a record. This action will need to accept any values that this action needs to be able to emplace (create) or modify.

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
}
```

Earlier, it was mentioned that only the user has control over their own record, as this contract is opt-in. To do this, utilize the `require_auth` method provided by the `eosio.cdt` library. 

This method accepts one argument, a name type, and asserts that the account executing the transaction equals the provided value. If this condition returns true, where the user provided as an argument in `upsert` does not equal the authorizing user, the action with unwind all progress before failing. 

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
 require_auth( user );
}
```

Instantiate the table. Earlier, a multi_index table was configured as `typedef addressbook_type`. To instantiate this table, consider its two required arguments:

* The `"code"`, which represents the contract's account. This value is accessible through the scoped `_code` variable, it can be thought of as "self". 
* The `"scope"` which declares the account to which the data in this range belongs. In this case, since we only have one table we can use `"_code"` as well. Important to notice, we are passing `_code.value` that returns `_code` in `unit64_t` as that is what `scope` requires.

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
  require_auth( user );
  addressbook_type addresses(_code, _code.value);
}
```

Next, query the iterator and setting it to a variable (iterator) since this iterator may be used several times.

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
  require_auth( user );
  eosio_assert(full_name.size() <= 30, "Full name is too long");
  eosio_assert(street.size() <= 30, "Street name is too long");
  eosio_assert(city.size() <= 20, "City name is too long");
  addressbook_type addresses(_code, _code.value);
  auto iterator = addresses.find(user.value);
}
```

Now our function needs to actually add or update the record (if it already exists) in the table:

```cpp
if( iterator == addresses.end() )
  {
    //The user isn't in the table
  }
  else {
    //The user is in the table
  }
```

If the record doesn't exist, we need to create it, to do this use the `emplace` function:

```cpp
addresses.emplace(user, [&]( auto& row ) {
    row.key = user;
    row.full_name = full_name;
    row.street = street;
    row.city = city;
    row.phone = phone;
});
```

If it already exists - we will update it using `modify` function:

```cpp
addresses.modify(iterator, user, [&]( auto& row ) {
    row.key = user;
    row.full_name = full_name;
    row.street = street;
    row.city = city;
    row.phone = phone
});
```

Let's put it all together:

```cpp

#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

class addressbook : public eosio::contract
{
  public:
    using contract::contract;
    addressbook(name receiver, name code, datastream<const char *> ds) : contract(receiver, code, ds) {}

    void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone)
    {
        require_auth(user);
        eosio_assert(full_name.size() <= 30, "Full name is too long");
        eosio_assert(street.size() <= 30, "Street name is too long");
        eosio_assert(city.size() <= 20, "City name is too long");
        addressbook_type addresses(_code, _code.value);
        auto iterator = addresses.find(user.value);

        if (iterator == addresses.end())
        {
            //The user isn't in the table
            addresses.emplace(user, [&](auto &row) {
                row.key = user;
                row.full_name = full_name;
                row.street = street;
                row.city = city;
                row.phone = phone;
            });
        }
        else
        {
            //The user is in the table
            addresses.modify(iterator, user, [&](auto &row) {
                row.key = user;
                row.full_name = full_name;
                row.street = street;
                row.city = city;
                row.phone = phone;
            });
        }
    }

  private:
    struct person
    {
        name key;
        std::string full_name;
        std::string street;
        std::string city;
        uint32_t phone;

        uint64_t primary_key() const { return key.value; }
    };

    typedef eosio::multi_index<"people"_n, person> addressbook_type;

};

```

We also may want to add the `erase` method. Please remember it doesn't remove the record from the history. However, it does remove it from the current state of the database, freeing resources if you are on a resource-limited network. Presently, you are on a single-node local testnet that has not resource-limitations imposed. 

```cpp
void erase(name user) {
    require_auth(user);
    addressbook_type addresses(_code, _code.value);
    auto iterator = addresses.find(user.value);
    eosio_assert(iterator != addresses.end(), "Record does not exist");
    addresses.erase(iterator);
}
```

The contract is now mostly complete. Users can create, modify and erase records. However, the contract is not quite ready to be compiled.

At the bottom of the file, utilize the `EOSIO_DISPATCH` macro, passing the name of the contract, and our actions `upsert` and `erase`.

This macro handles the apply handlers used by wasm to dispatch calls to specific actions in our contract.

Adding the following to the bottom of `addressbook.cpp` will make our `cpp` file compatible with EOSIO's wasm interpreter. Failing to include this declaration may result in an error when deploying the contract.

```cpp
EOSIO_DISPATCH( addressbook, (upsert)(erase))
```

## ABI Type Declarations

`eosio.cdt` includes an ABI Generator, but for it to work will require some minor declarations to our contract.

There are three main types of the ABI annotation that you need to use in order for the ABI Generator to recognise relevant functions and export them to the ABI file correctly:

```cpp
[[eosio::contract]] # This annotation is needed at the contract class definition
[[eosio::action]] # This annotation is needed on the publicly available functions
[[eosio::table]] # This annotation is needed for the multi index table structs
```

The final version of our file will look like this: 

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class [[eosio::contract]] addressbook : public eosio::contract {

public:
  using contract::contract;
  
  addressbook(name receiver, name code,  datastream<const char*> ds): contract(receiver, code, ds) {}

  [[eosio::action]]
  void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
    require_auth( user );
    addressbook_type addresses(_code, _code.value);
    auto iterator = addresses.find(user.value);
    if( iterator == addresses.end() )
    {
      addresses.emplace(user, [&]( auto& row ) {
       row.key = user;
       row.full_name = full_name;
       row.street = street;
       row.city = city;
       row.phone = phone;
      });
    }
    else {
      std::string changes;
      addresses.modify(iterator, user, [&]( auto& row ) {
        row.key = user;
        row.full_name = full_name;
        row.street = street;
        row.city = city;
        row.phone = phone;
      });
    }
  }

  [[eosio::action]]
  void erase(name user) {
    require_auth(user);

    addressbook_type addresses(_self, _code.value);

    auto iterator = addresses.find(user.value);
    eosio_assert(iterator != addresses.end(), "Record does not exist");
    addresses.erase(iterator);
  }

private:
  struct [[eosio::table]] person {
    name key;
    std::string full_name;
    std::string street;
    std::string city;
    uint32_t phone;
    uint64_t primary_key() const { return key.value; }

  };
  typedef eosio::multi_index<"people"_n, person> addressbook_type;

};

EOSIO_DISPATCH( addressbook, (upsert)(erase))
```

We have our table, let's test it now. First, we need to create couple of accounts:

Create a user account so we can test adding contact details to the address book. 

```bash
cleos create account eosio josh $PUBLICKEY
```

Create another account, this one will be used to store the smart contract for the address book

```bash
cleos create account eosio addressbook $PUBLICKEY
```

Now we need to compile the smart contract:

```bash
eosio-cpp -o ~/VTBootCamp/addressbook/addressbook.wasm ~/VTBootCamp/addressbook/addressbook.cpp --abigen --contract addressbook
```

Next, we need to upload the smart contract:

```bash
cleos set contract addressbook ~/VTBootCamp/addressbook -p addressbook@active
```

And let's add `josh` to the database: 

```bash
cleos push action addressbook upsert '["josh", "Joshua A", "Springfield St", "San Francisco, CA", 123456]' -p josh
```

Looks good! Is Josh in?

```bash
cleos get table addressbook addressbook people
```

The result should look like this: 

```json
{
  "rows": [{
      "key": "josh",
      "full_name": "Joshua A",
      "street": "Springfield St",
      "city": "San Francisco, CA",
      "phone": 123456
    }
  ],
  "more": false
}
```

What if we now need to update the first name?

```bash
cleos push action addressbook upsert '["josh", "Joshua A", "Market St", "San Francisco, CA", 123456]' -p josh
```

You should get the following result by repeating the last cleos command:

```json
{
  "rows": [{
      "key": "josh",
      "full_name": "Joshua A",
      "street": "Market St",
      "city": "San Francisco, CA",
      "phone": 123456
    }
  ],
  "more": false
}
```
