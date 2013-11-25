## Bunnymark
## http://www.goodboydigital.com/pixijs/bunnymark/

# Try changing these values in the REPL
# while the code is running!
gravity = 0.75
maxX = stage.width
minX = 0
maxY = stage.height
minY = 0

wabbitTexture = undefined
pirateTexture = undefined
bunnys = []
startBunnyCount = 10
isAdding = false
count = 0
counter = 0
container = undefined
clickImage = undefined
amount = 10

update = ->
  stats.begin()
  if isAdding

    # add 10 at a time :)
    for i in [0..amount]
      bunny = new PIXI.Sprite wabbitTexture, {
        x: 0
        y: 0
        width: 26
        height: 37
      }
      bunny.speedX = Math.random() * 10
      bunny.speedY = (Math.random() * 10) - 5
      bunny.anchor.x = 0.5
      bunny.anchor.y = 1
      # bunny.alpha = 0.3 + Math.random() * 0.7
      bunny.scale.y = 1
      # bunny.rotation = Math.random() - 0.5
      # random = Math2.randomInt(0, container.children.length - 2)
      container.addChild bunny #, random
      bunnys.push bunny
      count++

    amount = 0 if count >= 16500
    counter.html count + " BUNNIES"

  for bunny in bunnys
    bunny.position.x += bunny.speedX
    bunny.position.y += bunny.speedY
    bunny.speedY += gravity
    if bunny.position.x > maxX
      bunny.speedX *= -1
      bunny.position.x = maxX
    else if bunny.position.x < minX
      bunny.speedX *= -1
      bunny.position.x = minX
    if bunny.position.y > maxY
      bunny.speedY *= -0.85
      bunny.position.y = maxY
      bunny.spin = (Math.random() - 0.5) * 0.2
      bunny.speedY -= Math.random() * 6  if Math.random() > 0.5
    else if bunny.position.y < minY
      bunny.speedY = 0
      bunny.position.y = minY

  renderer.render stage
  window.frame = requestAnimFrame update
  stats.end()

start = ->
  amount = (if (renderer instanceof PIXI.WebGLRenderer) then 10 else 5)
  if amount is 5
    renderer.context.mozImageSmoothingEnabled = false
    renderer.context.webkitImageSmoothingEnabled = false

  window.frame = requestAnimFrame update

  wabbitTexture = new PIXI.Texture.fromImage "images/bunny.png"
  counter = $ "<div />", class: "counter"
  $('body').append counter

  count = startBunnyCount
  counter.html count + " BUNNIES"

  container = new PIXI.DisplayObjectContainer()
  stage.addChild container

  bunnys = for i in [0..startBunnyCount]
    bunny = new PIXI.Sprite wabbitTexture, {
      x: 0
      y: 0
      width: 26
      height: 37
    }
    bunny.speedX = Math.random() * 10
    bunny.speedY = (Math.random() * 10) - 5
    bunny.anchor.x = 0.5
    bunny.anchor.y = 1
    container.addChild bunny
    bunny

  onTouchStart = (event) -> isAdding = true
  onTouchEnd = (event) -> isAdding = false

  $(document).mousedown(onTouchStart)
    .mouseup(onTouchEnd)

start()
