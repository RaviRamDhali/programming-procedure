//---------------------------------------
//---------------------------------------
function DeleteRecordRemoveTr(element, controller) {
    var trDelete = $(element).closest('tr');
    
    // Spinning Icon Setup ------------
    var trIcon = $(element).children('i');
    //var trIconClasses = $(trIcon).attr('class');
    SpinningIconOn(trIcon, trDelete);
    // ---------------------------------


    var guid = $(trDelete).data('id');
    var postUrl = '/' + controller + '/Delete/' + guid;

    var result = confirm("Delete this record?");
    if (result == true) {
       $.post(postUrl, null, function (data) {
            var objJson = jQuery.parseJSON(data);

            if (objJson.success) {
                RemoveTr(trDelete);
            } else {
                SpinningIconOff(trIcon, trDelete);
                alert(objJson.message);
            };

        });
    } else {
        SpinningIconOff(trIcon, trDelete);
    };
}

//---------------------------------------
//---------------------------------------


function RemoveTr(trDelete) {
    $(trDelete).removeClass().addClass('deleteTr');
    $(trDelete).find("td").removeClass().addClass('deleteTd');

    $(trDelete).fadeOut(1300, function () {
        $(trDelete).remove();
    });
}

function SpinningIconOn(element, parentContainer) {
    $(parentContainer).addClass('alert');
    // $(element).removeClass();
    $(element).addClass('fa-spinner fa-spin');
}

function SpinningIconOff(element, parentContainer) {
    $(parentContainer).removeClass('alert');
    $(element).removeClass('fa-spinner fa-spin');
    // $(element).addClass(ogClass);
}
