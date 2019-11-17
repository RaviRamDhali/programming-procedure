// https://kapeli.com/cheat_sheets/Axios.docset/Contents/Resources/Documents/index



// Objects Defined
function initializeDiagramElement(objCanvas) {

    return {
        guid: objCanvas.id,
        diagramGuid: objCanvas.diagramId,
        configurationGuid: objCanvas.configurationId,
        coorx: objCanvas.oCoords.mt.x,
        coory: objCanvas.oCoords.mt.y
       };
}

function initializeDiagramElementLine(diagramGuid, parentConfigGuid, childConfigGuid, strokeColor) {
    return  {
        diagramGuid: diagramGuid,
        parentConfigurationGuid: parentConfigGuid,
        childConfigurationGuid: childConfigGuid,
        strokeColor: strokeColor
    };
}

function UpdateCanvasObject(objCanvas) {
    let objDiagramElement = initializeDiagramElement(objCanvas);
    axios.post('/api/Diagram', objDiagramElement);
}

function DeleteCanvasObject(objDiagramElement) {
    axios.delete('/api/Diagram', {data: objDiagramElement});
}

function UpdateLineElement(diagramGuid, parentConfigGuid, objChildCanvas, strokeColor, line) {
    let objLineElement = initializeDiagramElementLine(diagramGuid, parentConfigGuid, objChildCanvas.configurationId, strokeColor);
    axios.post('/api/Diagram/Line', objLineElement)
        .then(function (response) {
            console.log('UpdateLineElement response', response);

            if (response.data) {
                canvas.add(line);
                canvas.sendToBack(line);
                objChildCanvas.lineParent = line;
            }

            ListAllCanvasObjects();

        })
        .catch(function (error) {
            console.log('UpdateLineElement response error', error);
        });

}
