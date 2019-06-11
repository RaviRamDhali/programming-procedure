function SendSMSViaLambda(ORGANIZATION_NAME, toNumber, body) {

    body = '[' + ORGANIZATION_NAME + ']' + body

    var endpoint = "https://xxxxxxxxxxx.execute-api.xxxxxxxxxxxxxxxx.amazonaws.com/prod/send-sms"
    var org_name = ORGANIZATION_NAME.toLowerCase();
    var data = JSON.stringify({recipient: toNumber,body: body,client: org_name,});

    console.log('SendSMSViaLambda JS data', data)

     $.ajax({
             type: "POST",
             url: endpoint,
             data: data,
             dataType: 'json',
             contentType: 'application/json',
         })
         .done(function (result) {
              console.log('SendSMSViaLambda JS result', result)
         });

};
