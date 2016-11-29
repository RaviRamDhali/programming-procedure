<%

Class mappolygon
	public idno
	public park_idno
	public title
	public description
	public coordinates
	public fillColor
	public fillOpacity
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
		fillColor = rs("fillColor")
		fillOpacity = FormatNumber(rs("fillOpacity"), 2)
		command = SetCommand(rs)
	end function


	public function getall()
		dim sql
		sql = "select * from map_polygons"

		dim rs
		set rs = conn.execute(sql)
		set getall = rs
	end function

	public function getbyidno(idno)
		idno = CLng(idno)
		dim sql
		sql = "select top 1 * from map_polygons where idno = " & idno

		dim rs
		set rs = conn.execute(sql)
		set getbyidno = rs
	end function

	public function add(data)
		dim sql
		sql = "map_polygons"

		if (data.command = "update") then
		sql = "select * from map_polygons where idno = " & data.idno
		end if

		dim rs
		set rs = Server.CreateObject("ADODB.recordset")
		rs.LockType = 3
		rs.Open sql, conn

		if data.command = "add" then
		rs.addnew
		end if

			rs("idno") = data.idno
			rs("park_idno") = data.park_idno
			rs("title") = data.title
			rs("description") = data.description
			rs("coordinates") = data.coordinates
			rs("fillColor") = data.fillColor
			rs("fillOpacity") = data.fillOpacity

		rs.update
		rs.Close()
	end function

	public function delete(idno)
		dim sql
		sql = "delete from map_polygons where idno = " & idno

		dim rs
		set rs = conn.execute(sql)
	end function

end Class

%>