using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace DAL.Repository
{
    public class BaseRepository
    {
        private static bool initialized = false;
        public BaseRepository()
        {
            Initialize();
        }


        protected virtual string BaseConnectionString
        {
            get
            {
                return new ConfigurationBuilder().AddJsonFile("appsettings.json").Build().GetConnectionString("DefaultConnection");
            }

            //get
            //{
            //    // Now using Web.config for connectionStrings
            //    return ConfigurationManager.ConnectionStrings["mpConnection"].ConnectionString;
            //}
        }

        public static void Initialize()
        {
            if (!initialized)
            {
                initialized = true;
            }
        }

        protected async Task<T> WithConnectionAsync<T>(Func<IDbConnection, Task<T>> getData)
        {
            try
            {
                using (var connection = new SqlConnection(BaseConnectionString))
                {
                    await connection.OpenAsync(); // Asynchronously open a connection to the database
                    return await getData(connection); // Asynchronously execute getData, which has been passed in as a Func<IDBConnection, Task<T>>
                }
            }
            catch (TimeoutException ex)
            {
                throw new Exception(String.Format("{0}.WithConnection() experienced a SQL timeout", GetType().FullName), ex);
            }
            catch (SqlException ex)
            {
                throw new Exception(String.Format("{0}.WithConnection() experienced a SQL exception (not a timeout)", GetType().FullName), ex);
            }
        }

        protected T WithConnection<T>(Func<IDbConnection, T> getData)
        {
            try
            {
                using (var connection = new SqlConnection(BaseConnectionString))
                {
                    connection.Open(); // Open a connection to the database
                    return getData(connection); // Execute getData, which has been passed in as a Func<IDBConnection, Task<T>>
                }
            }
            catch (TimeoutException ex)
            {
                throw new Exception(String.Format("{0}.WithConnection() experienced a SQL timeout", GetType().FullName), ex);
            }
            catch (SqlException ex)
            {
                throw new Exception(String.Format("{0}.WithConnection() experienced a SQL exception (not a timeout)", GetType().FullName), ex);
            }
        }

    }
}
