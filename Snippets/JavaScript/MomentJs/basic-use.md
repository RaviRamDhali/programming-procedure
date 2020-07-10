Get Year : 20-xxxx
moment().format('YY') + '-',

Get HTML5:
moment().format(moment.HTML5_FMT.DATE),


<script type="text/javascript">
	
	var recuring = 'n';

	$(document).ready(function () {

		$('#formReminderModal').validate();

		$('#recurringEnd').rules("add", {
			reccuringdate: ''
		});

		jQuery.validator.addMethod("reccuringdate", function (value, element, data) {
			var beginDate = $('#due').val();
			var endDate = $('#recurringEnd').val();
			var recurring = $('#recurringEnd').val();

			var due = moment(beginDate);
			var recurringEndDate = moment(endDate);

			if (recurring === 'n')
				return true;

			isAfter = moment(recurringEndDate).isAfter(due);
			return isAfter;

		}, "Must be after due date.");


		// Recurrning toggle
		// -----------------------------------
		recurring = $('#recurring').val();
		HideRecurringEnd();

		if (recurring !== 'n')
			ShowRecurringEnd();

		$('#recurring').change(function () {
			HideRecurringEnd();
			recurring = $('#recurring').val();

			if (recurring !== 'n') {
				ShowRecurringEnd();
				SetEndDateAfterStartDate();
			}
				
		});
		// -----------------------------------


		$('#modalReminder').on('shown.bs.modal', function () {
			$('#title').focus();
		});


		// Radio Button toggle
		// -----------------------------------
		$('.radioPersonal').show();
		$('input[name=radioReminder]').change(function(e) {
			var value = $('input[name=radioReminder]:checked').val();
			$('.radioPersonal').show();

			if (value === 'personal')
				$('.radioPersonal').hide();
		});
		// -----------------------------------

	});

	function ShowRecurringEnd(){
		$('.container-inner-recurringEnd').show();
		$('.container-inner-recurringEnd').addClass('required');
	};

	function HideRecurringEnd(){
		$('.container-inner-recurringEnd').hide();
		$('.container-inner-recurringEnd').removeClass('required');
	};

	function SetEndDateAfterStartDate() {
		var beginDate = $('#due').val();
		var due = moment(beginDate);

		var b = due.clone().add(1, 'day');
		console.log(b.format('YYYY-MM-DD'));

		$('#recurringEnd').val(b.format('YYYY-MM-DD'));
		
	}

</script>
