"use strict";

var restify = require('restify'),
  request = require('request'),
  config = require('./config'),
  MongoClient = require('mongodb').MongoClient,
  ObjectID = require('mongodb').ObjectID,
  fs = require('fs'),
  utils = require('./utils'),
  emailValidator = require("email-validator"),
  bcrypt = require("bcrypt-nodejs"),
  uuidV4 = require('uuid/v4'),
  Vector2 = require('vector2-node'),
  craft = require('./craft'),
  Inventory = require('./inventory')

var TASK = { TYPES: { HOME_BASE_PLACE: 1, CRAFT: 2 } }

class Player {
  constructor(data) {
    delete data.password
    delete data.email
    delete data.token
    this.data = data
    this.inventory = new Inventory(data.inventory)
  }

  basic() {
    return { username: this.data.username,
    _id: this.data._id,
    level: this.data.level,
    group: this.data.group,
    exp: this.data.exp,
    home_base: this.data.home_base,
    inventory: this.inventory.items,
    apps: this.data.apps }
  }

  expFor(level) { return level * 10 }

  addExp(exp) {
    this.data.exp += exp
    while (this.data.exp >= this.expFor(this.data.level + 1)) {
      this.data.level++
      this.data.exp -= this.expFor(this.data.level)
    }
  }

  save() {
    return mongoDB.collection('users').updateOne({ _id: this.data._id }, { $set: this.data })
  }
}

function buildNeuralNetwork(activeNodes, networkNodes) {
  var newNodes = true
  while (newNodes) {
    newNodes = false
    networkNodes.forEach(function(n) {
      [new Vector2(-1, 0), new Vector2(0, -1), new Vector2(1, 0), new Vector2(0, 1)].forEach(function(v) {
        var newNode = n.clone().add(v)
        if (activeNodes.find(n => n.equals(newNode)) && !networkNodes.find(n => n.equals(newNode)) ) {
          networkNodes.push(newNode)
          newNodes = true
        }
      })
    })
  }
}

function userIntro(player) {
  return {
    username: player.username,
    _id: player._id
  }
}


function authHandler(req, res, next) {
  req.answer = function(code, data) {
    var answer = { code: code, data: data }
    console.log(answer)
    res.send(answer)
    return next()
  }

  if (req.params.token) {
    mongoDB.collection('users').findOne({ token: req.params.token }).then((r) =>  {
      if (r) {
        req.user = new Player(r)
      }
      return next()
    })
  } else {
    return next()
  }
}

function authLock(req, res, next) {
  if (!req.user) { return req.answer(401) }
  return next()
}

var server = restify.createServer()
server.use(restify.queryParser())
server.use(function crossOrigin(req,res,next) {
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With, content-type")
  res.header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
  return next()
})

server.use(restify.bodyParser({ mapParams: true }))

server.opts(/\.*/, (req, res, next) => {
  res.send(200)
  next()
})

server.use(authHandler)


server.get('/homebase', authLock, (req, res, next) => {
  req.answer(200, { home_base: req.user.data.home_base })
})

server.post('/homebase/install/:app', authLock, (req, res, next) => {
  var app = req.user.data.apps.find(a => a._id == req.params.app)
  req.user.data.apps.splice(req.user.data.apps.indexOf(app), 1)
  req.user.data.home_base.apps.push(app)
  req.user.save()
  req.answer(200)
})

server.post('/homebase/uninstall/:app', authLock, (req, res, next) => {
  var app = req.user.data.home_base.apps.find(a => a._id == req.params.app)
  req.user.data.home_base.apps.splice(req.user.data.home_base.apps.indexOf(app), 1)
  req.user.data.apps.push(app)
  req.user.save()
  req.answer(200)
})

server.get('/server/info', authLock, (req, res, next) => {
  req.answer(200, { })
})

server.get('/npcs', authLock, (req, res, next) => {
  mongoDB.collection('npcs').find({ "tile.0": { $gte: 10, $lte: 1100000 }, "tile.1": { $gte: 10, $lte: 1100000 }}).toArray((err, npcs) => {
    req.answer(200, npcs)
  })
})

server.get('/npc/:npc', authLock, (req, res, next) => {
  mongoDB.collection('npcs').findOne({ "_id": ObjectID(req.params.npc) }).then((r) =>  {
    req.answer(200, { npc: r })
  })
})

server.post('/group/:group', authLock, (req, res, next) => {
  req.user.data.group = parseInt(req.params.group)
  req.user.save().then((r) => {
    req.answer(200)
  })
})

server.post('/tasks/craft/:id', authLock, (req, res, next) => {
  var id = parseInt(req.params.id)
  var formula = craft.formulas.find(f => f.id == id)
  if (craft.canCraft(formula, req.user)) {
    formula.items.forEach(i => req.user.inventory.drop(i))
    var finishes_at = new Date()
    finishes_at.setSeconds(finishes_at.getSeconds() + 10)
    var task = {
      _id: new ObjectID(),
      type: TASK.TYPES.CRAFT,
      finishes_at: finishes_at,
      created_at: new Date,
      data: { formula: id }
    }
    task.s = 10
    req.user.data.tasks.push(task)
    req.user.save()
    req.answer(200, { action: { task: task } })
  } else req.answer(418)
})

server.post('/drop', authLock, (req, res, next) => {
  if (!req.user.data.last_drop) { return req.answer(418) }
  var last_drop = req.user.data.last_drop
  req.params.items.forEach((type) => {
    var inDrop = last_drop.find(i => i.type == type)
    if (inDrop) {
      req.user.inventory.add({ type: type, q: 1 })
      last_drop.splice(last_drop.indexOf(inDrop), 1)
    }
  })
  req.user.data.last_drop = null
  req.user.save()
  req.answer(200)
})

server.post('/gridPoint/:tileX/:tileY/hack', authLock, (req, res, next) => {
  var grid_point_id = req.params.tileX + '-' + req.params.tileY
  mongoDB.collection('grid_points').findOne({ user_id: req.user.data._id, grid_point: grid_point_id }).then((r) =>  {
    var notHackedBefore = new Date()
    if (r && r.last_hack > notHackedBefore) { return req.answer(418) }
    mongoDB.collection('grid_points').update(
      { user_id: req.user.data._id, grid_point: grid_point_id },
      { '$set': { last_hack: new Date } },
      { upsert: true, safe: false }, (err, data) => {
        if (err) { console.log(err); return req.answer(500) }
        var drop = [{ type: 1 }, { type: 2 }]
        req.user.data.last_drop = drop
        req.user.addExp(10)
        req.user.save()
        req.answer(200, { s: config.GP_HACK_WAIT, action: { drop: drop, exp: 10 } })
    })
  })
})

server.post('/gridPoint/:tileX/:tileY/surge', authLock, (req, res, next) => {
  var hackedBefore = new Date()
  hackedBefore.setSeconds(hackedBefore.getSeconds() - config.GP_HACK_WAIT)
  mongoDB.collection('grid_points').find({ user_id: req.user.data._id, 'last_hack': {'$gt': hackedBefore }  }).toArray((err, r) => {
    if (!r.length) { return req.answer(418) }
    var activeNodes = r.map(r => r.grid_point.split('-')).map(r => new Vector2(r[0], r[1]))
    var networkNodes = [new Vector2(parseInt(req.params.tileX), parseInt(req.params.tileY))]

    buildNeuralNetwork(activeNodes, networkNodes)
    networkNodes = networkNodes.map(n => [n.x, n.y])

    var npcFilter = networkNodes.map(n => { return { tile: n } })
    var hbFilter = networkNodes.map(n => { return { home_base: { tile: n } } })
    mongoDB.collection('npcs').find({ $or: npcFilter }).toArray((err, npcs) => {
      mongoDB.collection('users').find({ _id : { $ne: req.user.data._id }, $or: hbFilter }).toArray((err, users) => {
        req.answer(200, { s: config.GP_SURGE_WAIT, network: networkNodes, npcs: npcs, homeBases: users.length })
      })
    })
  })
})

server.get('/tile/:x/:y', authLock, (req, res, next) => {
  if (!req.user.data) { return req.answer(401) }
  var data = JSON.parse(fs.readFileSync('./tiles/' + parseInt(req.params.x) + '/' + parseInt(req.params.y) + '.json', 'utf8'))
  mongoDB.collection('npcs').find({ "tile": [parseInt(req.params.x), parseInt(req.params.y)] }).toArray((err, npcs) => {
    data.npcs = npcs
    req.answer(200, data)
  })
})


server.put('/tasks/homebase', authLock, (req, res, next) => {
  let t = req.user.data.tasks.find(t => t.type == TASK.TYPES.HOME_BASE_PLACE)
  if (t) { req.answer(518) } else {
    var finishes_at = new Date()
    finishes_at.setSeconds(finishes_at.getSeconds() + config.TASK_HB_DURATION)
    var task = {
      _id: new ObjectID(),
      type: TASK.TYPES.HOME_BASE_PLACE,
      finishes_at: finishes_at,
      created_at: new Date,
      data: { coords: [parseFloat(req.params.lat), parseFloat(req.params.lon)]}
    }
    req.user.data.tasks.push(task)
    req.user.save()
    task.s = config.TASK_HB_DURATION
    req.answer(200, { action: { task: task } })
  }
})

server.get('/task/:task_id', authLock, (req, res, next) => {
  var task = req.user.data.tasks.find(t => t._id == req.params.task_id)
  if (!task) { req.answer(404) } else {
    var s = task.finishes_at.getTime() - new Date().getTime()
    if (s > 1000) {
      req.answer(518, { s: s })
    } else {
      req.user.data.tasks.splice(req.user.data.tasks.findIndex(t => t._id == task._id ), 1)
      mongoDB.collection('users').updateOne({ _id: req.user.data._id }, { $set: { 'tasks': req.user.data.tasks }})
      var data = {}
      if (task.type == TASK.TYPES.HOME_BASE_PLACE) {
        req.user.data.home_base = { x: task.data.coords[0], y: task.data.coords[1], level: 1, tile: utils.latLonToTile(task.data.coords[0], task.data.coords[1]), apps: [] }
      } else if (task.type == TASK.TYPES.CRAFT) {
        var formula = craft.formulas.find(f => f.id == task.data.formula)
        if (formula.item) {
          req.user.inventory.add(formula.item)
          data.action = { item: formula.item }
        } else {
          var app = {
            type: formula.app.type,
            _id: new ObjectID()
          }
          req.user.data.apps.push(app)
          data.action = { app: app }
        }
      }
      req.user.save()
      req.answer(200, data)
    }
  }
})

server.get('/player', authLock, (req, res, next) => {
  var notHackedBefore = new Date()
  notHackedBefore.setSeconds(notHackedBefore.getSeconds() - config.GP_HACK_WAIT)
  req.user.data.tasks.forEach(t => {
    t.s = Math.floor((t.finishes_at.getTime() - new Date().getTime()) / 1000)
    delete t.created_at
    delete t.finishes_at
  })
  req.answer(200, {
    player: req.user.basic(),
    tasks: req.user.data.tasks,
  })
})

server.post('/auth', (req, res, next) => {
  mongoDB.collection('users').findOne({ username: req.params.username }).then(function(user) {
    if (!user || !bcrypt.compareSync(req.params.password, user.password)) {
      return req.answer(401)
    }
    var authToken = bcrypt.hashSync(uuidV4() + (new Date).getTime + req.params.username)
    req.user.data.token = authToken
    req.user.save().then(function(){
      req.answer(200, { token: authToken })
    })
  })
})

server.post('/join', (req, res, next) => {
  if (!emailValidator.validate(req.params.email)) { return req.answer(418) }
  mongoDB.collection('users').findOne({ email: req.params.email }).then( result => {
    if (result) { return req.answer(401) }
    mongoDB.collection('users').findOne({ username: req.params.username }).then( result => {
      if (result) { return req.answer(401) }
      var authToken = bcrypt.hashSync(uuidV4() + (new Date).getTime + req.params.username)
      mongoDB.collection('users').insert({
        email: req.params.email,
        username: req.params.username,
        password: bcrypt.hashSync(req.params.password),
        level: 1,
        exp: 0,
        token: authToken,
        tasks: [],
        inventory: [],
        apps: [],
        group: 0,
        created_at: new Date
      }).then(function(result) {
        req.answer(200, { token: authToken })
      })
    })
  })
})

var mongoDB = false
MongoClient.connect(config.MONGO, (err, db) => {
  if (err) { console.log(err) } else {
    mongoDB = db
    server.listen(config.PORT, '0.0.0.0', function() {
      console.log('Listening on *:' + config['PORT'])
    })
  }
})
