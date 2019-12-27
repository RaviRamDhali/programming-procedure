//---------------------------------------
$(document).ready(function () {
    
$(this).attr("data-id") // will return the string "123"
$(this).data("id") // will return the number 123
$('[data-id=' + item_id + ']') // By data-id

    
    
    //---------------------------------------
    //--- jquery.dataTables ---
    var oTable = $('table.dataTable').dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": true,
        "bSort": true,
        "bSortCellsTop": true,
        "sDom": '<"top"i>t<"bottom"><"clear">',
        aoColumnDefs: [{ aTargets: [-1], bSortable: false }]
    });

    $("thead input").keyup(function () {
        /* Filter on the column (the index) of this element */
        oTable.fnFilter(this.value, $(".dataTable-input input").index(this));
    });
    //---------------------------------------

    //---------------------------------------
    toastr.options = {
        "positionClass": "toast-top-center"
    };

});


function UpdateRecord(objForm,formButton,controller) {
    var postUrl = '/' + controller + '/Post';
    var formData = $(objForm).serialize();

    SpinningIconOnForButton(formButton);

    $.post(postUrl, formData, function (data) {
        var objJson = jQuery.parseJSON(data);
        if (objJson.success) {
            toastr.success(objJson.message);
            WaitAndRedirect("/" + controller + "?st=");
        } else {
            SpinningIconOffForButton(formButton);
            toastr.error(objJson.message + '. Please try again!');
            ProcessServerValidation(objForm, objJson.validation);
            return false;
        };
    });
};

function ProcessServerValidation(objForm, data) {
    var validator = $(objForm).validate();
    $.each(data, function (i, vObj) {
        var obj = {};
        obj[vObj.ValidationField] = vObj.ValidationMessage;

        validator.showErrors(obj);
    });
}

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
                toastr.success(controller + ' record deleted successfully!');
                RemoveTr(trDelete);
            } else {
                SpinningIconOffForRemoveTr(trIcon, trDelete);
                toastr.error('There was an error deleting ' + controller + ' record. Please try again!');
            };

        });
    } else {
        SpinningIconOffForRemoveTr(trIcon, trDelete);
    };
}

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

function WaitAndRedirect(url) {
    setTimeout(function () {
        window.location = url;
    }, 1500);
}

