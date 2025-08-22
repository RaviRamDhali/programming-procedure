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
