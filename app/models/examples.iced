Spine = require "spine"


loadExample = (url, autocb) ->
  await Spine.Ajax.awaitGet {url: url}, defer status, xhr, statusText, data
  switch status
    when "error" then "Error #{statusText}: #{data}"
    when "success" then data


exampleList =
  bunny:         "/examples/bunny.coffee"
  "bunny-short": "/examples/bunny-short.coffee"
  dragging:      "/examples/dragging.coffee"
  balls:         "/examples/balls.coffee"
  bunnymark:     "/examples/bunnymark.coffee"
  morph:         "/examples/morph.coffee"
  primitives:    "/examples/primitives.coffee"
  rendertexture: "/examples/rendertexture.coffee"
  text:          "/examples/text.iced"
  filters:       "/examples/filters.coffee"

examples = {}
for name, path of exampleList then do (path) ->
  examples[name] = (cb) -> loadExample path, cb

module.exports = examples