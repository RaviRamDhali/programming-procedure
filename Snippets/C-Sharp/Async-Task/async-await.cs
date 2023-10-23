namespace Infrastructure.Repository
{
    /// <summary>
    /// Repository class for handling data related to affiliates in the database.
    /// </summary>
    public class AffiliateRepository : BaseRepository, IAffiliateRepository
    {
        /// <summary>
        /// Initializes a new instance of the AffiliateRepository class.
        /// </summary>
        public AffiliateRepository() { }

        /// <summary>
        /// Retrieves a list of all affiliates from the database asynchronously.
        /// </summary>
        /// <returns>A list of Affiliate objects.</returns>
        public async Task<List<Affiliate>> GetAll()
        {
            string query = "SELECT * FROM dbo.Affiliates ORDER BY affiliate_id";
            return await WithConnectionAsync<List<Affiliate>>(async connection =>
            {
                return (await connection.QueryAsync<Affiliate>(query)).ToList();
            });
        }

        /// <summary>
        /// Retrieves an affiliate by its unique identifier asynchronously.
        /// </summary>
        /// <param name="value">The unique identifier of the affiliate.</param>
        /// <returns>The Affiliate object if found, otherwise null.</returns>
        public async Task<Affiliate> Get(Guid value)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("value", value);

            string query = "SELECT TOP 1 * FROM dbo.Affiliates WHERE Guid = @value ";
            return await WithConnectionAsync(connection => connection.QueryFirstOrDefaultAsync<Affiliate>(query, dynamicParameters));
        }

        /// <summary>
        /// Retrieves an affiliate by its affiliate_id asynchronously.
        /// </summary>
        /// <param name="value">The affiliate_id of the affiliate.</param>
        /// <returns>The Affiliate object if found, otherwise null.</returns>
        public async Task<Affiliate> GetByAffiliateId(string value)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("value", value);

            string query = "SELECT TOP 1 * FROM dbo.Affiliates WHERE affiliate_id = @value ";
            return await WithConnectionAsync(connection => connection.QueryFirstOrDefaultAsync<Affiliate>(query, dynamicParameters));
        }
    }
}


        public async Task<List<AffiliateViewModel>> GetAll()
        {
            try
            {
                var affiliates = await _repo.GetAll();

                if (affiliates == null || affiliates.Count == 0)
                {
                    // Log a message indicating no affiliates were found.
                    _logger.LogInformation("No affiliates were found in the database.");
                    return new List<AffiliateViewModel>();
                }

                return _map.FromModel(affiliates);
            }
            catch (Exception ex)
            {
                // Log the error and rethrow it for higher-level handling.
                _logger.LogError(ex, "An error occurred while retrieving affiliates.");
                throw;
            }
        }
