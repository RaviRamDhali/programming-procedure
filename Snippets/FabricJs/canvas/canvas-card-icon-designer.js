
function AddOptionButton(objCanvas) {

    ClearOptionButton();
    var objPosition = CalcPositionforCanvasCardOptionIcon(objCanvas)
    var icon = designerCanvasCardOptionIcon(objPosition);

    var htmlOptions = null;
    htmlOptions = designerCanvasCardDropDownOption(objCanvas);
    $("#canvas-container").append(icon).append(htmlOptions);
}

function designerCanvasCardOptionIcon(objPosition) {
    var stylePos = stylePosition(objPosition.top, objPosition.left);
    var theStyle = 'position:absolute;cursor:pointer;' + stylePos;

    var htmlIcon = null;

    htmlIcon = '<i data-toggle="dropdown" class="canvasoptionicon fi-menu text-primary" style="' + theStyle + '"></i>'

    return htmlIcon
}

function designerCanvasCardDropDownOption(objCanvas) {
    var htmlOptions = null;

    htmlOptions = '<ul class="canvasoptiondropdown dropdown-menu dropdown-setting"><li><a href="/Configuration/Detail/' + objCanvas.configurationId + '" class="canvasoption-detail" data-task="detail" data-id="' + objCanvas.configurationId + '" data-label="Details" data-configurationid="' + objCanvas.configurationId + '">Details</a><a href="#" class="canvasoption-connect" data-task="connect" data-id="' + objCanvas.configurationId + '" data-label="Connect to" data-configurationid="' + objCanvas.configurationId + '">Connect</a><a href="#" class="canvasoption-remove" data-task="remove" data-id="' + objCanvas.configurationId + '" data-label="Remove" data-configurationid="' + objCanvas.configurationId + '">Remove</a></li></ul>'

    return htmlOptions
}

function stylePosition(posTop, posLeft) {
    var styleTop = 'top:' + posTop + 'px;';
    var styleLeft = 'left:' + posLeft + 'px;';
    var result = styleTop + styleLeft;
    return result;
}


function initializeObjPosition(posTop, posLeft) {
    let objPosition = new Object();
    objPosition.top = posTop;
    objPosition.left = posLeft;
    return objPosition;
}

function CalcPositionforCanvasCardDeleteIcon(objCanvas) {

    var left = objCanvas.oCoords.mt.x + 5;
    var top = objCanvas.oCoords.mt.y - 15 + objCanvas.height;
    var adjustedWidth = objCanvas.width / 2 + 5;
    left = (left + adjustedWidth);

    let objPosition = initializeObjPosition(top, left)
    return objPosition;
}

function CalcPositionforCanvasCardOptionIcon(objCanvas) {
    var left = objCanvas.oCoords.mt.x;
    var top = objCanvas.oCoords.mt.y;
    var adjustedWidth = objCanvas.width / 2 + 5;
    left = (left + adjustedWidth);
    top = (top + 35);

    let objPosition = initializeObjPosition(top, left)
    return objPosition;
}

