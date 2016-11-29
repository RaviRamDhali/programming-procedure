<%

	public function SetCommand(rs)
			dim command
			On Error Resume Next
				command = rs("command")
				If Err <> 0 Then command = "add"
			Err.Clear
			SetCommand = command
	end function


	public function dropdownColors(selectedvalue)
		
		dim colors
		dim arrayColors
		dim color

		colors = "black,blue,brown,cyan,darkBlue,green,grey,lightBlue,lime,magenta,maroon,olive,orange,purple,red,silver,white,yellow"
		arrayColors = Split(colors,",")

		for each color in arrayColors
			dim inputoptions
			dim value
			dim label
			
			dim selected
			selected = ""

			value = color
			label = UCase(Left(value,1))&LCase(Right(value, Len(value) - 1))
			
			if(selectedvalue = color) then 
				selected = "selected='selected'"
			end if

			inputoptions = "<option value='"&value&"'" & selected & " style='color:"&color&"' >"&label&"</option>"

			response.write(inputoptions)

		next

	end function



%>