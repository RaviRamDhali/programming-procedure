using Newtonsoft.Json;
using System.Diagnostics;
using WebApi.Helpers; // Add this using statement for our new helper

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("IRCConnection");

if (connectionString.IsNotNullOrEmpty())
    new Service.Configuration.AppConfiguration().SetDbConnectionString(connectionString);
else
    throw new Exception("IRCConnection not found in appConfiguration!");


// Jwt auth options
builder.Services.Configure<Authentication.AuthOptions>(builder.Configuration.GetSection("AuthOptions"));
var authOptions = builder.Configuration.GetSection("AuthOptions").Get<Authentication.AuthOptions>();

// Application Settings
builder.Services.Configure<Service.Configuration.AppSettings>(builder.Configuration.GetSection("AppSettings"));
builder.Configuration.GetSection("AppSettings").Get<Service.Configuration.AppSettings>();
var appEnv = builder.Configuration.GetSection("AppSettings:AppEnv").Get<string>();


// The following line enables Application Insights telemetry collection.
builder.Services.AddApplicationInsightsTelemetry();

// Map interfaces to concrete classes, used for Dependency Injection
DependencyInjectionExt.AddScopedServices(builder.Services);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


builder.Services.AddAuthentication("Bearer")
    .AddJwtBearer("Bearer", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = authOptions.Issuer,

            ValidateAudience = true,
            ValidAudience = authOptions.Audience,

            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(authOptions.SecureKey))
        };
    });

builder.Services.AddHttpContextAccessor(); // Register IHttpContextAccessor

// Configure CORS
builder.Services.AddCors(CorsConfigHelper.GetCorsOptionsConfiguration(builder.Configuration));


var app = builder.Build();


app.MapGet("/debug/config", (Microsoft.Extensions.Configuration.IConfiguration config) =>
{
    var allowedOrigins = CorsConfigHelper.GetAllowedOrigins(config);
    
    return new
    {
        AllowedOrigins = allowedOrigins,
        RawAllowedOrigins = config["AppSettings:AllowedOrigins"],

        // More detailed debugging:
        AppSettingsSection = config.GetSection("AppSettings").Exists(),
        AllowedOriginsSection = config.GetSection("AppSettings:AllowedOrigins").Exists(),
        AppSettingsValue = config.GetSection("AppSettings").Value,

        // Check different ways to access:
        DirectAppSettings = config["AppSettings"],
        AllAppSettingsKeys = config.GetSection("AppSettings").GetChildren().Select(x => x.Key).ToArray(),

        // Raw config dump:
        AllConfigurationKeys = config.AsEnumerable()
            .Where(x => x.Key.StartsWith("AppSettings"))
            .ToDictionary(x => x.Key, x => x.Value)
    };
}).AllowAnonymous();

// Custom CORS get from appsettings.json and github variable
app.UseCors(CorsConfigHelper.DefaultCorsPolicyName);

app.UseSwagger();
app.UseSwaggerUI();

if (app.Environment.IsDevelopment() || appEnv == "DEV")
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

// Register the custom middleware
app.UseMiddleware<WebApi.Middleware.AuthenticationMiddleware>();


app.MapControllers();

app.Run();