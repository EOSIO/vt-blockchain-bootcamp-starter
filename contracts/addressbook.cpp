#include <eosio/eosio.hpp>
#include "eosio.token.hpp"

using namespace eosio;

class [[eosio::contract("addressbook")]] addressbook : public eosio::contract {

public:

   addressbook(name receiver, name code,  datastream<const char*> ds): 
	   addresses(get_self(), get_self().value),
	   contract(receiver, code, ds) {}

   [[eosio::action]]
   void upsert(name user, std::string first_name, std::string last_name, uint64_t age, std::string street, std::string city, std::string state) {
      require_auth(user);
      auto iterator = addresses.find(user.value);
      if( iterator == addresses.end() )
      {
         addresses.emplace(user, [&]( auto& row ) {
               row.key = user;
               row.first_name = first_name;
               row.last_name = last_name;
               row.age = age;
               row.street = street;
               row.city = city;
               row.state = state;
               });
      }
      else {
         addresses.modify(iterator, user, [&]( auto& row ) {
               row.first_name = first_name;
               row.last_name = last_name;
               row.age = age;
               row.street = street;
               row.city = city;
               row.state = state;
               });
      }
   }

   [[eosio::action]]
   void erase(name user) {
      require_auth(user);

      auto iterator = addresses.find(user.value);
      check(iterator != addresses.end(), "Record does not exist");
      addresses.erase(iterator);
   }

   template <typename Person>
   void print_person(const Person& p) {
      print_f("First Name : %\nSecond Name : %\nAge : %\n", p.first_name, p.last_name, p.age);
   }

   [[eosio::action]]
   void print(name user) {
      const auto& iter = addresses.find(user.value);
      check(iter != addresses.end(), "Record does not exist");
      print_f("First Name : %\nSecond Name : %\nAge : %\n", iter->first_name, iter->last_name, iter->age);
   }

   [[eosio::action]]
   void ge(uint64_t age) {
      auto index = addresses.get_index<"byage"_n>();
      for (auto iter = index.lower_bound(age); iter != index.end(); iter++)
         print_person(*iter);
   }

   void hello_hi();

   [[eosio::action]]
   void hi(name acnta) {
      require_auth("bob"_n);
      using hi_action = action_wrapper<"hi"_n, &addressbook::hello_hi>;
      hi_action hi("hello"_n, {get_self(), "active"_n});
      hi.send();
   }

private:
   struct [[eosio::table]] person {
      name key;
      std::string first_name;
      std::string last_name;
      uint64_t age;
      std::string street;
      std::string city;
      std::string state;

      uint64_t primary_key() const { return key.value; }
      uint64_t get_secondary_1() const { return age;}
   };

   typedef eosio::multi_index<"people"_n, person,
      indexed_by<"byage"_n, const_mem_fun<person, uint64_t, &person::get_secondary_1>>
   > address_index;

   address_index addresses;

};
