// Object events available in Fabricjs include;
// object: modified
// object: selected
// object: moving
// object: scaling
// object: rotating
// object: added
// object: removed”

canvas.on('mouse:over', function (e) {
	if (e.target) {
		HighlightSelectedCard(e.target.configurationId);
		HighlightSelectedCanvasObj(e.target)
	}
});

canvas.on('mouse:down', function (e) {
	ClearCardSelection();
	ClearHighlightSelectedCanvasObj();
	ClearOptionButton();

	var objCanvas = e.target;

	if (objCanvas) {
		HighlightSelectedCard(objCanvas.configurationId);
		HighlightSelectedCanvasObj(objCanvas)
		ClearOptionButton();

		if (arrayConnections.length === 2) {
			var strokeColor = "#9cdbef";
			ConnectParentChild(parentConfigurationId, objCanvas, strokeColor);
			arrayConnections = [];
			return;
		}

		AddOptionButton(objCanvas);
	}
});


canvas.on('object:added', function (e) {

	var objCanvas = e.target;

});

canvas.on('object:modified', function (e) {

	var objCanvas = e.target;

	UpdateCanvasObject(objCanvas);
	HighlightSelectedCard(e.target.configurationId);

	//calling delete btn function
	AddOptionButton(objCanvas);

});

// functions to call when object on canvas is selected.
// canvas.on('object:selected',function(e){

//     // console.log('selected', e.target)
//     // HighlightSelectedCard(e.target.configurationId);
//     //calling line function
// 	//******* */add_line(e);

//     //calling delete btn function
// 	// AddDeleteButton(e.target.oCoords.mt.x, e.target.oCoords.mt.y, e.target.width);
// 	//$('canvas').popover('destroy'); // closing popup

//     //Calling popup function
// 	//********  update_popup(e);

//     //calling function to update object values
//     //********  update_value(e);

// });


// functions to call when object on canvas is selected.
canvas.on('object:moving', function (e) {
	ClearCardSelection();
	ClearOptionButton();

	canvas.getObjects('line').forEach(function (objLine, sid) {

		var objCanvas = e.target;
		objCanvas.lineParent && objCanvas.lineParent.set({
			//'x1': objParentCanvas.left,
			//'x2': objParentCanvas.top,
			'x2': objCanvas.left + 40,
			'y2': objCanvas.top + 40
		});

		var selectedId = objCanvas.configurationId;
		var parentId = objLine.parentConfigurationId;
		var childId = objLine.childConfigurationId;

		var isParentMoving = (selectedId === parentId);
		if (isParentMoving) {
			var objChildCanvas = canvas.getItemByAttr('configurationId', childId);
			objChildCanvas.lineParent && objChildCanvas.lineParent.set({
				'x1': e.target.left + 40,
				'y1': e.target.top + 40
				//'x2': objCanvas.left,
				//'y2': objCanvas.top
			});
			console.log('To do: Center line after object:moving');
		}

		console.log('To do: Multi connection bug fix on object:moving');




		//     objLine.set(arrayConnections);
		//     canvas.renderAll();
		// }


		// if(o.id==e.target.getObjects()[1].getText()){
		// 	var line=o;
		// 	console.log('object:moving line 1', line);
		// 	var p = e.target;
		// 	o.set({ 'x2': p.left+ p.width/2, 'y2': p.top });
		// 	canvas.renderAll();
		// }
		// if(o.class==e.target.getObjects()[1].getText()){
		// 	var line=o;
		// 	console.log('object:moving line 2', line);
		// 	var p = e.target;
		// 	o.set({ 'x1': p.left+ p.width/2, 'y1': p.top+p.height });
		// 	canvas.renderAll();
		// }
	});

























});

canvas.on('mouse:move', function (e) {
	getMouseCoords(e);
});

canvas.on('mouse:out', function (e) {

});


