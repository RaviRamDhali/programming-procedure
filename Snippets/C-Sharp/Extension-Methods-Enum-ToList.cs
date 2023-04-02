[Serializable]
public enum eUserRole
{
    Admin = 100,
    Manager = 200,
    Member = 300,
    Guest = 400,
    Contractor = 500,
    Contact = 600,
    Higher = Admin | Manager,
    Lower = Guest | Contractor | Contact
}
    
public enum InvoiceValidType
{
    Review = 0,
    Approved = 1, 
    Rejected = 2
}

public enum MyEnum 
{ 
    [Description("value 1")] 
    Value1, 
    [Description("value 2")]
    Value2, 
    [Description("value 3")]
    Value3
}



public class EnumModel
{
    public int Value { get; set; }
    public string Name { get; set; }
}

public static List<InvoiceValidTypePresenter.EnumModel> GetAll()
{
    var list = new List<InvoiceValidTypePresenter.EnumModel>();

            list = (
                from IMSClasses.common.Enums.AttachmentDocTypes d 
                    in Enum.GetValues(typeof (IMSClasses.common.Enums.AttachmentDocTypes))
                select new InvoiceValidTypePresenter.EnumModel()
                {
                    Value = (int) d,
                    Name = d.ToString()
                }).ToList();
    return list;
}

  public static InvoiceValidTypePresenter.EnumModel GetById(int id)
  {
      var list = GetAll();
      
      return list.FirstOrDefault(x => x.Value == id);
  }
