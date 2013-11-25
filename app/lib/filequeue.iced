class FileQueue
  enabled: true

  disable: (callback) ->
    if @enabled
      @enabled = false
      try
        do callback
      catch e
        throw e
      finally
        @enabled = true
    else
      do callback

  max: 100
  throttle: 0

  queue: (request) ->
    @pipeliner or= new Pipeliner @max, @throttle
    return @pipeliner.queue unless request
    await @pipeliner.waitInQueue defer()
    request @pipeliner.defer()

  clearQueue: ->
    @pipeliner.queue = []
    @pipeliner.n_out = 0

  defaults:
    readAs: "DataURL"
    encoding: "UTF-8"

  readFile: (params = {}, defaults = {}) ->
    settings       = $.extend({}, @defaults, defaults, params) unless defaults is true
    reader         = new FileReader
    reader.onload  = (e) -> settings.success reader.result
    reader.onerror = settings.error

    read = switch settings.readAs
      when "ArrayBuffer"  then reader.readAsArrayBuffer settings.file, settings.encoding
      when "BinaryString" then reader.readAsBinaryString settings.file, settings.encoding
      when "DataURL"      then reader.readAsDataURL settings.file, settings.encoding
      when "Text"         then reader.readAsText settings.file, settings.encoding

    reader

  queueFile: (params = {}, defaults = {}) ->
    rv  = new iced.Rendezvous

    settings     = $.extend({}, @defaults, defaults, params)
    defersuccess = settings.success
    defererror   = settings.error

    settings.success = rv.id('success').defer e
    settings.error   = rv.id('error').defer e

    request = (next) ->
      reader = @readFile settings, true
      await rv.wait defer status
      switch status
        when 'success' then defersuccess reader.result
        when 'error' then defererror e
      next()

    request.abort = (statusText) ->
      return reader.abort(statusText) if reader
      index = @queue().indexOf(request)
      @queue().splice(index, 1) if index > -1
      Ajax.pipeliner.n_out-- if Ajax.pipeliner

      # deferred.rejectWith(
      #   settings.context or settings,
      #   [reader, statusText, '']
      # )
      request

    return request unless Ajax.enabled
    @queue request
    request

  awaitRead: (options, cb, queue = false) ->
    rv = new iced.Rendezvous()

    options.success = rv.id('success').defer result
    options.error   = rv.id('error').defer e

    if queue then @fileQueue options
    else @readFile options

    await rv.wait defer status
    cb status, result or e


module.exports = FileQueue