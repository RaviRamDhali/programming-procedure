# Example 1 - Basic

```
pm.test("Status code is 401", function () {
    pm.response.to.have.status(401);
});
```

```
pm.test("Verify payload",  () => {
    pm.expect(pm.response.json().token.access_token).not.empty
    // pm.expect(pm.response.json().token.access_token).to.not.be.null; (not.empty is better)
});
```

```
pm.test("Body is correct", function () {
    pm.expect(pm.response.json().success).to.equal(true)
});
```

```
pm.test("Verify payload",  () => {
    pm.expect(pm.response.json().user.guid).to.equal('a801ac42-6e3b-43bb-8dc3-dd464bdc7ace')
    pm.expect(pm.response.json().token.access_token).not.empty
});
```

```
pm.test("Body is correct", function () {
    pm.expect(pm.response.text()).to.equal('Invalid token')
});
```



# Example 2 - More details
This code extracts the response body from a Postman API response and searches for the occurrences of the 

strings **"isValid":false** and **"isValid":true**, counting how many times each appears.

It then logs the length of the response body and the counts of these occurrences to the console. 

Finally, it runs tests to check if the counts of these strings match expected values, failing the tests if the counts do not match the specified numbers.

```
let strSearchFalse = '"isValid":false';
let strSearchTrue = '"isValid":true';
let strBody = pm.response.text();
let countFalse = (strBody.match(new RegExp(strSearchFalse, "g")) || []).length;
let countTrue = (strBody.match(new RegExp(strSearchTrue, "g")) || []).length;

console.log('strBody', strBody.length);
console.log('countFalse', countFalse);
console.log('countTrue', countTrue);

pm.test(`String "${countFalse}" appears ${countFalse} times`, function () {
    pm.expect(countFalse).to.be.equals(30); // Adjust this condition as needed
});

pm.test(`String "${strSearchTrue}" appears ${countTrue} times`, function () {
    pm.expect(countTrue).to.be.equals(27); // Adjust this condition as needed
});
```
