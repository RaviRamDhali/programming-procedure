    public class PasswordResetRequests : BaseRepository
    {
        protected override string ConnectionString
        {
            get { return GlobalSettings.DateStores.SQLCONN; }
        }

        public PasswordToken RecentRequestGuid(int userId)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("userId", userId);
            string query = "SELECT TOP 1 * FROM [PasswordToken] WHERE userId = @userId";

            var model = WithConnection<PasswordToken>(connection =>
            {
                return (connection.Query<PasswordToken>(query, dynamicParameters)).FirstOrDefault();
            });

            if (model.IsNull()) 
                return null;

            return model;

        }

        public void DeleteOldPasswordResetRequests(int userId)
        {
            var model = RecentRequestGuid(userId);

            if(model.IsNull())
                return;
            
            WithConnection(connection =>
            {
                var isSuccess = connection.Delete(new PasswordToken { ID = model.ID});
                return true;
            });

        }

        public PasswordToken eUser_PasswordToken(PasswordToken model)
        {
            return WithConnection(connection =>
            {
                connection.Insert(model);
                return model;
            });

        }

        public PasswordToken GetResetPasswordByToken(Guid token)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("token", token);
            string query = "SELECT TOP 1 * FROM [PasswordToken] WHERE Token = @token";

            var model = WithConnection<PasswordToken>(connection =>
                (connection.Query<PasswordToken>(query, dynamicParameters)).FirstOrDefault()
            );

            if (model.IsNull())
                return null;
            
            return model;
        }
    }
