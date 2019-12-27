 $(document).find("#form-reservation-edit").change(function (e) {

    let arrFormfields = $("#form-reservation-edit").serializeArray();

    $.ajax({
        type: "POST",
        url: "/Reserv/Update",
        data: arrFormfields,
        beforeSend: function () {
        },
        success: function (d) {
            UpdateTableRow(arrFormfields);
        },
        complete: function () {
            // do nothing
        }
    });


 });

function UpdateTableRow(arrFormfields) {
    let objForm = objectifyForm(arrFormfields);
    let row = $("tr[data-id='" + objForm.reservationnumber + "']")

    ChangeIconState(objForm.iscontract, row, 'iscontract');
    ChangeIconState(objForm.hasperson, row, 'hasperson');
    ChangeIconState(objForm.uploadidentification, row, 'uploadidentification');
    ChangeIconState(objForm.sentinstructions, row, 'sentinstructions');
    ChangeIconState(objForm.contract, row, 'contract');
}

function ChangeIconState(hasValue, row, tdClass) {
    // Update the icon and color hasValue Green/Red
    let target = $(row).find('td.' + tdClass + ' > i ');
    if (hasValue)
        target.removeClass("fa-times-circle text-danger").addClass("fa-check-circle text-success");
    else
        target.removeClass("fa-check-circle text-success").addClass("fa-times-circle text-danger");
}
