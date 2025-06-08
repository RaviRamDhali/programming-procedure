using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.Extensions.Configuration;
using System;
using System.Linq;

namespace WebApi.Helpers
{
    /// <summary>
    /// Helper class for CORS configuration-related operations
    /// </summary>
    public static class CorsConfigHelper
    {
        /// <summary>
        /// The name of the default CORS policy
        /// </summary>
        public const string DefaultCorsPolicyName = "AllowSpecificOrigin";
        
        /// <summary>
        /// Gets allowed origins from configuration
        /// </summary>
        /// <param name="configuration">The IConfiguration instance</param>
        /// <returns>Array of allowed origin URLs</returns>
        public static string[] GetAllowedOrigins(Microsoft.Extensions.Configuration.IConfiguration configuration)
        {
            var allowedOriginsString = configuration["AppSettings:AllowedOrigins"];
            
            if (string.IsNullOrEmpty(allowedOriginsString))
                return [];
                
            return allowedOriginsString
                .Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(origin => origin.Trim())
                .ToArray();
        }
        
        /// <summary>
        /// Creates a CORS configuration action that can be used with AddCors
        /// </summary>
        /// <param name="configuration">The IConfiguration instance</param>
        /// <returns>Action to configure CORS options</returns>
        public static Action<CorsOptions> GetCorsOptionsConfiguration(Microsoft.Extensions.Configuration.IConfiguration configuration)
        {
            return options =>
            {
                var allowedOrigins = GetAllowedOrigins(configuration);
                
                options.AddPolicy(DefaultCorsPolicyName, policy =>
                {
                    if (allowedOrigins != null && allowedOrigins.Length > 0)
                    {
                        policy.WithOrigins(allowedOrigins)
                            .AllowAnyHeader()
                            .AllowAnyMethod()
                            .AllowCredentials();
                    }
                    else
                    {
                        // Fallback or log error
                        Console.WriteLine("WARNING: No allowed origins configured!");
                    }
                });
            };
        }
    }
}