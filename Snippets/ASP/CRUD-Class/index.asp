<!-- #include virtual=/Intranet/includes/global.asp -->
<!-- #include virtual=/Intranet/includes/adovbs.asp-->
<!-- #include virtual=/Intranet/includes/functions/Common.asp-->

<!-- #include virtual=/Intranet/Admin/mapbuilder/class_common.asp -->
<!-- #include virtual=/Intranet/Admin/mapbuilder/class_maplabel.asp -->
<!-- #include virtual=/Intranet/Admin/mapbuilder/class_mappolygon.asp -->
<!-- #include virtual=/Intranet/Admin/mapbuilder/class_maplinestring.asp -->


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



});

</script>

	<title></title>

</head>
<body>

<div class="container">

<!-- #include virtual=/Intranet/Admin/mapbuilder/inc_menu.asp -->

<div class="page-header">
        <h1>Camava Map Builder</h1>
        <p class="lead">Map Builder Examples</p>
      </div>

<div class="row">

<%
	dim rsMapLabel
	dim objMaplabel
	set objMaplabel = new maplabel
	set rsMapLabel = objMaplabel.getall
%>
<h2>Labels</h2>
<a href="mapLabels.asp" class="btn btn-success">Add</a>
<table class="table table-striped">
	<thead>
	<tr>
		<th>idno</th>
		<th>park_idno</th>
		<th>title</th>
		
		<th>fillColor</th>
		<th>anchor_x</th>
		<th>anchor_y</th>
		
	</tr>
	</thead>

	<tbody>
	<%
	while not rsMapLabel.eof
	call objMaplabel.initialize(rsMapLabel)
	%>

	<tr data-id="<%=objMaplabel.idno%>">
		<td><a href="/Intranet/admin/mapbuilder/mapLabels.asp?idno=<%=objMaplabel.idno%>"><%=objMaplabel.idno%></a></td>
		<td><%=objMaplabel.park_idno%></td>
		<td><%=objMaplabel.title%></td>
		
		<td><%=objMaplabel.fillColor%></td>
		<td><%=objMaplabel.anchor_x%></td>
		<td><%=objMaplabel.anchor_y%></td>
		
	
	<%
	rsMapLabel.MoveNext
	wend
	%>
	</tbody>
</table>



<%
	dim rsMaplingstring
	dim objMapLineString
	set objMapLineString = new maplinestring
	set rsMaplingstring = objMapLineString.getall
%>
<h2>Map Lingstring</h2>
<a href="mapLinestrings.asp" class="btn btn-success">Add</a>
<table class="table table-striped">
	<thead>
	<tr>
		<th>idno</th>
		<th>park_idno</th>
		<th>title</th>
		
		<th>strokeColor</th>
		<th>strokeWeight</th>
		<th>strokeOpacity</th>
		
	</tr>
	</thead>

	<tbody>
	<%
	while not rsMaplingstring.eof
	call objMapLineString.initialize(rsMaplingstring)
	%>

	<tr data-id="<%=objMapLineString.idno%>">
		<td><a href="/Intranet/admin/mapbuilder/mapLabels.asp?idno=<%=objMapLineString.idno%>"><%=objMapLineString.idno%></a></td>
		<td><%=objMapLineString.park_idno%></td>
		<td><%=objMapLineString.title%></td>
		
		<td><%=objMapLineString.strokeColor%></td>
		<td><%=objMapLineString.strokeWeight%></td>
		<td><%=objMapLineString.strokeOpacity%></td>
		
	
	<%
	rsMaplingstring.MoveNext
	wend
	%>
	</tbody>
</table>


</div>
</div>
</body>
</html>