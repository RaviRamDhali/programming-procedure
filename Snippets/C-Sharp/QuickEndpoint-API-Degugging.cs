## 

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
