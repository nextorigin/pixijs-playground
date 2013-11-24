Spine = require "spine"


loadExample = (url, autocb) ->
  await Spine.Ajax.awaitGet {url: url}, defer status, xhr, statusText, data
  switch status
    when "error" then "Error #{statusText}: #{data}"
    when "success" then data


examples =
  bunny: (cb) -> loadExample "/examples/bunny.coffee", cb

  "bunny-short": (cb) -> loadExample "/examples/bunny-short.coffee", cb

  balls: (cb) -> loadExample "/examples/balls.coffee", cb

  bunnymark: (cb) -> loadExample "/examples/bunnymark.coffee", cb


module.exports = examples