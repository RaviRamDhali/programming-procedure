
### [System.Web.Services.WebMethod]
**public static object <--- OBJECT not string**

****

*\api\default.aspx*

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default"%><head runat="server"/>



****
*\api\default.aspx.cs*

using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class _Default : System.Web.UI.Page {

    protected void Page_Load (object sender, EventArgs e) {
        Response.ContentType = "text/json";
        HttpContext.Current.Response.Write ("{\"domain\":\"api running successce.com customer\"}");
    }

    [System.Web.Services.WebMethod]
    public static object GetUsers (NameValueCollection formCollection) {
        var cadmin = new Customer();
        var AdminCustomers = cadmin.GetCustomers("");
        return AdminCustomers;
    }
    
    [System.Web.Services.WebMethod]
    public static object UpdateDraft (string id, string name) {
        return (id + DateTime.Now.ToShortDateString ());
    }

    [System.Web.Services.WebMethod]
    public static object AddDraft (string id) {
        return (DateTime.Now.ToShortDateString () + id);
    }
}

![alt text](https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/ASPX/WebMethod/WebMethod-POST-Man-REST.jpg)


![alt text](https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/ASPX/WebMethod/WebMethod-REST.jpg)

