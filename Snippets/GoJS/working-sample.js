var data = getData();
var objs = JSON.parse(data);
console.log(objs);


function init() {
  var $ = go.GraphObject.make;

  myDiagram =
    $(go.Diagram, "myDiagramDiv",
      {
        initialContentAlignment: go.Spot.TopLeft,
        "undoManager.isEnabled": true,
        "draggingTool.dragsLink": true,
      }
    );  // diagram

    // define a simple Node template

  
  // install custom linking tool, defined in PolylineLinkingTool.js
  // https://gojs.net/latest/extensions/PolylineLinkingTool.js
  var tool = new PolylineLinkingTool();
  //tool.temporaryLink.routing = go.Link.Orthogonal;  // optional, but need to keep link template in sync, below
  myDiagram.toolManager.linkingTool = tool;
  myDiagram.toolManager.hoverDelay = 10;

  
  
  
var nodeDataArray = objs;  
var linkDataArray = [
     { from: "20", to: "39"},
     { from: "20", to: "38" }, 
];

myDiagram.model = new go.GraphLinksModel(nodeDataArray, linkDataArray);
  
myDiagram.linkTemplate = $(go.Link, {
    corner: 10,
    routing: go.Link.AvoidsNodes,
    reshapable: false,
    resegmentable: true
    },

    $(go.Shape, { strokeWidth: 1.5}),
    $(go.Shape, { toArrow: "Block"})
);
  
 // define tooltips for nodes
var tooltiptemplate = $("ToolTip",
         $(go.TextBlock, { margin: 4 },
         new go.Binding("text", "name")
         ),
         );  // end of Adornment


 
// This is the actual HTML context menu:
var cxElement = document.getElementById("contextMenu");
// ContextMenu
  var myContextMenu = $(go.HTMLInfo, {
    show: showContextMenu,
    mainElement: cxElement
  });


  
  
  
// provide custom Node appearance
myDiagram.nodeTemplate =  $(go.Node, "Auto",
     {
      location: new go.Point(0, 0),  // set the Node.location
      locationObjectName: "SHAPE",  // the location point is at the center of "SHAPE"
      locationSpot: go.Spot.Center,
      toolTip: tooltiptemplate,
      contextMenu: myContextMenu,      
      cursor: "move",
      // fromLinkable: true,
      // toLinkable: true,
      // portId: "",
  
  
      mouseEnter: function(e, node) {
        console.log('mouseEnter  node', node);
        var shape = node.part.findObject("RoundedRectangle");
        if(shape){
          shape.stroke = "darkkhaki";
          shape.fill = "lightyellow";
        }
      },//mouseEnter 

      mouseLeave: function(e, node) {
       console.log('mouseLeave  node', node);
          var shape = node.part.findObject("RoundedRectangle");
          if(shape){
            shape.stroke = "black";
            shape.fill = "white";
          }
       }, //mouseLeave

  
   },

    new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
                            
    $(go.Shape, "RoundedRectangle", {
        name: "RoundedRectangle",
        margin: 4,
        fill: "white", // the default fill, if there is no data bound value
        portId: "", 
        cursor: "pointer",  // the Shape is the port, not the whole Node
        
        // allow all kinds of links from and to this port
        fromLinkable: true,
        toLinkable: true,

//         mouseEnter: function(e, node) {
//         console.log('node', node);
//         console.log('part', node.part);
//         console.log('data', node.part.data);
//         var shape = node.part.findObject("RoundedRectangle");
        
//           // node.fill = "red";
//           node.stroke = "green";
//           // node.part.fill = "red";
          
//         },
  
  
    }),
                            
    $(go.Panel, "Horizontal",
     
          $(go.Picture,{
              name: "Picture",
              desiredSize: new go.Size(30, 30),
              margin: new go.Margin(6, 8, 6, 10),
            },
            
            new go.Binding("source", "imgSrc")
           
           ), // picture

          $(go.Panel, "Table", {
                maxSize: new go.Size(150, 999),
                margin: new go.Margin(6, 10, 0, 3),
                defaultAlignment: go.Spot.Center,
              },
              $(go.TextBlock,new go.Binding("text", "assignedTo"),
                { stroke: "#348cd4" },
                { row: 0, column: 0, margin: 2}),

            
              $(go.TextBlock,new go.Binding("text", "wmI_Name"),
                { stroke: "#16181b" },
                { row: 2, column: 0, margin: 2}),

              $(go.TextBlock,new go.Binding("text", "ipAddress"),
                { stroke: "#16181b" },
                { row: 3, column: 0, margin: 2}),
             
            $(go.TextBlock,new go.Binding("text", "key"),
                { stroke: "#16181b" },
                { row: 4, column: 0, margin: 2}),
           
           ), //table

     ),  // panel  

                            
); // NodeTemplate

 
  
  
 
 myDiagram.contextMenu = myContextMenu;
  
  // We don't want the div acting as a context menu to have a (browser) context menu!
  cxElement.addEventListener("contextmenu", function(e) {
    e.preventDefault();
    return false;
  }, false);

  
  function showContextMenu(obj, diagram, tool) {
    // Show only the relevant buttons given the current state.
    var cmd = diagram.commandHandler;
    //document.getElementById("cut").style.display = cmd.canCutSelection() ? "block" : "none";
    //document.getElementById("copy").style.display = cmd.canCopySelection() ? "block" : "none";
    //document.getElementById("paste").style.display = cmd.canPasteSelection() ? "block" : "none";

    // Now show the whole context menu element
    cxElement.style.display = "block";
    // we don't bother overriding positionContextMenu, we just do it here:
    var mousePt = diagram.lastInput.viewPoint;
    cxElement.style.left = mousePt.x + "px";
    cxElement.style.top = mousePt.y + "px";
  }  
  
  
  
// ***********************************
// GoJs Event Handlers
// ***********************************
 
myDiagram.addDiagramListener("SelectionMoved", function(event) {
    
  // https://gojs.net/latest/api/symbols/Part.html#location
  // * PART
  var selectedNode = event.diagram.selection.first();
  
  console.log("selectedNode",selectedNode);
  console.log("selectedNodeKey",selectedNode.key);
  console.log("selectedNode", selectedNode.location.toString());
  console.log("selectedNode-x", selectedNode.location.x);
  console.log("selectedNode-y", selectedNode.location.y);
  console.log("locationObject", selectedNode.locationObject);
  
  //Save new location
  // key: selectedNode.key
  // location-x: selectedNode.location.x
  // location-y: selectedNode.location.y
   
});
 
  
// ***********************************
// ***********************************
 
  
  
}  //end gojs



// This is the general menu command handler, parameterized by the name of the command.
function cxcommand(event, val) {
  if (val === undefined) val = event.currentTarget.id;
  var diagram = myDiagram;
  switch (val) {
    case "cut": diagram.commandHandler.cutSelection(); break;
    case "copy": diagram.commandHandler.copySelection(); break;
    case "paste": diagram.commandHandler.pasteSelection(diagram.lastInput.documentPoint); break;
    case "delete": diagram.commandHandler.deleteSelection(); break;
    case "color": {
      var color = window.getComputedStyle(document.elementFromPoint(event.clientX, event.clientY).parentElement)['background-color'];
      changeColor(diagram, color); break;
    }
  }
  diagram.currentTool.stopTool();
}

// A custom command, for changing the color of the selected node(s).
function changeColor(diagram, color) {
  // Always make changes in a transaction, except when initializing the diagram.
  diagram.startTransaction("change color");
  diagram.selection.each(function(node) {
    if (node instanceof go.Node) {  // ignore any selected Links and simple Parts
      // Examine and modify the data, not the Node directly.
      var data = node.data;
      // Call setDataProperty to support undo/redo as well as
      // automatically evaluating any relevant bindings.
      diagram.model.setDataProperty(data, "color", color);
    }
  });
  diagram.commitTransaction("change color");
}

function showMessage(s) {
    document.getElementById("diagramEventsMsg").textContent = s;
}


function getData(){

        let jsondata = '[{"key":20,"loc":"450 20","guid":"160e0adf-456b-ac13-cc96-0bc96c3d0f45","typeId":3,"statusId":1,"name":"Backup Server 390","description":"PowerEdge T430 Server - ACH-FS1","vendor":"HP","manufacturer":"Dell","model":"Surtinexover","active":true,"ipAddress":"10.2.4.20","wmI_Name":"CE86-4259","assignedTo":"Wallace86","diagramElement":{"guid":"2fed5415-48d8-439f-9618-8490c99a79f3","diagramId":"aefb8652-07d2-d5cf-8186-ce3847bbd6b8","configurationId":"160e0adf-456b-ac13-cc96-0bc96c3d0f45","parentDiagramElementId":"00000000-0000-0000-0000-000000000000","coorX":696.92,"coorY":84.00,"created":"2019-10-06T07:39:22.937","modified":"2019-10-06T07:47:19.247","active":true,"ipAddress":null,"wmiName":null,"assignedTo":null,"name":"Backup Server 390","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/backup-server-64.png","diagramSiteFullName":"Main Office > Main Office","line":null},"imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/backup-server-64.png","typeTitle":"Server-Backup","statusTitle":"Online","typeImage":"backup-server-64.png","statusImage":"online.png","statusCssClass":"success","typeCssClass":null},{"key":38,"loc": "500 200","guid":"d6766f79-2f40-f6fb-f615-22b6ccf87c29","typeId":16,"statusId":5,"name":"Platinum SQL Server Software Maintenance","description":"PracticeMaster Platinum License - 6 Users","vendor":"Hewlett-Packard","manufacturer":"Hewlett-Packard","model":"Unpebentor-4584","active":true,"ipAddress":"10.2.4.38","wmI_Name":"BERT-5321","assignedTo":"Ravi","diagramElement":{"guid":"9280cccd-59fc-41d4-966a-0255b4d923e2","diagramId":"aefb8652-07d2-d5cf-8186-ce3847bbd6b8","configurationId":"d6766f79-2f40-f6fb-f615-22b6ccf87c29","parentDiagramElementId":"00000000-0000-0000-0000-000000000000","coorX":147.42,"coorY":79.00,"created":"2019-10-06T07:39:25.39","modified":"2019-10-07T18:52:56.437","active":true,"ipAddress":null,"wmiName":null,"assignedTo":null,"name":"Platinum SQL Server Software Maintenance","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/server-64.png","diagramSiteFullName":"Main Office > Main Office","line":null},"imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/server-64.png","typeTitle":"Server Management","statusTitle":"Maintenance","typeImage":"server-64.png","statusImage":"maintenance.png","statusCssClass":"secondary","typeCssClass":null},{"key":39,"loc": "100 200","guid":"198283d6-a59e-46dc-6404-9768a950dcd0","typeId":6,"statusId":2,"name":"iDRAC 7 Express","description":"Platinum SQL Server Software Maintenance","vendor":"Intel","manufacturer":"Intel","model":"Happickar","active":true,"ipAddress":"10.2.4.39","wmI_Name":"EO63-3284","assignedTo":"Leo63","diagramElement":{"guid":"0cafbbed-3cd9-4716-bea2-a829fed74034","diagramId":"aefb8652-07d2-d5cf-8186-ce3847bbd6b8","configurationId":"198283d6-a59e-46dc-6404-9768a950dcd0","parentDiagramElementId":"00000000-0000-0000-0000-000000000000","coorX":523.12,"coorY":216.00,"created":"2019-10-06T07:39:30.35","modified":"2019-10-07T18:52:55.343","active":true,"ipAddress":null,"wmiName":null,"assignedTo":null,"name":"iDRAC 7 Express","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/firewall-64.png","diagramSiteFullName":"Main Office > Main Office","line":null},"imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/firewall-64.png","typeTitle":"Router/Firewall","statusTitle":"Offline","typeImage":"firewall-64.png","statusImage":"offline.png","statusCssClass":"danger","typeCssClass":null},{"key":47,"loc" : "500 400","guid":"eab9f460-0e6f-e2aa-6cf4-056ddc61601a","typeId":6,"statusId":5,"name":"Networking X1052P Smart Web Managed Switch`","description":"Exchange 2010 Enterprise Edition","vendor":"Intel","manufacturer":"Intel","model":"Gropickor","active":true,"ipAddress":"10.2.4.47","wmI_Name":"THA0-4144","assignedTo":"Samantha0","diagramElement":{"guid":"e4f8ffba-9ab3-4be5-86c4-398a5c580b59","diagramId":"aefb8652-07d2-d5cf-8186-ce3847bbd6b8","configurationId":"eab9f460-0e6f-e2aa-6cf4-056ddc61601a","parentDiagramElementId":"00000000-0000-0000-0000-000000000000","coorX":145.50,"coorY":279.00,"created":"2019-10-06T07:39:35.8","modified":"2019-10-07T18:52:55.933","active":true,"ipAddress":null,"wmiName":null,"assignedTo":null,"name":"Networking X1052P Smart Web Managed Switch`","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/firewall-64.png","diagramSiteFullName":"Main Office > Main Office","line":null},"imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/firewall-64.png","typeTitle":"Router/Firewall","statusTitle":"Maintenance","typeImage":"firewall-64.png","statusImage":"maintenance.png","statusCssClass":"secondary","typeCssClass":null}]'
    
  return jsondata;
}

let data1 = {"key":55,"loc":"250 20","name":"Old Dog","assignedTo":"Mara","wmI_Name": "MA-RA-6","ipAddress":"192.168.0.1","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/backup-server-64.png"}; 

let data2 = {"key":56,"loc":"450 30","name":"New Dog","assignedTo":"Rongo","wmI_Name": "RO-GO-6","ipAddress":"192.168.0.1","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/backup-server-64.png"}; 

let data3 = {"key":57,"loc":"550 40","name":"Puppy Dog","assignedTo":"Piper","wmI_Name": "PI-PE-6","ipAddress":"192.168.0.1","imgSrc":"https://d18vir2fzaotj1.cloudfront.net/assets/images/components/backup-server-64.png"}; 


$(".add1").click( function(e){
  
  $(this).hide();
  
      // with whatever properties your node's model data needs
    myDiagram.model.addNodeData(data1);
    var node = myDiagram.findNodeForData(data1);
    node.move(new go.Point(12, 34));  
});

$(".add2").click( function(e){
  
  $(this).hide();
  
      // with whatever properties your node's model data needs
    myDiagram.model.addNodeData(data2);
    var node = myDiagram.findNodeForData(data2);
    node.move(new go.Point(12, 34));  
});


$(".add3").click( function(e){
  
  $(this).hide();
  
      // with whatever properties your node's model data needs
    myDiagram.model.addNodeData(data3);
    var node = myDiagram.findNodeForData(data3); 
    var selectedNode = node;
    console.log("selectedNode",selectedNode);
    console.log("selectedNodeKey",selectedNode.key);
    console.log("selectedNode", selectedNode.location.toString());
    console.log("selectedNode-x", selectedNode.location.x);
    console.log("selectedNode-y", selectedNode.location.y);
    console.log("locationObject", selectedNode.locationObject);
  
    node.move(selectedNode.location);  
});
