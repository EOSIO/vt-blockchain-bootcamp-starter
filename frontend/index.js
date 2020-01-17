const express = require('express')
const app = express()
const port = 3000
app.use(express.static('public'))

var request = require('request');
const apiUrl = 'http://127.0.0.1:8888';
app.use('/chain', function(req, res) {
  console.log(req.url);
  var url = apiUrl + req.url;
  req.pipe(request({ qs:req.query, uri: url, json: true })).pipe(res);
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))