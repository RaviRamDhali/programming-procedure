public List<BLL.ViewModel.Customer> CustomerFromDb(List<DAL.ModelDb.Customer> customers)
{
    return customer.Select(CustomerFromDb).ToList();
}

public BLL.ViewModel.Customer CustomerFromDb(DAL.ModelDb.Customer data)
{
    var result = new BLL.ViewModel.Customer();

    result.Id = data.Id;
    result.Guid = data.Guid;
    result.Modified = data.Modified;
    result.LastLogin = data.LastLogin;

    return result;
}
