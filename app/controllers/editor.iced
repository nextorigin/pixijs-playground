Spine     = require 'spine'
FileQueue = require 'lib/filequeue'


class Editor extends Spine.Controller
  logPrefix: "(Playground:Editor)"

  DEFAULT_SETTINGS =
    lastVariable: '$_'

  elements:
    "nav.sandbox": "navSandbox"
    "textarea.sandbox": "placeholder"

  runOrStopUserScript: (e) ->
    button = $(e.target).closest('button')
    if button.is ".selected"
      @stopUserScript()
      button.text "run!"
    else
      @runUserScript()
      button.text "stop!"
    button.toggleClass "selected"

  runUserScript: ->
    return unless input = @val()
    @addToSaved input
    @processSaved()

  stopUserScript: -> window.cancelAnimationFrame window.frame

  processSaved: ->
    @trigger "presave"
    try
      compiled = switch @lang()
        when "coffee" then IcedCoffeeScript.compile @saved, bare: on
        when "vanilla" then @saved

      value = eval.call window, compiled
      window[@settings.lastVariable] = value
      @console.printValue value
    catch e
      @console.printCompileError e

    @saved = ''

  addToHistory: (s) =>
    @history.unshift s
    @historyi = -1

  addToSaved: (s) =>
    @saved += if s[...-1] is '\\' then s[0...-1] else s
    @saved += '\n'
    @addToHistory s

  mouseenterExampleNav:            -> @navSandbox.fadeIn 180
  mouseenterKeepExampleNav:        -> @navSandbox.stop(true).fadeTo 1, 1
  mouseleaveExampleNav:            -> @navSandbox.fadeOut 180

  switchLang: (e) ->
    el = $(e.target).closest('button')
    return if el.is ".selected"

    if ((el.is ".langswitch-coffee") and @switchToCoffee()) or @switchToVanilla()
      el.addClass("selected").siblings().removeClass "selected"

  lang: (name) ->
    if name then @trigger "langchange", @_lang = name
    else @_lang

  events:
    "click button.run": "runOrStopUserScript"
    "click button.refresh-example": "refreshExample"
    "mouseenter .CodeMirror": "mouseenterExampleNav"
    "mouseenter nav.sandbox": "mouseenterKeepExampleNav"
    "mouseleave .CodeMirror": "mouseleaveExampleNav"
    "click button.langswitch-coffee": "switchLang"
    "click button.langswitch-vanilla": "switchLang"
    "dragover .CodeMirror": "fileDragHover"
    "dragleave .CodeMirror": "fileDragHover"
    "drop .CodeMirror": "fileSelectHandler"

  constructor: (options, settings = {}) ->
    @history = []
    @historyi = -1
    @saved = ''
    # @multiline = false

    super

    @settings = $.extend({}, DEFAULT_SETTINGS)

    if localStorage and localStorage.settings
      for k, v of JSON.parse(localStorage.settings)
        @settings[k] = v

    for own k, v of settings
      @settings[k] = v

    CodeMirror.keyMap.tabSpace =
      fallthrough: ['default']
      Tab: (cm) ->
        spaces = Array(cm.getOption("indentUnit") + 1).join(" ")
        cm.replaceSelection spaces, "end", "+input"

    @codemirror or= CodeMirror.fromTextArea @placeholder[0], {
      mode: "icedcoffeescript"
      theme: "monokai"
      lineNumbers: true
      tabSize: 2
      keyMap: "tabSpace"
    }
    @wrapper = $ @codemirror.getWrapperElement()
    @wrapper.addClass "sandbox"

  render: (examplename) ->
    @loadExample examplename

  val: (value) ->
    if value then @codemirror.doc.setValue "#{value}\n\n\n\n"
    else @codemirror.doc.getValue()

  loadExample: (name) ->
    @example = name
    await @examples[name] defer example
    @val example
    @codemirror.scrollIntoView @codemirror.doc.lineCount() - 1

  refreshExample: -> @loadExample @example

  clear: -> @val ""

  switchToVanilla: ->
    unless input = @val()
      @lang "vanilla"
      return true

    try
      compiled = IcedCoffeeScript.compile input, bare: on
      @val compiled
      @lang "vanilla"
      return true
    catch e
      @console.printCompileError e
      return false

  # "js2coffee/out/lib/browser" refuses to be parsed by concatenator/minifier
  # switchToCoffee: ->
  #   unless input = @val()
  #     @lang "coffee"
  #     return true

  #   try
  #     compiled = js2coffee.build input, {show_src_lineno: true, indent: "  "}
  #     @val "#{compiled}"
  #     @lang "coffee"
  #     return true
  #   catch e
  #     output = @console.printCompileError e
  #     @print output
  #     return false

  switchToCoffee: ->
    @clear()
    @refreshExample()
    @lang "coffee"
    return true

  fileDragHover: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @wrapper.toggleClass "draghover", e.type is "dragover"

  fileSelectHandler: (e) ->
    # cancel event and hover styling
    @fileDragHover e

    # fetch FileList object
    e = e.originalEvent if e.originalEvent?
    files = e.target.files or e.dataTransfer.files

    # process all File objects
    @parseFile file for file in files

  parseFile: (file) ->
    {name, type} = file
    return @console.print "Unknown filetype: #{type}" unless /(png|gif|jpeg|jpg)/.test type

    window.assets or= []
    varname = "window.assets[#{window.assets.length}]"
    @console.print "Adding #{name} as #{varname}"

    @fileQueue or= new FileQueue
    await @fileQueue.awaitRead {file: file}, defer status, dataurl
    return @log "Error: #{dataurl}" if status is "error"

    window.assets.push dataurl
    value = switch @lang()
      when "coffee" then """# #{name}
newimage = #{varname}
#{@val().trim()}
"""
      when "vanilla" then """// #{name}
var newimage = #{varname}
#{@val().trim()}
"""
    @val value
    @codemirror.scrollIntoView 0



module.exports = Editor
