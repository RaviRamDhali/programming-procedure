myDiagram.addDiagramListener("SelectionMoved", function (event) {
    console.log("SelectionMoved ...");
    // https://gojs.net/latest/api/symbols/Part.html#location
    // * PART
    let selectedNode = event.diagram.selection.first();
    let nodeData = selectedNode.data;  //node data
    //Save new location
    console.log('Save new location ...')

    let updatedNode = {
    guid: nodeData.guid,
    diagramGuid: nodeData.diagramId,
    configurationGuid: nodeData.key,
    coorx: selectedNode.location.x,
    coory: selectedNode.location.y
    }
    console.log('updatedNode', updatedNode)

    axios.post('/api/Diagram', updatedNode);

});
