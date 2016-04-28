path     = require "path"
Skeleton = require "nextorigin-express-skeleton"
extend   = (require "util")._extend


class Server extends Skeleton
  port: 9294

  constructor: (options = {}) ->
    defaults =
      static:  path.join __dirname, "../public"
      favicon: path.join __dirname, "../public/favicon.ico"
    super extend defaults, options
    @app.use (require "connect-livereload")() if (@app.get "env") is "development"


server = new Server
server.listen()
