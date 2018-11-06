<%

'//|---------------------------------------------------------------------------
'//| Logic Functions
'//|---------------------------------------------------------------------------
Function IIf(vBooleanToEvaluate, vIfTrue, vIfFalse)
	If vBooleanToEvaluate Then
		IIf = vIfTrue
	Else
		IIf = vIfFalse
	End If
End Function

'//|---------------------------------------------------------------------------
'//| Numeric & Math Functions
'//|---------------------------------------------------------------------------

Function IsOdd(nInput)
	IsOdd = CBool(nInput Mod	2 = 1)
End Function

Function IsEven(nInput)
	IsOdd = CBool(nInput Mod	2 = 0)
End Function

Function GreaterOf(nInput1, nInput2)
	If GetNumeric(nInput1) > GetNumeric(nInput2) Then
		GreaterOf = GetNumeric(nInput1)
	Else
		GreaterOf = GetNumeric(nInput2)
	End If
End Function

Function LesserOf(nInput1, nInput2)
	If GetNumeric(nInput1) < GetNumeric(nInput2) Then
		LesserOf = GetNumeric(nInput1)
	Else
		LesserOf = GetNumeric(nInput2)
	End If
End Function

Function LimitTo(nInput, nMin, nMax)
	LimitTo = LesserOf(GreaterOf(nInput, nMin), nMax)
End Function

Function Ceiling(nInput)
	If nInput = Int(nInput) Then
		Ceiling = Int(nInput)
	Else
		Ceiling = Int(nInput) + 1
	End If
End Function

Function GetRandomInt(nMin, nMax)
	Randomize
	GetRandomInt = Int(((nMax+1-nMin) * Rnd) + nMin)
End Function

Function LogB(nNumber,nBase)
	Dim nLg
	If nNumber <=0 then
		Err.Raise 5 , , "Logarithms for zero and negitive numbers are not defined"
	Exit Function
	End If
	For I = 0 to nNumber
	    If nBase ^ I = nNumber then
	       LogB=I
	       Exit Function
	    ElseIf nBase ^ I < nNumber And nBase ^ (I+1) > nNumber then
	        nLg = I
	        For J= 1 to 99999
	            nLg = nLg + 0.00001
	            If nBase ^ nLg >= nNumber Then
	               LogB = nLg
	               Exit Function
	            End If
	        Next
	     End IF
	Next
End Function

Function Log10(X)
    Log10 = Log(X) / Log(10)
End Function

Function LogXofY(X,Y)
    LogXofY = Log(X) / Log(Y)
End Function


'//|---------------------------------------------------------------------------
'//| Numeric Formatting Functions
'//|---------------------------------------------------------------------------
Function FormatFraction(nDecimal)
	FormatFraction = "0"

	If IsNumeric(nDecimal) Then
		Dim nFraction, sFraction

		nDecimal = CDbl(nDecimal)
		nFraction = nDecimal - Int(nDecimal)

		If nFraction = 0 Then
			sFraction = ""
		ElseIf nFraction <= 0.37 Then
			sFraction = "�"
		ElseIf nFraction <= 0.62 Then
			sFraction = "�"
		Else
			sFraction = "�"
		End If

		If Int(nDecimal) = 0 Then
			FormatFraction = sFraction
		Else
			FormatFraction = Int(nDecimal) & sFraction
		End If
	End If
End Function

Function FormatBytesSize(nBytes)
	If nBytes < 1024 Then
		FormatBytesSize = nBytes & " B"
	ElseIf nBytes < 1024^2 Then
		FormatBytesSize = Round(nBytes/1024,1) & " kB"
	ElseIf nBytes < 1024^3 Then
		FormatBytesSize = Round(nBytes/1024^2,1) & " MB"
	ElseIf nBytes < 1024^4 Then
		FormatBytesSize = Round(nBytes/1024^3,1) & " GB"
	ElseIf nBytes < 1024^5 Then
		FormatBytesSize = Round(nBytes/1024^4,1) & " TB"
	ElseIf nBytes < 1024^6 Then
		FormatBytesSize = Round(nBytes/1024^5,1) & " PB"
	ElseIf nBytes < 1024^7 Then
		FormatBytesSize = Round(nBytes/1024^6,1) & " EB"
	ElseIf nBytes < 1024^8 Then
		FormatBytesSize = Round(nBytes/1024^7,1) & " ZB"
	End If
End Function


'//|---------------------------------------------------------------------------
'//| Type Conversion Functions
'//|---------------------------------------------------------------------------

Function GetMoney(vInput)
	GetMoney = Round(GetNumeric(vInput), 2)
End Function

Function GetNumeric(vInput)
	If IsNull(vInput) Then
		GetNumeric = 0
	ElseIf IsNumeric(vInput) Then
		GetNumeric = CDbl(vInput)
	Else
		GetNumeric = 0
	End If
End Function

Function GetDate(vInput)
	If IsDate(vInput) Then
		if vInput	= "1/1/1900" then
			GetDate	= ""
		else
			GetDate = CDate(vInput)
		end if
	Else
		GetDate = ""
	End If
End Function

Function GetStr(vInput)
	GetStr = ""
	If IsNull(vInput) Then Exit Function
	On Error Resume Next
		GetStr = Trim(vInput)
	On Error Goto 0
End Function

Function GetInt(vInput)
	GetInt = 0
	If IsNull(vInput) Then Exit Function
	If Not IsNumeric(vInput) Then Exit Function
	GetInt = Int(vInput)
End Function

Function GetBit(vInput)
	If IsNull(vInput) Or Trim(vInput) = "" Or GetInt(vInput) = 0 Then
		GetBit = 0
		Exit Function
	Else
		GetBit = 1
	End If
End Function

Function GetBool(vInput)
	If LCase(GetStr(vInput)) = "true" Or LCase(GetStr(vInput)) = "on" Then
		GetBool = True
	ElseIf LCase(GetStr(vInput)) = "false" Then
		GetBool = False
	ElseIf IsNull(vInput) Or Trim(vInput) = "" Or GetInt(vInput) = 0 Then
		GetBool = False
		Exit Function
	Else
		GetBool = CBool(vInput)
	End If
End Function

'//|---------------------------------------------------------------------------
'//| Date/Time Functions
'//|---------------------------------------------------------------------------
Function Now_Adjusted()
	nDisplayOffSet = GetInt(Application("DisplayTimeZoneOffset"))
	nServerOffSet = GetInt(Application("ServerTimeZoneOffset"))

	Now_Adjusted = DateAdd("h", nDisplayOffSet, DateAdd("h", (-nServerOffSet), Now))
End Function

Function Date_Adjusted
	dNow = Now_Adjusted
	Date_Adjusted = CDate( Month(dNow) & "/" & Day(dNow) & "/" & Year(dNow) )
End Function

Function Hour12(dInput)
	Hour12 = ""
	If IsDate(dInput) Then
		Hour12 = Hour(dInput)
		If Hour12 > 12 Then Hour12 = Hour12 - 12
	End If
End Function

Function GetW3CDate(dDate)
	GetW3CDate = Year(dDate) & "-" & _
				String(2-Len(Month(dDate)),"0") & _
				Month(dDate) & "-" &  _
				String(2-Len(Day(dDate)),"0") & _
				Day(dDate)
End Function

Function GetTimeStampString()
	GetTimeStampString = GetTimeStampFromDate(Now_Adjusted)
End Function

Function GetTimeStampFromDate(dInput)
	GetTimeStampFromDate = Year(dInput) & _
				String(2-Len(Month(dInput)),"0") & _
				Month(dInput) & _
				String(2-Len(Day(dInput)),"0") & _
				Day(dInput) & _
				String(2-Len(Hour(dInput)),"0") & _
				Hour(dInput) & _
				String(2-Len(Minute(dInput)),"0") & _
				Minute(dInput) & _
				String(2-Len(Second(dInput)),"0") & _
				Second(dInput)
End Function

Function GetDayInt()
	GetDayInt = (Year(Now_Adjusted) * 10000) + _
				(Month(Now_Adjusted) * 100) + _
				Day(Now_Adjusted)
End Function

Function GetDayIntFromDate(dDate)
	GetDayIntFromDate = (Year(dDate) * 10000) + _
				(Month(dDate) * 100) + _
				Day(dDate)
End Function

Function GetDateFromDayInt(nDayInt)
	GetDateFromDayInt = Null
	sDayString = GetStr(nDayInt)
	If Not Len(sDayString) = 8 Then Exit Function
	If Not IsNumeric(sDayString) Then Exit Function
	GetDateFromDayInt = GetDate(Mid(sDayString,5,2) & "-" & Mid(sDayString,7,2) & "-" & Mid(sDayString,1,4))
End Function

		Function GetDayString()
			GetDayString = Year(Now_Adjusted) & _
						String(2-Len(Month(Now_Adjusted)),"0") & _
						Month(Now_Adjusted) & _
						String(2-Len(Day(Now_Adjusted)),"0") & _
						Day(Now_Adjusted)
		End Function

		Function GetDateFromDayString(sDayString)
			GetDateFromDayString = Null
			If Not Len(sDayString) = 8 Then Exit Function
			If Not IsNumeric(sDayString) Then Exit Function
			GetDateFromDayString = GetDate(Mid(sDayString,5,2) & "-" & Mid(sDayString,7,2) & "-" & Mid(sDayString,1,4))
		End Function

		Function DayStringDiff(sDayString1, sDayString2)
			DayStringDiff = DateDiff("d", GetDateFromDayString(sDayString1), GetDateFromDayString(sDayString2))
		End Function

'//|---------------------------------------------------------------------------
'//| Date/Time Formatting Functions
'//|---------------------------------------------------------------------------
Function FormatShortDateTime(dInput)	'//| "1/1/2008 1:01 PM"
	If Not IsDate(dInput) Then Exit Function
	nHour = Hour(dInput)
	sAMPM = "AM"
	If nHour > 12 Then
		nHour = nHour - 12
		sAMPM = "PM"
	End If
	FormatShortDateTime = Month(dInput) & "/" & Day(dInput) & "/" & Year(dInput) & " " & nHour & ":" & GetFixedLengthNumber(Minute(dInput), 2) & " " & sAMPM
End Function

Function FormatShortDate(dInput)		'//| "1/1/2008"
	If Not IsDate(dInput) Then Exit Function
	FormatShortDate = Month(dInput) & "/" & Day(dInput) & "/" & Year(dInput)
End Function

Function FormatVeryShortDate(dInput)		'//| "1/1"
	If Not IsDate(dInput) Then Exit Function
	If Year(dInput) = Year(Now) Then
		FormatVeryShortDate = Month(dInput) & "/" & Day(dInput)
	Else
		FormatVeryShortDate = FormatShortDate(dInput)
	End If
End Function

Function FormatShortDate2(dInput)		'//| "1-1-2008"
	FormatShortDate2 = Month(dInput) & "-" & Day(dInput) & "-" & Year(dInput)
End Function

Function FormatShortDate3(dInput)		'//| "Jan-1-2008"
	If Not IsDate(dInput) Then Exit Function
	FormatShortDate3 = MonthName(Month(dInput), True) & "-" & Day(dInput) & "-" & Year(dInput)
End Function


'//|---------------------------------------------------------------------------
'//| Form Parsing Functions
'//|---------------------------------------------------------------------------
Function FormBit(sFieldName)
	If FormText(sFieldName, 10) > "" Then
		FormBit = 1
	Else
		FormBit = 0
	End If
End Function

Function FormBool(sFieldName)
	FormBool = GetBool(FormText(sFieldName, 5))
End Function

Function FormInt(sFieldName)
	FormInt = GetInt(FormText(sFieldName, 16))
End Function

Function FormMoney(sFieldName)
	FormMoney = GetMoney(FormText(sFieldName, 16))
End Function

Function FormDate(sFieldName)
	FormDate = GetDate(FormText(sFieldName, 50))
End Function

Function FormText(sFieldName, nMaxLength)
	If Request.Form(sFieldName) > "" Then
		FormText = Trim(Left(Request.Form(sFieldName), nMaxLength))
	ElseIf Request.QueryString(sFieldName) > "" Then
		FormText = Trim(Left(Request.QueryString(sFieldName), nMaxLength))
	End If
End Function



'//|---------------------------------------------------------------------------
'//| String Functions
'//|---------------------------------------------------------------------------

'//| String Test Functions
'//|--------------------------------
Function StartsWith(sStringToCheck, sStartsWithString)
	If LCase(Left(GetStr(sStringToCheck), Len(GetStr(sStartsWithString)))) = LCase(GetStr(sStartsWithString)) _
		And Len(GetStr(sStartsWithString)) > 0 Then
		StartsWith = True
	Else
		StartsWith = False
	End If
End Function

Function EndsWith(sStringToCheck, sEndsWithString)
	If LCase(Right(GetStr(sStringToCheck), Len(GetStr(sEndsWithString)))) = LCase(GetStr(sEndsWithString)) _
		And Len(GetStr(sEndsWithString)) > 0 Then
		EndsWith = True
	Else
		EndsWith = False
	End If
End Function

'//| Length limiters/adjusters
'//|--------------------------------
'Function AddLineBreaksAtIncrements(sInput, nIncrement)
'	Dim sOutput
'	sOutput = ""
'	If IsNull(sInput) Then Exit Function
'	If Len(sOutput) > nIncrement Then
'	sOutput = Trim(sInput)
'	If Len(sOutput) > nIncrement Then
'		If nIncrement > 3 Then
'			sOutput = Trim(Left(sOutput, nIncrement - 3)) & "..."
'		Else
'			sOutput = Trim(Left(sOutput, nIncrement))
'		End If
'	End If
'	AddLineBreaksAtIncrements = sOutput
'End Function

Function AddCommasToNumber(sNumber)
	AddCommasToNumber = InsertStringAtIncrement(GetStr(sNumber), ",", 3, True)
End Function

Function InsertStringAtIncrement(sStringToModify, sStringToInsert, nIncrement, bFromRight)
	Dim sTemp, nIteration, nIterations
	sTemp = GetStr(sStringToModify)
	nIterations = Int((Len(sStringToModify)-1)/nIncrement)
	For nIteration = 1 To nIterations
		If bFromRight Then
			nStringPos = Len(sTemp) - (nIteration * nIncrement) - (nIteration-1)
			sTemp = Left(sTemp, nStringPos) & sStringToInsert & Mid(sTemp, nStringPos+1)
		Else
			nStringPos = (nIteration * nIncrement) + (nIteration-1)
			sTemp = Left(sTemp, nStringPos) & sStringToInsert & Mid(sTemp, nStringPos+1)
		End If
	Next
	InsertStringAtIncrement = sTemp
End Function

Function LimitLength(sInput, nMaxLength)
	LimitLength = ""
	If IsNull(sInput) Then Exit Function
	LimitLength = Trim(sInput)
	If Len(LimitLength) > nMaxLength Then
		If nMaxLength > 3 Then
			LimitLength = Trim(Left(LimitLength, nMaxLength - 3)) & "..."
		Else
			LimitLength = Trim(Left(LimitLength, nMaxLength))
		End If
	End If
End Function

Function LimitLengthMid(sInput, nMaxLength)
	LimitLengthMid = ""
	If IsNull(sInput) Then Exit Function
	LimitLengthMid = Trim(sInput)
	If Len(LimitLengthMid) > nMaxLength Then
		If nMaxLength > 3 Then
			LimitLengthMid = Trim(Left(LimitLengthMid, Int((nMaxLength - 3)/2))) & "..." & Trim(Right(LimitLengthMid, Int((nMaxLength - 3)/2)))
		Else
			LimitLengthMid = Trim(Left(LimitLengthMid, nMaxLength))
		End If
	End If
End Function

Function CropLength(sInput, nMaxLength)
	CropLength = ""
	If IsNull(sInput) Then Exit Function
	CropLength = Trim(sInput)
	If Len(CropLength) > nMaxLength Then
		CropLength = Trim(Left(CropLength, nMaxLength))
	End If
End Function

Function GetFixedLengthString(sInput, nMaxLength)
	GetFixedLengthString = ""
	If IsNull(sInput) Then Exit Function
	GetFixedLengthString = Left(Trim(sInput), nMaxLength)
	If Len(GetFixedLengthString) < nMaxLength Then
		GetFixedLengthString = GetFixedLengthString & String(nMaxLength-Len(GetFixedLengthString), " ")
	End If
End Function

Function BreakLargeWords(sInput, nMaxWordSize)
	BreakLargeWords = ""
	If IsNull(sInput) Then Exit Function
	arrWords = Split(sInput, " ")
	For nWord = 0 To UBound(arrWords)
		If Len(arrWords(nWord)) > nMaxWordSize _
			And Not InStr(arrWords(nWord), "<") > 0 _
			And Not InStr(arrWords(nWord), "=""") > 0 Then
			BreakLargeWords = BreakLargeWords & LimitLength(arrWords(nWord), nMaxWordSize) & " "
		Else
			BreakLargeWords = BreakLargeWords & arrWords(nWord) & " "
		End If
	Next
	BreakLargeWords = Trim(BreakLargeWords)
End Function

Function GetFixedLengthNumber(nNumber, nLength)
	GetFixedLengthNumber = PadString(GetStr(nNumber), nLength, "0", True)
End Function

Function PadString(sStringToPad, nLength, sPadChars, bPadOnLeft)
	Dim sOutput
	sOutput = GetStr(sStringToPad)
	While Len(sOutput) < nLength
		If bPadOnLeft Then
			sOutput = sPadChars & sOutput
		Else
			sOutput = sOutput & sPadChars
		End If
	Wend
	PadString = sOutput
End Function


Function PadStringLeft(sStringToPad, nLength, sPadChars)
	Dim sOutput
	sOutput = GetStr(sStringToPad)
	While Len(sOutput) < nLength
		sOutput = sPadChars & sOutput
	Wend
	PadString = sOutput
End Function


'//| Random data generators
'//|--------------------------------
Function GetRandomString(nChars)	'//| Returns numbers and non-vowel lowercase letters only
dim nRand
	Randomize
	GetRandomString = ""

	While Len(GetRandomString) < nChars '// Length of random string
		nRand = Int((255 * Rnd) + 1)
		If (nRand > 47 And nRand < 58) Or (nRand > 96 And nRand < 123) Then 	'// Capital letters:  Or (nRand > 64 And nRand < 91)
			'// Filter out vowels to prevent words from being formed
			If (nRand <> Asc("a")) And (nRand <> Asc("e")) And (nRand <> Asc("i")) And (nRand <> Asc("o")) And (nRand <> Asc("u")) Then
				GetRandomString = GetRandomString & Chr(nRand)
			End If
		End If
	Wend
End Function

Function GetRandomStringOfConsonants(nChars)	'//| Returns non-vowel capitals only
dim nRand
	Randomize
	GetRandomStringOfConsonants = ""

	While Len(GetRandomStringOfConsonants) < nChars '// Length of random string
		nRand = Int((255 * Rnd) + 1)
		If (nRand > 64 And nRand < 91) Then
			'// Filter out vowels to prevent words from being formed
			If (nRand <> Asc("A")) And (nRand <> Asc("E")) And (nRand <> Asc("I")) And (nRand <> Asc("O")) And (nRand <> Asc("U")) Then
				GetRandomStringOfConsonants = GetRandomStringOfConsonants & Chr(nRand)
			End If
		End If
	Wend
End Function

Function GetRandomStringOfLetters(nChars)	'//| Returns capitals only
dim nRand
	Randomize
	GetRandomStringOfLetters = ""

	While Len(GetRandomStringOfLetters) < nChars '// Length of random string
		nRand = Int((255 * Rnd) + 1)
		If (nRand > 64 And nRand < 91) Then
			GetRandomStringOfLetters = GetRandomStringOfLetters & Chr(nRand)
		End If
	Wend
End Function

Function GetRandomFontName()
	sFontNames = "Times New Roman|Courier New|Arial|Verdana|Tahoma|Trebuchet MS|Georgia"
	arrFontNames = Split(sFontNames, "|")
	GetRandomFontName = arrFontNames(GetRandomInt(LBound(arrFontNames), UBound(arrFontNames)))
End Function

Function GetRandomBoolean()
	Randomize
	GetRandomBoolean = GetBool(GetRandomInt(1, 2) = 1)
End Function

Function GetRandomVBColor()
	GetRandomVBColor = GetRandomInt(VBBlack, VBWhite)
End Function


'//| Text Filtering
'//|--------------------------------

Function FilterString_ValidCharsOnly(sInput, sValidChars)
	Dim sOutput
	sInput = GetStr(sInput)

	For nChar = 1 To Len(sInput)
		sChar = Mid(sInput, nChar, 1)
		If InStr(sValidChars, sChar) > 0 Then
			sOutput = sOutput & sChar
		End If
	Next

	FilterString_ValidCharsOnly = sOutput
End Function

Function FixSubDomain(sInput)
	FixSubDomain = Left(AlphaNumericOnly(sInput), 25)
End Function

Function FixEmailUserName(sInput)
	FixEmailUserName = Left(AlphaNumericOnly(sInput), 40)
End Function

Function FixChatUserName(sInput)
	FixChatUserName = Left(AlphaNumericOnly(sInput), 30)
End Function

Function AlphabetOnly(sInput)
	sValidChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	AlphabetOnly = FilterString_ValidCharsOnly(sInput, sValidChars)
End Function

Function AlphaNumericOnly(sInput)
	sValidChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	AlphaNumericOnly = FilterString_ValidCharsOnly(sInput, sValidChars)
End Function

Function RemoveLineBreaks(sInput)
	Dim sOutput
	sOutput = Replace(GetStr(sInput), VBCrLf, " ")
	sOutput = Replace(sOutput, VBCr, " ")
	sOutput = Replace(sOutput, VBLf, " ")
	sOutput = Replace(sOutput, "  ", " ")
	'sOutput = NormalizeString(sOutput)
	RemoveLineBreaks = sOutput
End Function

Function NormalizeString(sInput)
	Dim sOutput
	sOutput = Replace(GetStr(sInput), "	", " ")
	While InStr(sOutput, "  ") > 0
		sOutput = Replace(GetStr(sOutput), "  ", " ")
	Wend
	sOutput = TrimChars(sOutput, VBCrLf & " 	")
	NormalizeString = sOutput
End Function





'//| Escaping & Stripping
'//|--------------------------------
Function EscapeJS(sInput)
	If IsNull(sInput) Then
		EscapeJS = ""
	Else
		EscapeJS = Replace(sInput, "'", "\'")
'		EscapeJS = Replace(EscapeJS, """", "\""")
		EscapeJS = Replace(EscapeJS, VBCrLf, "\n")
	End If
End Function

Function EscapeSQL(sInput)
	If IsNull(sInput) Then
		EscapeSQL = ""
	Else
		EscapeSQL = Replace(sInput, "'", "''")
	End If
End Function

Function RemoveHTMLTags(sInput)
	Set RegularExpressionObject = New RegExp
	RegularExpressionObject.Pattern = "<[^>]+>"
	RegularExpressionObject.IgnoreCase = True
	RegularExpressionObject.Global = True
	RemoveHTMLTags = RegularExpressionObject.Replace(sInput, "")
	Set RegularExpressionObject = Nothing
End Function

Function FixHTML(sInput)
Dim sTemp
	sTemp = GetStr(sInput)
	sTemp = Replace( sTemp,  "&", "&#38;" )
	sTemp = Replace( sTemp,  "<", "&#60;" )
	sTemp = Replace( sTemp,  ">", "&#62;" )
	sTemp = Replace( sTemp, """", "&#34;" )
	sTemp = Replace( sTemp,  "'", "&#39;" )
	FixHTML = sTemp
End Function

Function EscapeHTML(sInput)
Dim sTemp
	sTemp = FixHTML(sInput)

	'//|---------------------------------------------
	'//| Add line breaks
	'//|---------------------------------------------
	sTemp = Replace(sTemp, VBNewLine, "<BR>")

	'//|---------------------------------------------
	'//| Backdoor so sneaky people can have html ;)
	'//|---------------------------------------------
	sTemp = Replace(sTemp, "{[", "<")
	sTemp = Replace(sTemp, "]}", ">")
	sTemp = Replace(sTemp, "*|", """")
	sTemp = Replace(sTemp, "*/", "'")
	EscapeHTML = sTemp
End Function

Function EscapeHTML_AllowSafeHTML(sInput)
Dim sTemp
	sTemp = Replace( GetStr(sInput), "<", "&lt;" )

	'//|---------------------------------------------
	'//| Add line breaks
	'//|---------------------------------------------
	sTemp = Replace(sTemp, VBNewLine, "<BR>")

	'//|---------------------------------------------
	'//| Unescape safe HTML tags
	'//|---------------------------------------------
	sSafeHTMLTags = "A|B|BIG|BLOCKQUOTE|BR|CODE|FONT|H1|H2|H3|H4|H5|H6|HR|I|IMG|LI|OL|P|PRE|S|SMALL|STRIKE|STRONG|SUB|SUP|U|UL"
	arrSafeHTMLTags = Split(sSafeHTMLTags, "|")
	For nTag = 0 To UBound(arrSafeHTMLTags)
		sTemp = Replace(sTemp, "&lt;" & arrSafeHTMLTags(nTag), "<" & arrSafeHTMLTags(nTag), 1, -1, 1)
		sTemp = Replace(sTemp, "&lt;/" & arrSafeHTMLTags(nTag), "</" & arrSafeHTMLTags(nTag), 1, -1, 1)
	Next

	'//|---------------------------------------------
	'//| Escape unsafe attributes
	'//|---------------------------------------------
	sUnSafeHTMLAttributes = "onabort|onblur|onchange|onclick|ondblclick|onerror|onfocus|onkeydown|onkeypress|onkeyup|onload|onmousedown|onmousemove|onmouseout|onmouseover|onmouseup|onreset|onresize|onselect|onsubmit|onunload"
	arrUnSafeHTMLAttributes = Split(sUnSafeHTMLAttributes, "|")
	For nAttribute = 0 To UBound(arrUnSafeHTMLAttributes)
		sTemp = Replace(sTemp, arrUnSafeHTMLAttributes(nAttribute), "nojs", 1, -1, 1)
	Next

	sTemp = Replace(sTemp, "javascript:", "nojs:", 1, -1, 1)
	sTemp = Replace(sTemp, "<A ", "<A rel=""nofollow"" TARGET=""_blank"" ", 1, -1, 1)

	'//|---------------------------------------------
	'//| Backdoor so sneaky people can have html ;)
	'//|---------------------------------------------
	sTemp = Replace(sTemp, "{[", "<")
	EscapeHTML_AllowSafeHTML = sTemp
End Function

Function StripHTML(sInput)
Dim sTemp
	sTemp = Replace( GetStr(sInput), "<", "<!" )
	StripHTML = sTemp
End Function

Function StripURLs(sInput)
	If IsNull(sInput) Then Exit Function
	StripURLs = Trim(sInput)
'	While InStr(LCase(sInput), "http://") > 0 Or InStr(LCase(sInput), "https://") > 0
'		nStartPos = InStr(LCase(sInput), "http://")
'
'		For nCheckPos = nStartPos To nStartPos + 500
'			If Not InStr(sValidChars, Mid(sPage,nCheckPos,1)) > 0 Then
'				nEndPos = nCheckPos
'				Exit For
'			End If
'		Next
'	Wend

'	sValidChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$-_.+!*(),;/?:@=&#"
'	arrStarts = Array("http://","https://")
'
'	For nPos = 1 To Len(sInput)
'		For nStart = 0 To UBound(arrStarts)
'			If LCase(Mid(sInput, nPos, Len(arrStarts(nStart)))) = LCase(arrStarts(nStart)) Then
'				'//|-------------------------------------------------
'				'//| Get start and end of URL
'				'//|-------------------------------------------------
'				nStartPos = nPos
'				For nCheckPos = nStartPos To nStartPos + 500
'					If Not InStr(sValidChars, Mid(sInput,nCheckPos,1)) > 0 Then
'						nEndPos = nCheckPos
'						Exit For
'					End If
'				Next
'
'				'//|-------------------------------------------------
'				'//| Remove the URL
'				'//|-------------------------------------------------
'				sFoundURL = Left(Mid(sInput, nStartPos, nEndPos - nStartPos),500)
'
'			End If
'		Next
'	Next
End Function

Function TrimChars(sInput, sCharactersToTrim)
	TrimChars = TrimCharsRight(TrimCharsLeft(sInput, sCharactersToTrim), sCharactersToTrim)
End Function

Function TrimCharsLeft(sInput, sCharactersToTrim)
	Dim sTemp
	sTemp = GetStr(sInput)
	While InStr(sCharactersToTrim, Left(sTemp, 1)) > 0
		sTemp = Mid(sTemp, 2)
	Wend
	TrimCharsLeft = sTemp
End Function

Function TrimCharsRight(sInput, sCharactersToTrim)
	Dim sTemp
	sTemp = GetStr(sInput)
	While InStr(sCharactersToTrim, Right(sTemp, 1)) > 0 And Len(sTemp) > 0
		sTemp = Left(sTemp, Len(sTemp) - 1)
	Wend
	TrimCharsRight = sTemp
End Function

Function TrimString(sInput, sStringToTrim)
	TrimString = TrimStringRight(TrimStringLeft(sInput, sStringToTrim), sStringToTrim)
End Function

Function TrimStringLeft(sInput, sStringToTrim)
	Dim sTemp
	sTemp = GetStr(sInput)
	While LCase(Left(sTemp, Len(sStringToTrim))) = LCase(sStringToTrim)
		sTemp = Mid(sTemp, Len(sStringToTrim)+1)
	Wend
	TrimStringLeft = sTemp
End Function

Function TrimStringRight(sInput, sStringToTrim)
	Dim sTemp
	sTemp = GetStr(sInput)
	While LCase(Right(sTemp, Len(sStringToTrim))) = LCase(sStringToTrim)
		sTemp = Left(sTemp, Len(sTemp) - Len(sStringToTrim))
	Wend
	TrimStringRight = sTemp
End Function

'//| Hex converters
'//|--------------------------------
Function HexToDec(strHex)
  dim lngResult
  dim intIndex
  dim strDigit
  dim intDigit
  dim intValue

  lngResult = 0
  for intIndex = len(strHex) to 1 step -1
    strDigit = mid(strHex, intIndex, 1)
    intDigit = instr("0123456789ABCDEF", ucase(strDigit))-1
    if intDigit >= 0 then
      intValue = intDigit * (16 ^ (len(strHex)-intIndex))
      lngResult = lngResult + intValue
    else
      lngResult = 0
      intIndex = 0 ' stop the loop
    end if
  next

  HexToDec = lngResult
End Function

Function IPToHex(sIP)
Dim arrIP
	arrIP = Split(sIP,".")
	If UBound(arrIP) = 3 Then
		sPart1 = String(2-Len(Hex(arrIP(0))),"0") & Hex(arrIP(0))
		sPart2 = String(2-Len(Hex(arrIP(1))),"0") & Hex(arrIP(1))
		sPart3 = String(2-Len(Hex(arrIP(2))),"0") & Hex(arrIP(2))
		sPart4 = String(2-Len(Hex(arrIP(3))),"0") & Hex(arrIP(3))
		IPToHex = sPart1 & sPart2 & sPart3 & sPart4
	Else
		IPToHex = ""
	End If
End Function

Function GetIPFromHex(sHexIP)
	'On Error Resume Next
	GetIPFromHex = CLng("&H" & Mid(sHexIP, 1, 2)) & "." & _
				CLng("&H" & Mid(sHexIP, 3, 2)) & "." & _
				CLng("&H" & Mid(sHexIP, 5, 2)) & "." & _
				CLng("&H" & Mid(sHexIP, 7, 2))
	'On Error Goto 0
End Function

Function HexIP
	HexIP = IPToHex(Request.ServerVariables("REMOTE_ADDR"))
End Function

Function Capitalize(sInput)
	If IsNull(sInput) Then
		Capitalize = ""
		Exit Function
	End If
	sInput = Trim(sInput)

	Capitalize = UCase(Left(sInput,1)) & LCase(Mid(sInput,2))
End Function

Function TitleCase(sInput)
	Dim sOutput
	sInput = GetStr(sInput)
	While InStr(sInput,"  ") > 0
		sInput = Replace(sInput, "  ", " ")
	Wend
	arrWords = Split(sInput, " ")
	sOutput = ""
	For nWord = 0 To UBound(arrWords)
		sOutput = sOutput & Capitalize(arrWords(nWord)) & " "
	Next
	TitleCase = Trim(sOutput)
End Function

Function FixCapsAbuse(sInput)
	If IsNull(sInput) Then
		FixCapsAbuse = ""
		Exit Function
	End If

	FixCapsAbuse = ""
	sInput = Trim(sInput)

	ArrWords = Split(sInput, " ")

	For nWord = 0 To UBound(ArrWords)
		sWord = ArrWords(nWord)
		nCapsLetters = 0
		nLowerCaseLetters = 0
		nNonLetterChars = 0
		For nLetter = 1 To Len(sWord)
			sChar = Mid(sWord, nLetter, 1)
			nChar = Asc(sChar)

			If (nChar >= 65 And nChar <= 90) Then
				nCapsLetters = nCapsLetters + 1
			ElseIf (nChar >= 97 And nChar <= 122) Then
				nLowerCaseLetters = nLowerCaseLetters + 1
			Else
				nNonLetterChars = nNonLetterChars + 1
			End If
		Next
		If ((nCapsLetters/Len(sWord)) > .8 And Len(sWord) > 3) Or _
			(nCapsLetters = 0) Then
			sWord = Capitalize(sWord)
		End If
		FixCapsAbuse = FixCapsAbuse & " " & sWord
	Next
	FixCapsAbuse = Trim(FixCapsAbuse)
End Function

'//| String Encryption & Decryption
'//|--------------------------------
Function Scramble(sOrig)	'//| ghetto encryption
	sOrig = GetStr(sOrig)
	Scramble = ""
	For nChar = 1 To Len(sOrig)
		nAsc = Asc(Mid(sOrig, nChar, 1)) + 128
		If nAsc > 255 Then nAsc = nAsc - 256
		Scramble = Scramble & Chr(nAsc)
	Next
End Function

Function EncryptStringWithKey(it, key)
	Dim keylen, size, encryptstr, keymod, i
	keylen = Len(key)
	size = Len(it)
	encryptstr = ""
	On Error Resume Next
	For i = 1 To size Step 1
		keymod = (i Mod keylen) + 1
		encryptstr = encryptstr & Chr(Asc(Mid(it, i, 1)) + Asc(Mid(key, keymod, 1)))
	Next
	EncryptStringWithKey = encryptstr
End Function

Function DecryptStringWithKey(it, key)
	Dim keylen, size, decryptstr, keymod, i
	keylen = Len(key)
	size = Len(it)
	decryptstr = ""
    On Error Resume Next
	For i = 1 To size step 1
		keymod = (i MOD keylen) + 1
		decryptstr = decryptstr & Chr(Asc(Mid(it, i, 1)) - Asc(Mid(key, keymod, 1)))
	Next
	DecryptStringWithKey = decryptstr
End Function



'//| URL Processing
'//|--------------------------------
Function FixInputURL(sInput)
	FixInputURL = Trim(sInput)
	If InStr(FixInputURL, ":") < 1 Then FixInputURL = "http://" & FixInputURL
End Function

Function ExtractDomainFromURL(sURL)
	ExtractDomainFromURL = ""
	If Len(sURL) < 6 Then Exit Function

	nEndOfDomain = InStr(9, sURL, "/") - 1
	If nEndOfDomain < 1 Then nEndOfDomain = Len(sURL)

	nLastPeriod = InStrRev(sURL, ".", nEndOfDomain)
	n2ndToLastPeriod = InStrRev(sURL, ".", nLastPeriod - 1)

	'//| fix for .com.au type domains
	If nLastPeriod - n2ndToLastPeriod < 5 And nLastPeriod - n2ndToLastPeriod > 0 Then n2ndToLastPeriod = InStrRev(sURL, ".", n2ndToLastPeriod - 1)

	nStartOfDomain = InStrRev(sURL, "/", 9) + 1
	If n2ndToLastPeriod > nStartOfDomain Then nStartOfDomain = n2ndToLastPeriod + 1

	If nEndOfDomain > nStartOfDomain Then
		ExtractDomainFromURL = Mid(sURL, nStartOfDomain, nEndOfDomain - nStartOfDomain + 1)
	End If
End Function

Function ExtractURLFromURL(sURL)
	ExtractURLFromURL = ""
	If Len(sURL) < 6 Then Exit Function

	nStartOfPath = InStr(9, sURL, "/")

	If nStartOfPath > 0 Then
		ExtractURLFromURL = Mid(sURL, nStartOfPath)
	End If
End Function

Function RemoveEndingDirsFromURL(sPath, nDirs)
	If Right(sPath, 1) = "/" Then sPath = Left(sPath, Len(sPath)-1)

	For nDir = 1 To nDirs
		nLastSlash = InStrRev(sFullPath, "/")
		If nLastSlash > 9 Then
			sPath = Left(sPath, nLastSlash-1)
		End If
	Next

	RemoveEndingDirsFromURL = sPath
End Function

'//| HTML Processing
'//|--------------------------------
Function AddHTMLLineBreaks(sInput)
	If Not IsNull(sInput) Then AddHTMLLineBreaks = Replace(sInput,vbCrLf,"<BR>")
End Function

Function URLsToLinks(sInput)
	Dim sValidChars, arrStarts, sOutput, bFoundURL, sFoundURL, nPos, nStartPos, nEndPos
	sInput = GetStr(sInput)
	nMaxURLLength = 500
	sValidChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$-_.+!*(),;/?:@=&#"
	arrStarts = Array("http://","https://")
	sOutput = ""

	For nPos = 1 To Len(sInput)
		bFoundURL = False
		For nStart = 0 To UBound(arrStarts)
			If LCase(Mid(sInput, nPos, Len(arrStarts(nStart)))) = LCase(arrStarts(nStart)) Then
				bFoundURL = True
				'//|-------------------------------------------------
				'//| Get start and end of URL
				'//|-------------------------------------------------
				nStartPos = nPos
				For nEndPos = nStartPos To Len(sInput)
					If Not InStr(sValidChars, Mid(sInput,nEndPos,1)) > 0 Then
						Exit For
					End If
				Next

				'//|-------------------------------------------------
				'//| Add URL to output
				'//|-------------------------------------------------
				debug "nStartPos = " & nStartPos
				debug "nEndPos = " & nEndPos
				If nEndPos > nStartPos Then
					sFoundURL = Mid(sInput, nStartPos, nEndPos - nStartPos)
					If Len(sFoundURL) > nMaxURLLength Then
						bFoundURL = False
					Else
						sOutput = sOutput & "<A HREF=""" & sFoundURL & """>" & LimitLengthMid(sFoundURL, 50) & "</A>"
						nPos = nEndPos
					End If
				End If
			End If
			on error goto 0
		Next
		If Not bFoundURL Then sOutput = sOutput & Mid(sInput, nPos, 1)
	Next
	URLsToLinks = sOutput
End Function

Function ExtractTitleFromHTML(sPage)
	Dim sTemp, nTitleStart
	sTemp = GetStr(sPage)

	nTitleStart = InStr(1, LCase(sTemp), "<title>", 1) + 7
	If nTitleStart < 1 Then Exit Function

	nTitleEnd = InStr(nTitleStart, LCase(sTemp), "</title>", 1)
	If nTitleEnd <= nTitleStart Then Exit Function

	sTemp = Mid(sTemp, nTitleStart, nTitleEnd - nTitleStart)

	ExtractTitleFromHTML = sTemp
End Function

Function DigestHTMLString(sInput)
	Dim sTemp
	sTemp = GetStr(sInput)

	sTemp = MakeHTMLOneLine(sTemp)
	sTemp = DecodeHTMLNumericEntities(sTemp)
	sTemp = FixEmailObfuscation(sTemp)

	DigestHTMLString = sTemp
End Function

Function MakeHTMLOneLine(sInput)
	Dim sTemp
	sTemp = GetStr(sInput)

	sTemp = Replace(sTemp, Chr(10), " ")
	sTemp = Replace(sTemp, Chr(13), " ")
	sTemp = Replace(sTemp, "	", " ")
	While InStr(sTemp, "  ") > 0
		sTemp = Replace(sTemp, "  ", " ")
	Wend

	MakeHTMLOneLine = sTemp
End Function

Function DecodeHTMLNumericEntities(sInput)
	'//|-------------------------------------
	'//| Convert Numeric Entities to text
	'//|-------------------------------------
	Dim sTemp, sValidChars
	sValidChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,-_+/?:;#@=&()*$!"
	sTemp = GetStr(sInput)

	'// Convert "&#187;"  to  "�"
	For nChar = 1 To Len(sValidChars)
		sChar = Mid(sValidChars, nChar, 1)
		sTemp = Replace(sTemp, "&#" & Asc(sChar) & ";", sChar)
	Next

	'// Convert "&#187"  to  "�"	(for refs with missing ";" character)
	For nChar = 1 To Len(sValidChars)
		sChar = Mid(sValidChars, nChar, 1)
		sTemp = Replace(sTemp, "&#" & Asc(sChar), sChar)
	Next

	DecodeHTMLNumericEntities = sTemp
End Function


'//| Email Address Processing
'//|--------------------------------
Function CleanEmailAddress(sInput)
	Dim sTemp
	sTemp = GetStr(sInput)
	sTemp = Replace(sTemp, "mailto:", "")
	sTemp = TrimStringLeft(sTemp, "20")
	sTemp = TrimStringLeft(sTemp, "22")
	sTemp = TrimChars(sTemp, ".-:")
End Function

Function EmailIsValid(sEmail)
	Dim ValidEmail, emailParts, iLoopCounter, emailChar, acceptableChars, last2Chars
	ValidEmail = True
	acceptableChars="abcdefghijklmnopqrstuvwxyz.-_@"
	emailParts = Split(sEmail, "@")
	If UBound(emailParts) <> 1 Then
		ValidEmail = false
	Else
		If Len(emailParts(0))<1 OR Len(emailParts(1))<4 Then ValidEmail = false
		If Left(emailParts(0), 1)="." Then ValidEmail = false
		If InStr(emailParts(1), ".") <= 0 Then ValidEmail = false
		last2Chars=Right(emailParts(1),2)
		If InStr(last2chars,".") Then ValidEmail = false
		If InStr(emailParts(1), "_") >0 Then ValidEmail = false
	End If

	For iLoopCounter = 1 to Len(sEmail)
		emailChar = Lcase(Mid(sEmail, iLoopCounter, 1))
		If InStr(acceptableChars, emailChar) = 0 and Not IsNumeric(emailChar) Then ValidEmail = false
	Next
	If InStr(sEmail, "..") > 0 Then ValidEmail=false
	If InStr(sEmail, "@.") > 0 Then ValidEmail=false
	EmailIsValid=ValidEmail
End function

Function EmailIsValidOLD(sEmail)
	sEmail = Trim(sEmail)
	EmailIsValid = Not CBool( _
						Len(sEmail) < 7 _
						Or Instr(sEmail,"@") < 2 _
						)
	'//|--------------------------------------------
	'//| Test characters if prev tests succeeded
	'//|--------------------------------------------
	If EmailIsValid Then
		sAcceptedChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@-_+"
		For nChar = 1 To Len(sEmail)
			If Not InStr(sAcceptedChars, Mid(sEmail,nChar,1)) > 0 Then EmailIsValid = False
		Next
	End If
	'//|--------------------------------------------
	'//| Test individual components
	'//|--------------------------------------------
	If EmailIsValid Then
		sUser = Left(sEmail, InStr(sEmail, "@")-1)
		sDomain = Mid(sEmail, InStr(sEmail, "@")+1)
		If Len(sDomain) < 6 Or InStr(sDomain, ".") < 2 Then EmailIsValid = False
	End If
End Function

Function FindEmailsInString(sInput)	'//| Returns array of email addresses found in string
	Dim sTemp, nPos, sValidChars, sEmailsFound
	sValidChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-_+"

	sTemp = DigestHTMLString(sInput)

	sEmailsFound = " "
	For nPos = 1 To Len(sTemp)
		If LCase(Mid(sTemp, nPos, 1)) = "@" Then
			nEmailStart = 0
			nEmailEnd = 0

			Debug "@ Found at position " & nPos

			For nCheckPos = nPos - 1 To nPos - 100 Step -1
				If Not InStr(sValidChars, Mid(sTemp,nCheckPos,1)) > 0 Then
					Debug "Start char: " & Mid(sTemp,nCheckPos,1)
					nEmailStart = nCheckPos + 1
					Exit For
				End If
			Next
			If nEmailStart = 0 Then nEmailStart = nPos - 100
			Debug "Email Start Found at position " & nEmailStart

			For nCheckPos = nPos + 1 To nPos + 100
				If Not InStr(sValidChars, Mid(sTemp,nCheckPos,1)) > 0 Then
					nEmailEnd = nCheckPos
					Exit For
				End If
			Next
			If nEmailEnd = 0 Then nEmailEnd = nPos + 100
			Debug "Email end Found at position " & nEmailEnd

			sFoundEmail = CleanEmailAddress(Left(Mid(sTemp, nEmailStart, nEmailEnd - nEmailStart),500))

			If EmailIsValid(sFoundEmail) Then
				'//|-------------------------------------------------
				'//| Add to delimited string of found Emails
				'//|-------------------------------------------------
				If Not InStr(LCase(sEmailsFound), " " & LCase(sFoundEmail) & " ") > 0 And Len(sFoundEmail) > 0 Then
					sEmailsFound = sEmailsFound & sFoundEmail & " "
				End If
			ElseIf sFoundEmail <> "@import" And sFoundEmail <> "@" Then
				Debug "Invalid Email Suspect Found: |" & sFoundEmail & "|"
			End If
		End If
	Next
	sEmailsFound = Trim(sEmailsFound)
	FindEmailsInString = Split(sEmailsFound, " ")
End Function

Function Test
	Test = "[test output]"
End Function

Function FixEmailObfuscation(sInput)
	Dim sTemp
	sTemp = GetStr(sInput)

	sTemp = Replace(sTemp, " (at) ", "@")
	sTemp = Replace(sTemp, " [at] ", "@")
	sTemp = Replace(sTemp, " [dot] ", ".")
	sTemp = Replace(sTemp, "_at_", "@")
	sTemp = Replace(sTemp, "(at)", "@")
	sTemp = Replace(sTemp, "[at]", "@")
	sTemp = Replace(sTemp, "[dot]", ".")

	FixEmailObfuscation = sTemp
End Function

Function ExtractDomainFromEmail(sEmail)
	If Not EmailIsValid(sEmail) Then Exit Function
	ExtractDomainFromEmail = Mid(sEmail, InStr(sEmail,"@") + 1)
End Function


'//|---------------------------------------------------------------------------
'//| Array/Dictionary/Collection Functions
'//|---------------------------------------------------------------------------
Function SortDictionary(objDict,intSort)	'//| intSort: 1=Sort by Key, 2=Sort by Item
  ' declare our variables
  Dim strDict()
  Dim objKey
  Dim strKey,strItem
  Dim X,Y,Z

  ' get the dictionary count
  Z = objDict.Count

  ' we need more than one item to warrant sorting
  If Z > 1 Then
    ' create an array to store dictionary information
    ReDim strDict(Z,2)
    X = 0
    ' populate the string array
    For Each objKey In objDict
        strDict(X,dictKey)  = CStr(objKey)
        strDict(X,dictItem) = CStr(objDict(objKey))
        X = X + 1
    Next

    ' perform a a shell sort of the string array
    For X = 0 to (Z - 2)
      For Y = X to (Z - 1)
        If StrComp(strDict(X,intSort),strDict(Y,intSort),vbTextCompare) > 0 Then
            strKey  = strDict(X,dictKey)
            strItem = strDict(X,dictItem)
            strDict(X,dictKey)  = strDict(Y,dictKey)
            strDict(X,dictItem) = strDict(Y,dictItem)
            strDict(Y,dictKey)  = strKey
            strDict(Y,dictItem) = strItem
        End If
      Next
    Next

    ' erase the contents of the dictionary object
    objDict.RemoveAll

    ' repopulate the dictionary with the sorted information
    For X = 0 to (Z - 1)
      objDict.Add strDict(X,dictKey), strDict(X,dictItem)
    Next

  End If

End Function

%>
