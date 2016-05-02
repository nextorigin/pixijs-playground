## Render Texture Demo
## http://www.goodboydigital.com/pixijs/examples/11/

w = stage.width
h = stage.height

# Try changing these values in the REPL
# while the code is running!
itemRotation      = 0.1
containerRotation = -0.01
zoomSpeed         = 0.01

# OOH! SHINY!
# create two render textures.. these dynamic textures will be used to draw the scene into itself
renderTexture  = new PIXI.RenderTexture w, h
renderTexture2 = new PIXI.RenderTexture w, h
currentTexture = renderTexture

# create a new sprite that uses the render texture we created above
outputSprite = new PIXI.Sprite(currentTexture)
# align the sprite
outputSprite.position.x = w / 2
outputSprite.position.y = h / 2
outputSprite.anchor.x = 0.5
outputSprite.anchor.y = 0.5
# add to stage
stage.addChild outputSprite

stuffContainer = new PIXI.DisplayObjectContainer()
stuffContainer.position.x = w / 2
stuffContainer.position.y = h / 2
stage.addChild stuffContainer

fruits = [
  "images/spinObj_01.png"
  "images/spinObj_02.png"
  "images/spinObj_03.png"
  "images/spinObj_04.png"
  "images/spinObj_05.png"
  "images/spinObj_06.png"
  "images/spinObj_07.png"
  "images/spinObj_08.png"]

items = for i in [0..20]
  item = PIXI.Sprite.fromImage(fruits[i % fruits.length])
  item.position.x = Math.random() * (w/2) - (h/2)
  item.position.y = Math.random() * (w/2) - (h/2)
  item.anchor.x = 0.5
  item.anchor.y = 0.5
  stuffContainer.addChild item
  item

# used for spinning!
count = 0

animate = ->
  # rotate each item
  item.rotation += itemRotation for item in items
  count += zoomSpeed

  # swap the buffers..
  temp = renderTexture
  renderTexture = renderTexture2
  renderTexture2 = temp

  # set the new texture
  outputSprite.setTexture renderTexture

  # twist this up!
  stuffContainer.rotation += containerRotation
  outputSprite.scale.x = outputSprite.scale.y = 1 + Math.sin(count) * 0.2

  # render the stage to the texture
  # the true clears the texture before content is rendered
  renderTexture2.render stage, true
  # and finally render the stage
  renderTexture.render stage

ani animate

