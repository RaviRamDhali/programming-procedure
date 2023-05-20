# Get image from ULR and save to Azure Blob

```
const azure = require('azure-storage');
const https = require('https');

module.exports = async function (context, req) {
    const imageUrl = req.query.imageUrl; // Assuming the URL is passed as a query parameter

    if (!imageUrl) {
        context.res = {
            status: 400,
            body: 'Please provide the imageUrl parameter.'
        };
        return;
    }

    const blobService = azure.createBlobService('<storage account name>', '<storage account key>');

    // Generate a unique name for the blob using a GUID or any other suitable method
    const blobName = '<unique blob name>.jpg';

    // Download the image from the URL
    https.get(imageUrl, response => {
        if (response.statusCode !== 200) {
            context.res = {
                status: 400,
                body: 'Failed to download the image.'
            };
            return;
        }

        // Create a write stream to the blob
        const writeStream = blobService.createWriteStreamToBlockBlob('<container name>', blobName, (error, result, response) => {
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
};
```
