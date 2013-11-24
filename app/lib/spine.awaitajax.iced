Spine = @Spine or require "spine"


awaitAjax =
  awaitAjax: (options, cb, queue = false) ->
    rv = new iced.Rendezvous()

    options.success = rv.id('success').defer data, statusText, xhr # data, statusText, xhr
    options.error   = rv.id('error').defer xhr, statusText, data # xhr, statusText, error

    if queue then @Q.ajaxQueue options
    else new $.ajax options

    await rv.wait defer status
    cb status, xhr, statusText, data

  awaitGet: (options, cb, queue) ->
    options.method = 'GET'
    @awaitAjax options, cb, queue

  awaitPost: (options, cb, queue) ->
    options.method = 'GET'
    @awaitAjax options, cb, queue

  awaitQueuedAjax: (options, cb) ->
    @awaitAjax options, cb, true

  awaitQueuedGet: (options, cb) ->
    @awaitGet options, cb, true

  awaitQueuedPost: (options, cb) ->
    @awaitPost options, cb, true


Spine.Class.extend.call Spine.Ajax, awaitAjax
module?.exports = awaitAjax