express = require("express")
routes = require("./routes")
mongoose = require('mongoose')

app = module.exports = express.createServer()
app.configure ->
  app.set "views", __dirname + "/../views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  mongoose.connect 'mongodb://localhost/blog-dev'
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  mongoose.connect 'mongodb://localhost/blog-prod'
  app.use express.errorHandler()

#routes
app.get "/", routes.index
app.get "/post/new", routes.newPost
app.post "/post/new", routes.addPost
app.get "/post/:id", routes.viewPost

#run
app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
