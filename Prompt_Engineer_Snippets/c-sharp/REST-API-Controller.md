## Propmt
You are a senior C# software architect.  
Generate an ASP.NET Core REST API controller that follows best practices:  

- Use [ApiController] and RESTful route naming.  
- Use dependency injection for a service (e.g., I<ENTITY>Service).  
- Implement standard CRUD endpoints:  
  - GET /api/manager/<entity> → GetAll  
  - GET /api/manager/<entity>/{id:guid} → GetById  
  - POST /api/manager/<entity> → Create (returns 201 CreatedAtAction)  
  - PUT /api/manager/<entity>/{id:guid} → Update (returns 204 NoContent)  
  - DELETE /api/manager/<entity>/{id:guid} → Delete (returns 204 NoContent)  
- Wrap each action in a helper method HandleRequestAsync for error handling.  
- Use IActionResult return types (Ok, NotFound, BadRequest, NoContent, CreatedAtAction).  
- Keep controller thin (only coordinate requests → service calls).  
- Use Guid as the identifier type.  
- Assume a DTO class named <ENTITY>Update for create/update.  

The controller should look like:

[ApiController]  
[Route("api/manager/<entity>")]  
public class <Entity>Controller : BaseApiController<<Entity>Controller>  

## Usage
Generate an ASP.NET Core controller for "roles" using the generic prompt.  
Service: IRoleService  
DTO: RoleUpdate  


## Skeleton
Skeleton Controller Template

```
using Microsoft.AspNetCore.Mvc;

namespace WebApi.Controllers.Manager
{
    [ApiController]
    [Route("api/manager/<entity>")]
    public class <Entity>Controller : BaseApiController<<Entity>Controller>
    {
        private readonly <IEntityService> _<entity>Service;

        public <Entity>Controller(<IEntityService> <entity>Service, ILogger<<Entity>Controller> logger)
            : base(logger)
        {
            _<entity>Service = <entity>Service;
        }

        // GET: api/manager/<entity>
        [HttpGet]
        public async Task<IActionResult> GetAll() =>
            await HandleRequestAsync(async () =>
            {
                var data = await _<entity>Service.GetAllForManagement();
                return data == null ? NotFound() : Ok(data);
            }, "An error occurred while retrieving <entity>.");

        // GET: api/manager/<entity>/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id) =>
            await HandleRequestAsync(async () =>
            {
                var data = await _<entity>Service.GetById(id);
                return data == null ? NotFound() : Ok(data);
            }, "An error occurred while retrieving <entity>.");

        // POST: api/manager/<entity>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] <Entity>Update model) =>
            await HandleRequestAsync(async () =>
            {
                var record = await _<entity>Service.Create(model);
                if (record == null) return BadRequest("Failed to create <entity>.");

                return CreatedAtAction(nameof(GetById), new { id = record.Guid }, record);
            }, "An error occurred while creating <entity>.");

        // PUT: api/manager/<entity>/{id}
        [HttpPut("{id:guid}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] <Entity>Update model) =>
            await HandleRequestAsync(async () =>
            {
                var updated = await _<entity>Service.Update(id, model);
                return !updated ? NotFound() : NoContent();
            }, "An error occurred while updating <entity>.");

        // DELETE: api/manager/<entity>/{id}
        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> Delete(Guid id) =>
            await HandleRequestAsync(async () =>
            {
                var deleted = await _<entity>Service.Delete(id);
                return !deleted ? NotFound() : NoContent();
            }, "An error occurred while deleting <entity>.");
    }
}
``
