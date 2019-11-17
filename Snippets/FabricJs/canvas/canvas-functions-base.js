// *************************************************************
// *************************************************************

// drag menu items to canvas
// function handleDragStart > moved to handleDragStart.js

// //HTML 5 dragging handle functions
function handleDragEnd(e) {
    // this/e.target is the source node.
    // [].forEach.call(images, function (img) {
    //     img.classList.remove('img_dragging');
    // });
}

function handleDragOver(e) {
    if (e.preventDefault) {
        e.preventDefault(); // Necessary. Allows us to drop.
    }
}


function handleDragEnter(e) {
    // console.log('handleDragEnter: ', e)
    // this / e.target is the current hover target.
    // this.classList.add('over');
    // console.log('handleDragEnter .....', e)
}

// Standard Canvas Objects


function handleDragLeave(e) {
    this.classList.remove('over'); // this / e.target is previous target element.
}

function getMouseCoords(event) {
    var pointer = canvas.getPointer(event.e);
    var posX = pointer.x;
    var posY = pointer.y;
    $('#chords').text(posX + ", " + posY); // Log to console

}

// *************************************************************
// *************************************************************
