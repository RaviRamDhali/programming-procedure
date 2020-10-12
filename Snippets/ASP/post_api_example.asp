<!-- #include virtual=/intranet/includes/global.asp -->
<!-- #include virtual=/includes/classes/jsonObject.class.asp-->

<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>

<body>

<%

Dim id
Dim site_id
Dim photo_file_name
Dim photo_title
Dim photo_title_clr
Dim photo_caption
Dim photo_caption_clr
Dim link_url
Dim display_order
Dim external_id

Dim fileExist
Dim onCloudinary

Dim ImageName
Dim path

Dim fileStream
Dim fsoReader
Dim forReading
forReading = 1


Dim strStatus
Dim strResponse



SQL = "Select * from photo_gallery where id > 260"
set RS = conn.execute(SQL)
%>

<div class="container">




<table class="table table-sm">
    <thead>
    <tr>
        <th>fileExist</th>
        <th>onCloudinary</th>
        <th>id</th>
        <th>site_id</th>
        <th>photo_file_name</th>
        <th>external_id</th>
        <!-- <th>path</th> -->
    </tr>
    </thead>
    <tbody>


<%
if not RS.EOF then
    while not RS.EOF

    id = RS("id")
    site_id = RS("site_id")
    photo_file_name = RS("photo_file_name")
    photo_title = RS("photo_title")
    photo_title_clr = RS("photo_title_clr")
    photo_caption = RS("photo_caption")
    photo_caption_clr = RS("photo_caption_clr")
    link_url = RS("link_url")
    display_order = RS("display_order")
    external_id = RS("external_id")

    path = SITE_IMG_PATH & "gallery_thumb/" & photo_file_name

    onCloudinary = GetCloudinaryStatus(external_id)



        Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

        If objFSO.FileExists(Server.MapPath(path)) Then
            fileExist = True

            UploadFile Server.MapPath(path), strStatus,strResponse

            Dim publicId
            publicId = GetPublicId(strResponse)

            'Update photo_gallery with cloudinary path
            Dim updateSQL
            updateSQL = "Update photo_gallery set external_id = '" & publicId & "' where id = " & id
            conn.execute(updateSQL)

            Dim updateSQLtemp
            updateSQLtemp = "Update photo_gallery set link_url = '" & publicId & "' where id = " & id
            conn.execute(updateSQLtemp)


            ' Set fsoReader = objFSO.OpenTextFile(Server.MapPath(path), forReading)
            ' fileStream = fsoReader.ReadAll
            ' fsoReader.Close
        Else
            fileExist = False
        End If



%>

<tr>
    <td><%=fileExist%></td>
    <td><%=onCloudinary%></td>
    <td><%=id%></td>
    <td><%=site_id%></td>
    <td><%=photo_file_name%></td>
    <td><%=external_id%></td>
    <!-- <td><%=path%></td> -->
</tr>


<%

    RS.MoveNext
    wend

end if
set RS = Nothing

conn.Close
Set conn = Nothing

%>
</tbody>
</table>


</div> <!-- container -->

</body>
</html>

<%

Function GetCloudinaryStatus(external_id)

    Dim result
    result = False

    result = not(external_id = "" OR isNull(external_id))

    'Check if external_id url has any ext
    if(result) then
        result = InStr(external_id,".") > 1
    end if

    GetCloudinaryStatus = result

End Function


Sub UploadFile(strPath, strStatus, strResponse)

        Response.Write("strPath")

        Dim strFile, strExt, strContentType, strBoundary, bytData, bytPayLoad

        'On Error Resume Next

        Set objFSO = Server.CreateObject("Scripting.FileSystemObject")


        If objFSO.FileExists(strPath) Then
            fileExist = True
            strFile = objFSO.GetFileName(strPath)
            strExt = objFSO.GetExtensionName(strPath)


            Dim objStream
            Set objStream = CreateObject("ADODB.Stream")
            objStream.Type = 1
            objStream.Mode = 3
            objStream.Open
            objStream.LoadFromFile strPath

            If Err.Number <> 0 Then
                strStatus = Err.Description & " (" & Err.Number & ")"
                Exit Sub
            End If

            bytData = objStream.Read

            strBoundary = String(6, "-") & Replace(Mid(CreateObject("Scriptlet.TypeLib").Guid, 2, 36), "-", "")

            Dim objStreamForm
            Set objStreamForm = CreateObject("ADODB.Stream")
            objStreamForm.Mode = 3
            objStreamForm.Charset = "Windows-1252"
            objStreamForm.Open
            objStreamForm.Type = 2

            objStreamForm.WriteText = FormParameterToString(strBoundary)

            objStreamForm.WriteText "--" & strBoundary & vbCrLf
            objStreamForm.WriteText "Content-Disposition: form-data; name=""upload_file""; filename=""" & strFile & """" & vbCrLf
            objStreamForm.WriteText "Content-Type: """ & strContentType & """" & vbCrLf & vbCrLf
            objStreamForm.Position = 0
            objStreamForm.Type = 1
            objStreamForm.Position = objStreamForm.Size
            objStreamForm.Write bytData
            objStreamForm.Position = 0
            objStreamForm.Type = 2
            objStreamForm.Position = objStreamForm.Size
            objStreamForm.WriteText vbCrLf & "--" & strBoundary & "--"
            objStreamForm.Position = 0
            objStreamForm.Type = 1
            bytPayLoad = objStreamForm.Read

            Dim objHTTP
            Set objHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP")
            objHTTP.SetTimeouts 0, 60000, 300000, 300000
            objHTTP.SetOption 2, objHTTP.GetOption(2)
            objHTTP.Open "POST", "https://localhost:44307/gallery/upload", False
            objHTTP.SetRequestHeader "Content-type", "multipart/form-data; boundary=" & strBoundary
            objHTTP.Send bytPayLoad

            If Err.Number <> 0 Then
                strStatus = Err.Description & " (" & Err.Number & ")"
            Else
                strStatus = objHTTP.StatusText & " (" & objHTTP.Status & ")"
            End If
            If objHTTP.Status = "200" Then strResponse = objHTTP.ResponseText

            objStream.Close
            objStreamForm.Close

            Set objFSO = nothing
            Set objStream = nothing
            Set objStreamForm = nothing
            Set objHTTP = nothing

            Exit Sub

            Else
                strStatus = "File not found"
                Exit Sub
            End If

End Sub
%>


<%
    Function FormParameterToString(strBoundary)

        Dim params
        set params = SetFormParameter()


        Dim i, pkeys, result
        pkeys = params.Keys
        result = ""

        For i = 0 To params.Count - 1
            If i > 0 Then
                result = result & vbCrLf & vbCrLf
            End If
            result = result & FormCollectionBuilder(strBoundary, pkeys(i), params.Item(pkeys(i)))
        Next

        Set params = nothing

        FormParameterToString = result

    End Function
%>

<%
    Function SetFormParameter()
        Dim params
        Set params = CreateObject("Scripting.Dictionary")
        params.Add "tags", "20,Site,691"
        params.Add "caption", "undefined"
        params.Add "clientId", "20"
        params.Add "galleryType", "Site"
        params.Add "gallery_id", "691"
        params.Add "task", "transform"
        set SetFormParameter = params
    End Function
%>


<%
    Function FormCollectionBuilder(strBoundary, key, value)
        Dim result
        result = ""
        result = result & "--" & strBoundary & vbCrLf
        result = result & "Content-Disposition: form-data; name=""" & key & """" & vbCrLf & vbCrLf
        result = result & value & vbCrLf
        FormCollectionBuilder = result
    End Function
%>

<%
    Function GetPublicId(strResponse)
        Dim result, format

        Dim jsonObj, outputObj
        set jsonObj = new JSONobject
        set outputObj = jsonObj.parse(strResponse)

        ' Nested json obj
        Dim arrResult
        Set arrResult = outputObj("result")
        result = arrResult("publicId")
        format = arrResult("format")

        GetPublicId = result & "." & format

    End Function
%>
