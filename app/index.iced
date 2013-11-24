require 'lib/setup'
emoji     = require 'emoji-images'

Spine    = require 'spine'
Stage    = require 'controllers/stage'
Console  = require 'controllers/console'
Editor   = require 'controllers/editor'
examples = require 'models/examples'


escapeHTML = (s) ->
  s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');


class App extends Spine.Controller
  logPrefix: "(Playground:App)"

  DEFAULT_SETTINGS =
    example: "bunnymark"
    lang: "coffee"

  elements:
    "aside#output": "output"
    "section.playground": "playground"
    "button.refresh-playground": "buttonRefreshPlayground"

  refreshPlayground: ->
    button = $ "button.run"
    if button.is ".selected" then button.trigger "click", target: button[0]
    @stage.refresh()

  selectExample: (e) -> @editor.render $(e.target).val()

  mouseenterPlaygroundRefresh:     -> @buttonRefreshPlayground.fadeIn 180 if @stage
  mouseenterKeepPlaygroundRefresh: -> @buttonRefreshPlayground.stop(true).fadeTo 1, 1
  mouseleavePlaygroundRefresh:     -> @buttonRefreshPlayground.fadeOut 180

  events:
    "click button.refresh-playground": "refreshPlayground"
    "change select.examples": "selectExample"
    "mouseenter section.playground": "mouseenterPlaygroundRefresh"
    "mouseenter button.refresh-playground": "mouseenterKeepPlaygroundRefresh"
    "mouseleave section.playground": "mouseleavePlaygroundRefresh"

  constructor: (options, settings = {}) ->
    super

    @settings = $.extend({}, DEFAULT_SETTINGS)

    if localStorage and localStorage.settings
      for k, v of JSON.parse(localStorage.settings)
        @settings[k] = v

    for own k, v of settings
      @settings[k] = v

    examplelist = (name for own name of examples)
    @render examplelist, @settings.example

  initStage: ->
    @stage ?= new Stage el: @playground
    @stage.showStats()
    @buttonRefreshPlayground.show()

  render: (examplelist = [], example) ->
    @view = require("views/index")({examples: examplelist, example: example})
    @view = emoji @view, "images/emoji", 20
    @html @view

    @log "settings.lang #{@settings.lang}"
    @console  = new Console el: @output, input: @$ "input.repl"
    @editor   = new Editor el: @el, examples: examples, console: @console
    @editor.on "presave", @proxy @initStage
    @editor.on "langchange", @console.proxy @console.lang
    @editor.lang @settings.lang

    @refreshPlayground() if @stage
    @editor.render example

  langChange: (name) -> @settings.lang = name


module.exports = App
