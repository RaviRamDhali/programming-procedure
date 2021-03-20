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
