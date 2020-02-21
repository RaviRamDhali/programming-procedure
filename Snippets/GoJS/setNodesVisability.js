
function setAllNodesVisability(show){
    myDiagram.commit(function (diag) {
        diag.nodes.each(function (node) {node.visible = show;})
    });
}

function setNodesVisabilityByType(configTypeId) {
    myDiagram.commit(function (diag) {
        diag.nodes.each(function (node) {
            console.log('node',node);
            if (node.data.configTypeGuid == configTypeId) {
                node.visible = true;
            }
        })
    });
}
