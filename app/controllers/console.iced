Spine     = require 'spine'
nodeutil  = require '../lib/nodeutil'


class Console extends Spine.Controller
  logPrefix: "(Playground:Console)"

  DEFAULT_SETTINGS =
    lastVariable: '$_'
    maxLines: 8
    maxDepth: 2
    showHidden: false
    colorize: true

  elements:
    "button.refresh-console": "buttonRefreshConsole"

  addToHistory: (s) =>
    @history.unshift s
    @historyi = -1

  addToSaved: (s) =>
    @saved += if s[...-1] is '\\' then s[0...-1] else s
    @saved += '\n'
    @addToHistory s

  handleKeypress: (e) =>
    switch e.which
      when 13
        e.preventDefault()
        input = @input.val()

        if input
          @addToSaved input
          if input[...-1] isnt '\\' and not @multiline
            @processSaved()

      when 27
        e.preventDefault()
        input = @input.val()

        if input and @multiline and @saved
          input = @input.val()

          @addToSaved input
          @processSaved()
        else if @multiline and @saved
          @processSaved()

        @multiline = not @multiline
        # @setPrompt()

      when 38
        e.preventDefault()

        if @historyi < @history.length-1
          @historyi += 1
          @input.val @history[@historyi]

      when 40
        e.preventDefault()

        if @historyi > 0
          @historyi += -1
          @input.val @history[@historyi]

  mouseenterConsoleRefresh:        -> @buttonRefreshConsole.fadeIn 180
  mouseenterKeepConsoleRefresh:    -> @buttonRefreshConsole.stop(true).fadeTo 1, 1
  mouseleaveConsoleRefresh:        -> @buttonRefreshConsole.fadeOut 180

  events:
    "mouseenter aside#output": "mouseenterConsoleRefresh"
    "mouseenter button.refresh-console": "mouseenterKeepConsoleRefresh"
    "mouseleave aside#output": "mouseleaveConsoleRefresh"

  constructor: (options, settings = {}) ->
    @history = []
    @historyi = -1
    @saved = ''
    @multiline = false

    super
    @input.keydown @handleKeypress

    @settings = $.extend({}, DEFAULT_SETTINGS)

    if localStorage and localStorage.settings
      for k, v of JSON.parse(localStorage.settings)
        @settings[k] = v

    for own k, v of settings
      @settings[k] = v


  lang: (name) ->
    if name then @_lang = name
    else @_lang

  processSaved: ->
    try
      compiled = switch @lang()
        when "coffee" then IcedCoffeeScript.compile @saved, bare: on
        when "vanilla" then @saved

      value = eval.call window, compiled
      window[@settings.lastVariable] = value
      @printValue value
    catch e
      @printCompileError e
    finally
      @saved = ''

  print: (args...) =>
    s = args.join(' ') or ' '
    o = @el.html() + s + '\n'
    @html o.split('\n')[-@settings.maxLines...].join('\n')
    undefined

  printValue: (value) =>
    @print nodeutil.inspect value, @settings.showHidden, @settings.maxDepth, @settings.colorize

  printCompileError: (e) ->
    if e.stack
      output = e.stack
     # FF doesn't have Error.toString() as the first line of Error.stack
     # while Chrome does.
     if output?.split('\n')[0] isnt e.toString()
        output = "#{e.toString()}\n#{e.stack}"
    else
      output = e.toString()
    @print output



module.exports = Console