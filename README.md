# PixiJS Playground

Interactive PixiJS playground in [Iced] CoffeeScript and JavaScript. Like JSFiddle, with a REPL and HTML5 local file (image and script) drag + drop.

https://github.com/nextorigin/pixijs-playground

* [Demo](#demo)
* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
  + [Development gulp tasks](#development-gulp-tasks)
* [Credits](#credits)
* [License](#license)

## Demo
Fully-working demo available at http://pixijs-playground.nextorig.in .

## Installation
```sh
npm install pixijs-playground
```

## Usage

Run a simple Express server for the compiled static files
```
gulp serve
```

## Development
```sh
git clone https://github.com/nextorigin/pixijs-playground.git
cd pixijs-playground/
npm install
gulp build
gulp serve
```

### Development gulp tasks
```
$ gulp --tasks-simple
css:copy
css:watch
css:codemirror
styl
styl:watch
css
templatizer
coffee
coffee:watch
js:copy
js:watch
js
watchify
build
clean
watch
serve
```

## Credits

Built with:

  * [SpineJS](https://github.com/spine/spine) MVC framework

  * [Gulp](https://gulpjs.com) Streaming build system

  * [Browserify](https://browserify.com) Browser-side require()

  * [Pixi.js](https://github.com/GoodBoyDigital/pixi.js) Super fast HTML5 webGL/canvas 2D rendering engine

  * [stats.js](https://github.com/mrdoob/stats.js/) JavaScript [Frame Rendering] Performance Monitor

  * [Iced CoffeeScript](https://github.com/maxtaco/coffee-script), a superset of CoffeeScript with await/defer

  * [CodeMirror](https://github.com/marijnh/codemirror) In-Browser code editor

and some help from:

  * [coffeescript-repl](https://github.com/larryng/coffeescript-repl) In-Browser CoffeeScript advanced REPL

  * [js2coffee](https://github.com/rstacruz/js2coffee) JavaScript to CoffeeScript compiler


## License

MIT
