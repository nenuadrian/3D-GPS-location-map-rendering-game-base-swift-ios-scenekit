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
  WebSocket = require('ws'),
  app = express(),
  server = http.createServer(app),
  wss = new WebSocket.Server({ server }),
  winston = require('winston')

wss.broadcast = function (channel, data) {
  wss.clients.forEach(ws => {
    if (ws.channel == channel && ws.readyState === WebSocket.OPEN) {
      ws.send(data)
    }
  })
}

var battles = {}

function getBattle(id, callback) {
  if (!battles[id]) {
    mongoDB.collection('npcs').findOne({ _id: ObjectID(id) }).then((npc) => {
      var battle = {
        health: 100
      }
      battles[id] = battle
      callback(battle)
    })
  } else {
  callback(battles[id])
  }
}

wss.on('connection', function connection(ws) {
  console.log('Openned')
  console.log(ws.upgradeReq.headers)
  mongoDB.collection('users').findOne({ token: ws.upgradeReq.headers.token }).then((r) =>  {
    if (r) {
      ws.user = r
      ws.send(JSON.stringify({ action: 'ready' }))
      ws.on('message', function incoming(message) {
        let msg = JSON.parse(message)
        winston.info(msg)
        if (msg.action == 'join_battle') {
          ws.channel = msg.npc_id
          getBattle(ws.channel, (battle) => {
            ws.apps = ws.user.apps.filter(a => msg.apps.indexOf(a._id.toString()) != -1)
            wss.broadcast(ws.channel, JSON.stringify({ action: 'joined_battle', user: { id: ws.user._id.toString(), username: ws.user.username, apps: ws.apps } }))
            ws.send(JSON.stringify({ action: 'battle', data: battle }))
          })
        }

        if (msg.action == 'attack') {
          wss.broadcast(ws.channel, JSON.stringify({ action: 'damage', value: 20, user: ws.user._id.toString() }))
          battles[ws.channel].health -= 20
          if (battles[ws.channel].health <= 0) {
            mongoDB.collection('npcs').updateOne({ _id: ObjectID(ws.channel) }, { $unset: { occupy: null }}).then(() => {
              wss.broadcast(ws.channel, JSON.stringify({ action: 'defeated' }))
              delete battles[ws.channel]
            })
          }
        }
      })
    } else {
      ws.send(JSON.stringify({ action: '404' }))
    }
  })
})

var mongoDB = false
MongoClient.connect(config.MONGO, (err, db) => {
  if (err) { console.log(err) } else {
    mongoDB = db
    server.listen(3005, function listening() {
      winston.info('Listening on %d', server.address().port)
    })
  }
})
