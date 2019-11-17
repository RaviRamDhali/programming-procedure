// https://stackoverflow.com/questions/32931236/how-to-remove-fabric-js-object-with-custom-id
// Extended Fabric.js

fabric.Canvas.prototype.getItemByAttr = function (attr, name) {

    var object = null,
        objects = this.getObjects();

    for (var i = 0, len = this.size(); i < len; i++) {

        if (!objects[i][attr])
            continue;

        if (!name)
            continue;

        if (objects[i][attr].toLowerCase() && objects[i][attr].toLowerCase() === name.toLowerCase()) {
            object = objects[i];
            break;
        }
    }
    return object;
};

// --------------------------------------
// --------------------------------------

function ListAllCanvasObjects() {
    var objs = canvas.getObjects().map(function (o) {
        return o;
    });
    console.log('getObjects objs', objs);
}

function RemoveAllObjectsFromCanvasCard() {
    // remova all elements from canvas
    ClearOptionButton();
    ClearCardSelection();
    canvas.remove.apply(canvas, canvas.getObjects().concat());
};

function RemoveObjectFromCanvasCard(configurationid) {
    // remova all elements from canvas
    ClearOptionButton();
    ClearCardSelection();
    canvas.getItemByAttr('configurationId', configurationid).remove();
    canvas.renderAll();
    // canvas.remove.apply(canvas, canvas.getObjects().concat());
};

function RemoveCardSelection(configurationid) {
    var row = $('div[data-configurationid="' + configurationid + '"]').parent('.card.widget-user');

    $(row).removeClass('alert-info').addClass('bounceOut').delay(500).queue(function () {
        $(this).hide();
    });
}

function RemoveLineElement(configurationid) {

    var objects = canvas.getObjects('line');

    for (let i in objects) {
         var objLine = objects[i];

         if (configurationid == objLine.parentConfigurationId)
            canvas.remove(objLine);

         if (configurationid == objLine.childConfigurationId)
            canvas.remove(objLine);

     }
}


function ClearOptionButton() {
    $(document).find(".canvasoptionicon").remove();
    $(document).find(".canvasoptiondropdown.dropdown-menu").remove();
}

function ClearCardSelection() {
    $(document).find('.card.alert-info').removeClass('alert-info');
}

function ClearHighlightSelectedCanvasObj() {

    var objects = canvas.getObjects();

    for (var i = 0, len = objects.length; i < len; i++) {
        var objEach = objects[i];

        if (!objEach.item)
            return;

        objEach.item(0).set({
           stroke: '00000020',
               strokeWidth: 0.4
        });

    }
}

function HighlightSelectedCard(configurationid) {
    ClearCardSelection();
    $('div[data-configurationid="' + configurationid + '"]').parent('.card.widget-user').addClass('alert-info');
}

function HighlightSelectedCanvasObj(objCanvas) {
    ClearHighlightSelectedCanvasObj();
    if (!objCanvas)
        return;

    var rect = objCanvas.item(0);
        rect.set({
            stroke: '#9cdbef',
            strokeWidth: 2,
        });
    canvas.renderAll();
}

function ZoomRest() {
    canvas.setZoom(1);
    canvas.renderAll();
    console.log('canvaszoom', canvas.getZoom());
}

function ZoomIn() {
    canvas.setZoom(canvas.getZoom() + 0.2);
    canvas.trigger('moved');
    console.log('canvaszoom', canvas.getZoom());
}

function ZoomOut() {
    canvas.setZoom(canvas.getZoom() - 0.2);
    canvas.trigger('moved');
    console.log('canvaszoom', canvas.getZoom());
}

