mkdirp  = require "mkdirp"
path    = require "path"
gulp    = require "gulp"
Plugins = require "gulp-load-plugins"
Combine = require "stream-combiner"
tmpl    = require "templatizer"
bify    = require "browserify"
bifyshm = require "browserify-global-shim"
source  = require "vinyl-source-stream"
wtfy    = require "watchify"
chalk   = require "chalk"
del     = require "del"


plugins     = Plugins()
{log}       = plugins.util
{src, dest} = gulp



config =
  builddirs: [
    "build/*"
    "public/js/*"
    "public/css/*"
  ]
  css:
    src:  "css/*.css"
    dest: "public/css/"
  styl:
    src:  "css/*.styl"
    dest: "public/css"
  js:
    src:  "app/**/*.js"
    dest: "build/js/"
  templatizer:
    src:  "app/views/"
    dest: "build/js/views/templates.js"
  coffee:
    src:  "app/**/*.iced"
    dest: "build/js/"
  browserify:
    libs: [
      "lib/stats.min.js",
      "lib/pixi.dev.js",
      "lib/Tween.js"
      "build/js/pixijs-playground.js"
    ]
    dest: "public/js/"


notifier = plugins.notify.onError title: "pixijs-playground - error", message: "<%= error.message %>"

copyCSS = new Combine [
  plugins.changed config.css.dest
  dest config.css.dest
]

compileStyl = new Combine [
  plugins.changed config.styl.dest, extension: ".css"
  plugins.sourcemaps.init()
  plugins.stylus().on "error", notifier
  plugins.autoprefixer()
  plugins.sourcemaps.write()
  dest config.styl.dest
]

copyJS = new Combine [
  plugins.changed config.js.dest
  dest config.js.dest
]

compileCoffee = new Combine [
  plugins.changed config.coffee.dest, extension: ".js"
  plugins.sourcemaps.init()
  plugins.icedCoffee().on "error", notifier
  plugins.sourcemaps.write()
  dest config.coffee.dest
]

makewatcher = (src) ->
  events  = "add,change,unlink,addDir,unlinkDir,error".split ","
  watcher = plugins.watch src
  for event in events then do (event) ->
    watcher.on event, (path) -> log "#{event}:", path
  watcher

bundleAll = (watch = false) ->
  watch = watch is true
  b     = bify config.browserify.libs, fullPaths: watch, cache: {}, packageCache: {}
  shim  = bifyshm.configure "jquery": "$", appliesTo: includeExtensions: ['.js']

  b.transform shim, global: true
  if watch
    log "watching"
    b = wtfy b

  bundle = ->
    log "bundling"
    b.bundle()
      .on "error", notifier
      .pipe source "pixijs-playground.js"
      .pipe dest config.browserify.dest
  lasttime = 0

  b.on "update", bundle
  b.on "time", (time) -> lasttime = time
  b.on "bytes", (bytes) ->
    log "Bundled " + (chalk.cyan (Math.round bytes/1024) + "Kb") + " after " + chalk.magenta "#{lasttime}ms"

  bundle()

clean = (cb) -> del config.builddirs, cb


gulp.task "css:copy", ->
  src   config.css.src
  .pipe copyCSS

gulp.task "css:watch", ->
  src   config.css.src
  .pipe makewatcher config.css.src
  .pipe copyCSS

gulp.task "styl", ->
  src   config.styl.src
  .pipe compileStyl

gulp.task "styl:watch", ->
  src   config.styl.src
  .pipe makewatcher config.styl.src
  .pipe compileStyl

gulp.task "css", ["css:copy", "styl"]

gulp.task "templatizer", ->
  mkdirp.sync path.dirname config.templatizer.dest
  tmpl config.templatizer.src, config.templatizer.dest

gulp.task "coffee", ->
  src   config.coffee.src
  .pipe compileCoffee

gulp.task "coffee:watch", ->
  src   config.coffee.src
  .pipe makewatcher config.coffee.src
  .pipe compileCoffee

gulp.task "js:copy", ->
  src   config.js.src
  .pipe copyJS

gulp.task "js:watch", ->
  src   config.js.src
  .pipe makewatcher config.js.src
  .pipe copyJS

gulp.task "js", ["js:copy", "templatizer", "coffee"], bundleAll
gulp.task "watchify", -> bundleAll true

gulp.task "build", ["styl", "css", "js"]
gulp.task "clean", clean
gulp.task "watch", ["styl:watch", "js:watch", "coffee:watch", "watchify"]
gulp.task "default", ["build"]
