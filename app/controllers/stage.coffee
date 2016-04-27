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

  ani: (loopfn) ->
    recursiveloop = ->
      # Beginning of animation loop
      @stats.begin()
      # Call the animation
      loopfn()
      # render the stage
      @renderer.render @stage
      # Recursively loop this animation
      window.frame = requestAnimFrame recursiveloop
      # End of animation loop
      @stats.end()
    window.frame = requestAnimFrame recursiveloop

  constructor: (options, pixisettings = {}) ->
    super

    @pixisettings      = extend {}, @pixidefaults, pixisettings

    @stage             = new PIXI.Stage @pixisettings.backgroundColor
    @stage.width       = @el.width()
    @stage.height      = @el.height()
    @stage.interactive = @pixisettings.interactive
    window.stage  = @stage

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
    $('body').append @$stats

    # "Export" values where sandbox can reach them
    window.renderer = @renderer
    window.stats    = @stats
    window.frame    = undefined
    window.ani      = @ani

  hideStats: -> @$stats.css display: "none"
  showStats: -> @$stats.css display: "block"

  removeChildren: ->
    @stage.removeChild child for child in @stage.children by -1

  refresh: ->
    @removeChildren()
    @stats.end()
    @renderer.render @stage


module.exports = Stage
