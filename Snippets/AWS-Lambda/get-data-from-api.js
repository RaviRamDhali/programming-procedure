const https = require('https');

exports.handler = (event, context, callback) => {
    var options = {
        method: 'GET',
        host: 'swapi.co',
        path: '/api/people/1/',
        headers: {
            "Content-Type": "application/json"
        }
    };
    const req = https.request(options, (res) => {
        let body = '';
        console.log('Status:', res.statusCode);
        console.log('Headers:', JSON.stringify(res.headers));
        res.setEncoding('utf8');
        res.on('data', (chunk) => body += chunk);
        res.on('end', () => {
            console.log('Successfully processed HTTPS response');
            // If we know it's JSON, parse it
            if (res.headers['content-type'] === 'application/json') {
                body = JSON.parse(body);
            }
            callback(null, body);
        });
    });
    req.on('error', callback);
    req.end();
};
