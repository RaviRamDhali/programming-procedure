// Await value
SignUp(customer, password, userIp).then(
    function (value) {
        console.log('%c SignUp THEN ', 'background: black; color: yellow', value);
    },
);


// Await axios POST
function SignUp(customer, password, userIp) {

    var result = new $.Deferred();

    PostSignUp(customer, password, userIp)
        .then(data => {

            setTimeout(() => {
                result.resolve(data);
            }, 2000);


        })
        .catch(err => console.log(err))

    return result.promise();
}

// Axios POST with return promise
function PostSignUp(customer, password, userIp) {

    console.log('%c PostSignUp called', 'background: black; color: yellow');

    return axios.post('/api/customer/signUp', {
        data: customer,
        password: password,
        userIp: userIp
    }).then(response => response.data.d);
}
