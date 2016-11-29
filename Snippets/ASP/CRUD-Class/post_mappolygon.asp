<!-- #include virtual=/Intranet/includes/global.asp -->
<!-- #include virtual=/Intranet/includes/adovbs.asp-->
<!-- #include virtual=/Intranet/includes/functions/Common.asp-->

<!-- #include virtual=/Intranet/Admin/mapbuilder/class_common.asp -->
<!-- #include virtual=/Intranet/Admin/mapbuilder/class_mappolygon.asp -->

<%
dim park
set park = new mappolygon

if(Request.Form("command") = "delete") then
	call park.delete(Request.Form("idno"))
	response.redirect("/Intranet/admin/mapbuilder/")
end if


call park.initialize(Request.Form)

if (park.command = "update") OR (park.command = "add")  then
	park.add(park)
	response.redirect("/Intranet/admin/mapbuilder/")
end if


%>