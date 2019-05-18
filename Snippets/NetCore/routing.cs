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
