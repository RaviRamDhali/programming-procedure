function SignUp(customer, password, userIp) {

    var result = new $.Deferred();

    PostSignUp(customer, password, userIp)
        .then(data => {
            result.resolve(data);
        })
        .catch(function (error) {
            return result.reject(error);
        });
        
    return result.promise();
}
