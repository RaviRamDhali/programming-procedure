using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;

public partial class customer_report : System.Web.UI.Page {

  protected void Page_Load(object sender, EventArgs e) {

    string connectionString = WebConfigurationManager.ConnectionStrings["devDB"].ConnectionString;
       
    Customer item = new Customer();
    string stateabbr = "ca";

    using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string strSql = "SELECT TOP 1 c.CustomerID as Id" +
            ", c.FirstName" +
            ", c.LastName" +
            ", c.Email" +
            " FROM Customer AS c" +
            //" WHERE c.StateAbbr = @stateabbr" +
            " WHERE c.StateAbbr = 'CA'" +
            " ORDER BY c.LastName" ;

            SqlCommand cmd = new SqlCommand(strSql, conn);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.Add("@stateabbr", stateabbr);
            
            conn.Open();

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    while (reader.Read()){
                   
                    item.Id = reader["Id"].ToInt32OrDefault();
                    item.FirstName = reader["FirstName"].ToStringOrDefault();
                    item.LastName = reader["LastName"].ToStringOrDefault();
                    item.Email = reader["Email"].ToStringOrDefault().ToLower().Trim();
                    }
                }else{
                  return;
                }

            } //using datareader
      
          conn.Close();

        } // using sqlconn


        string json = JsonConvert.SerializeObject(item);
        HttpContext.Current.Response.Write("<li>json :" + json + "</li>");
       
  }


  public class Customer{
    public int Id {get;set;}
    public string FirstName {get;set;}
    public string LastName {get;set;}
    public string Email {get;set;}
  }

}
