const users = {
  'bob': {
    'private': '5KU4LQuZjdg7K7qKQ7B4gCWSxX4Wn9pnfJ1zSNSDDdTjC5s2eo3',
    'public': 'EOS6FJrY3d6rx5iP6kQNN1sRRNxJnqfRrNmYL7tgkJrZj1CVrDk6y',
  },
  'alice': {
    'private': '5KdiJygvjhWeU2wPNsgybm4uomy4pbVz8z93hWBmNSjQ9zwrQnU',
    'public': 'EOS83cWh7iL5SpFLV4etAUQhTtKnYjKtCSeixaAK6TBzBf8vMMAkU',
  },
  'john': {
    'private': '5J8yEGU9gzaV6WqdaMLyPk89ECK9biheQxP5tf1SKjeuDV7MUKS',
    'public': 'EOS8dKWrRLHx1tULVjVeKJ6TRmRAjgrd51tSzDw3QQbo6FZZuyGKL',
  },
  'billy': {
    'private': '5HwMxLDqFwMZ3CmoAEyHz2byM95gj1x5zivmBKDyWrEG8Tj7ZQt',
    'public': 'EOS5GDiCs18KTntwp5Uba3Vy5qRgNvH4FBt61YCgfWRUEGJ4hdqT1',
  },
};

const privateKeys = [
  '5KU4LQuZjdg7K7qKQ7B4gCWSxX4Wn9pnfJ1zSNSDDdTjC5s2eo3',
  '5KdiJygvjhWeU2wPNsgybm4uomy4pbVz8z93hWBmNSjQ9zwrQnU',
  '5J8yEGU9gzaV6WqdaMLyPk89ECK9biheQxP5tf1SKjeuDV7MUKS',
  '5HwMxLDqFwMZ3CmoAEyHz2byM95gj1x5zivmBKDyWrEG8Tj7ZQt',
];

// The JsonRpc class is used for communicating directly with a node's RPC API.
const rpc = new eosjs_jsonrpc.JsonRpc('http://127.0.0.1:8888');

// The JsSignatureProvider handles using private keys to sign transactions.
const signatureProvider = new eosjs_jssig.JsSignatureProvider(privateKeys);

// The Api class pulls together the JsonRpc and JsSignatureProvider
// to provide easy to use methods for signing and broadcasting transactions
const api = new eosjs_api.Api({ rpc, signatureProvider });


async function get_table_all_elements() {
  const result = await rpc.get_table_rows({
    json: true,            // Get the response as json (if false, returns serialized form).
    code: 'addressbook',   // Account name that the contract is deployed to.
    scope: 'addressbook',  // Account that owns the data
    table: 'people',       // Table name (as defined by eosio::multi_index<your_table_name here, ...>
    limit: 10,             // Maximum number of rows that we want to get
    reverse: false,        // Optional: Get reversed data
    show_payer: false      // Optional: Show ram payer
  });
  console.log(result);
  generate_table(result);
}

async function get_table_by_bound(lower_bound) {
  const result = await rpc.get_table_rows({
    json: true,                // Get the response as json
    code: 'addressbook',       // Contract that we target
    scope: 'addressbook',      // Account that owns the data
    table: 'people',           // Table name (as defined by eosio::multi_index<your_table_name_here, ...>
    limit: 10,                 // Maximum number of rows that we want to get
    table_key: 'byage',        // The key of the seconday index (as defined by indexed_by<your_key_name_here, ...>
    index_position: 2,         // The index position to query. The primary key is considered index 1.
    key_type: 'i64',           // The type of the secondary index key.
                               // (Can be i64, i128, i256, float64, float128, ripemd160, sha256)
    lower_bound: lower_bound,  // By setting lower_bound, only values >= lower_bound will be returned
    reverse: false,            // Optional: Get reversed data
    show_payer: false,         // Optional: Show ram payer
  });
  generate_table(result);
}

async function create_entry() {
  const form_info = get_form_info();
  try {
    const result = await api.transact({
      actions: [{                 // actions contains an array of transaction objects.
        account: 'addressbook',   // the account the contract is deployed on.
        name: 'upsert',           // the name of the action.
        authorization: [{
          actor: form_info.user,  // the user authorizing the action.
          permission: 'active',   // the permission used for authorizing the action.
        }],
        data: {                               // transaction data, changes per transaction.
          user: form_info.user,            
          first_name: form_info.first_name,
          last_name: form_info.last_name,
          age: form_info.age,
          street: form_info.street,
          city: form_info.city,
          state: form_info.state,
        },
      }]
    }, {
      blocksBehind: 3,
      expireSeconds: 30,
    });
    show_logs(result);
  } catch (e) {
    show_error(e);
  }
}

async function erase_entry() {
  const user = get_erase_user();

  try {
    const result = await api.transact({
      actions: [{
        account: 'addressbook',
        name: 'erase',
        authorization: [{
          actor: user,
          permission: 'active',
        }],
        data: {
          user,
        },
      }]
    }, {
      blocksBehind: 3,
      expireSeconds: 30,
    });
    show_logs(result);
  } catch (e) {
    show_error(e);
  }
}

//==================================================================
// DOM Manipulation Code
//==================================================================
function generate_table(data) {
  let tbl = document.getElementById("results-tbl");
  let tblBody = document.getElementById("results-tbl-body");

  tblBody.innerHTML = ''; // clear out table to repopulate

  for (const row of data.rows) {
    let trow = document.createElement("tr");
    for (let j = 0; j < 7; j++) {
      var cell = document.createElement("td");
      var cellText = document.createTextNode(Object.entries(row)[j][1]);
      cell.appendChild(cellText);
      trow.appendChild(cell);
    }
    tblBody.appendChild(trow);
  }

  tbl.style.display = 'inline'; // show the table
}

function show_logs(result) {
  const str = '\n\nTransaction pushed!\n\n' + JSON.stringify(result, null, 2);
  console.info(str);
  const pre = document.getElementById("logs");
  pre.innerHTML = str;
  pre.style.border = "1px solid black";
}

function show_error(e) {
  let error = '\nCaught exception: ' + e;
  if (e instanceof eosjs_jsonrpc.RpcError) {
    error += '\n\n' + JSON.stringify(e.json, null, 2);
  }
  console.error(error);
  const pre = document.getElementById("logs");
  pre.innerHTML = error;
  pre.style.border = "1px solid red";
}

function get_table() {
  const age = document.getElementById("filter-age");

  if (age.value) {
    return get_table_by_bound(age.value);
  } else {
    return get_table_all_elements();
  }
}

function get_form_info() {
  const user = document.getElementById('create-user-select').value;
  const first_name = document.getElementById('first-name').value;
  const last_name = document.getElementById('last-name').value;
  const age = document.getElementById('age').value;
  const street = document.getElementById('street').value;
  const city = document.getElementById('city').value;
  const state = document.getElementById('state').value;
  return {
    user,
    first_name,
    last_name,
    age,
    street,
    city,
    state,
  }
}

function get_erase_user() {
  return document.getElementById('erase-user-select').value;
}
