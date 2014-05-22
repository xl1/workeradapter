uuid = do ->
  re = /[xy]/g
  replacer = (c) ->
    r = Math.random() * 16 |0
    (if c is 'x' then r else (r & 3 | 8)).toString 16
  ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(re, replacer).toUpperCase()


class WorkerAdapter
  @makeWorker = (code) ->
    blob = new Blob [code], type: 'text/javascript'
    new Worker window.URL.createObjectURL blob

  constructor: (func) ->
    @resolveFunctions = {}
    @worker = WorkerAdapter.makeWorker """
      var __func = (#{func});
      addEventListener('message', function(e){
        if(e.data.type === 'run')
          postMessage({
            type: 'end',
            result: __func.apply(null, e.data.arguments),
            original: e.data
          });
      }, false);
    """
    @worker.addEventListener 'message', ({ data }) =>
      if data.type is 'end'
        id = data.original.id
        @resolveFunctions[id]?(data.result)
        delete @resolveFunctions[id]
    , false

  run: (args...) ->
    id = uuid()
    new Promise (resolve, reject) =>
      @resolveFunctions[id] = resolve
      @worker.postMessage
        type: 'run'
        id: id
        arguments: args


if 'self' of @
  @WorkerAdapter = WorkerAdapter
module?.exports = WorkerAdapter
