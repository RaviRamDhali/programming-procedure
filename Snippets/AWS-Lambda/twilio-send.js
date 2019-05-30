var https = require('https');
var queryString = require('querystring');

var d = new Date();
var n = d.getSeconds();


// Lambda function:
exports.handler = (event, context, callback) => {

    var obj = JSON.parse(JSON.stringify(event));
    // console.log(obj);
    // console.log(obj.recipient);
    // console.log( n + obj.body);
    // console.log(obj.client);
    
    //messageString = obj.body;
    obj.body = (n + '% ' + obj.body) // add dynamic perc
    SendSMS(obj.recipient, obj.body, callback);

};


function SendSMS(to, body, callback) {

    // Twilio Credentials
    var fromNumber = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    var accountSid = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    var authToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    var baseUrl = "https://api.twilio.com"
    var smsUrl = baseUrl + "/2010-04-01/Accounts/" + accountSid + "/Messages.json"

    // The SMS message to send
    var message = {
        To: to,
        From: fromNumber,
        Body: body
    };

    var twilioPayload = queryString.stringify(message);
    
    var messageString = queryString.stringify(message);

    let bufferSize = (accountSid + ':' + authToken).length

    // Options and headers for the HTTP request   
    var options = {
        host: 'api.twilio.com',
        port: 443,
        path: smsUrl,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': Buffer.byteLength(twilioPayload),
            'Authorization': 'Basic ' + Buffer.alloc(bufferSize, accountSid + ':' + authToken).toString("base64")
        }
    };

    // Setup the HTTP request
    var req = https.request(options, function (res) {

        res.setEncoding('utf-8');

        // Collect response data as it comes back.
        var responseString = '';
        res.on('data', function (data) {
            responseString += data;
        });

        // Log the responce received from Twilio.
        // Or could use JSON.parse(responseString) here to get at individual properties.
        res.on('end', function () {
            console.log('Twilio Response: ' + responseString);
            callback(null, 'API request sent successfully.')
        });
    }).on('error', function (e) {
        console.error('HTTP error: ' + e.message);
        callback('HTTP error: ' + e.message)
    })

    // Send the HTTP request to the Twilio API.
    // Log the message we are sending to Twilio.
    // console.log('Twilio API call: ' + messageString);
    req.write(messageString);
    req.end();
}
