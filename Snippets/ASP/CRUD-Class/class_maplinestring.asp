<%

Class maplinestring
	public idno
	public park_idno
	public title
	public description
	public coordinates
	public strokeColor
	public strokeWeight
	public strokeOpacity
	public command


	public function initialize(rs)
		If IsNumeric(rs("idno")) Then
			idno = rs("idno")
		Else
			idno = Counter()
		End If

		park_idno = rs("park_idno")
		title = rs("title")
		description = rs("description")
		coordinates = rs("coordinates")
		strokeColor = rs("strokeColor")
		strokeWeight = rs("strokeWeight")
		strokeOpacity = FormatNumber(rs("strokeOpacity"), 2)
		command = SetCommand(rs)
	end function


	public function getall()
		dim sql
		sql = "select * from map_linestrings"

		dim rs
		set rs = conn.execute(sql)
		set getall = rs
	end function

	public function getbyidno(idno)
		idno = CLng(idno)
		dim sql
		sql = "select top 1 * from map_linestrings where idno = " & idno

		dim rs
		set rs = conn.execute(sql)
		set getbyidno = rs
	end function

	public function add(data)
		dim sql
		sql = "map_linestrings"

		if (data.command = "update") then
		sql = "select * from map_linestrings where idno = " & data.idno
		end if

		dim rs
		set rs = Server.CreateObject("ADODB.recordset")
		rs.LockType = 3
		rs.Open sql, conn

		if data.command = "add" then
		rs.addnew
		end if

			response.write("<br/>idno:" & data.idno)
			response.write("<br/>park_idno:" & data.park_idno)
			response.write("<br/>title:" & data.title)
			response.write("<br/>description:" & data.description)
			response.write("<br/>coordinates:" & data.coordinates)
			response.write("<br/>strokeColor:" & data.strokeColor)
			response.write("<br/>strokeWeight:" & data.strokeWeight)
			response.write("<br/>strokeOpacity:" & data.strokeOpacity)
			
			rs("idno") = data.idno
			rs("park_idno") = data.park_idno
			rs("title") = data.title
			rs("description") = data.description
			rs("coordinates") = data.coordinates
			rs("strokeColor") = data.strokeColor
			rs("strokeWeight") = data.strokeWeight
			rs("strokeOpacity") = data.strokeOpacity

		rs.update
		rs.Close()
	end function

	public function delete(idno)
		dim sql
		sql = "delete from map_linestrings where idno = " & idno

		dim rs
		set rs = conn.execute(sql)
	end function




































End Class

%>