function RemoveGLthanChar(notes) {
    var regex = /<[^>](.*?)>/g;
    var strBlocks = notes.match(regex);

    strBlocks.forEach(function (dirtyBlock) {
        let cleanBlock = dirtyBlock.replace("<", "[").replace(">", "]");
        notes = notes.replace(dirtyBlock, cleanBlock);
    });

    return notes;
}



$('#form1').submit(function (e) {
    e.preventDefault();
    var dirtyBlock = $("#comments").val();
    var cleanedBlock = RemoveGLthanChar(dirtyBlock);
    $("#comments").val(cleanedBlock);
    this.submit();
});
