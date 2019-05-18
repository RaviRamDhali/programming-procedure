public class HomeController : Controller
	{
		public IActionResult Index()
		{
			
			var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions()
			{
				Path = "/",
				HttpOnly = false,
				IsEssential = true, //<- there
				Expires = DateTime.Now.AddMonths(1),
			};
      
			Response.Cookies.Append("mspid", "6000000-00000-2927-1FFD-00000000000", cookieOptions);
			
      var obj = new BLL.Services.ManagedServicesProvider.ManagedServicesProvider(3);
			var model = obj.GetCompanies();
			
      return View(model);
		}
	}
