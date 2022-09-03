SQL Error : String or binary data would be truncated.

Turn on TRACEON 460 for verbose error logging exception.Message

```
DBCC TRACEON(460, -1);
GO
```


**Error was:**
```String or binary data would be truncated. The statement has been terminated.```

**Error now:**
```String or binary data would be truncated in table test.dbo.Customer, column Email. Truncated value: 24327dgmnnyvup24327dgmnnyvup24327dgmnnyvup24327dgm.The statement has been terminated.```
