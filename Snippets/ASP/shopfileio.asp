<%
const pfieldnames=1
const pfieldvalues=2
const pfieldtypes=3
const pfieldcount=4
const ptableflag=5
const ptemplatedisplay=6
const ptemplaterray=7
const ptokenformat=8
const pidfield=9
const pidvalue=10
const ptokens=11
const pdatacurrentrecord=12
const pdata=13
const pdatarecordcount=14
const pdatainmemory=15
const pparseattributes=16

'***********************************************************************
' VP-ASP 5.50   Merge templates with database
' June 11, 2003  Fix readentirefile  for emaillist, formatsaving, include
'                oitemstemplate HTML 
' Oct 6, 2003 add dualcustomerprice and  dualsaving
' Dec 27, 2003 add formatimage
' Jan 24, 2004 Inventory products
' March 26, 2004  Quantity discounts, inventory products 
' July 2 2004  minor changes
' Sept 21, 2004 support for dual price field, out of stock message duplicate
'**********************************************************************
' Template handling Version 5.00
' "ADD_OITEMS"
' "ADD_PAGEHEADER"
' "ADD_PAGETRAILER"
' "SPECIAL_ORDERBUTTON"
' "SPECIAL_CHECKBOX"
' "ADD_FORMSTART"
' "ADD_FORMEND"
' "ADD_PRODUCTFEATURES"
' "ADD_QUANTITY"
' "ADD_ORDERBUTTON"
' "ADD_CHECKBOX"
' "ADD_TABLE"
' "ADD_TABLEEND"
' "ADD_PRODUCT"
' "ADD_CROSSSELLING"
' "file=filename INCLUDE"
' "field=fieldname INCLUDE
' "ADD_OITEMSTEMPLATE"
'  DISPLAY_QUANTITYDISCOUNTS 
'
' Does field substitution from database to a text template
' TemplateDisplay Yes = output to browser
' No put into array
'**********************************************************
'**************************************************************
' filename to be opened
' rc=4 if file cannot be found
' returns fsObj and RecordObj
'*************************************************************
Sub OpenInputFile (filename, fsObj, RecordObj, rc)
on error resume next
Dim whichfile, dbfile
dbfile=left(filename,3)
If lcase(dbfile)="db=" then
   OpenInputFiledb filename, fsObj, RecordObj, rc
   exit sub
end if   
whichfile=server.mappath(filename)
set fsObj = Server.CreateObject("Scripting.FileSystemObject")
set RecordObj= fsObj.OpenTextFile(whichfile, 1, False)
If err.number > 0 then
      rc=4
      fsObj.close
      set fsObj=nothing
else
      rc=0
'      debugwrite whichfile  & " opened ok<br>"
end if
End sub
'
' close a file
Sub CloseFile (fsObj, RecordObj, rc, parsearray)
If parsearray(pdatainmemory)="Yes" then exit sub
set RecordObj = nothing
set fsObj = nothing
rc=0
end sub
'
' reads and entire file template into a memory array
'
' creates and array of converted records
Sub ShopTemplateArray(Filename, RS, Outarray, Outcount)
dim parsearray, fieldnames, fieldvalues, fieldtypes, fieldcount
redim fieldnames(100)
redim fieldvalues(100)
redim fieldtypes(100)
redim parsearray(Pparseattributes)
Dim i
Dim NewRecord
Dim fs,ts
Dim rc
Dim Bypass
Dim tempcount
OpenInputFile Filename, fs, ts, rc
If rc> 0 then
     shopwriteError  getlang("LangReadFail")  & filename  
     exit sub
end if
GetFieldValues RS, fieldnames, fieldvalues, fieldtypes, fieldcount
dim Temparray
tempcount=ubound(outarray)
redim temparray(tempcount)
outcount=0
SetupParseArray Parsearray, filename, rs, fieldnames, fieldvalues, fieldtypes, fieldcount, fs, ts
ReadEntireFile fs, ts, Tempcount, TempArray, parsearray
CloseFile fs,ts, rc, parsearray
for i = 0 to tempcount - 1
    Substitute Temparray(i), NewRecord, Bypass, parsearray, rs 
    If Bypass=False  then 
       OutArray(outcount)=NewRecord
       outcount=outcount+1
     end if
next
end sub
'
Sub SetupParseArray (Parsearray, filename, rs, fieldnames, fieldvalues, fieldtypes, fieldcount, fsoobj,recordobj)
dim data, datacount, rc, dbfieldname
redim parsearray(Pparseattributes)
parsearray(pfieldnames)=fieldnames
parsearray(pfieldvalues)=fieldvalues
parsearray(pfieldtypes)=fieldtypes
parsearray(pfieldcount)=fieldcount
parsearray(ptableflag)=""
parsearray(ptemplatedisplay)="No"
parsearray(pidfield)=rs(0).name
parsearray(pidvalue)=rs(0).value
parsearray(pdatarecordcount)=0
parsearray(pdatainmemory)=""
CheckFiledb filename,dbfieldname,rc
If rc=0 then
   redim data(500)
   ReadEntireFileDB  fsoobj, RecordObj, datacount,data,parsearray
   parsearray(pdata)=data
   parsearray(pdatarecordcount)=datacount
   parsearray(pdatacurrentrecord)=0
   parsearray(pdatainmemory)="Yes"
end if
end sub
'****************************************************************
' writes each record to browser
'***************************************************************
Sub ShopTemplateWrite(Filename, RS, orc)
Dim i
Dim NewRecord
Dim recordObj, FsObj
dim rc
Dim MyText
dim readcount
Dim Bypass
OpenInputFile Filename, fsObj, RecordObj, rc
If rc> 0 then
     shopwriteError  getlang("LangReadFail")  & filename
      orc=4
     exit sub
end if
dim parsearray, fieldnames, fieldvalues, fieldtypes, fieldcount
redim fieldnames(150)
redim fieldvalues(150)
redim fieldtypes(150)
redim parsearray(Pparseattributes)
readcount=0
GetFieldValues RS, fieldnames, fieldvalues, fieldtypes, fieldcount
'For i = 0 to fieldcount
'   debugwrite fieldnames(i) & "=" & fieldvalues(i)
'next   
SetupParseArray Parsearray, filename, rs, fieldnames, fieldvalues, fieldtypes, fieldcount, fsobj, recordobj
Parsearray(pTemplateDisplay)="Yes"
ReadARecord RecordObj, MyText, rc, parsearray
Do while rc=0
  Substitute mytext, NewRecord, Bypass, parsearray, rs 
  If Bypass=False  then 
     Response.write NewRecord & vbcrlf
  end if
  'debugwrite "old=" & Mytext & " new=" & NewRecord
  readcount=readcount+1
  ReadARecord RecordObj, MyText, rc, parsearray
' Response.write Server.HTMLEncode(mytext) & "<br>"  
Loop
CloseFile fsObj,RecordObj, rc, parsearray
orc=0
end sub
'
Sub ReadEntireFile (fsoobj, RecordObj, readcount, readarray,parsearray)
'on error resume next
dim rc
dim mytext, data, i
If parsearray(pdatainmemory)="Yes" Then
  data=parsearray(Pdata)
  for i = 0 to parsearray(pdatarecordcount)-1
     readarray(i)=data(i)
  next
  readcount=parsearray(pdatarecordcount)   
  exit sub
end if  
rc=0
readcount=0
ReadARecord RecordObj, MyText, rc, parsearray
'Response.write Server.HTMLEncode(mytext) & "<br>"  
'Debugwrite myText
Do while rc=0
  readarray(readcount)=mytext
  readcount=readcount+1
  ReadARecord RecordObj, MyText, rc, parsearray
  'Response.write Server.HTMLEncode(mytext) & "<br>"  
Loop
end sub

'
Sub ReadARecord (RecordObj, record, rc,parsearray)
If parsearray(Pdatainmemory)="Yes" then
  ReadARecordDB RecordObj, record, rc,parsearray
  exit sub
end if  
if RecordObj.AtEndofStream then
   rc=4
   exit sub
end if 
record = RecordObj.readline
rc=0
End Sub

Function Find_Replace(srchString, FndString, InsertString,   strend ) 
  Dim i, LastChar, Next_Pos 
  Dim CurrentPos, LastPos
  Dim tempstring 
 
  If strend > 0 Then
    LastChar = strend
  Else
    LastChar = Len(srchString)
  End If
  tempstring = srchString
  Next_Pos = 0
  Next_Pos = InStr(Next_Pos + 1, tempstring, FndString)
  Do Until (Next_Pos = 0) Or (Next_Pos > LastChar)
    tempstring = Left(tempstring, Next_Pos - 1) & InsertString & Right(tempstring, (Len(tempstring) - Len(FndString) - (Next_Pos - 1)))
    LastChar = LastChar - Len(FndString) + Len(InsertString)
    Next_Pos = 0
    Next_Pos = InStr(Next_Pos + 1, tempstring, FndString)
  Loop
  Find_Replace = tempstring
End Function
'
Sub Substitute (inrecord, workrecord, Bypass, parsearray, parseRS)
' values can be any field in the products table
' or special keywords
' [field]
' [
dim tokenformat
dim tokens(5)
dim tokencount
Dim rc 
Dim morefields 
Dim dbindex 
Dim dbfieldname 
Dim dbvalue 
Dim dbvalue1
Dim token 
Dim Newrecord 
Dim fieldfound 
Dim pos 
Dim endpos 
Dim specchar 
Dim dbvalue2
Dim firstchar
Dim length

pos = 1
Bypass=False
'Response.write "converting " & Server.HTMLEncode(inrecord) & "<br>"  
workrecord = inrecord
morefields = True
fieldfound = False        ' used to determine if record is ouput if starts with a $
firstchar = Left(workrecord, 1) ' save first character
Do While morefields = True
   pos = InStr(pos, workrecord, "[")
   If pos > 0 Then
       endpos = InStr(pos, workrecord, "]")
       If endpos=0 then
           WriteError "Missing ] on field starting at " & Pos
           morefields=false 
       else  
        length = endpos - pos + 1
        tokenformat=""
        token = Mid(workrecord, pos, length)
        specchar = Mid(token, 2, 1)
        dbfieldname = Mid(token, 2, length - 2)
        parserecord dbfieldname, tokens, tokencount, " "
        if tokencount> 1 then
          dbfieldname=tokens(1)           
          tokenformat=ucase(tokens(0))      ' formatcurrency, formatnumber
          'debugwrite "tokenformat=" & tokenformat & " token=" & token 
        end if 
        Parsearray(ptokenformat)=tokenformat
        Parsearray(ptokens)=tokens
        FindField dbfieldname, dbvalue, rc, parsearray, parseRS
        If rc > 0 Then Exit Sub
        Newrecord = Find_Replace(workrecord, token, dbvalue, 0)
        If dbvalue <> "" Then
           fieldfound = True  ' used to determine if record written
        End If
        workrecord = Newrecord
       end if
    Else
       morefields = False
    End If
Loop
' at this point if record starts with a $ and no fields substituted, do not write it
If firstchar = "$" Then
    If fieldfound = False Then
       workrecord=""
       Bypass=True 
       Exit Sub
    Else
       length = Len(workrecord) - 1
       Newrecord = Mid(workrecord, 2, length)
       workrecord = Newrecord
       bypass=False
    End If
End If
Bypass=False
End Sub
Sub WriteError (msg)
shopwriteError  msg 
end sub
'
Sub FindField(fieldname, value, rc, parsearray, parsers)
Dim i
Dim temparea
Dim ucfieldname 
Dim Fieldtype
'On error resume next
ucfieldname = UCase(fieldname)
rc = 0
ProcessKeyword ucfieldname, value, rc, parsearray, parseRS
If rc = 0 Then Exit Sub
rc = 0
FindInDatabase ucfieldname, temparea, fieldtype ,rc, parsearray
If rc > 0 then
    WriteError  "Field " & fieldname & " " &  getlang("LangDatabaseFail") 
    value=""
    exit sub
end if
If temparea="" then
    value=""
    exit sub
end if
'   debugwrite fieldname & " type=" & fieldtype & " " & temparea 
   DoSpecialFormating temparea, Parsearray, parseRS
   value = temparea
End Sub
'
Sub FindInDatabase (fieldname, fieldvalue, fieldtype, rc, parsearray)
dim i
dim fieldcount, fieldvalues, fieldtypes, fieldnames
fieldcount=parsearray(pfieldcount)
fieldnames=parsearray(pfieldnames)
fieldvalues=parsearray(pfieldvalues)
fieldtypes=parsearray(pfieldtypes)
'Debugwrite "finding=" & fieldname & " fieldcount=" & fieldcount
for i=0 to fieldcount
     ' debugwrite "field=" & fieldnames(i) & " value=" & fieldvalues(i)
     if fieldname=Fieldnames(i) then
          fieldvalue=fieldvalues(i)
          fieldtype=fieldtypes(i)
	  if fieldname="cdescription" then fieldvalue=memdescription
          rc=0
          'debugwrite fieldname & " found =" & fieldvalue
          exit sub
     end if
next
rc=4
fieldvalue="" 
end sub
'
Sub ProcessKeyword (keyword, value, rc, parsearray,parseRS)
dim tokenformat
tokenformat=parsearray(ptokenformat)
rc=4
Select Case keyword
    Case "ADD_OITEMS"
        Handle_OITEMS value, parsearray,parseRS
        rc=0
    Case "ADD_PAGEHEADER"
        Handle_PAGEHEADER value, parsearray
        rc=0
    Case "ADD_PAGETRAILER"
        Handle_PageTrailer value, parsearray
        rc=0
    Case "SPECIAL_ORDERBUTTON"
        Handle_SpecialOrderButton value,parsearray,parseRS
        rc=0
    Case "SPECIAL_CHECKBOX"
        Handle_SpecialCheckbox value,parsearray
        rc=0
   Case "ADD_FORMSTART"
        Handle_FormStart "User",parsearray, "shopaddtocart.asp"
        rc=0
    Case "ADD_FORMEND"
        Handle_FormEnd "User",parsearray
        rc=0
    Case "ADD_PRODUCTFEATURES"
        Add_ProductFeatures "User",parsearray,"", parseRS
        rc=0
    Case "ADD_QUANTITY"
        Add_Quantity "User",parsearray
        rc=0
    Case "ADD_ORDERBUTTON"
        Add_Button "User",parsearray
        rc=0
    Case "ADD_CHECKBOX"
        Add_Checkbox "User",parsearray
        rc=0
    Case "ADD_TABLE"
        Add_Table "User",parsearray
        rc=0
     Case "ADD_TABLEEND"
        Add_TableEnd "User",parsearray
        rc=0
     Case "ADD_PRODUCT"
        Add_Product "User",parsearray
        rc=0
     Case "INCLUDE"
        Handle_Include value,parsearray
        rc=0
     Case "ADD_CROSSSELLING"
        Handle_CROSSSELLING value,parsearray, parseRS
        rc=0     
    Case "SUB"
       Handle_Product ucase(tokenformat)
     rc=0
     Case "ADD_OITEMSTEMPLATE"
        Handle_OITEMSTEMPLATE value, parsearray, parseRS
        rc=0
    Case "ADD_OITEMTOTAL"
       Handle_OitemTotal value, parsearray, parseRS
     rc=0
    Case "ADD_OITEMDELIVERY" 
       Handle_OitemDelivery value, parsearray, parseRS
     rc=0
     Case "ADD_RATINGSUMMARY" 
       Handle_RatingSummary value, parsearray, parseRS
     rc=0
     Case "ADD_INVENTORYPRODUCTS"
        Handle_INVENTORYPRODUCTS value,parsearray, parseRS
        rc=0   
      Case "INVOICE_OITEMS"
        Handle_INVOICEOITEMS value,parsearray, parseRS
        rc=0 
      Case "DISPLAY_QUANTITYDISCOUNTS"
        Handle_QUANTITYDISCOUNTS value,parsearray, parseRS
        rc=0 
     Case "ADD_WEBSESSLINK"
        Handle_ADDWEBSESSLINK value,parsearray, parseRS
        rc=0 
end select 
end sub

Sub DoSpecialFormating (value, parsearray, parseRS)
dim tokenformat
tokenformat=parsearray(ptokenformat)
If tokenformat="" then exit sub
dim strprice
dim inventorycheck
 Select Case tokenformat
	Case "FORMATCURRENCY"
              value = shopformatcurrency(value,getconfig("xdecimalpoint"))
        Case "DUALPRICE"
              GetDualPricevalue value, strPrice, parsearray  
              value = formatnumber(strprice,getconfig("xdecimalpoint"))
        Case "FORMATNUMBER"
              value = formatnumber(value,getconfig("xdecimalpoint"))
        Case "FORMATDATE"
               value = shopdateformat(value,getconfig("xdateformat"))
        Case "FORMATCUSTOMERPRICE"
               value = HandleCustomerPrice(value, parsearray, parseRS)
               value=shopformatcurrency(value,getconfig("xdecimalpoint"))  
        Case "URLENCODE"
               value = server.urlencode(value)   
        Case "FORMATSAVING"
             value = HandlePriceSaving(value, parsearray,parseRS)
             If value<>"" then
                value=shopformatcurrency(value,getconfig("xdecimalpoint"))  
             end if   
        Case "FORMATTIME"
             value = formatdatetime(value,vbshorttime)
	Case "DUALCUSTOMERPRICE"
		value = HandleCustomerPrice(value, parsearray, parseRS)
		ConvertCurrency value, strPrice
		value = formatnumber(strprice,getconfig("xdecimalpoint"))
	Case "DUALSAVING"
		value = HandlePriceSaving(value, parsearray,parseRS)
		If value<>"" then 
	           ConvertCurrency value, strPrice
		   value = formatnumber(strprice,getconfig("xdecimalpoint"))
		end if
	Case "FORMATIMAGE"
             value = Handleformatimage(value)
       	Case "FORMATOITEMTOTAL"
             value = Handleformatoitemtotal(value)
        case "FORMATCURRENCYCONVERSION"
              value=HandleFormatCurrencyConversion (value, parsearray,parseRS)      
	End Select
end sub
'
Sub Handle_OITEMS (body, parsearray,parseRS)
'*******************************************************
' Template format order items
' expects myconn to be open as open connection
'********************************************************
Dim Isql, deliveryaddress, deliveryarray
dim orderid
Dim rsitems
Dim Dbc, recordid
Dim CR, itemname
recordid=parsearray(pidvalue)
If ucase(Getsess("emailformat"))="HTML" then
  CR="<br>"
else
  CR = GetMailCR
end if
'OpenOrderdb dbc
isql="select * from oitems where orderid="
If Getsess("oid")<>"" then
    Orderid=GetSess("oid")
else
    Orderid=recordid
end if
Body=""
ISql=Isql & Orderid
'debugwrite isql
Set rsitems=myconn.execute(Isql)
Do While Not RSItems.EOF
     itemname=rsitems("itemname")
     if getconfig("xdeliveryaddress")="Yes" then
         deliveryaddress=rsitems("address") 
         If not isnull(Deliveryaddress)  and Deliveryaddress<>"" then
         ConvertDeliveryToArray DeliveryArray, Deliveryaddress
          GetDeliveryName Itemname, DeliveryArray
         end if
     end if
     If ucase(Getsess("emailformat"))<>"HTML" then
        Itemname=RemoveHtmlFileio(itemname, CR)
     end if   
     Body = Body & CR & Itemname & CR 
     Body = Body &  getlang("LangProductQuantity") & ": " & RSItems("numitems")  & CR
     If getconfig("xDisplayPrices")<>"No" then
         Body = Body &  getlang("LangProductPrice") & ": " & shopformatcurrency(RSItems("unitprice"),getconfig("xdecimalpoint")) & CR 
    end if
RSItems.MoveNext
Loop 
rsitems.close
Set rsitems=nothing
'Shopclosedatabase dbc
end sub
'
'
'
Sub ShopReadEntireFile(Filename, Outarray, Outcount, parsearray)
Dim i
Dim NewRecord
Dim fs,ts
Dim rc
outcount=0
OpenInputFile Filename, fs, ts, rc
If rc> 0 then
      exit sub
end if
ReadEntireFile fs, ts, Outcount, OutArray, parsearray
CloseFile fs,ts, rc, parsearray
rc=0
end sub

Sub Handle_PageHeader (value, parsearray)
dim templatedisplay
templatedisplay=parsearray(ptemplatedisplay)
Value=""
If TemplateDisplay="No" then exit sub
ShopPageHeader
end sub
Sub Handle_PageTrailer (value, parsearray)
dim templatedisplay
templatedisplay=parsearray(ptemplatedisplay)
Value=""
If TemplateDisplay="No" then exit sub
ShopPageTrailer
end sub

'************************************************************
' add button to allow people to order but do not put this out if using
' Inventory products
' When using inventory products do not put out order button
'************************************************************
Sub Handle_SpecialOrderButton (ivalue,parsearray,parseRS)
dim rc, inventorycheck
Checkinventoryproducts ivalue,parsearray,parseRS, inventorycheck
If inventorycheck=true then
'   Handle_Inventoryproducts ivalue, parsearray,parseRS
   exit sub
end if
'   
Handle_FormStart ivalue,parsearray,"shopaddtocart.asp"
Add_Table "", parsearray
prodindex=""
Add_ProductFeatures "",parsearray,"",parseRS
Add_Quantity "",parsearray
Add_Button "",parsearray
Add_Product "",parsearray
Add_TableEnd "",parsearray
Handle_FormEnd "",parsearray
end sub

Sub Add_Product (ivalue, parsearray)
Dim Id, fieldtype, rc
dim fieldname
fieldname="CATALOGID"
id=0
FindInDatabase fieldname, id, fieldtype ,rc, parsearray 
If rc > 0 then
    WriteError  "Field " & fieldname & " " &  getlang("LangDatabaseFail") 
end if
%>
<input type=hidden name=productid value="<%=ID%>">
<%
end sub
'
Sub Add_Table (ivalue, parsearray)
dim tableflag
WriteForm TemplateTable
TableFlag="True"
parsearray(ptableflag)=tableflag
end sub
'
Sub Add_TableEnd (ivalue, parsearray)
dim tableflag
WriteForm "</table>"
Tableflag=""
parsearray(ptableflag)=tableflag
End Sub
'
Sub Handle_SpecialCheckBox (ivalue, parsearray)
Handle_FormStart ivalue, "shopproductselect.asp"
Add_Table "",parsearray
Add_ProductFeatures "",parsearray, "0"
Add_Quantity "", parsearray
Add_CheckBox "",parsearray
Add_Button "",parsearray
Add_TableEnd "",parsearray
Add_ProductIndex "",parsearray
Handle_FormEnd "",parsearray
end sub

Sub Add_ProductIndex (ivalue, parsearray)
WriteForm "<input type=hidden name=prodindex value=1>"
end sub
'
Sub Add_CheckBox (ivalue, parsearray)
Dim Id, fieldname,fieldtype, rc
fieldname="CATALOGID"
FindInDatabase fieldname, Id, fieldtype ,rc,parsearray 
If rc > 0 then
    WriteError  "Field " & fieldname & " " &  getlang("LangDatabaseFail") 
end if
If TableFlag<>"" then
   Response.write TemplateCheckboxRow  & TemplateCheckboxColumn
end if
WriteForm "<input type=checkbox name='Processed0' value='" & ID & "'>"
if TableFlag<>"" then
  WriteForm TemplateCheckboxColumnEnd
  Response.write "</tr>"
end if
end sub'

Sub Add_Button (ivalue, parsearray)
dim mytext, mybutton, tableflag
tableflag=parsearray(ptableflag)
dim fieldvalue
dim rc
Dim Id, fieldname,fieldtype
WriteNoStockMessage rc, parsearray
if rc> 0 then 
   Response.write OutofStockColumn &  getlang("LangOutOfStock") & OutofStockColumnEnd
   exit sub
end if   
fieldname="CATALOGID"
FindInDatabase fieldname, Id, fieldtype ,rc,parsearray
If rc > 0 then
    WriteError  "Field " & fieldname & " " &  getlang("LangDatabaseFail") 
else
   ID=0
end if
mytext=getconfig("XButtonText")
if mytext="" then
   mytext="Order"
end if
mybutton=""
fieldname="BUTTONIMAGE"
fieldvalue=""
FindInDatabase fieldname, fieldvalue, fieldtype ,rc,parsearray
if fieldvalue<>"" then
     mybutton= fieldvalue
else
    if getconfig("xButtonImage") <>"" then
      mybutton=getconfig("xButtonImage")
    end if
end if
if tableflag<>"" then 
   Response.write TemplateButtonRow  & TemplateButtonColumn
end if
If myButton="" then
     WriteForm  "<input type=submit value="""  & mytext & """ name=Order>"
else
     WriteForm "<input border=0 src=" & mybutton & " type=image>"
end if
If tableflag<>"" then
   response.write "</td></tr>"
end if
end sub
'
Sub Add_Quantity (ivalue, parsearray)
dim strminimumquantity, rc, tableflag, fieldtype
WriteNoStockMessage rc, parsearray
if rc> 0 then exit sub
tableflag=parsearray(ptableflag)
FindInDatabase "MINIMUMQUANTITY", strminimumquantity ,fieldtype, rc,parsearray
If strminimumquantity="" then
  strminimumquantity=0
end if  
If strMinimumquantity=0 then
 If tableflag<>"" then
  Response.write TemplateQuantityRow & TemplateQuantityColumn
 end if
 %>
 <input type=text size=2 maxlength=3 name=quantity value=1>
 <%
 If tableflag<>"" then
   response.write TemplateQuantityColumnEnd & "</tr>"
 end if
else
   GenerateMinimumList strMinimumquantity, parsearray
end if    
End sub
'

Sub GetFieldValues (RS, fieldnames, fieldvalues, fieldtypes, fieldcount)
Dim i
dim fldname
i=0
' memo fields must be gotten first
  For each fldName in RS.Fields
       fieldnames(i) = ucase(fldname.name)
       fieldTypes(i) = fldname.type
       If Fieldtypes(i)="201" then
           fieldvalues(i)=RS(i)
       end if 
       i=i+1 
  next
  fieldcount=i-1 
  for i=0 to fieldcount
      if fieldtypes(i)<>"201" then
            fieldvalues(i)=RS(i).value
      end if  
      if isnull(fieldvalues(i)) then
                fieldvalues(i)=""
      end if 
'Debugwrite fieldnames(i) & " " & fieldvalues(i)   
next
   
End Sub

Sub ParseRecord (record,words,wordcount,delimiter)
Dim pos 
Dim recordl
Dim bytex
Dim temprec
Dim maxwords
Dim i
maxwords = 10
temprec = record
Dim maxentries
pos = 1
wordcount = 0
' make sure word array is null
maxentries = UBound(words)
For i = 0 To maxentries - 1
   words(i) = ""
Next
recordl = Len(temprec)
' first eliminate leading blanks
Do
   bytex = Mid(temprec, pos, 1)
   While bytex = " " And pos <= recordl
     pos = pos + 1
     bytex = Mid(temprec, pos, 1)
   
   Wend
' copy word into word array
   While bytex <> delimiter And pos <= recordl
     words(wordcount) = words(wordcount) & bytex
     pos = pos + 1
     bytex = Mid(temprec, pos, 1)
     
   Wend
   wordcount = wordcount + 1
   pos = pos + 1
   If wordcount > maxentries Then Exit Sub
Loop Until pos > recordl

End Sub
'
Sub Add_ProductFeatures (ivalue, parsearray, Index,parseRS)
dim rc, fieldtype, tableflag
prodindex=index
tableflag=parsearray(ptableflag)
FindInDatabase "FEATURES", strfeatures, fieldtype, rc,parsearray
If rc=0 then
   FindInDatabase "SELECTLIST", strselectlist, fieldtype, rc,parsearray
   FindInDatabase "CATALOGID", lngcatalogid, fieldtype, rc, parsearray
   If tableflag<>"" then
     WriteForm TemplateFeaturesRow  & TemplateFeaturesColumn
   end if 
   FormatProductOptions
   if tableflag<>"" then
     Writeform TemplateFeaturesColumnEnd & "</tr>"
   end if 
end if
end sub

Sub Handle_FormStart (value, parsearray, action)
Dim Newaction
newaction="shopaddtocart.asp"
If action<>"" then
    newaction=action
end if
%>
<form method=post action="<%=newaction%>">
<%
end sub
'
Sub Handle_FormEnd (ivalue, parsearray)
addwebsessform
WriteForm "</form>"
end sub

Sub WriteForm (text)
Response.write text
end sub

Sub Handle_Include (ivalue,parsearray)
'******************************************************
'[filename INCLUDE]
' field=abc INCLUDE]
' abc is field in recordset
'******************************************************
Dim NewRecord, ucfieldname, tokens
Dim recordObj, FsObj
dim rc
Dim MyText
dim readcount
Dim Bypass, filename, pos, fieldtype, filetype
dim values(10),valuecount
readcount=0
tokens=parsearray(ptokens)
filename=tokens(0)
pos=instr(filename,"=")
if pos>0 then 
   Parserecord filename,values,valuecount,"="
   ucfieldname=ucase(values(1))
   if ucase(values(0))="FIELD" then 
       FindInDatabase ucfieldname, filename, fieldtype ,rc,parsearray    
       If isnull(filename) or filename="" then
         exit sub
       end if
   else
       filename=values(1)
   end if        
end if   
'debugwrite "filename=" & filename
' Nov 3 fix
dim savevalue
savevalue=parsearray(Pdatainmemory)
parsearray(Pdatainmemory)="No"
OpenInputFile Filename, fsObj, RecordObj, rc
If rc> 0 then
     parsearray(Pdatainmemory)=savevalue
     shopwriteError  getlang("LangReadFail")  & filename 
     exit sub
else
    GetFileType filename,filetype
end if    
ReadARecord RecordObj, MyText, rc, parsearray
Do while rc=0
  If filetype="TXT" then
     '  Response.write Server.HTMLEncode(MyText)  & "<br>"
       ivalue=ivalue & Server.HTMLEncode(MyText)  & "<br>"
  else
       'response.write mytext
        ivalue=ivalue &  mytext
  end if          
  readcount=readcount+1
  ReadARecord RecordObj, MyText, rc, parsearray
Loop
CloseFile fsObj,RecordObj, rc, parsearray
parsearray(Pdatainmemory)=savevalue
end sub
'
Sub GetFileType(filename, filetype)
dim xtype
filetype="TXT"
xtype=ucase(right(filename,3))
Select case xtype
    case "TXT"
       filetype="TXT"
    case "HTM"
       filetype="HTM"
    case "TML"
       filetype="HTM"
end select
end sub

Sub GenerateMinimumList (strminimumquantity,parsearray)
Dim PArray(20),PArrayCount, tableflag
If Getconfig("xproductminimumquantity")="Yes" Then
  If tableflag<>"" then
    Response.write TemplateQuantityRow & TemplateQuantityColumn
  end if  
    Response.write "<input type='text' maxlength=4 size='3' value='" & strMinimumQuantity & "' name='quantity'>"  
   If tableflag<>"" then
      response.write TemplateQuantityColumnEnd & "</tr>"
   end if
   exit sub 
end if
dim minamount, amount, multiply
tableflag=parsearray(ptableflag)
minamount=strminimumquantity
parraycount=getconfig("xproductminimumlist")
if parraycount="" then
   parraycount=6
end if
parraycount=clng(parraycount)   
for i = 1 to parraycount
    amount=i*minamount
    parray(i)=amount
next    
dim i
sSelect = "<select size=1 name='quantity'>"
sSelect = sSelect & "<option selected>" & minamount & "</option>" 
for i = 2 to parraycount
  sSelect = sSelect & "<option>" & Parray(i) & "</option>"      
next    
sSelect= sSelect & "</select></p>"   
If tableflag<>"" then
  Response.write TemplateQuantityRow & TemplateQuantityColumn
end if
Response.write sSelect
If tableflag<>"" then
   response.write TemplateQuantityColumnEnd & "</tr>"
end if
end sub

Function RemovehtmlFileio(itemname, CR)
dim workrecord, firstchar, morefields, pos, endpos, length
dim token
workrecord=replace(itemname,"<br>",CR)
'If mailremovehtml<>"Yes" then
 '    Removehtml=workrecord
  '   exit function
'end if 
pos=1    
morefields = True
Do While morefields = True
   pos=1    
   pos = InStr(pos, workrecord, "<")
   If pos > 0 Then
       endpos = InStr(pos, workrecord, ">")
       If endpos=0 then
            morefields=false 
       else  
         length = endpos - pos + 1
         token = Mid(workrecord, pos, length)
         workrecord=replace(workrecord,token,"")
        end if
     else
        morefields=false
     end if
loop
RemovehtmlFileio=workrecord
end function         
'************************************************************
' add cross seelling links
'*************************************************************
Sub Handle_CrossSelling (ivalue, parsearray,parseRS)
dim lngcstock
dim strCrossProductIDs,strsql, rs, strmessage, strcdescurl,strurl
dim fieldtype,rc
FindInDatabase "CROSSSELLING", strcrossProductids, fieldtype, rc, parsearray
If rc>0 then exit sub
if strCrossProductids="" then exit sub
strsql="select * from products where catalogid in (" & strcrossproductids & ")"
strsql=strsql & " and hide=0"
if getconfig("xstocklow")<>"" then
    lngcstock= clng(getconfig("xstocklow")) 
    strsql = strsql & " and cstock> " & lngcstock
end if 
set rs=dbc.execute(strsql)
If Getconfig("Xcrosssellingimage")="Yes" then
    HandleCrosssellingimages rs
    exit sub
end if    
While Not rs.EOF
   strCDescURL=rs("cdescurl")
   If isnull(Strcdescurl) then
         strCDescURL=getconfig("xCrossLinkURL")
   end if
   if ucase(strcDESCURL)="SHOPEXD.ASP" then
       strurl="shopexd.asp?id=" & rs("catalogid")
   else
   	strurl="shopquery.asp?catalogid=" & rs("catalogid")
   end if
   strurl=addwebsess(strurl)
   strMessage=strMessage & "<br><a href='" & strURL & "'>" & Rs("cname") & "</a>"		
   RS.MoveNext
WEND
RS.Close
set RS=Nothing		
strMessage="<BR>" &  getlang("LangCrossSellingMessage") & strMessage
Response.write strmessage
end sub
Sub WriteNoStockMessage (rc, parsearray)
dim lngcstock,id,fieldtype,rc1, fieldname
rc=0
if getconfig("xOutOfStockLimit")="" then exit sub
fieldname="CSTOCK"
FindInDatabase fieldname, lngcstock, fieldtype ,rc1, parsearray 
'debugwrite "LNGCSTOCK=" & lngcstock & " " & rc1
if isnull(lngcstock) then exit sub
If lngcstock="" then exit sub
if clng(lngcstock)>clng(getconfig("xOutOfStocklImit")) then exit sub
'Response.write OutofStockColumn &  getlang("LangOutOfStock") & OutofStockColumnEnd
rc=4
end sub

Sub ShopMergetemplate (dbtable, template, catalogid, idfield)
dim tempdatabase, tmprs, rc
EditOpenDatabase dbc, tempdatabase, dbtable
'on error resume next
if isnumeric (catalogid) then
     Sql="select * from " & dbtable 
     If idfield<>"" then
       sql=sql & "  where " & idfield & "="  & catalogid
     end if  
else
      sql="select * from " & dbtable 
      If idfield<>"" then
       sql=sql & "  where " & idfield & "='"  & catalogid & "'"
      end if 
end if
Set tmpRS=dbc.execute(sql)
If tmpRS.eof then
   If catalogid<>"" then 
     Serror = SError &  getlang("LangReadFail") & "-" & getlang("LangEditTableName") & "=" & dbtable
   else
      Serror = SError &  getlang("LangReadFail") & " " & getlang("langedittablename") & "=" & dbtable
   end if   
end if 
If serror="" then
 ShopTemplateWrite  template, tmpRS, rc
end if 
CloseRecordset tmpRS
Shopclosedatabase dbc
end sub
'

Function HandleCustomerPrice (iprice, parsearray,parseRS)
dim discount, categoryid, ioprice, newprice
dim fieldtype, rc
newprice=iprice
FindInDatabase "CATALOGID", catalogid, fieldtype ,rc, parsearray 
FindInDatabase "CCATEGORY", categoryid, fieldtype ,rc, parsearray 
ShopCustomerPrices ParseRS, catalogid, categoryid, iprice, newprice,discount
'HandleCustomerprice=shopformatcurrency(newprice,getconfig("xdecimalpoint"))
HandleCustomerprice=newprice
end function

Function HandlePriceSAving (iprice, parsearray,parseRS)
dim discount, categoryid, ioprice, newprice
dim strretailprice, saving
dim fieldtype, rc
newprice=iprice
FindInDatabase "RETAILPRICE", strretailprice, fieldtype ,rc, parsearray 
If strretailprice="" then exit function
If strretailprice=0 then exit function
FindInDatabase "CATALOGID", catalogid, fieldtype ,rc, parsearray 
FindInDatabase "CCATEGORY", categoryid, fieldtype ,rc, parsearray 
ShopCustomerPrices ParseRS, catalogid, categoryid, iprice, newprice,discount
saving=strretailprice-newprice
'HandlePriceSaving=shopformatcurrency(saving,getconfig("xdecimalpoint"))
HandlePriceSaving=saving
end function

Sub Handle_OITEMSTEMPLATE (body, parsearray,parseRS)
'*******************************************************
' Template format order items
' expects myconn to be open as open connection
'********************************************************
dim filename, outarray(10), outcount, suffix, emailformat
filename=Getconfig("xoitemstemplate")
Dim Isql,orderid, rsitems
Dim recordid
Dim CR, itemname, i
recordid=parsearray(pidvalue)
Suffix=right(filename,3)
If ucase("suffix")<>"TXT" then
   setsess "emailformat","HTML"
end if   
If ucase(Getsess("emailformat"))="HTML" then
  CR=""
else
  CR = GetMailCR
end if
'OpenOrderdb dbc
isql="select * from oitems where orderid="
If Getsess("oid")<>"" then
    Orderid=GetSess("oid")
else
    Orderid=recordid
end if
Body=""
ISql=Isql & Orderid
'debugwrite isql
Set rsitems=myconn.execute(Isql)
If rsitems.eof then
   closerecordset rsitems
   exit sub
end if
do while not rsitems.eof
  ShopTemplateArray Filename, RSITEMS, Outarray, Outcount
  for i = 0 to outcount-1  
    itemname=outarray(i) 
    If ucase(Getsess("emailformat"))<>"HTML" then
        Itemname=RemoveHtmlFileio(itemname, CR)
     end if   
     Body = Body & CR & Itemname
  next 
  rsitems.movenext
loop 
closerecordset rsitems 
end sub

Sub Handle_OitemTotal(value,parsearray,parseRS)
dim quantity, unitprice, rc, fieldtype, price, total
FindInDatabase "NUMITEMS", quantity, fieldtype ,rc, parsearray 
FindInDatabase "UNITPRICE", unitprice, fieldtype ,rc, parsearray 
Total=quantity*unitprice
value=shopformatcurrency(total,getconfig("xdecimalpoint"))
end sub

Sub Handle_OitemDelivery(value,parsearray,parseRS)
dim rc, fieldtype, price, total, itemname
dim CR
dim deliveryaddress, deliveryarray
If ucase(Getsess("emailformat"))="HTML" then
  CR="<br>"
else
  CR = GetMailCR
end if
if getconfig("xdeliveryaddress")="Yes" then
   FindInDatabase "ADDRESS", deliveryaddress, fieldtype ,rc, parsearray 
   If not isnull(Deliveryaddress)  and Deliveryaddress<>"" then
     ConvertDeliveryToArray DeliveryArray, Deliveryaddress
     GetDeliveryName Itemname, DeliveryArray
    If ucase(Getsess("emailformat"))<>"HTML" then
        Itemname=RemoveHtmlFileio(itemname, CR)
     end if   
     value=itemname
   end if
end if
end sub
'****************************************************************
' see if template is in database. If it is open the recordset
' put whole template into fsobj
'******************************************************************
Sub OpenInputFiledb (filename, fsObj, RecordObj, rc)
dim dbprefix, dbfilename, conn
shopopendatabase conn
dbprefix=left(filename,3)
if lcase(dbprefix)="db=" then
   dbfilename=right(filename,len(filename)-3)
else
   dbfilename=filename
end if      
dim sql
sql="select * from templates where templatename='" & dbfilename & "'"
If getconfig("xdebug")="Yes" then
  debugwrite sql
end if  
set recordobj=conn.execute(sql)
If not recordobj.eof then
    rc=0
    fsobj=recordobj("template")
else
    rc=4
end if
closerecordset recordobj
shopclosedatabase conn
recordobj=""
If rc=0 then 
   recordobj="db"
end if 
end sub

Sub ReadEntireFileDB  (fsoobj, RecordObj, readcount, readarray,parsearray)
dim data, delimiter, i
delimiter="~"
readcount=0
data=replace(fsoobj,vbcrlf,delimiter)
parserecord data, readarray, readcount,delimiter
'debugwrite "Recordcount=" & readcount
'for i = 0 to readcount
'  debugwrite readarray(i)
'next  
end sub
'***********************************************************************
' Record are already in memory in the parse arary
'************************************************************************
Sub ReadARecordDB (RecordObj, record, rc,parsearray)
dim data, currentrecord, recordcount
currentrecord=parsearray(pdatacurrentrecord)
recordcount=parsearray(pdatarecordcount)
data=parsearray(pdata)
If currentrecord=recordcount then
   rc=4
   exit sub
end if
record=data(currentrecord)
currentrecord=currentrecord+1
parsearray(pdatacurrentrecord)=currentrecord
rc=0
end sub

Sub CheckfileDB(filename,fieldname,rc)
dim dbprefix
dbprefix=left(filename,3)
if lcase(dbprefix)="db=" then
   fieldname=right(filename,len(filename)-3)
   rc=0
else
   fieldname=""
   rc=4
end if      
end sub

Sub HandleCrosssellingImages (rs)
dim headerok
If rs.eof then 
   Closerecordset rs
  exit sub
end if  
AddCrossSellingHeader
headerok=true
While Not rs.EOF
   addCrossSellingrow rs
   RS.MoveNext
WEND
Closerecordset rs
if headerok=true then
   response.write tabledefend
end if   	
end sub

Sub addCrossSellingHeader
'*******************************************************************
' Start crossselling table
'****************************************************************
Response.write reporttabledef
response.write reportheadrow
response.write ReportHeadColumn
Response.write getlang("LangCrossSellingMessage")
Response.write ReportHeadColumnEnd
response.write reportrowend 
Response.write tabledefend
Response.write reporttabledef
end sub
'**********************************************************************
' format one row of crossselling. 
' all products must have an image
'**************************************************************************
Sub AddCrossSellingrow (rs)
dim catalogid, imagefile, cname, cprice, url, imageurl
dim buttonimage, buttontext, buttonname
buttonimage=Getconfig("xbuttonmoreinfo")
buttontext=getlang("langProductExtendeddescription")
buttonname="View"
if isNull(buttonimage) Or buttonimage="" then
	buttonimage=""
end if
catalogid=rs("catalogid")
imagefile=rs("cimageurl")
URL=rs("cdescurl")
If isnull(url) then
    URL=getconfig("xCrossLinkURL")
end if
url=addwebsess(url)
if imagefile<>"" then
   imageurl="<a href='" & url & "'><img src='" & imagefile & "' border='0'></a>"
else
   imageurl="&nbsp;" 
end if     
if ucase(URL)="SHOPEXD.ASP" then
       url="shopexd.asp?id=" & rs("catalogid")
else
	url="shopquery.asp?catalogid=" & rs("catalogid")
end if
url=addwebsess(url)
cname=rs("cname")
Response.write reportdetailrow
response.write reportdetailcolumn
Response.write imageurl
response.write reportDetailColumnEnd 
response.write reportdetailcolumn
response.write "<a href='" & url & "'>" & cname & "</a>"
response.write reportDetailColumnEnd 

response.write "</tr>"
end sub

Sub  Handle_RatingSummary (value, parsearray, parseRS)
dim oaverage,image, count
dim fieldtype, rc, lngcatalogid, fieldname
If getconfig("xAllowRatingProducts")<>"Yes" then exit sub
If getconfig("xAllowRatingSummary")<>"Yes" then exit sub
fieldname="CATALOGID"
FindInDatabase fieldname, lngcatalogid, fieldtype ,rc, parsearray 
FileioReviewaverage lngcatalogid, oaverage,image, count, dbc
If image="" then
   response.write "<p align=center>" & getlang("langNoReviews") & "</p>"
   exit sub
end if   
response.write "<p align='center'>"
Response.write count & "&nbsp;" & getlang("langratingheader")  & "<br>"
response.write "<img border='0' src='" & image & "'></p>" 
end sub

Sub FileioReviewAverage(catalogid, oaverage, image, outcount, dbc)
dim rs, rsql, strrating, conn
rsql=" SELECT catalogid, Avg(rating) AS avgofrating, count(catalogid) as countcatalogid from reviews where catalogid=" & catalogid & " AND authorized IS NOT NULL GROUP BY catalogid"
If getconfig("xproductdb")<>"" then
   shopopendatabase conn
   set rs=conn.execute(rsql)
else   
  set rs=dbc.execute(rsql)
end if  
if not rs.eof then
  oaverage=rs("avgofrating")
  oaverage=clng(oaverage)
  strrating=cstr(oaverage)
  outcount=rs("countcatalogid")
  Select case strrating
   Case "1"
     image="vpasp_stars1.gif"
   Case "2"
     image="vpasp_stars2.gif"
   Case "3"
     image="vpasp_stars3.gif"
   Case "4"
     image="vpasp_stars4.gif"
   Case "5"
     image="vpasp_stars5.gif"
    Case else
      image=""
   end select      
else
   oaverage=""
   image=""
end if    
rs.close
set rs=nothing
If getconfig("xproductdb")<>"" then
  shopclosedatabase conn
end if  
end sub
'
Function HandleFormatimage (fieldvalue)
dim newvalue
if fieldvalue="" then 
   handleformatimage=""
   exit function
end if   
newvalue="<img border='0' src='" & fieldvalue & "'>"
handleformatimage=newvalue
end function
'************************************************************
' add Inventory Products. Codse is in shopproductinventory
'*************************************************************
Sub Handle_Inventoryproducts (ivalue, parsearray,parseRS)
If getconfig("xinventoryproducts")<>"Yes" then exit sub
FormatInventoryproducts dbc, parseRS
end sub

'***************************************************************************
' if there are associated products then display them
' instead of the order button
'***************************************************************************
sub Checkinventoryproducts (ivalue,parsearray,parseRS, inventorycheck)
inventorycheck=false
If getconfig("xinventoryproducts")<>"Yes"  then exit sub
dim strCrossProductIDs,strsql, rs
dim fieldtype,rc
FindInDatabase "INVENTORYPRODUCTS", strcrossProductids, fieldtype, rc, parsearray
If strcrossproductids<>"" then 
   inventorycheck=true
end if
end sub

Sub  Handle_INVOICEOITEMS (value,parsearray, parseRS)
'*******************************************************
' Template format order items
' expects myconn to be open as open connection
' $H is one type header
' $T is one time trailer
'********************************************************
dim filename, outarray(500), outcount, suffix, emailformat
dim headerwritten
dim body, record, outrec, prefix
filename=Getconfig("xinvoiceoitemstemplate")
filename="tmp_invoiceoitems.htm"
headerwritten=false
Dim Isql,orderid, rsitems
Dim recordid
Dim CR, itemname, i
recordid=parsearray(pidvalue)
isql="select * from oitems where orderid="
Orderid=recordid
Body=""
ISql=Isql & Orderid
'debugwrite isql
Set rsitems=myconn.execute(Isql)
If rsitems.eof then
   closerecordset rsitems
   exit sub
end if
do while not rsitems.eof
  ShopTemplateArray Filename, RSITEMS, Outarray, Outcount
  for i = 0 to outcount-1  
    record=outarray(i)
    outrec=Striprecord(record)
    prefix=ucase(left(record,2))
    if prefix=";T" then
        outrec=""
    end if   
    If headerwritten=true then 
      if prefix=";H" then
        outrec=""
      end if
    end if
    If outrec<>"" then
      response.write outrec & vbcrlf
    end if
  next
  headerwritten=true 
  rsitems.movenext
loop 
closerecordset rsitems 
for i = 0 to outcount-1  
    record=outarray(i)
    outrec=striprecord(record)
    prefix=ucase(left(record,2))
    if prefix=";T" then
     response.write outrec & vbcrlf
    end if
next
end sub

'******************************************************************
' Display quantity discounts
'*******************************************************************
Sub Handle_Quantitydiscounts(value,parsearray,parseRS)
if getconfig("xquantityPrices")<>"Yes" then exit sub
dim lookupsql, lookuprs, oldprice, newprice, iprice, discount, i
dim quantitylowfield, quantityhighfield, quantitylow, quantityhigh, pricefield
Dim Discountamount,DiscountPercent
dim catalogid, categoryid, price, discountprice, discpercent
dim fieldvalue
dim quantitygroup, qdbc
catalogid=parsers("catalogid")
categoryid=ParseRs("ccategory")
quantitygroup=ParseRs("groupfordiscount")
lookupsql="select * from quantitydiscounts " 
lookupsql = lookupsql & " where catalogid=" & catalogid
lookupsql = lookupsql & " or categoryid=" & categoryid
If not isnull(quantitygroup) then 
   lookupsql = lookupsql & " or groupfordiscount='" & quantitygroup & "'"
end if 
'debugwrite "lookupsql=" & lookupsql
If getconfig("xproductdb")<>"" then
   shopopendatabase qdbc  
   Set lookuprs=qdbc.execute(lookupsql)
else   
   Set lookuprs=dbc.execute(lookupsql)
end if   
if lookuprs.eof then
    lookuprs.close
    set lookuprs=nothing
    If getconfig("xproductdb")<>"" then
      shopclosedatabase qdbc  
    end if
    exit sub
end if
shopwriteheader getlang("LangProductDiscount")
response.write ReportTableDef & ReportHeadRow 
Response.write ReportHeadColumn & getlang("LangProductQuantity") & ReportHeadColumnEnd
Response.write ReportHeadColumn & getlang("LangProductPrice") & ReportHeadColumnEnd
response.write ReportRowEnd
newprice=Parsers("cprice")
price=newprice
ShopCustomerPrices ParseRS, catalogid, categoryid, iprice, newprice,discount
for i = 1 to 5
  If i=1 then 
    quantitylowField= "minquantity"
  else
   quantitylowField= "quantity" & i-1
  end if  
  quantityhighfield="quantity" & i
  pricefield="discount" & i
  Quantitylow= lookuprs(quantitylowfield)
  quantityhigh=lookuprs(quantityhighfield)
  If isnull(quantityhigh) then exit for
  If quantityhigh=0 then exit for
  If I >1 Then 
     quantitylow=quantitylow+1
  end if   
  fieldvalue= quantitylow & " to " & quantityhigh
  response.write reportdetailrow
  response.write ReportDetailColumn & fieldvalue & ReportDetailcolumnEnd 
  discpercent=lookuprs(pricefield)
  If discpercent>=1 then
       discount=discpercent
  else    
       discount=Price*discpercent
  end if   
  'debugwrite "discountpercent=" & discpercent
  DiscountPrice=Price-discount
  DiscountPrice=shopformatcurrency(Discountprice,getconfig("xdecimalpoint"))
  response.write ReportDetailColumn & discountprice & ReportDetailcolumnEnd 
  response.write "</tr>"
next  
response.write "</table>"
closerecordset lookuprs
If getconfig("xproductdb")<>"" then
      shopclosedatabase qdbc  
end if
end sub
Function StripRecord(inrec)
dim prefix, newrec
prefix=ucase(left(inrec,2))
newrec=inrec
if prefix=";H" or prefix=";T" then
   newrec=mid(inrec,3,len(inrec)-2)
end if
striprecord=newrec     
end function
'
'************************************************************
' adds &websess=xxxxxxxxxxxxxxxx
'************************************************************
Sub Handle_ADDWEBSESSLINK( value,parsearray, parseRS)
value=addwebsesslink
end sub

'****************************************************************************
' Create hyperlink to currency converter
'***************************************************************************
Function HandleFormatCurrencyConversion (total, parsearray,parseRS)
dim value, cprice
value=""
If Getconfig("xproductconvertcurrency")="Yes"  Then 
  cprice=shopformatnumber(total,getconfig("xdecimalpoint"))
  ShopConvertCurrencyLink  cprice, value  
end if
HandleFormatCurrencyConversion=value
end function

Sub GetDualPricevalue( value, strcprice, parsearray)
dim dualpricefield
If Getconfig("xdualpricefield")=""  then
  ConvertCurrency value, strcPrice
  exit sub
end if
dualpricefield=Getconfig("xdualpricefield")
dim fieldtype,rc
FindInDatabase ucase(dualpricefield), strcprice, fieldtype, rc, parsearray
If isnumeric(strcprice) then exit sub
strcprice=value
end sub
%>
