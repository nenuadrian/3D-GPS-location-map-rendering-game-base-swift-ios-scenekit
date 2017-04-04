var rconfig = require('./config'),
  MongoClient = require('mongodb').MongoClient,
  ObjectID = require('mongodb').ObjectID,
  utils = require('./utils'),
  emailValidator = require("email-validator"),
  bcrypt = require("bcrypt-nodejs"),
  uuidV4 = require('uuid/v4'),
  Vector2 = require('vector2-node'),
  express = require('express'),
  http = require('http'),
  WebSocket = require('ws')

var app = express()
var server = http.createServer(app)
var wss = new WebSocket.Server({ server })


wss.on('connection', function connection(ws) {
  console.log('Openned')

  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });

  ws.send('something');
});


server.listen(3005, function listening() {
  console.log('Listening on %d', server.address().port);
});

/*
try { ws.send('something'); }
catch (e) { }*/
