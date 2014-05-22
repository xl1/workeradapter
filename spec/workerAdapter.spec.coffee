describe 'WorkerAdapter', ->
  it 'should create worker', ->
    w = new WorkerAdapter ->
    expect w.worker instanceof Worker
      .toBe true

  it 'should return the value returned by the inner function', ->
    r = null
    runs ->
      new WorkerAdapter(-> 42)
        .run()
        .then (result) -> r = result
    waitsFor 40, -> r
    runs ->
      expect(r).toBe 42

  it 'should pass arguments', ->
    r = null
    runs ->
      new WorkerAdapter((x, y) -> x + y)
        .run(10, 20)
        .then (result) -> r = result
    waitsFor 40, -> r
    runs ->
      expect(r).toBe 30
