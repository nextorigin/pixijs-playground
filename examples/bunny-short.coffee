## Bunny demo using ani() helper method
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
  # lets rotate mr rabbit a little
  bunny.rotation += 0.1


ani animate