## Photonstorm Balls Demo
## http://gametest.mobi/pixi/balls/

w = stage.width
h = stage.height
stars = []

# Try changing these values in the REPL
# while the code is running!
starCount = 2500
sx = 1.0 + (Math.random() / 20)
sy = 1.0 + (Math.random() / 20)
slideX = w / 2
slideY = h / 2

start = ->
  ballTexture = new PIXI.Texture.fromImage "images/bubble_32x32.png"

  stars = for i in [0..starCount]
    tempBall = new PIXI.Sprite(ballTexture)

    tempBall.position.x = (Math.random() * w) - slideX
    tempBall.position.y = (Math.random() * h) - slideY
    tempBall.anchor.x = 0.5
    tempBall.anchor.y = 0.5

    stage.addChild(tempBall)
    {sprite: tempBall, x: tempBall.position.x, y: tempBall.position.y}

  # $('#rnd').click newWave
  # $('#sx').html 'SX: ' + sx + '<br />SY: ' + sy

  window.frame = requestAnimFrame(update)

newWave = ->
  sx = 1.0 + (Math.random() / 20)
  sy = 1.0 + (Math.random() / 20)
  $('#sx').html 'SX: ' + sx + '<br />SY: ' + sy

# resize = ->
#   w = stage.width - 16
#   h = stage.height - 16

#   slideX = w / 2
#   slideY = h / 2

#   renderer.resize(w, h)

update = ->
  stats.begin()
  for i in [0..starCount]
    stars[i].sprite.position.x = stars[i].x + slideX
    stars[i].sprite.position.y = stars[i].y + slideY
    stars[i].x = stars[i].x * sx
    stars[i].y = stars[i].y * sy

    if      stars[i].x > w  then stars[i].x = stars[i].x - w
    else if stars[i].x < -w then stars[i].x = stars[i].x + w

    if      stars[i].y > h  then stars[i].y = stars[i].y - h
    else if stars[i].y < -h then stars[i].y = stars[i].y + h

  renderer.render(stage)
  window.frame = requestAnimFrame(update)
  stats.end()


start()