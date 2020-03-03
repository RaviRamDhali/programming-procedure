You can use github context for such purpose. Example:

```
jobs:
  build:
    name: Build
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v1
      - if: ${{ github.actor == "MickeyMouse" }}
        run: ./runMickeyScripts.sh
      - if: ${{ github.actor != "MickeyMouse" }}
        run: ./runNotMickeyScripts.sh
```


Resource:

https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions
