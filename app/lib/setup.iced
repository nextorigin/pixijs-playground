require('json2ify')
require('es5-shimify')
jQuery = require('jqueryify')

require('spine')
require('spine/lib/local')
require('spine/lib/manager')
require('spine/lib/route')

require('iced-coffee-script')
# require('iced-coffee-script/extras/coffee-script-iced')

require('./spine.ajax')
require('./spine.awaitajax')

require('codemirror/lib/codemirror')
require('./codemirror-iced-coffee-script')

window.Math2 = require('./Math2')

jQuery ->
  return if window.app
  App = require "../pixijs-playground"
  window.app = new App el: $ "body"
