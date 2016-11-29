<!-- #include virtual=/Intranet/includes/global.asp -->
<!-- #include virtual=/Intranet/includes/adovbs.asp-->
<!-- #include virtual=/Intranet/includes/functions/Common.asp-->

<!-- #include virtual=/Intranet/Admin/mapbuilder/class_common.asp -->
<!-- #include virtual=/Intranet/Admin/mapbuilder/class_mappolygon.asp -->

<%
	dim rs
	dim data
	set data = new mappolygon
	set rs = data.getall

dim park
dim rs_park
set park = new mappolygon

dim idno
idno = Request.QueryString("idno")
set rs_park = park.getbyidno(idno)

'BOF & EOF indicates an empty recordset
If rs_park.BOF And rs_park.EOF Then 
	park.command = "add" ' set command to add
    response.write("<strong>no record found</strong>")
else
	call park.initialize(rs_park)
	park.command = "update" ' set command to edit
end if


%>
<!DOCTYPE html>
<html>
<head>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">
$( document ).ready(function() {

	$('.row-delete').click(function(e){
		e.preventDefault();

		if(!confirm('Are you sure?'))
			return;

		var idno = $(this).closest('tr').data('id');
		$('#idno').val(idno);
		$('#command').val("delete");
		$('#form').submit();
	});



});

</script>

	<title>Map LineStrings</title>

</head>
<body>

<div class="container">
<!-- #include virtual=/Intranet/Admin/mapbuilder/inc_menu.asp -->
<div class="page-header">
        <h1>Map LineStrings</h1>
      </div>
<div class="row">

<table class="table table-striped">
	<thead>
	<tr>
		<th>idno</th>
		<th>park_idno</th>
		<th>title</th>
		<th>description</th>
		<th>coordinates</th>
		<th>strokeColor</th>
		<th>strokeWeight</th>
		<th>strokeOpacity</th>
		<th></th>

	</tr>
	</thead>

	<tbody>
	<%
	while not rs.eof
	call data.initialize(rs)
	%>

	<tr data-id="<%=data.idno%>">
		<td><a href="/Intranet/admin/mapbuilder/mappolygons.asp?idno=<%=data.idno%>"><%=data.idno%></a></td>
		
		<td><%=data.park_idno%></td>
		<td><%=data.title%></td>
		<td><%=data.description%></td>
		<td><%=data.coordinates%></td>
		<td><%=data.fillColor%></td>
		<td><%=data.fillOpacity%></td>
		
		<td><a href="#" class="glyphicon glyphicon-trash row-delete"></a></td>
	
	<%
	rs.MoveNext
	wend
	%>
	</tbody>
</table>

	<div class="alert alert-info">
		<h2><%=park.title%></h2>
		<p><%=park.description%></p>
	</div>


	<div class="col-md-3">
		<form id="form"	name="form" method="post" action="post_mappolygon.asp" >
			<div class="form-group"> 
				<label>park_idno</label> 
				<input class="form-control" type="number" name="park_idno" id="park_idno" value="<%=park.park_idno%>"/> 
			</div>
			<div class="form-group"> 
				<label>title</label> 
				<input class="form-control" type="text" name="title" id="title" value="<%=park.title%>"/> 
			</div>
			<div class="form-group"> 
				<label>description</label> 
				<input class="form-control" type="text" name="description" id="description" value="<%=park.description%>"/> 
			</div>
			<div class="form-group"> 
				<label>coordinates</label> 
				<input class="form-control" type="text" name="coordinates" id="coordinates" value="<%=park.coordinates%>"/> 
			</div>

			<div class="form-group"> 
				<label>fillColor</label>
				<select class="form-control" name="fillColor" id="fillColor">
					<% Call dropdownColors(park.fillColor) %>
				</select>
			</div>

			<div class="form-group"> 
				<label>fillOpacity</label> 
				<input class="form-control" type="number" step="any" name="fillOpacity" id="fillOpacity" value="<%=park.fillOpacity%>"/> 
			</div>


			<div class="form-group">
				<input type="hidden" name="idno" id="idno" value="<%=park.idno%>">
				<input type="hidden" name="command" id="command" value="<%=park.command%>">
				<button class="btn btn-info">Submit</button>
				<a href="/Intranet/admin/mapbuilder/" class="btn btn-default">Reset</a>
			</div>

		</form>
	</div>
	
</div>
</div>
</body>
</html>