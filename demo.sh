#! /bin/bash

cleos push action addressbook upsert '["bob", "Bob", "Ross", 700, "123 Happy Tree Lane", "Daytona", "Florida"]' -p bob@active

cleos get table addressbook addressbook people

cleos push action addressbook upsert '["bob", "Bobert", "Ross", 700, "123 Happy Tree Lane", "Daytona", "Florida"]' -p bob@active

cleos get table addressbook addressbook people

## wrong authority
cleos push action addressbook upsert '["alice", "Larry", "Kittinger", 4, "100 Block.one Ln", "Blacksburg", "Virginia"]' -p bob@active
cleos push action addressbook upsert '["alice", "Larry", "Kittinger", 4, "100 Block.one Ln", "Blacksburg", "Virginia"]' -p alice@active

cleos get table addressbook addressbook people

cleos -v push action addressbook print '["bucky"]' -p bob@active
cleos -v push action addressbook print '["bob"]' -p bob@active
cleos -v push action addressbook print '["alice"]' -p alice@active

cleos -v push action addressbook ge '[40]' -p alice@active
cleos -v push action addressbook ge '[700]' -p alice@active
cleos -v push action addressbook ge '[701]' -p alice@active


cleos -v push action addressbook hi '["bob"]' -p bob

cleos push action eosio.token create '["eosio", "1000000.0000 SYS"]' -p eosio.token
cleos push action eosio.token issue '["eosio", "100000.0000 SYS", "issuing tokens"]' -p eosio
cleos push action eosio.token transfer '["eosio", "bob", "1000.0000 SYS", "start"]' -p eosio
cleos push action eosio.token transfer '["eosio", "alice", "1000.0000 SYS", "start"]' -p eosio

