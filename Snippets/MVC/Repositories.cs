namespace DAL.Repositories
{
    public class Company
    {
        public static int GetId(Guid guid)
        {
            using (var db = new EFContext())
            {
                return (from x in db.Company where x.Guid == guid select x.Id).FirstOrDefault();
            }
        }
        public static Guid GetGuid(int id)
        {
            using (var db = new EFContext())
            {
                return (from x in db.Company where x.Id == id select x.Guid).FirstOrDefault();
            }
        }
        public Models.Company Get(int id)
        {
            using (var db = new EFContext())
            {
                return (from x in db.Company where x.Id == id select x).FirstOrDefault();
            }
        }
        public Models.Company Get(Guid guid)
        {
            int id = GetId(guid);
            return Get(id);
        }
        public List<Models.Company> GetAll(Guid mspGuid)
        {
            int companyId = Repositories.ServicesProvider.GetId(mspGuid);
            return GetAll(companyId);
        }
        public List<Models.Company> GetAll(int mspId)
        {
            using (var db = new EFContext())
            {
                return (from x in db.Company where x.Mspid == mspId select x).ToList();
            }
        }
    }
}
