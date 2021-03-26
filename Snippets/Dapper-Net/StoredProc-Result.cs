

// Even if the storedproc does not return anything,
// the below will Execute and return 0
var dynamicParameters = new DynamicParameters();
dynamicParameters.Add("CustomerID", customerId);
dynamicParameters.Add("ExpirationDate", DateTime.Now.AddYears(2));

WithConnection(connection =>
{
    return connection.Query<int>("spOrderCreate", dynamicParameters, commandType: CommandType.StoredProcedure).FirstOrDefault();

});



var spName = "[dbo].[InsertLogAndReturnID]";

 using (SqlConnection objConnection = new SqlConnection(Util.ConnectionString))
 {
    objConnection.Open();
    DynamicParameters p = new DynamicParameters();

    p.Add("@ID", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);
    p.Add("@TypeID", 1);
    p.Add("@Description", "TEST1");
    p.Add("@UserName", "stone");

    var row = SqlMapper.Execute(objConnection, spName, p, commandType: CommandType.StoredProcedure);
     var id  = p.Get<Int32>("@ID");

      objConnection.Close();
   }
