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
  constants = require('./constants'),
  Vector2 = require('vector2-node')

  const flatten = arr => arr.reduce(
    (acc, val) => acc.concat(
      Array.isArray(val) ? flatten(val) : val
    ),
    []
  )

var server = restify.createServer()
server.use(restify.queryParser())
server.use(function crossOrigin(req,res,next) {
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With, content-type")
  res.header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
  return next()
})
server.use(restify.bodyParser({ mapParams: true }))

server.opts(/\.*/, function (req, res, next) {
  res.send(200)
  next()
})

function cardinal(req, res, next) {
  req.answer = function(code, data) {
    res.send({ code: code, data: data })
    return next()
  }
  req.isAuthenticated = false
  if (req.params.token) {
    mongoDB.collection('users').findOne({ token: req.params.token }).then(function(r) {
      if (r) {
        delete r['password']
        delete r['token']
        req.user = r
        req.isAuthenticated = true
      }
      return next()
    })
  } else {
    return next()
  }
}

server.use(cardinal)

server.post('/gridPoint/:tileX/:tileY/hack', function (req, res, next) {
  if (!req.isAuthenticated) { return req.answer(401) }
  var grid_point_id = req.params.tileX + '-' + req.params.tileY
  var notHackedBefore = new Date()
  notHackedBefore.setSeconds(notHackedBefore.getSeconds() - constants.GP_HACK_WAIT)
  mongoDB.collection('grid_point_logs').findOne({ user_id: req.user._id, grid_point: grid_point_id, 'last_hack': {'$gte': notHackedBefore }  }).then(function(r) {
    if (r) { return req.answer(418) }
    mongoDB.collection('grid_point_logs').update(
        { user_id: req.user._id, grid_point: grid_point_id },
        { '$set': { last_hack: new Date } },
        { upsert: true, safe: false },
        function(err, data){
          if (err) { console.log(err); return req.answer(500) }
          return req.answer(200, { remaining: constants.GP_HACK_WAIT })
        }
    )
  })
})

function buildNeuralNetwork(activeNodes, networkNodes) {
  var newNodes = true
  while (newNodes) {
    newNodes = false
      networkNodes.forEach(function(n) {
        for (var i = -1; i <= 1; i++) {
          for (var j = -1; j <= 1; j++) {
            var newNode = n.clone().add(new Vector2(i, j))
            if (activeNodes.find(n => n.equals(newNode)) && !networkNodes.find(n => n.equals(newNode)) ) {
              networkNodes.push(newNode)
              newNodes = true
            }
          }
        }
      })
    }
}

server.post('/gridPoint/:tileX/:tileY/surge', function (req, res, next) {
  if (!req.isAuthenticated) { return req.answer(401) }
  var hackedBefore = new Date()
  hackedBefore.setSeconds(hackedBefore.getSeconds() - constants.GP_HACK_WAIT)
  mongoDB.collection('grid_point_logs').find({ user_id: req.user._id, 'last_hack': {'$gte': hackedBefore }  }).toArray(function(err, r) {
    if (!r.length) { return req.answer(418) }
    var activeNodes = r.map(r => r.grid_point.split('-')).map(r => new Vector2(r[0], r[1]))
    var networkNodes = [new Vector2(parseInt(req.params.tileX), parseInt(req.params.tileY))]
    buildNeuralNetwork(activeNodes, networkNodes)
    req.answer(200, { remaining: constants.GP_SURGE_WAIT, network: networkNodes })
  })
})

server.post('/tiles', function (req, res, next) {
  if (!req.isAuthenticated) { return req.answer(401) }
  var data = []
  req.params.tiles.forEach(function(tile) {
    data.push(JSON.parse(fs.readFileSync('./tiles/' + tile[0] + '/' + tile[1] + '.json', 'utf8')))
  })
  req.answer(200, data)
})


server.post('/tasks/homebase', function (req, res, next) {
  if (!req.isAuthenticated) { return req.answer(401) }
  let t = req.user.tasks.find(t => t.type == 'hb')
  if (t) {
    req.answer(518)
  } else {
    var finish = new Date()
    finish.setSeconds(finish.getSeconds() + constants.TASK_HB_DURATION)
    var task = { _id: new ObjectID(), type: 'hb', finishes_at: finish, created_at: new Date }
    req.user.tasks.push(task)
    mongoDB.collection('users').updateOne({ _id: req.user._id }, { $set: { 'tasks': req.user.tasks }})
    task.remaining = constants.TASK_HB_DURATION
    req.answer(200, { task: task })
  }
})

server.get('/session', function (req, res, next) {
  if (!req.isAuthenticated) { return req.answer(401) }
  return req.answer(200)
})

server.post('/auth', function (req, res, next) {
  if (req.isAuthenticated) { return req.answer(418) }
  mongoDB.collection('users').findOne({ username: req.params.username }).then(function(result) {
    if (!result || !bcrypt.compareSync(req.params.password, result.password)) {
      return req.answer(401)
    }
    var authToken = bcrypt.hashSync(uuidV4() + (new Date).getTime + req.params.username)
    mongoDB.collection('users').updateOne({ _id: result._id }, { $set: { token: authToken }}).then(function(){
      req.answer(200, { token: authToken })
    })
  })
})

server.post('/join', function (req, res, next) {
  if (req.isAuthenticated || !emailValidator.validate(req.params.email)) { return req.answer(418) }
  mongoDB.collection('users').findOne({ email: req.params.email }).then(function(result) {
    if (result) { return req.answer(401) }
    mongoDB.collection('users').findOne({ username: req.params.username }).then(function(result) {
      if (result) { return req.answer(401) }
      var authToken = bcrypt.hashSync(uuidV4() + (new Date).getTime + req.params.username)
      mongoDB.collection('users').insert({
        email: req.params.email,
        username: req.params.username,
        password: bcrypt.hashSync(req.params.password),
        token: authToken,
        tasks: [],
        created_at: new Date
      }).then(function(result) {
        req.answer(200, { token: authToken })
      })
    })
  })
})

var mongoDB = false
MongoClient.connect(config['mongo'], function(err, db) {
  if (err) {
    console.log(err)
  } else {
    mongoDB = db
    server.listen(config['PORT'], '0.0.0.0', function(){
      console.log('Listening on *:' + config['PORT'])
    })
  }
})
