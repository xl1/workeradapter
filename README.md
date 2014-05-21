# WorkerAdapter

function --> Web worker

```coffee
new WorkerAdapter (x, y, z) ->
  result.sum = x + y + z
.run 10, 20, 30
.then ({ result }) ->
  console.log result.sum # 60
```
