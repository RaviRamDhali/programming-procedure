## Revert a single file to its state at the time a branch was created

You can revert a single file to its state at the time a branch was created using the git checkout command.

Use these three steps to revert the file **SomeFile.txt** to its content when your branch was created.

The key is to find the commit hash of the point where your branch was created and then use that hash to checkout the specific file.

-----

### 1\. Find the Base Commit

Get the commit hash where your current branch diverged from the main branch.

```
git merge-base HEAD main
```

-----

### 2\. Revert the File

Use the commit hash from Step 1 to check out the file's historical content.

```
git checkout <COMMIT_HASH> -- SomeFile.txt
```

-----

### 3\. Commit the Change

Finalize the reversion by committing the local change.

```
git commit -m "Revert SomeFile.txt to its state at branch creation"
```
