public List<BLL.ViewModel.Customer> CustomerFromDb(List<DAL.ModelDb.Customer> customers)
{
    // #1 Group by linq expression
    return customer.Select(CustomerFromDb).ToList();
    
    // #2 Foreach into Linq expression
    return customer.Select(data => CustomerFromDb(data)).ToList();
    
    // #3 Foreach
    var list = new List<BLL.ViewModel.Customer>();

            foreach (var data in customer)
            {
                list.Add(Customer(data));
            }

    return list;
    
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
