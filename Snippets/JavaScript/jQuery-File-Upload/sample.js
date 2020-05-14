// https://github.com/blueimp/jQuery-File-Upload

$('#fileupload').fileupload({
    loadImageMaxFileSize: 20000000, // 20MB
    previewMinHeight: 164,
    previewMaxHeight: 164,
    previewMinWidth: null,
    previewMaxWidth: null,
    previewThumbnail: false,
    previewCanvas: false,
    previewOrientation: false
});
