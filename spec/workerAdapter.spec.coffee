describe 'WorkerAdapter', ->
  it 'should create worker', ->
    w = new WorkerAdapter ->
    expect w.worker instanceof Worker
      .toBe true

  it 'should return `result` object', ->
    r = null
    runs ->
      new WorkerAdapter ->
        result.answer = 42
      .run().then ({ result }) -> r = result
    waitsFor 40, -> r
    runs ->
      expect(r).toEqual answer: 42

  it 'should pass arguments', ->
    r = null
    runs ->
      new WorkerAdapter (x, y) ->
        result.xplusy = x + y
      .run(10, 20).then ({ result }) -> r = result
    waitsFor 40, -> r
    runs ->
      expect(r).toEqual xplusy: 30
