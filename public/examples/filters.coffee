## WebGL Filters Demo
## http://www.goodboydigital.com/pixijs-webgl-filters/

# Helper fn
camelCase = (word) -> word[1].toLowerCase() + word[1..-1]

# Initialize GUI
$(".dg.main").remove()
dat = require "lib/dat.gui.min"
gui = new dat.GUI

# Enable first filter only
filtersSwitchs = [true, false, false, false, false, false, false, false, false, false, false]

# One of these filters is not like the other filters
displacementTexture = PIXI.Texture.fromImage("images/filters/displacement_map.jpg")
displacementFilter  = new PIXI.DisplacementFilter(displacementTexture)
displacementFolder  = gui.addFolder("Displacement")
displacementFolder.add(filtersSwitchs, "0").name "apply"
displacementFolder.add(displacementFilter.scale, "x", 1, 200).name "scaleX"
displacementFolder.add(displacementFilter.scale, "y", 1, 200).name "scaleY"

# Filter GUI properties
Filters =
  Blur: sliders:
    blurX: prop: "blurX", start: 0, end: 32
    blurY: prop: "blurY", start: 0, end: 32

  Pixelate: sliders:
    PixelSizeX: prop: "x", start: 1, end: 32, subprop: "size"
    PixelSizeY: prop: "y", start: 1, end: 32, subprop: "size"

  Invert: sliders:
    Invert: prop: "invert", start: 0, end: 1

  Grey: sliders:
    Grey: prop: "grey", start: 0, end: 1

  Sepia: sliders:
    Sepia: prop: "sepia", start: 0, end: 1

  Twist: sliders:
    Angle:      prop: "angle",  start: 0, end: 10
    Radius:     prop: "radius", start: 0, end: 1
    "offset.x": prop: "x",      start: 0, end: 1, subprop: "offset"
    "offset.y": prop: "y",      start: 0, end: 1, subprop: "offset"

  DotScreen: sliders:
    Angle: prop: "angle", start: 0, end: 10
    Scale: prop: "scale", start: 0, end: 1

  ColorStep: sliders:
    step: prop: "step",  start: 1, end: 100

  CrossHatch: {}
  RGBSplit: {}


# Filter GUI Factory
filterId = 1
createFilter = (name, props) ->
  camelName = camelCase name
  filter = window["#{camelName}Filter"] = new PIXI["#{name}Filter"]()
  folder = window["#{camelName}Folder"] = gui.addFolder name
  folder.add(filtersSwitchs, "#{filterId++}").name "apply"
  if sliders = props.sliders
    for title, slider of sliders
      toChange = if slider.subprop then filter[slider.subprop] else filter
      folder.add(toChange, slider.prop, slider.start, slider.end).name title
  filter

# Create Filter GUI
filterCollection = (createFilter name, filter for name, filter of Filters)
filterCollection.unshift displacementFilter

# Setup stage
pondContainer = new PIXI.DisplayObjectContainer()
stage.addChild pondContainer
stage.interactive = true
bg        = PIXI.Sprite.fromImage("images/filters/displacement_BG.jpg")
bg.width  = stage.width
bg.height = stage.height
pondContainer.addChild bg

# Set bounds for fish
padding = 100
bounds = new PIXI.Rectangle -padding, -padding, stage.width + padding * 2, stage.height + padding * 2

# Create fishes
fishs = for i in [0..20]
  fishId = i % 4
  fishId++

  fish            = PIXI.Sprite.fromImage "images/filters/displacement_fish#{fishId}.png"
  fish.anchor.x   = fish.anchor.y = 0.5
  fish.direction  = Math.random() * Math.PI * 2
  fish.speed      = 2 + Math.random() * 2
  fish.turnSpeed  = Math.random() - 0.8
  fish.position.x = Math.random() * bounds.width
  fish.position.y = Math.random() * bounds.height
  fish.scale.x    = fish.scale.y = 0.8 + Math.random() * 0.3

  pondContainer.addChild fish
  fish

# Create waves overlay
waves   = PIXI.Texture.fromImage "images/filters/zeldaWaves.png"
overlay = new PIXI.TilingSprite waves, stage.width, stage.height
overlay.alpha = 0.2
pondContainer.addChild overlay

displacementFilter.scale.x = 50
displacementFilter.scale.y = 50


count = 0
switchy = false


animate = ->
  count += 0.1
  blurAmount  = Math.cos(count)
  blurAmount2 = Math.sin(count * 0.8)
  filtersToApply = (filter for i, filter of filterCollection when filtersSwitchs[i])
  pondContainer.filters = (if filtersToApply.length then filtersToApply else null)

  for fish in fishs
    fish.direction  += fish.turnSpeed * 0.01
    fish.position.x += Math.sin(fish.direction) * fish.speed
    fish.position.y += Math.cos(fish.direction) * fish.speed
    fish.rotation    = -fish.direction - Math.PI / 2

    # wrap..
    fish.position.x += bounds.width  if fish.position.x < bounds.x
    fish.position.x -= bounds.width  if fish.position.x > bounds.x + bounds.width
    fish.position.y += bounds.height if fish.position.y < bounds.y
    fish.position.y -= bounds.height if fish.position.y > bounds.y + bounds.height

  displacementFilter.offset.x = count * 10 #blurAmount * 40;
  displacementFilter.offset.y = count * 10
  overlay.tilePosition.x      = count * -10 #blurAmount * 40;
  overlay.tilePosition.y      = count * -10

ani animate

