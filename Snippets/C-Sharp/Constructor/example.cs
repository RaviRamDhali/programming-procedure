using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Remotion.Linq.Clauses;

namespace BLL.Services.Company
{
	public class Company
	{
		private Guid _Guid;

		public int Id { get; set; }
		public Guid Guid { get; set; }
		public int Mspid { get; set; }
		public string Name { get; set; }
		public string Address1 { get; set; }
		public string Address2 { get; set; }
		public string City { get; set; }
		public string State { get; set; }
		public string Zip { get; set; }
		public string Phone { get; set; }
		public string Email { get; set; }
		public DateTime Created { get; set; }
		public DateTime Modified { get; set; }
		public bool Active { get; set; }

		public string FriendlyUrl { get; set; }

		public Company(int companyId)
		{
			GetCompany(companyId);
		}

		public Company(Guid companyGuid)
		{
			Id = GetByGuid(companyGuid) ;
			GetCompany(Id);
		}
		
		public void GetCompany(int id)
		{
			using (var db = new EFContext())
			{
				var data = ( from c in db.Company where c.Id == id select c).FirstOrDefault();

				if (data.IsNotNull())
				{
					Id = data.Id;
					Guid = data.Guid;
					Mspid = data.Mspid;
					Name = data.Name;
					Address1 = data.Address1;
					Address2 = data.Address2;
					City = data.City;
					State = data.State;
					Zip = data.Zip;
					Phone = data.Phone;
					Email = data.Email;
					Created = data.Created;
					Modified = data.Modified;
					Active = data.Active;
				}
			}
		}
		private int  GetByGuid(Guid guid)
		{
			using (var db = new EFContext())
			{
				return (from c in db.Company where c.Guid == guid select c.Id).FirstOrDefault();
			}
		}
		public Guid GetGuidById()
		{
			using (var db = new EFContext())
			{
				return (from c in db.Company where c.Id == Id select c.Guid).FirstOrDefault();

			}
		}
	}
}
