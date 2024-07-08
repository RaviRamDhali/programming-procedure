# .gitignore not working
To untrack every file that is now in your .gitignore
Commit any code changes

This removes any changed files from the index(staging area)

```git rm -r --cached . ```

Then

```git add . ```

Commit it:

```git commit -m ".gitignore is now working"```
