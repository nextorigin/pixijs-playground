## Dragging Demo
## http://www.goodboydigital.com/pixijs/examples/8/

# Try changing these values in the REPL
# while the code is running!
draggingAlpha = 0.8

createBunny = (texture, x, y) ->
  # create our little bunny friend..
  bunny = new PIXI.Sprite texture

  # enable the bunny to be interactive..
  # this will allow it to respond to mouse and touch events
  bunny.interactive = true

  # this button mode will mean the hand cursor appears
  # when you rollover the bunny with your mouse
  bunny.buttonMode = true

  # center the bunnys anchor point
  bunny.anchor.x = 0.5
  bunny.anchor.y = 0.5

  # make it a bit bigger, so its easier to touch
  bunny.scale.x = bunny.scale.y = 3

  # use the mousedown and touchstart
  bunny.mousedown = bunny.touchstart = (data) ->
    # stop the default event...
    data.originalEvent.preventDefault()

    # store a refference to the data
    # The reason for this is because of multitouch
    # we want to track the movement of this particular touch
    @data = data
    @alpha = draggingAlpha
    @dragging = @data.getLocalPosition(@parent)

  # set the events for when the mouse is released or a touch is released
  bunny.mouseup = bunny.mouseupoutside = bunny.touchend = bunny.touchendoutside = (data) ->
    # set the interaction data to null
    @data = null
    @alpha = 1
    @dragging = false

  # set the callbacks for when the mouse or a touch moves
  bunny.mousemove = bunny.touchmove = (data) ->
    return unless @dragging
    # need to get parent coords..
    newPosition  = @data.getLocalPosition(@parent)
    @position.x += newPosition.x - @dragging.x
    @position.y += newPosition.y - @dragging.y
    @dragging    = newPosition

  # move the sprite to its designated position
  bunny.position.x = x
  bunny.position.y = y

  # add it to the stage
  stage.addChild bunny
  bunny


# Try loading your own images
# by dragging them into the drop target!
texture = PIXI.Texture.fromImage "images/bunny.png"

# Create all bunnies
bunnys = for i in [0..10]
  createBunny texture, Math.random() * stage.width, Math.random() * stage.height

# turn on stage interaction
stage.interactive = true

# animate stage
ani ->
