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
        HttpContext.Current.Response.Write ("{\"domain\":\"api running"}");

    }

    [System.Web.Services.WebMethod]
    public static string UpdateDraft (string id, string name) {
        return (id + DateTime.Now.ToShortDateString ());
    }

    [System.Web.Services.WebMethod]
    public static string AddDraft (string id) {
        return (DateTime.Now.ToShortDateString () + id);
    }
}
