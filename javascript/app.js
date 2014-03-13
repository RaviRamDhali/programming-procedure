//---------------------------------------
//---------------------------------------
function UpdateRecord(formData,formButton,controller) {
    var postUrl = '/' + controller + '/Post';

    SpinningIconOnForButton(formButton);

    $.post(postUrl, formData, function (data) {
        var objJson = jQuery.parseJSON(data);
        if (objJson.success) {
            window.location = "/" + controller +"?st=";
        } else {
            SpinningIconOffForButton(formButton);
            // ProcessServerValidation(data);
        };
    });
};


//---------------------------------------
//---------------------------------------
function DeleteRecordRemoveTr(element, controller) {
    var trDelete = $(element).closest('tr');
    
    // Spinning Icon Setup ------------
    var trIcon = $(element).children('i');
    //var trIconClasses = $(trIcon).attr('class');
    SpinningIconOnForRemoveTr(trIcon, trDelete);
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
                SpinningIconOffForRemoveTr(trIcon, trDelete);
                alert(objJson.message);
            };

        });
    } else {
        SpinningIconOffForRemoveTr(trIcon, trDelete);
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

function SpinningIconOnForRemoveTr(element, parentContainer) {
    $(parentContainer).addClass('alert');
    // $(element).removeClass();
    $(element).addClass('fa-spinner fa-spin');
}

function SpinningIconOffForRemoveTr(element, parentContainer) {
    $(parentContainer).removeClass('alert');
    $(element).removeClass('fa-spinner fa-spin');
    // $(element).addClass(ogClass);
}

function SpinningIconOnForButton(element) {
    $(element).attr('disabled', true);
    $(element).html(CreateSpinningIcon());
}

function SpinningIconOffForButton(element) {
    $(element).attr('disabled', false);
    $(element).html("Submit");
}

function CreateSpinningIcon() {
    var strHtml = "<i class='fa fa-spinner fa-spin'></i> Processing ... ";
    return strHtml;

}
