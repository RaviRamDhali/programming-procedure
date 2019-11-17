
$(document).on('click', '.canvasoption-connect', function (e) {
    e.preventDefault();
    parentConfigurationId = $(this).attr("data-configurationid");
    ConnectDispatcher(parentConfigurationId, null);
});

$(document).on('click', '.canvasoption-remove', function (e) {

    configurationid = $(this).attr("data-configurationid");
    var objCanvas = canvas.getItemByAttr('configurationId', configurationid);

    let objDiagramElement = initializeDiagramElement(objCanvas);

    canvas.remove(objCanvas);

    DeleteCanvasObject(objDiagramElement);
    ClearOptionButton();
    ClearCardSelection();

    RemoveLineElement(objCanvas.configurationId);
    RemoveCardSelection(objCanvas.configurationId);

});


$(document).on('click', ".card-body.card-configuration", function (e) {
    var configurationid = $(this).attr("data-configurationid");
    var objCanvas = canvas.getItemByAttr('configurationId', configurationid);

    if (!objCanvas)
        return;

    HighlightSelectedCard(configurationid);
    HighlightSelectedCanvasObj(objCanvas);
    ClearOptionButton();
    AddOptionButton(objCanvas);
});

$(document).on('click', ".canvasoptionicon", function () {
    if (canvas.getActiveObject()) {
        var objCanvas = canvas.getActiveObject();
        let objDiagramElement = initializeDiagramElement(objCanvas);
    }
});


$(document).on('click', ".canvasdeleteicon", function () {

    if (canvas.getActiveObject()) {
        //*********** */removeline(); //remove connection if any
        var objCanvas = canvas.getActiveObject();
        let objDiagramElement = initializeDiagramElement(objCanvas);

        canvas.remove(objCanvas);

        DeleteCanvasObject(objDiagramElement);
        ClearOptionButton();
        ClearCardSelection();

        RemoveLineElement(objCanvas.configurationId);
        RemoveCardSelection(objCanvas.configurationId);

    }
});

$(document).on('click', ".canvaszoomreset", function () {
    ZoomRest();
});

$(document).on('click', ".canvaszoomin", function () {
    ZoomIn();
});

$(document).on('click', ".canvaszoomout", function () {
    ZoomOut();
});
