.Net project .gitignore file

```
*.suo
*.user
_ReSharper.*
bin
obj
```

After adding to the .gitignore
```
git rm -r --cached .
git add .
```
then
```
git commit -am "Remove ignored files"
```



git archive --format zip --output c:/full/path/to/zipfile.zip master

