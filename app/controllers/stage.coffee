Spine    = require "spine"
{extend} = require "/lib/utils"


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

  removeChildren: ->
    @stage.removeChild child for child in @stage.children by -1

  refresh: ->
    @removeChildren()
    @stats.end()
    @renderer.render @stage


module.exports = Stage
