GitHub Settings Actions Secrest setting for Website ASPX Connection String secrest

![image](https://user-images.githubusercontent.com/1455413/199467758-d34da197-6127-4156-a4fa-f2e9e0bd3012.png)

```
metadata=res://*/Model.csdl|res://*/Model.ssdl|res://*/Model.msl;provider=System.Data.SqlClient;provider connection string=&quot;Data Source=sql.server.com,3389;Initial Catalog=TestSolution;User ID=Tester;Password=xxxxxxxxxxxx;Integrated Security=False;MultipleActiveResultSets=True&quot;
```

## ConnectionStrings.DefaultConnection
Taget **ConnectionStrings.DefaultConnection** (Parent.Child)

```
- run: echo "Variable Substitution json"
        - uses: microsoft/variable-substitution@v1 
          with:
            files: './WebApi/appsettings.json'
          env:
            ConnectionStrings.DefaultConnection: ${{ secrets.CONNSTRING_PROD }}
```
