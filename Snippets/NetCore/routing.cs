// GET api/user/firstname/lastname/address

[HttpGet("{firstName}/{lastName}/{address}")]

public string GetQuery(string id, string firstName, string lastName,string      address)
{
 return $"{firstName}:{lastName}";
}


[HttpGet("{companyId}/{diagramId}", Name = "GetDiagrams")]
public string Get(Guid companyId, Guid diagramId)
{
  var diagrams = new BLL.Services.Diagram.DiagramElement(companyId, diagramId, _config);
  var json = diagrams.ListForDrawingCanvas();
  return Newtonsoft.Json.JsonConvert.SerializeObject(json);
}



// https://localhost:44324/api/Configuration/Types
[HttpGet("Types", Name = "GetConfigurationTypes")]
 public ActionResult GetTypes()
 {
  var configuration = new BLL.Services.Configuration.Selections();
  var obj = configuration.GetTypes();
  return Ok(obj);
 }

https://localhost:44324/api/Configuration/Status
[HttpGet("Status", Name = "GetConfigurationStatusTypes")]
public ActionResult GetStatusTypes()
{
 var configuration = new BLL.Services.Configuration.Selections();
 var obj = configuration.GetStatusTypes();
 return Ok(obj);
}
