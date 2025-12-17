## Immediate Window 
```Newtonsoft.Json.JsonConvert.SerializeObject(model, Newtonsoft.Json.Formatting.Indented)```


## Stopwatch
```
var stopwatch = Stopwatch.StartNew();
 >>>>>>>>> 
Debug.WriteLine($"*****************************");
Debug.WriteLine($"Elapsed time Questions/Read : {stopwatch.ElapsedMilliseconds} ms");
Debug.WriteLine($"*****************************");

stopwatch.Restart();
  >>>>>>>>>>>
Debug.WriteLine($"*****************************");
Debug.WriteLine($"Elapsed time Questions/Read: {stopwatch.ElapsedMilliseconds} ms");
Debug.WriteLine($"*****************************");

```
