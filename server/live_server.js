var config = require('./config'),
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

wss.broadcast = function (channel, data) {
  wss.clients.forEach(ws => {
    if (ws.channel == channel && ws.readyState === WebSocket.OPEN) {
      ws.send(data)
    }
  })
}

wss.on('connection', function connection(ws) {
  console.log('Openned')

  ws.on('message', function incoming(message) {
    let msg = JSON.parse(message)
    console.log(msg)
    if (msg.action == 'join_battle') {
      ws.channel = msg.npc_id
    }

    if (msg.action == 'attack') {
      wss.broadcast(ws.channel, JSON.stringify({ action: 'damage' }))

      mongoDB.collection('npcs').updateOne({ _id: ObjectID(ws.channel) }, { $unset: { occupy: null }}).then(() => {
        wss.broadcast(ws.channel, JSON.stringify({ action: 'defeated' }))
      })
    }
  })

})

var mongoDB = false
MongoClient.connect(config.MONGO, (err, db) => {
  if (err) { console.log(err) } else {
    mongoDB = db
    server.listen(3005, function listening() {
      console.log('Listening on %d', server.address().port)
    })
  }
})
