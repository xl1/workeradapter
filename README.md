# WorkerAdapter

- converts a function to a web worker.
- wraps a worker in promises.

```js
new WorkerAdapter(function(x, y, z){
  return x + y + z;
}).run(10, 20, 30).then(function(result){
  console.log(result); // 60
});
```
