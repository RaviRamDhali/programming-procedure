
    var stopwatch = Stopwatch.StartNew();
    {
    ......... code block
    }
    stopwatch.Stop();
    Debug.WriteLine($"*****************************");
    Debug.WriteLine($"Elapsed time Initialize: {stopwatch.ElapsedMilliseconds} ms");
    Debug.WriteLine($"*****************************");

