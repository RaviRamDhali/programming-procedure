using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BLL.ViewModels;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Migrations.Operations;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace anaxisoft.Controllers.WebAPI
{
	[Route("api/[controller]")]
	[ApiController]
	public class DiagramController : ControllerBase
	{
		BLL.AppSettings _config { get; }
		public DiagramController(BLL.AppSettings config)
		{
			_config = config;

		}

		// GET: api/Diagram
		[HttpGet]
		public IEnumerable<string> Get()
		{
			return new string[] { "value1", "value2" };
		}

		// GET: api/Diagram/5
		[HttpGet("{companyId}/{diagramId}", Name = "GetDiagrams")]
		public string Get(Guid companyId, Guid diagramId)
		{
			var diagrams = new BLL.Services.Diagram.DiagramElement(companyId, diagramId, _config);
			var json = diagrams.ListForDrawingCanvas();
			return Newtonsoft.Json.JsonConvert.SerializeObject(json);
		}
		
		[HttpPost]
		public IEnumerable<string> Auth([FromForm] string email, string password)
		{
			var auth = new BLL.Services.Authentication.Login(email,password);

			int userId = auth.GetUser();

			return new string[] { "userId", userId.ToStringOrDefault() };

		}
		
		[HttpPost]
		public IEnumerable<string> Auth([FromForm] BLL.ViewModels.Common.Auth data)
		{
			var auth = new BLL.Services.Authentication.Login(data.email,data.password);

			int userId = auth.GetUser();

			return new string[] { "userId", userId.ToStringOrDefault() };

		}
		

		// POST: api/Diagram
		[HttpPost]
		public string Post([FromBody] BLL.PostModels.Page.DiagramEditor data)
		{
			var diagramelement = new BLL.Services.Diagram.DiagramElement(data);
			return JsonConvert.SerializeObject(diagramelement.Dispatcher());
		}
		// DELETE: api/ApiWithActions/5
		[HttpDelete]
		public void Delete([FromBody] BLL.PostModels.Page.DiagramEditor data)
		{
			var diagramelement = new BLL.Services.Diagram.DiagramElement(data);
			diagramelement.Delete();
		}

	}
}
