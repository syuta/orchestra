routes = require "../routes/index"
mongoose = require "mongoose"
Post = require "../models/Post"
require "should"

describe "routes", ->
  req =
    params:
      {}
    body:
      {}
  res =
    redirect: (route) ->
      #do nothing
    render: (view, vars)->
      #do nothing
  before (done) ->
    mongoose.connect 'mongodb://localhost/blog', ->
      Post.remove done

  describe "index", ->
    it "should display index with posts", (done) ->
      res.render = (view, vars) ->
        view.should.equal "index"
        vars.title.should.eql "ぶろぐ"
        vars.posts.should.eql []
        done()
      routes.index(req, res)

  describe "new post", ->
    it "should display the add post page", (done) ->
      res.render = (view, vars) ->
        view.should.equal "add_post"
        vars.title.should.equal "あたらしい投稿"
        done()
      routes.newPost(req, res)
    it "should add a new post when posted to", (done) ->
      req.body.post =
        title: "たいとるです"
        body: "ほんぶんです"

      routes.addPost req, redirect: (route) ->
        route.should.eql "/"
        routes.index req, render: (view, vars) ->
          view.should.equal "index"
          vars.posts[0].title.should.eql "たいとるです"
          vars.posts[0].body.should.eql "ほんぶんです"
          done()