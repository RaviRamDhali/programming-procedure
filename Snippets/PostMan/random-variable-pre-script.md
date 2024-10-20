# Pre-script
```
// Create an array named "empNumber" with the given strings
var empNumber = ["999650", "999385", "999665", "999000"];
// Randomly pick one from the array
var randomempNumber = empNumber[Math.floor(Math.random() * empNumber.length)];
// Set the picked value to a collection variable
pm.collectionVariables.set("empNumber", randomempNumber);
```

# Post-response
```
var empNumber = pm.collectionVariables.get("empNumber");

pm.test("Successful request", function () {
    
    if(empNumber == '999000'){
        pm.expect(pm.response.code).to.eq(404);
        return;
    }

    pm.expect(pm.response.code).to.eq(200);
});
```
