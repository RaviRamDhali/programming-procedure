
//initialising canvas
var canvas = new fabric.Canvas('canvas');

fabric.Object.prototype.transparentCorners = false;

var _height = $('#canvas-container').height();
var _width = $('#canvas-container').width();

canvas.setHeight(800);
canvas.setWidth(_width);

// canvas.setHeight(800);
// canvas.setWidth(800);
// CanvasResize();

ZoomRest();


canvas.renderAll();
var arrayConnections = []; // [coorStartX, coorStartY, coorEndX, coorEndY]
var parentConfigurationId = null; // [coorStartX, coorStartY, coorEndX, coorEndY]




// Bind the event listeners for the image elements
var images = document.querySelectorAll('.card-configuration');

[].forEach.call(images, function (img) {
    img.addEventListener('dragstart', handleDragStart, false);
    img.addEventListener('dragend', handleDragEnd, false);
});



// Bind the event listeners for the canvas
var canvasContainer = document.getElementById('canvas-container');
canvasContainer.addEventListener('dragenter', handleDragEnter, false);
canvasContainer.addEventListener('dragover', handleDragOver, false);
canvasContainer.addEventListener('dragleave', handleDragLeave, false);
canvasContainer.addEventListener('drop', handleDrop, false);


// 	//load menus from json
// 	function Get(yourUrl){
// 		var Httpreq = new XMLHttpRequest(); // a new request
// 		Httpreq.open("GET",yourUrl,false);
// 		Httpreq.send(null);
// 		return Httpreq.responseText;
// 	}
// 	var objects = JSON.parse(Get('https://my.api.mockaroo.com/objects.json?key=29e0d260'));
// 	$(objects).each(function(index, item) {
// 		var data='<div id="'+item['id']+'" data="'+item['Name']+'" draggable="true" class="grid-container"><div class="card widget-user"> <div class="card-body"> <img src="'+item['Image']+'" class="img-fluid d-inline" alt="user"><h5 class="d-inline"><span class="badge">'+item['Status']+'</span> '+item['Name']+'</h5><div class="wid-u-info"><p class="text-muted m-b-0"> Vendor : '+item['Vendor']+'</p><p class="text-muted m-b-0"> Manufacturer : '+item['Manufacturer']+' </p><div class="user-position"><span class="text-pink font-secondary">'+item['Location']+'</span></div></div> </div></div></div>'

// 		//  var data=' <div id="'+item['id']+'" data="'+item['Name']+'" draggable="true" width="100" height="100"><img src="'+item['Image']+'">'+item['Name']+'</div>';
// 		$('#images').append(data);
// 	});

// //initialising canvas
// 	var canvas = new fabric.Canvas('canvas');


// //initialising popup on selecting object on canvas
// 	function update_popup(e) {
// 		var title=e.target.getObjects()[1].getText();
// 		var ico=e.target.getObjects()[3].getSrc();
// 		var data=e.target.getObjects()[2].getText();
// 		$('canvas').popover({
// 			content: data,
// 			title: '<span class="text-info"><strong><img src="'+ico+'" height="16px" width="16px">'+title+'</strong></span> <button type="button" id="closepop" class="close">&times;</button>',
// 			placement: 'top',
// 			html:true,
// 		});
// 		$('.footer_div').show();
// 		$('.footer_div h2').text(title);  $('.footer_div p').html(data);
// 		$('.footer_div img').attr('src',ico);
// 		$('.popover').css('top',e.target.height-200);
// 	}



// // make connection line
// 	function makeLine(coords,id,cls) {

// 		return new fabric.Line(coords, {
// 			fill: 'red',
// 			stroke: 'red',
// 			strokeWidth: 5,
// 			selectable: true,
// 			id: id,
// 			class:cls,
// 			evented: false,
// 		});

// 	}
// //removing connection
// 	function removeline(e){
// 		canvas.getObjects().forEach(function(o) {
// 			var objname=canvas.getActiveObject().getObjects()[1].getText();
// 			if(o.id ===objname||o.class ===objname ) {
// 				canvas.remove(o);
// 			}
// 		});
// 	}


// //adding dummy data
// 	function add_dummy (){
// 		//dummy 1
// 		var rect = new fabric.Rect({
// 			width: 150,
// 			height: 100,
// 			fill: 'lightblue',
// 			scaleY: 0.5,
// 			originX: 'center',
// 			originY: 'center',
// 			stroke: 'black',
// 			strokeWidth: 1,
// 		});

// 		var text = new fabric.Text('Tea', {
// 			fontSize: 20,
// 			originX: 'left',
// 			originY: 'center',
// 		});
// 		var text1_2 = new fabric.Text('This is dummy content to be shown for Tea!!', {
// 			fontSize: 0,
// 			//fill: 'white',
// 		});
// 		text1_2.setVisible(false);

// 		fabric.Image.fromURL('https://img.icons8.com/material/4ac144/256/home.png', function(img) {
// 			var img1 = img.scale(0.08).set({  originX: 'right',  originY: 'right',});
// 			var group = new fabric.Group([ rect, text,text1_2,img1 ], {
// 				left: 300,
// 				top: 20,
// 				// angle: -10
// 			});
// 			canvas.add(group);
// 			canvas.forEachObject(function(o){ o.hasBorders = o.hasControls = false; });
// 			canvas.renderAll();
// 		});


// 		canvas.renderAll();
// 	}
// // dummy data  functions
// 	$('#adddummy').click(function(){add_dummy ();});
// 	$('#clearcanvs').click(function(){
// 		canvas.clear();
// 		$(".deleteBtn").remove();
// 		$('#connect').removeAttr('x1');
// 		$('#connect').removeAttr('y1');
// 		//$('canvas').popover('destroy');
// 		$('#json_value').val('');
// 	});

// // Declaring json value array
// 	var json_value= new Array();
// //updating object values
// 	var parent='';
// 	var child='';
// 	function update_value(e,parent,child){
// 		var chords=e.target.oCoords.mt.x+','+e.target.oCoords.mt.y;
// 		var objID=e.target.getObjects()[1].get('id');

// 		$(objects).each(function(index, item) {
// 			if(item['id']==objID){
// 				var selected_obj=objects[item['id']-1];
// 				json_value.push(selected_obj);
// 				selected_obj['chords']=chords;
// 				if(parent){
// 					selected_obj['parent']=parent;
// 					selected_obj['child']=child;
// 				}
// 				$('#json_value').val(JSON.stringify(selected_obj, null, 4));

// 				$('.footer_div').show();
// 				$('.footer_div img').attr('src',$(this).find('img').attr('src'));
// 				var html='<tr>';
// 				var headings='';
// 				var data='';
// 				Object.keys(selected_obj).forEach(function(key) {
// 					if(key!=='Image'&&key!=='id'){
// 						headings+='<th>'+key+'</th>';
// 						data+='<td>'+selected_obj[key]+'</td>';
// 					}
// 				});
// 				html+=headings;
// 				html+='<tr/>';
// 				html+='<tr>';
// 				html+=data;
// 				html+='<tr/>';
// 				$('#objvals').html(html);

// 			}
// 		});

// 	}

// //add line

// 	function add_line(e){
// //updating chords
// 		$('#ochords').text(e.target.oCoords.mt);
// 		console.log('x:'+e.target.oCoords.mt.x);
// 		console.log('y:'+e.target.oCoords.mt.y);
// 		//add line
// 		$('#connect').css('background-color','#fff');
// 		var x1=$('#connect').attr('x1');
// 		var y1=$('#connect').attr('y1');
// 		if(typeof x1 !== typeof undefined && x1 !== false && typeof y1 !== typeof undefined && y1 !== false)
// 		{

// 			var x1=$('#connect').attr('x1');
// 			var y1=$('#connect').attr('y1');
// 			var cls=$('#connect').attr('obj');
// 			var x2=e.target.oCoords.mt.x;
// 			var y2=e.target.oCoords.mt.y;


// 			var line=makeLine([ x1, y1, x2, y2 ],e.target.getObjects()[1].getText(),cls);
// 			canvas.add(line);
// 			update_value(e,cls,e.target.getObjects()[1].getText());

// 			if(y2<y1){
// 				canvas.sendToBack(line);
// 				canvas.renderAll();
// 			}

// 			//canvas.add(makeLine([ y2, x2, x1, y1 ]));

// 			$('#connect').removeAttr('x1');
// 			$('#connect').removeAttr('y1');
// 			$('#connect').removeAttr('obj');
// 		}

// 		//add line end
// 	}

// //delete button on objects on canvas
// 	function addDeleteBtn(x, y, w){
// 		$(".deleteBtn").remove();
// 		var btnLeft = x;
// 		var btnTop = y - 15;
// 		var widthadjust=w/2+5;
// 		btnLeft=widthadjust+btnLeft-10;
// 		var deleteBtn = '<img with="20px" height="20px" src="https://cdn1.iconfinder.com/data/icons/ui-color/512/Untitled-12-128.png" class="deleteBtn" style="position:absolute;top:'+btnTop+'px;left:'+btnLeft+'px;cursor:pointer;"/>';
// 		$(".canvas-container").append(deleteBtn);
// 	}


// // functions to call when object on canvas is selected.
// 	canvas.on('object:selected',function(e){
// //calling line function
// 		add_line(e);
// //calling delete btn function
// 		addDeleteBtn(e.target.oCoords.mt.x, e.target.oCoords.mt.y, e.target.width);
// 		//$('canvas').popover('destroy'); // closing popup
// 		//Calling popup function
// 		update_popup(e);
// 		//calling function to update object values
// 		update_value(e);

// 	});

// 	canvas.on('mouse:down',function(e){
// 		if(!canvas.getActiveObject())
// 		{
// 			$(".deleteBtn").remove();
// 			//$('canvas').popover('destroy');
// 		}
// 	});
// 	function getMouseCoords(event)
// 	{
// 		var pointer = canvas.getPointer(event.e);
// 		var posX = pointer.x;
// 		var posY = pointer.y;
// 		$('#chords').text(posX+", "+posY);    // Log to console
// 	}
// 	canvas.on('mouse:move',function(e){
// 		getMouseCoords(e);
// 	});

// 	canvas.on('object:modified',function(e){
// 		addDeleteBtn(e.target.oCoords.mt.x, e.target.oCoords.mt.y, e.target.width);
// 		//$('canvas').popover('destroy');
// 	});

// 	canvas.on('object:moving',function(e){
// 		$(".deleteBtn").remove();
// 		canvas.getObjects('line').forEach(function(o,sid) {
// 			if(o.id==e.target.getObjects()[1].getText()){
// 				var line=o;
// 				// console.log(line);
// 				var p = e.target;
// 				o.set({ 'x2': p.left+ p.width/2, 'y2': p.top });
// 				canvas.renderAll();
// 			}
// 			if(o.class==e.target.getObjects()[1].getText()){
// 				var line=o;
// 				//console.log(line);
// 				var p = e.target;
// 				o.set({ 'x1': p.left+ p.width/2, 'y1': p.top+p.height });
// 				canvas.renderAll();
// 			}
// 		});
// 	});

// 	$(document).on('click',".deleteBtn",function(){
// 		if(canvas.getActiveObject())
// 		{
// 			removeline(); //remove connection if any
// 			canvas.remove(canvas.getActiveObject()); //remove obj
// 			$(".deleteBtn").remove();
// 			//$('canvas').popover('destroy');
// 			$('.footer_div').hide();
// 		}
// 	});

// // popup close on click function
// 	$(document).on('click',".close",function(){
// 		//$('canvas').popover('destroy');
// 		$('canvas').popover('hide');
// 	});

// // make connecection
// 	$(document).on('click',"#connect",function(){
// 		if(canvas.getActiveObject())
// 		{

// 			var x1=canvas.getActiveObject().oCoords.mt.x;
// 			var y1=canvas.getActiveObject().oCoords.mt.y;
// 			var h1=canvas.getActiveObject().height;
// 			var obj=canvas.getActiveObject().getObjects()[1].getText();
// 			$('#connect').attr('x1',x1);
// 			$('#connect').attr('y1',y1+h1);
// 			$('#connect').attr('obj',obj);
// 		}
// 		else{
// 			alert('Select Object to connect');
// 			$('#connect').css('background-color','red');
// 		}
// 	});
// //Removing Connection
// 	$(document).on('click',"#disconnect",function(){
// 		removeline();
// 	});
// // drag menu items to canvas
// 	function handleDragStart(e) {
// 		[].forEach.call(images, function (img) {
// 			img.classList.remove('img_dragging');
// 		});
// 		this.classList.add('img_dragging');
// 	}

// 	function handleTouchStart(e) {
// 		[].forEach.call(images, function (img) {
// 			img.classList.remove('img_dragging');
// 		});
// 		this.classList.add('img_dragging');
// 	}

// 	function handleDragOver(e) {
// 		if (e.preventDefault) {
// 			e.preventDefault(); // Necessary. Allows us to drop.
// 		}

// 		e.dataTransfer.dropEffect = 'copy';
// 		return false;
// 	}

// 	function handleDragEnter(e) {
// 		// this / e.target is the current hover target.
// 		this.classList.add('over');
// 	}

// 	function handleDragLeave(e) {
// 		this.classList.remove('over'); // this / e.target is previous target element.
// 	}

// 	function handleDrop(e) {
// 		// this / e.target is current target element.
// 		if (e.stopPropagation) {
// 			e.stopPropagation(); // stops the browser from redirecting.
// 		}

// //creating fabric object from menu items
// // Rectangle
// 		var rect = new fabric.Rect({
// 			width: 150,
// 			height: 100,
// 			fill: 'lightblue',
// 			scaleY: 0.5,
// 			originX: 'left',
// 			originY: 'left',
// 			stroke: 'black',
// 			strokeWidth: 1,
// 		});
// // Title
// 		var text = new fabric.Text($('.img_dragging').attr('data'), {
// 			id:$('.img_dragging').attr('id'),
// 			fontSize: 20,
// 			originX: 'left',
// 			originY: 'left',
// 			fontFamily:'FontAwesome',
// 			left:40,
// 		});
// 		//Data
// 		var text2 = new fabric.Text($('.img_dragging').attr('data'), {
// 			fontSize: 0,
// 			//fill: 'white',
// 		});
// 		text2.setVisible(false);
// //Image
// 		fabric.Image.fromURL($('.img_dragging img').attr('src'), function(img) {
// 			var img1 = img.set({  originX: 'left',  originY: 'left', left:10, height:20, width:20});
// //grouping to make object
// 			var group = new fabric.Group([ rect, text,text2,img1 ], {
// 				left: e.layerX,
// 				top: e.layerY,

// 			});
// //adding to canvas
// 			canvas.add(group);
// //update width of object
// 			rect.set({ 'width': group.width+5 });
// //removing unwanted features
// 			canvas.forEachObject(function(o){ o.hasBorders = o.hasControls = false; });
// //refresh canvas
// 			canvas.renderAll();
// 		});
// 		return false;
// 	}

// //HTML 5 dragging handle functions
// 	function handleDragEnd(e) {
// 		// this/e.target is the source node.
// 		[].forEach.call(images, function (img) {
// 			img.classList.remove('img_dragging');
// 		});
// 	}

// 	function handleTouchEnd(e) {
// 		// this/e.target is the source node.
// 		[].forEach.call(images, function (img) {
// 			img.classList.remove('img_dragging');
// 		});
// 	}

// 	function swipeIt(e) {
// 		var contact = e.touches;
// 		this.style.left = initX+contact[0].pageX-firstX + 'px';
// 		this.style.top = initY+contact[0].pageY-firstY + 'px';
// 	}

// 	if (Modernizr.draganddrop) {
// 		// Browser supports HTML5 DnD.

// 		// Bind the event listeners for the image elements
// 		var images = document.querySelectorAll('#images div');
// 		[].forEach.call(images, function (img) {

// 			// co-ordinates
// 			let initX;
// 			let initY;
// 			let firstX;
// 			let firstY;

// 			img.addEventListener('dragstart', handleDragStart, false);
// 			img.addEventListener('dragend', handleDragEnd, false);

// 			img.addEventListener('stouchstart', (e) =>{
// 				e.preventDefault();
// 				initX = this.offsetLeft;
// 				initY = this.offsetTop;
// 				var touch = e.touches;
// 				firstX = touch[0].pageX;
// 				firstY = touch[0].pageY;

// 				this.addEventListener('touchmove', swipeIt, false);

// 				window.addEventListener('touchend', function(e) {
// 					e.preventDefault();
// 					object.removeEventListener('touchmove', swipeIt, false);
// 				}, false);
// 			}, false);

// 		});



// 		// Bind the event listeners for the canvas
// 		var canvasContainer = document.getElementById('canvas-container');
// 		canvasContainer.addEventListener('dragenter', handleDragEnter, false);
// 		canvasContainer.addEventListener('dragover', handleDragOver, false);
// 		canvasContainer.addEventListener('dragleave', handleDragLeave, false);
// 		canvasContainer.addEventListener('drop', handleDrop, false);
// 	} else {
// 		// Replace with a fallback to a library solution.
// 		alert("This browser doesn't support the HTML5 Drag and Drop API.");
// 	}

// //footer details div
// 	$('#images div').click(function(){
// 		$('.footer_div').show();
// 		$('.footer_div img').attr('src',$(this).find('img').attr('src'));
// 		var objID=$(this).attr('id');
// 		var html='<tr>';
// 		var headings='';
// 		var data='';
// 		Object.keys(objects[objID-1]).forEach(function(key) {
// 			if(key!=='Image'&&key!=='id'){
// 				headings+='<th>'+key+'</th>';
// 				data+='<td>'+objects[objID-1][key]+'</td>';
// 			}
// 		});
// 		html+=headings;
// 		html+='<tr/>';
// 		html+='<tr>';
// 		html+=data;
// 		html+='<tr/>';
// 		$('#objvals').html(html);
// 	});
