## Photonstorm Morph Demo
## http://gametest.mobi/pixi/morph/

# Try changing these values in the REPL
# while the code is running!
n = 2000
d = 1
current = 1
objs = 17
vx = 0
vy = 0
vz = 0

w = stage.width
h = stage.height
points1 = []
points2 = []
points3 = []
tpoint1 = []
tpoint2 = []
tpoint3 = []
balls = []

nextObject = ->
  current++
  current = 0 if current > objs
  makeObject current
  setTimeout nextObject, 8000

makeObject = (t) ->
  xd = undefined
  i = -1

  switch t
    when 0
      while ++i < n
        points1[i] = -50 + Math.round(Math.random() * 100)
        points2[i] = 0
        points3[i] = 0

    when 1
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10)
        points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10)
        points3[i] = Math.sin(xd) * 100

    when 2
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10)
        points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 3
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(xd) * 100

    when 4
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 5
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 6
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 7
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 8
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10)
        points3[i] = Math.sin(xd) * 100

    when 9
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(xd) * 100

    when 10
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 11
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10)
        points3[i] = Math.sin(xd) * 100

    when 12
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.sin(xd) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 13
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 14
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.sin(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 15
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

    when 16
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10)
        points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10)
        points3[i] = Math.sin(xd) * 100

    when 17
      while ++i < n
        xd = -90 + Math.round(Math.random() * 180)
        points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10)
        points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10)
        points3[i] = Math.sin(i * 360 / n) * 100

update = ->
  x3d = undefined
  y3d = undefined
  z3d = undefined
  tx = undefined
  ty = undefined
  tz = undefined
  ox = undefined
  d++  if d < 250
  vx += 0.0075
  vy += 0.0075
  vz += 0.0075
  i = 0

  while i < n
    tpoint1[i]++  if points1[i] > tpoint1[i]
    tpoint1[i]--  if points1[i] < tpoint1[i]
    tpoint2[i]++  if points2[i] > tpoint2[i]
    tpoint2[i]--  if points2[i] < tpoint2[i]
    tpoint3[i]++  if points3[i] > tpoint3[i]
    tpoint3[i]--  if points3[i] < tpoint3[i]
    x3d = tpoint1[i]
    y3d = tpoint2[i]
    z3d = tpoint3[i]
    ty = (y3d * Math.cos(vx)) - (z3d * Math.sin(vx))
    tz = (y3d * Math.sin(vx)) + (z3d * Math.cos(vx))
    tx = (x3d * Math.cos(vy)) - (tz * Math.sin(vy))
    tz = (x3d * Math.sin(vy)) + (tz * Math.cos(vy))
    ox = tx
    tx = (tx * Math.cos(vz)) - (ty * Math.sin(vz))
    ty = (ox * Math.sin(vz)) + (ty * Math.cos(vz))
    balls[i].position.x = (512 * tx) / (d - tz) + w / 2
    balls[i].position.y = (h / 2) - (512 * ty) / (d - tz)
    i++

start = ->
  # Try creating your own texture by dragging and dropping
  # an image file onto the drop target!
  ballTexture = new PIXI.Texture.fromImage "images/pixel.png"
  makeObject 0
  i = 0

  while i < n
    tpoint1[i] = points1[i]
    tpoint2[i] = points2[i]
    tpoint3[i] = points3[i]
    tempBall = new PIXI.Sprite(ballTexture)
    tempBall.anchor.x = 0.5
    tempBall.anchor.y = 0.5
    tempBall.alpha = 0.5
    balls[i] = tempBall
    stage.addChild tempBall
    i++

  setTimeout nextObject, 5000
  ani update

start()
