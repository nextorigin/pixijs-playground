Spine      = require 'spine'
Iced       = require 'iced-coffee-script'
CodeMirror = require "codemirror"
IcedMirror = require "codemirror-iced-coffee-script"
js2coffee  = require "js2coffee/dist/js2coffee"
FileQueue  = require '../lib/filequeue'


capitalize = (str) -> str[0].toUpperCase() + str[1..]


class Editor extends Spine.Controller
  logPrefix: "(Playground:Editor)"

  DEFAULT_SETTINGS =
    lastVariable: '$_'

  elements:
    "nav.sandbox": "navSandbox"
    "textarea.sandbox": "placeholder"
    "footer": "footer"
    "aside#help": "help"

  toggleHelp: ->
    if @help.is ":visible" then @help.fadeOut 300
    else @help.fadeIn 300

  saveSettings: ->
    input = @val()
    @addToSaved input
    localStorage.settings = JSON.stringify $.extend {}, @settings, assets: window.assets, script: @saved

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
        when "coffee"  then @compileIced @saved
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
    "click button.help": "toggleHelp"
    "click button.save": "saveSettings"
    "click button.run": "runOrStopUserScript"
    "click button.refresh-example": "refreshExample"
    "mouseenter .CodeMirror": "mouseenterExampleNav"
    "mouseenter nav.sandbox": "mouseenterKeepExampleNav"
    "mouseleave .CodeMirror": "mouseleaveExampleNav"
    "click button.langswitch-coffee": "switchLang"
    "click button.langswitch-vanilla": "switchLang"
    "dragover footer": "fileDragHover"
    "dragleave footer": "fileDragHover"
    "drop footer": "fileSelectHandler"

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
        switch k
          when "assets", "userscripts"
            window[k] = v

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
    if @settings.script
      @val @settings.script
      @scrollToEnd()

  render: (examplename) ->
    @loadExample examplename

  val: (value) ->
    if value then @codemirror.doc.setValue "#{value}\n\n\n\n"
    else @codemirror.doc.getValue()

  loadExample: (name) ->
    @example = name
    await @examples[name] defer example
    @val example
    @scrollToEnd()

  scrollToEnd: -> @codemirror.scrollIntoView @codemirror.doc.lineCount() - 1

  refreshExample: -> @loadExample @example

  clear: -> @val ""

  compileIced: (source) -> Iced.compile source, bare: on, runtime: "inline"

  switchToVanilla: ->
    unless input = @val()
      @lang "vanilla"
      return true

    try
      compiled = @compileIced input
      @val compiled
      @lang "vanilla"
      return true
    catch e
      @console.printCompileError e
      return false

  switchToCoffee: ->
    unless input = @val()
      @lang "coffee"
      return true

    try
      compiled = js2coffee.build input, {show_src_lineno: true, indent: "  "}
      @val "#{compiled.code}"
      @lang "coffee"
      return true
    catch e
      output = @console.printCompileError e
      @print output
      return false

  fileDragHover: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @footer.toggleClass "draghover", e.type is "dragover"

  fileSelectHandler: (e) ->
    # cancel event and hover styling
    @fileDragHover e

    # fetch FileList object
    e = e.originalEvent if e.originalEvent?
    files = e.target.files or e.dataTransfer.files

    # process all File objects
    @parseFile file for file in files

  parseFile: (file) ->
    {type, name} = file
    if /(png|gif|jpeg|jpg)/.test type
      @parseImage file
    else if /(javascript|js|coffee|iced)/.test name
      @parseScript file
    else
      @console.print "Unknown filetype: #{type}: #{name}"

  parseImage: (file) ->
    {name} = file
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

  parseScript: (file) ->
    {name}    = file
    firstDot  = name.indexOf "."
    firstDot  = name.length if firstDot is -1
    guessname = capitalize name[0...firstDot]

    window.userscripts ?= []
    varname = "window.userscripts[#{window.userscripts.length}]"
    @console.print "Adding #{name} as window.#{guessname} = #{varname}"

    @fileQueue or= new FileQueue
    await @fileQueue.awaitRead {file: file, readAs: "Text"}, defer status, text
    return @log "Error: #{text}" if status is "error"

    text = @compileIced text if /(iced|coffee)/.test name

    try
      compiled = eval text
    catch e
      return @console.printCompileError e

    window.userscripts.push compiled
    window[guessname] = compiled
    value = switch @lang()
      when "coffee" then """# #{name}
# Success!  If this is a CommonJS module,
# it is available at window.#{guessname}
#
# to save this in localStorage with the script, run:
# app.editor.saveUserScript #{varname}
newscript = window.#{guessname}
#{@val().trim()}
"""
      when "vanilla" then """// #{name}
// Success!  If this is a CommonJS module,
// it is available at window.#{guessname}
//
// to save this in localStorage with the script, run:
// app.editor.saveUserScript(#{varname})
var newscript = window.#{guessname}
#{@val().trim()}
"""
    @val value
    @codemirror.scrollIntoView 0

  saveUserScript: (script) ->
    @settings.userscripts ?= []
    @settings.userscripts.push script unless script in @settings.userscripts

module.exports = Editor
