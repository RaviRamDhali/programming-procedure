Allows for Guid or NULL 

In C# 7, the supported syntax is:
Guid foo = default(Guid);
but the simpler form was added in 7.1.
 
 [HttpGet]
    [Route("api/directorygroup/{id?}")]
    public async Task<IHttpActionResult> DirectoryGroup(Guid? id = default(Guid?))
    {
        var srv = new BLL.Service.Directory();
        var model = srv.GetDirectoryGroup(id);

        if (model.IsNull())
            return NotFound();

        return Ok(model);
    }


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
