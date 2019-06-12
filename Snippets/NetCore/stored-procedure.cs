public int GetUser()
		{

			int result = 0;

			using (var db = new EFContext())
			{

				using (var command = db.Database.GetDbConnection().CreateCommand())
				{
					command.CommandText = "CustomerAuthentication";
					command.CommandType = CommandType.StoredProcedure;				
					command.Parameters.Add(new SqlParameter("@email", SqlDbType.VarChar) { Value = _email });
					command.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar) { Value = _password });
	
					db.Database.OpenConnection();

					using (var data = command.ExecuteReader())
					{
						while (data.Read())
						{
							result = data["value"].ToInt32OrDefault();
						}
					}
				}

			}

			return result;
		}
