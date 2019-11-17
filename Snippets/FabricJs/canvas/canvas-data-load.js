//adding dummy data
function drawDiagramElement(diagramElementList) {

	// Add item to canvas
	diagramElementList.forEach(function (item) {
		let objComponent = initializeCanvasCardFromDB(item);
		designerCanvasCard(objComponent, item.coorX, item.coorY)
	}); //end foreach

	drawDiagramElementLines(diagramElementList);

};

function drawDiagramElementLines(diagramElementList) {

	// settimeout needed to wait till entire canvas drawn in DOM
	setTimeout(function () {
		// Add line connections to canvas
		diagramElementList.forEach(function (item) {

			if (!item.line || item.line.length === 0)
				return null;

				item.line.forEach(function (dataLine) {

					var objParentCanvas = canvas.getItemByAttr('configurationId', dataLine.parentConfigurationGuid);
					var objChildCanvas = canvas.getItemByAttr('configurationId', dataLine.childConfigurationGuid);
					var objParentCoor = CanvasRectCalcCenterCoor(objParentCanvas);
					var objChildCoor = CanvasRectCalcCenterCoor(objChildCanvas);

					var arrayConnections = [objParentCoor.x, objParentCoor.y, objChildCoor.x, objChildCoor.y]

					var line = makeLine(dataLine.parentConfigurationGuid, dataLine.childConfigurationGuid, arrayConnections, dataLine.strokeColor);
					canvas.add(line);
					canvas.sendToBack(line);
					objChildCanvas.lineParent = line;
			});

		}); //end foreach
	}, 500);

};
