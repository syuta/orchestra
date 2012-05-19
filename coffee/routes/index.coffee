Post = require '../models/Post'

module.exports =
  index: (req, res) ->
    Post.find {}, (err, posts) ->
      res.render "index",
        title: "ぶろぐ"
        posts: posts

  newPost: (req, res) ->
    res.render "add_post", title: "あたらしい投稿"

  addPost: (req, res) ->
    new Post(req.body.post).save ->
      res.redirect "/"

  viewPost: (req, res) ->
    Post.findById req.params.id, (err, post) ->
      res.render 'post', post: post, title: post.title