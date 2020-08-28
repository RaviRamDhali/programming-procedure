Allows for Guid or NULL 

[HttpGet]
[Route("api/directorygroup/{id?}")]
public async Task<IHttpActionResult> DirectoryGroup(Guid? id = default)
{
    var srv = new BLL.Service.Directory();
    var model = srv.GetDirectoryGroup(id);

    if (model.IsNull())
        return NotFound();

    return Ok(model);
}
