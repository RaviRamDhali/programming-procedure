function ConnectDispatcher(parentConfigurationId, childConfigurationId) {

    var objParentCanvas = canvas.getItemByAttr('configurationId', parentConfigurationId);

    if (!objParentCanvas)
        return;

    // if (parentConfigurationId && childConfigurationId) {
    //      var objChildCanvas = canvas.getItemByAttr('configurationId', childConfigurationId);
    //      console.log('ConnectDispatcher childConfigurationId', objChildCanvas)
    //      ConnectParentChild(parentConfigurationId, objChildCanvas)
    //      return;
    // }

    if (parentConfigurationId && childConfigurationId == null) {
        ConnectParentSetup(objParentCanvas)
        return;
    }
}


function ConnectParentSetup(objParentCanvas) {
    var coorCenter = CanvasRectCalcCenterCoor(objParentCanvas);
    arrayConnections = [];
    arrayConnections = [coorCenter.x, coorCenter.y]; // [coorStartX, coorStartY, coorEndX, coorEndY]
}


function ConnectParentChild(parentConfigurationId, objChildCanvas, strokeColor) {

    var line = null;
    var coorCenter = CanvasRectCalcCenterCoor(objChildCanvas);
    // append multiple values to the array
    arrayConnections.push(coorCenter.x, coorCenter.y);

    var line = makeLine(parentConfigurationId, objChildCanvas.configurationId, arrayConnections, strokeColor);

    UpdateLineElement(diagramGuid, parentConfigurationId, objChildCanvas, strokeColor, line);

}

function makeLine(parentConfigurationId, childConfigurationId, coords, strokeColor) {

    return new fabric.Line(coords, {
        stroke: strokeColor,
        strokeWidth: 2,
        selectable: false,
        evented: false,
        parentConfigurationId: parentConfigurationId,
        childConfigurationId: childConfigurationId
    });
};

function CanvasRectCalcCenterCoor(objCanvas) {

    if(!objCanvas)
        return;

    var x1 = objCanvas.oCoords.mt.x;
    var y1 = objCanvas.oCoords.mt.y;
    var x2 = objCanvas.oCoords.mb.x;
    var y2 = objCanvas.oCoords.mb.y;

    var centerX = (x1 + x2) / 2;
    var centerY = (y1 + y2) / 2;

    var coorCenter = new Object();
    coorCenter.x = centerX;
    coorCenter.y = centerY;

    return coorCenter;

}

