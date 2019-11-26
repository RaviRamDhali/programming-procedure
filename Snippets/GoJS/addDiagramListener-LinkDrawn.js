myDiagram.addDiagramListener("LinkDrawn", function (event) {
    console.log("LinkDrawn");

    let selectedNode = event.diagram.selection.first();
    let dataLink = event.subject.data;

    let fromNode  = event.subject.fromNode.data;
    let toNode  = event.subject.toNode.data;

    console.log('fromNode',fromNode);
    console.log('toNode',toNode);
    console.log('selectedNode', selectedNode);

    let arrLink = {
        from: dataLink.from.toString(),
        to: dataLink.to.toString()
    };

    console.log('arrLink', arrLink);
});
