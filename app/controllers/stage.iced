Spine    = require "spine"
PIXI     = require "../lib/pixi.dev.js"


extend = (base, objs...) ->
  base[key] = value for key, value of obj for obj in objs
  base


class Stage extends Spine.Controller
  logPrefix: "(Playground:Stage)"

  pixidefaults:
    backgroundColor: 0xFFFFFF
    transparent: false
    antialias: false

  resize: ->

  bindResize: ->
    $(window).resize @resize
    $(window).on "onorientationchange", @resize

  release: ->
    $(window).off "resize", @resize
    $(window).off "onorientationchange", @resize

  _frameFns:     []
  addFrameFn:    (fn) -> @_frameFns.push fn
  removeFrameFn: (fn) -> @_frameFns.splice (@_frameFns.indexOf fn), 1

  ani: (loopfn = ->) ->
    @addFrameFn loopfn

    recursiveloop = =>
      # Beginning of animation loop
      @stats.begin()
      # Call the animation
      fn() for fn in @_frameFns
      # render the stage
      @renderer.render @stage
      # Recursively loop this animation
      @frame = requestAnimFrame recursiveloop
      # End of animation loop
      @stats.end()
    @frame = requestAnimFrame recursiveloop

  constructor: (options, pixisettings = {}) ->
    super

    @pixisettings      = extend {}, @pixidefaults, pixisettings

    @stage             = new PIXI.Stage @pixisettings.backgroundColor
    @stage.width       = @el.width()
    @stage.height      = @el.height()
    @stage.interactive = @pixisettings.interactive
    window.stage = this
    window.ani = @proxy @ani

    @render()
    @bindResize()
    @addChild = @append
    @removeChildren = @remove

  render: ->
    # let pixi choose WebGL or canvas
    @renderer = PIXI.autoDetectRenderer @stage.width,
                                        @stage.height,
                                        null,
                                        @pixisettings.transparent,
                                        @pixisettings.antialias
    @stats    = new Stats
    @$stats   = $ @stats.domElement

    # attach render to page
    @el.append @renderer.view
    @hideStats()
    @el.append @$stats

  hideStats: -> @$stats.css display: "none"
  showStats: -> @$stats.css display: "block"

  append: (children...) ->
    for child in children
      if child.display
        child.stage = this
        child = child.display
      @stage.addChild child
    this

  addChild: ->

  remove: (children...) ->
    children = @stage.children unless children.length

    for child in children by -1
      if child.display
        child.stage = null
        child = child.display
      @stage.removeChild child
    this

  removeChildren: ->

  refresh: ->
    @removeChildren()
    @stats.end()
    @renderer.render @stage

  stackLevel: (child) -> @stage.children.indexOf (child.display or child)

  bringToFront: (children...) ->
    @removeChildren children...
    @append children...

  sendToBack: (children...) ->
    @moveInStack children..., 0

  moveInStack: (children..., newLevel) ->
    @removeChildren children...
    @addChildrenAt children..., newLevel

  addChildrenAt: (children..., newLevel) ->
    for child in children
      if child.display
        child.stage = this
        child = child.display
    @stage.addChildAt (child.display or child), newLevel for child in children
    this


module.exports = Stage
