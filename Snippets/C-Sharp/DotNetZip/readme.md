https://github.com/haf/DotNetZip.Semverd

```
using (var fs = File.Create(filename))
{
  using(var s = new ZipOutputStream(fs))
  {
    s.PutNextEntry("entry1.txt");
    byte[] buffer = Encoding.ASCII.GetBytes("This is the content for entry #1.");
    s.Write(buffer, 0, buffer.Length);
  }
}
```
