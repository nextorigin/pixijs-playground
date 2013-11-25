## Bunny demo
## http://www.goodboydigital.com/pixi-js-tutorial-getting-started/

# create the sprite from bunny texture
texture = PIXI.Texture.fromImage "images/bunny.png"
bunny = new PIXI.Sprite texture

# rotate around center
bunny.anchor.x = 0.5
bunny.anchor.y = 0.5

# center sprite in stage
bunny.position.x = 200
bunny.position.y = 150

# place it on the stage for rendering
stage.addChild bunny

animate = ->
  # Beginning of animation loop
  stats.begin()

  # lets rotate mr rabbit a little
  bunny.rotation += 0.1

  # render the stage
  renderer.render stage

  # Recursively loop this animation
  window.frame = requestAnimFrame animate

  # End of animation loop
  stats.end()

window.frame = requestAnimFrame animate