function addNodeDataColor(node) {
    let shape = node.part.findObject("RoundedRectangle");
    if (shape) {
        shape.stroke = "darkkhaki";
        shape.fill = "lightgreen";
    }
}
