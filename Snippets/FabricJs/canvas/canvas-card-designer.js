function designerCanvasCard(objComponent, coorX, coorY) {

    //creating fabric object from menu items
    // Rectangle
    var rect = new fabric.Rect({
        width: 75,
        height: 75,
        fill: '#fff',
        // scaleY: 0.5,
        originX: 'center',
        originY: 'center',
        hasBorders: false,
        stroke: '00000020',
        strokeWidth: 0.4,
    });

    // Computer User Text
	var compUser = new fabric.Text(objComponent.assingedTo,
		{
			fontSize: 10,
			originX: 'center',
			originY: 'top',
			fontFamily: '"Poppins", sans-serif',
			// left: 60,
			top: -15
		});

    // Computer Name Text
    var compName = new fabric.Text(objComponent.wmiName,
		{
			fontSize: 10,
			originX: 'center',
			originY: 'top',
			fontFamily: '"Poppins", sans-serif',
			// left: 60,
			top: 0
		});

    // Computer Ip Address Text
    var compIp = new fabric.Text(objComponent.ip,
		{
			fontSize: 10,
			originX: 'center',
			originY: 'top',
			fontFamily: '"Poppins", sans-serif',
			// left: 60,
			top: 15,
		});

    fabric.Image.fromURL(objComponent.img, function (img) {
		var imgComponent = img.set({
		    left: -40,
		    top: -50
        });
        imgComponent.scaleToHeight(32);
        imgComponent.scaleToWidth(32);


        let objFabric = new Object();
		objFabric.rect = rect;

		objFabric.compUser = compUser;
		objFabric.compName = compName;
		objFabric.compIp = compIp;


        objFabric.img = imgComponent;

        //grouping to make object
        var group = new fabric.Group([objFabric.rect, objFabric.compUser, objFabric.compName, objFabric.compIp, objFabric.img], {
        // var group = new fabric.Group([objFabric.rect, objFabric.text, objFabric.img], {
        // var group = new fabric.Group([objFabric.rect, objFabric.text, objFabric.text2, objFabric.img], {
            left: coorX,
            top: coorY,
            id: objComponent.id,
            diagramId: objComponent.diagramId,
            configurationId: objComponent.configurationId,
            hasControls: false,
            hasBorders: false
        });

        //adding to canvas
        canvas.add(group);

        //update width of object
        rect.set({
            'width': group.width + 5
        });

        //refresh canvas
        canvas.renderAll();

    });



};


