# Get image from ULR and save to Azure Blob

```
const azure = require('azure-storage');
const https = require('https');
module.exports = async function (context, req) {
    const imageUrl = req.query.imageUrl; // Assuming the URL is passed as a query parameter

    if(!imageUrl){
        context.res = {
            status: 400,
            body: 'Please provide the imageUrl parameter.'
        };
        return;
    }

    const blobService = azure.createBlobService('dhxxxxxxxxxxxxxxxx', 'cVafltxxxxxxxxxxxxxxxx');

    // Generate a unique name for the blob using a GUID or any other suitable method
    const crypto = require('crypto');
    var uuid = crypto.randomUUID()

    context.log('uuid: ' + uuid);
    const blobName = uuid + ".jpg";
    context.log('blobName: ' + blobName);

    https.get(imageUrl, response => {
        
        if (response.statusCode !== 200) {
            context.log('https.get FAILED');
            context.res = {
                status: 400,
                body: 'Failed to download the image.'
            };
            return;
        }
        

        // Create a write stream to the blob
        const writeStream = blobService.createWriteStreamToBlockBlob('wp-intake', blobName, (error, result, response) => {
            if (error) {
                context.res = {
                    status: 500,
                    body: 'Failed to save the image to the blob.'
                };
                return;
            }

            context.res = {
                status: 200,
                body: 'Image saved successfully.'
            };

        });

         // Pipe the response stream to the blob write stream
         response.pipe(writeStream);

    });

    // context.log('JavaScript HTTP trigger function processed a request.');

    // const name = (req.query.name || (req.body && req.body.name));
    // const responseMessage = name
    //     ? "Thanks " + name + " for providing the Image URL: " + imageUrl
    //     : "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.";

    // context.res = {
    //     // status: 200, /* Defaults to 200 */
    //     body: responseMessage
    // };
}
```
