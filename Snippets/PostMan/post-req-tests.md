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
