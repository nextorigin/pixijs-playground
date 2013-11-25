## Text Demo
## http://www.goodboydigital.com/pixijs/examples/8/


loadBitmapFont = ->
  # create a new loader
  assetsToLoader = ["images/text/desyrel.fnt"]
  loader = new PIXI.AssetLoader(assetsToLoader)

  # use await block to wait for callback
  await
    loader.onComplete = defer()
    # begin load
    loader.load()

  bitmapFontText = new PIXI.BitmapText "bitmap fonts are\n now supported!",
    font: "35px Desyrel"
    align: "right"
  bitmapFontText.position.x = stage.width - bitmapFontText.width - 20
  bitmapFontText.position.y = 20

  PIXI.runList bitmapFontText
  stage.addChild bitmapFontText

loadWebFonts = (callback) ->
  window.WebFontConfig =
    google: families: ["Snippet", "Arvo:700italic", "Podkova:700"]
    active: callback

  do ->
    wf = document.createElement "script"
    wf.src = ((if "https:" is document.location.protocol then "https" else "http")) + "://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
    wf.type = "text/javascript"
    wf.async = "true"
    s = (document.getElementsByTagName "script")[0]
    s.parentNode.insertBefore wf, s
    window.wf = wf


init = ->
  loadBitmapFont()

  # add a shiney background..
  background = PIXI.Sprite.fromImage("images/text/textDemoBG.jpg")
  stage.addChild background

  # create some white text using the Snippet webfont
  textSample = new PIXI.Text "Pixi.js can has\nmultiline text!",
    font: "35px Snippet"
    fill: "white"
    align: "left"
  textSample.position.x = 20
  textSample.position.y = 20

  # create a text object with a nice stroke
  spinningText = new PIXI.Text "I'm fun!",
    font: "bold 72px Podkova"
    fill: "#cc00ff"
    align: "center"
    stroke: "#FFFFFF"
    strokeThickness: 6

  # setting the anchor point to 0.5 will center align the text... great for spinning!
  spinningText.anchor.x = spinningText.anchor.y = 0.5
  spinningText.position.x = stage.width / 2
  spinningText.position.y = stage.height / 2

  # create a text object that will be updated..
  countingText = new PIXI.Text "COUNT 4EVAR: 0",
    font: "bold italic 48px Arvo"
    fill: "#3e1707"
    align: "center"
    stroke: "#a4410e"
    strokeThickness: 7
  countingText.position.x = stage.width / 2
  countingText.position.y = stage.height * 2/3
  countingText.anchor.x = 0.5

  # add Text objects to stage
  stage.addChild textSample
  stage.addChild spinningText
  stage.addChild countingText


  count = 0
  score = 0

  animate = ->
    count++
    if count is 50
      count = 0
      score++
      # update the text...
      countingText.setText "COUNT 4EVAR: " + score

    # just for fun, lets rotate the text
    spinningText.rotation += 0.03

  ani animate


if window.wf
  init()
else
  await loadWebFonts defer()
  init()
