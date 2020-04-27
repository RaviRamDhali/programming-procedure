 
 ### \App_Start\WebApiConfig.cs ###
 
```c#
public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            config.Formatters.JsonFormatter.SupportedMediaTypes
                .Add(new MediaTypeHeaderValue("text/html"));


            // Web API routes
            config.MapHttpAttributeRoutes();
```



### Controllers.Api ###

```c#
namespace WebApplication.Controllers.Api
{
    public class DefaultController : ApiController
    {
        // GET: api/Default
        [Route ("api/")]
        public IHttpActionResult Get()
        {
            var result = new Dictionary<string, string>();
            result.Add("name", "api");
            result.Add("datetime", DateTime.Now.ToString());
            result.Add("dbconnection", (1==1).ToString());
            return Ok(result);
        }

        // GET: api/Default/5 
        public IHttpActionResult Get(int id)
        {
            return Ok("get by id");
        }
    }
}
```
