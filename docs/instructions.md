# Before we Begin

## Linux

This guide assumes that if you are using Linux, you're using Ubuntu. If using a different Linux Distro, please 

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

Enter the following into terminal

```bash
mkdir ~/VTBootCamp
```

To create the *VTBootCamp* directory in your home directory. 

Change to the home directory.

```bash
cd ~/tVTBootCamp
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

You should now have two terminal windows that will provide the luxury 

![NoteChain GUI](https://i.imgur.com/Czvlqss.png)

The lower-half of the interface contains *accounts, public keys and private keys* for users that were created when you ran the first time setup bash script in a previous step.

Copy one of the example account's information into the UI of the NoteChain application.

Add some test copy in the "Note" field and press 'Add/Update Note'. As a result you should get a new note created in the frontend of the application.

You should see a message similar to following:

```json
{
    "server_version": "75635168",
    "chain_id": "cf057bbfb72640471fd910bcb67639c22df9f92470936cddc1ade0e2f2e7dc4f",
    "head_block_num": 2511,
    "last_irreversible_block_num": 2510,
    "last_irreversible_block_id": "000009ce07f8934fd8a6498e120b36b7eb012896481f5102f8cf3d9ec1c03775",
    "head_block_id": "000009cfc8a2adf575d78218b28695615bdb6724a6e40359f96c9e1395386b14",
    "head_block_time": "2018-08-01T06:42:39.500",
    "head_block_producer": "eosio",
    "virtual_block_cpu_limit": 2458387,
    "virtual_block_net_limit": 12913257,
    "block_cpu_limit": 199900,
    "block_net_limit": 1048576
}

```

More in-depth documentation for the example app with additional commands can be found here: [https://github.com/EOSIO/vt-blockchain-bootcamp-starter](https://github.com/EOSIO/vt-blockchain-bootcamp-starter)

# Cleos

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

Moments ago, you save your password, enter it when prompted. 

Next, create a key in your wallet. 

```cleos wallet create_key
Created new private key with a public key of: "EOS74GhNdMRYtej..."
```

Now lets check the wallet is there:

```bash
cleos wallet list
```

The output should be following:

```
Wallets:
[
  "default *",
  "eosiomain",
  "notechainwal"
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
]
```

We will be using this key a few more times throughout the guide, so copy it somewhere easy to access. 

## User account

Now lets create some user accounts.

Each account should have a Private key. Think of it as both login and password for your EOSIO account.

To create a new account we need to open the eosiomain wallet and then run a cleos command:

```bash
cleos create account eosio 
cleos get account testacc -j
```

# Smart contract

The folder where you should store your smart contracts is following:

```bash
cd ~/vt-blockchain-bootcamp-starter/blockchain/contracts
```

We need to create a new folder for our example contract.

```bash
mkdir example
cd example
touch example.cpp
subl ./example.cpp
```

Our example contract will be very simple. It will take a username as an argument and will publish a "Hello, username" message to the blockchain. It's quite useless, but good for understanding how smart contracts work. We hope your smart contracts will be more sophisticated :)

Open `example.cpp` file in your editor and paste following code:

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class [[eosio::contract]] example : public contract {
  public:
      using contract::contract;

      [[eosio::action]]
      void hi( name user ) {
         print( "Hello, ", name{user});
      }
};
EOSIO_DISPATCH( example, (hi))

```

Let's break this contract apart in parts.

```cpp
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
```

This imports standard eosio c++ libraries. More libraries can be found in `eosiolib` folder.

EOSIO contracts extend the contract class. Initialize our parent contract class with the code name of the contract and the receiver. The important parameter here is the code parameter which is the account on the blockchain that the contract is being deployed to.

```cpp
class hello : public contract {
  public:
      using contract::contract;

      [[eosio::action]]
      void hi( name user ) {
         print( "Hello, ", name{user});
      }
};
```

This is a standard implementation of a contract structure that has one method called `hi` that takes a `user` parameter of type `name`. Then it prints out a name of this user.

```cpp
EOSIO_DISPATCH( example, (hi))
```

`EOSIO_DISPATCH` is a C++ macro that expands into a dispatcher. Requests to a smart contract are sent to compiled WASM as a binary blob which are then unpacked, and routed to your action based on the logic inside your pre-compilation smart contract logic. ABI files enable the easy description of  ABI file is like an address book that shows what are the methods and what are their parameters inside smart contract that can be called by your app.

## eosio.cdt

eosio.cdt is a toolchain for WebAssembly (WASM) and set of tools to facilitate contract writing and compilation for the EOSIO platform. We installed `eosio.cdt` for you when you ran the `first_time_setup.sh`, you can 

## Compile the smart contract

First we need to generate a WASM file. A WASM file is a compiled smart contract ready to be uploded to EOSIO network.

`eosio-cpp` is the WASM compiler and an ABI generator utility. Before uploading the smart contract to the network we need to compile it from C++ to WASM.

```
eosio-cpp -o ~/vt-blockchain-bootcamp-starter/blockchain/contracts/example/example.wasm ~/vt-blockchain-bootcamp-starter/blockchain/contracts/example/example.cpp --abigen --contract example
```

Now in the folder `` you will see three files:

```bash
example.cpp  # this is source code of the example contract
example.abi  # this is the ABI file - describes the interface of the smart contract
example.wasm # this is the compiled WASM file
```

Congratulations, You have created your first smart contract. Lets upload this contract to the blockchain:

```bash
cleos set contract testaccount ~/vt-blockchain-bootcamp-starter/blockchain/contracts/example/example.wasm --permission testacc@active
```

Run the transaction:

```bash
cleos push action testaccount hi '["testacc"]' -p testacc@active
```

## EOSIO token contract

Now let's get real and create a custom token. With EOSIO it's easy!

First, we need to create an account for currency system contract:

```bash
cleos create key --to-console
cleos create key --to-console
cleos wallet import --private-key **PRIVATEKEY1**
cleos wallet import --private-key **PRIVATEKEY2**
cleos create account eosio eosio.token **PUBLICKEY1** **PUBLICKEY2**
```

Then we need to upload the smart contract:

```bash
cleos set contract eosio.token /contracts/eosio.token -p eosio.token
```

Once that done, we can issue new token!

```bash
cleos push action eosio.token create '{"issuer":"eosio", "maximum_supply":"1000000000.0000 HAK"}' -p eosio.token@active
```

This command created a new token `HAK` with a precision of 4 decimals and a maximum supply of `1000000000.0000 HAK`.

In order to create this token we required the permission of the eosio.token contract because it "owns" the symbol namespace (e.g. "HAK"). Future versions of this contract may allow other parties to buy symbol names automatically. For this reason we must pass `-p eosio.token` to authorize this call.

## Issue Tokens to Account "testacc"

Now that we have created the token, the issuer can issue new tokens to the account user we created earlier.

We will use the positional calling convention (vs named args).

```
cleos push action eosio.token issue '[ "testacc", "100.0000 HAK", "memo" ]' -p eosio
```

This time the output contains several different actions: one issue and three transfers. While the only action we signed was issue, the issue action performed an "inline transfer" and the "inline transfer" notified the sender and receiver accounts. The output indicates all of the action handlers that were called, the order they were called in, and whether or not any output was generated by the action.

Technically, the eosio.token contract could have skipped the inline transfer and opted to just modify the balances directly. However, in this case, the eosio.token contract is following our token convention that requires that all account balances be derivable by the sum of the transfer actions that reference them. It also requires that the sender and receiver of funds be notified so they can automate handling deposits and withdrawals.

Let's check `testaccount`'s balance:

```bash
cleos get table eosio.token testaccount accounts
```

You should see following output:

```json
{
  "rows": [{
      "balance": "100.0000 HAK"
    }
  ],
  "more": false
}
```

Now, let's send some tokens to another user! 

```bash
cleos push action eosio.token transfer '[ "testacc", "eosio", "25.0000 HAK", "m" ]' -p testaccount@active
```

Nailed it! Let's check the balance is correct:

```bash
cleos get table eosio.token eosio accounts
```

Should give you: 

```json
{
  "rows": [{
      "balance": "25.0000 HAK"
    }
  ],
  "more": false
}
```

```bash
cleos get table eosio.token testacc accounts
```

Should give you: 

```json
{
  "rows": [{
      "balance": "75.0000 HAK"
    }
  ],
  "more": false
}
```

Awesome! Let's move to the next part.

## Persistence API

Great, now we want to store our information in a table-like structure, similar to a database. 

Let's imagine we are building an address book where users can add their social security number, age and name. 

First, create a folder in your `work` folder that will contain the contract files.

```bash
cd ~/vt-blockchain-bootcamp-starter/eosio_docker/contracts
mkdir addressbook
cd addressbook
```

And create a new `.cpp` file:

```bash
touch addressbook.cpp
subl ./addressbook.cpp
```

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

Before a table can be configured and instantiated, a struct that represents the data structure of the address book needs to be written. Think of this as a "schema." Since it's an address book, the table will contain people, so create a struct called "person"

```cpp
struct person {};
```

When defining the schema for a `multi_index` table, you will require a unique value to use as the primary key.

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

Great. The basic schema is now complete. Next, define a `primary_key` method, which will be used by `multi_index` iterators. Every multi_index schema requires a primary key. To accomplish this you simply create a method called `primary_key()` and return a value, in this case, the `key` member as defined in the struct.

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

*Note: A table's schema cannot be modified while it has data in it. If you need to make changes to a table's schema in any way, you first need to remove all its rows*


Add the `struct` in `private` as a private field:

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

Now that the schema of the table has been defined with a struct we need to configure the table. The `eosio::multi_index` constructor needs to be named and configured to use the struct we previously defined.

```cpp
// We setup the table usin multi_index container:
typedef eosio::multi_index<"people"_n, person> addressbook_type;
```

We need to initialize the class in the constructor.

```cpp
// We inititialize the class with a constructor and we pass the name as a parameter in the constructor
// this name will be set to the account that deploys the contract
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

Earlier, it was mentioned that only the user has control over their own record, as this contract is opt-in. To do this, utilize the require_auth method provided by the eosio.cdt. This method accepts one argument, an name type, and asserts that the account executing the transaction equals the provided value.

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
 require_auth( user );
}
```

Instantiate the table. Previously, a `multi_index table` was configured, and declared it as `addressbook_type `. To instantiate a table, consider its two required arguments:

* The `"code"`, which represents the contract's account. This value is accessible through the scoped `_code` variable.
* The `"scope"` which make sure the uniqueness of the contract. In this case, since we only have one table we can use `"_code"` as well. Important to notice, we are passing `_code.value` that returns `_code` in `unit64_t` as that is what `scope` requires.

```cpp
void upsert(name user, std::string full_name, std::string street, std::string city, uint32_t phone) {
  require_auth( user );
  addressbook_type addresses(_code, _code.value);
}
```

Next, query the iterator, setting it to a variable since this iterator will be used several times.

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

If the record doesn't exist, we need to create it. We will use an `emplace` method to do it:

```cpp
addresses.emplace(user, [&]( auto& row ) {
    row.key = user;
    row.full_name = full_name;
    row.street = street;
    row.city = city;
    row.phone = phone;
});
```

If it already exists - we will update it using `modify` method:

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

```

We also may want to add the `erase` method. Please remember it doesn't remove the record from the history, but removes it from the current state of the database, freeing resources if you are on a resource-limited network.

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

At the bottom of the file, utilize the `EOSIO_DISPATCH` macro, passing the name of the contract, and our lone action "upsert".

This macro handles the apply handlers used by wasm to dispatch calls to specific methods in our contract.

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

Awesome, we have our table! Let's test it now.

First, we need to create couple of accounts:

```bash
# This account will be a user who wants to add their contact details to the address book
cleos create key --to-console
cleos create key --to-console
cleos wallet import --private-key **PRIVATEKEY1**
cleos wallet import --private-key **PRIVATEKEY2**
cleos create account eosio khaled **PUBLICKEY1** **PUBLICKEY2**

# This account will be used to store the smart contract for the address book
cleos create key --to-console
cleos create key --to-console
cleos wallet import --private-key **PRIVATEKEY3**
cleos wallet import --private-key **PRIVATEKEY4**
cleos create account eosio addressbook **PUBLICKEY3** **PUBLICKEY4**
```

Now we need to compile and upload the smart contract:

```bash
eosio-cpp -o ~/vt-blockchain-bootcamp-starter/eosio_docker/contracts/addressbook/addressbook.wasm ~/vt-blockchain-bootcamp-starter/eosio_docker/contracts/addressbook/addressbook.cpp --abigen --contract addressbook

# notice we are using the path to the contract inside the container, not the local path
cleos set contract addressbook /opt/eosio/bin/contracts/addressbook -p addressbook@active
```

And let's add `khaled` to the database: 

```bash
cleos push action addressbook upsert '["khaled", "Khaled A", "Springfield St", "San Francisco, CA", 123456]' -p khaled
```

Looks good! Is Khaled in?

```bash
cleos get table addressbook addressbook people
```

The result should look like this: 

```json
{
  "rows": [{
      "key": "khaled",
      "full_name": "Khaled A",
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
cleos push action addressbook upsert '["khaled", "Khaled A", "Market St", "San Francisco, CA", 123456]' -p khaled
```

You should get the following result by repeating the last cleos command:

```json
{
  "rows": [{
      "key": "khaled",
      "full_name": "Khaled A",
      "street": "Market St",
      "city": "San Francisco, CA",
      "phone": 123456
    }
  ],
  "more": false
}
```

Congrats, all done! 
