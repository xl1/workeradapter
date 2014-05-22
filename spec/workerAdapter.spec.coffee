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

  it 'can run repeatedly', ->
    r1 = r2 = r3 = null
    runs ->
      w = new WorkerAdapter (x) -> x * 2
      w.run(3).then (result) ->
        r1 = result
        w.run(r1).then (result) ->
          r2 = result
      w.run(4).then (result) ->
        r3 = result
    waitsFor 40, -> r1 && r2 && r3
    runs ->
      expect(r1).toBe 6
      expect(r2).toBe 12
      expect(r3).toBe 8
