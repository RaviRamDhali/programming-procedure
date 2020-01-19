public List<Reservation> GetReservations(Models.PostData formData)
{
    string formTask = formData.custom.task;
    string search = "%" + formData.custom.searchTerm.ToStringOrDefault().Trim().ToLower() + "%";
    string sqlStatus = formTask;
    int pagesize = formData.pageSize.ToInt32OrDefault();

    if (formTask == "all") sqlStatus = "departed";

    var dynamicParameters = new DynamicParameters();
    dynamicParameters.Add("sqlStatus", sqlStatus.ToStringOrDefault().Trim().ToLower());
    dynamicParameters.Add("search", search.ToStringOrDefault().Trim().ToLower());
    dynamicParameters.Add("pagesize", pagesize.ToInt32OrDefault());

    return WithConnection<List<Reservation>>(connection =>
    {
    string query = "SELECT top (@pagesize) * FROM [Reservation] WHERE 1 = 1";

    //if (formTask == "all")
    //    query = "SELECT top (@pagesize) * FROM [Reservation] WHERE Status = @sqlStatus AND ReservationNumber LIKE 'res-%' Order by ReservationNumber";


    if (formData.custom.searchTerm.IsNullOrEmpty())
    {
        query += " AND Status = @sqlStatus";
    }
    else
    {
        query += " AND ReservationNumber LIKE @search";
        query += " OR FirstName LIKE @search";
        query += " OR LastName LIKE @search";
    }


    if (formTask == "all")
    {
        query += " Order by DateStart";
    }
    else
    {
        query += " Order by DateStart";
    }

    return (connection.Query<Reservation>(query, dynamicParameters)).ToList();
}
