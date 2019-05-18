using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BLL;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace anaxisoft
{
	public class Startup
	{
		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;

		}

		public IConfiguration Configuration { get; }

		// This method gets called by the runtime. Use this method to add services to the container.
		public void ConfigureServices(IServiceCollection services)
		{
			services.Configure<CookiePolicyOptions>(options =>
			{
				// This lambda determines whether user consent for non-essential cookies is needed for a given request.
				options.CheckConsentNeeded = context => true;
				options.MinimumSameSitePolicy = SameSiteMode.None;
			});



			//config the db connection string 
			// var connectionString = Configuration.GetConnectionString("SQLConnection");
			 
			services.AddDbContext<BLL.EFContext>(options => 
				options.UseSqlServer(Configuration.GetConnectionString("SQLConnection")));

			services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

			services.Configure<BLL.AppSettings>(Configuration.GetSection("AppSettings"));

			services.AddOptions();
			var section = Configuration.GetSection("AppSettings");
			services.Configure<BLL.AppSettings>(section);

			var config = new BLL.AppSettings();
			Configuration.Bind("AppSettings", config);
			services.AddSingleton(config);


		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public void Configure(IApplicationBuilder app, IHostingEnvironment env)
		{
			if (env.IsDevelopment())
			{
				app.UseDeveloperExceptionPage();
			}
			else
			{
				app.UseExceptionHandler("/Home/Error");
				app.UseHsts();
			}

			app.UseHttpsRedirection();
			app.UseStaticFiles();
			app.UseCookiePolicy();

			app.UseMvc(routes =>
			{
				routes.MapRoute(
					"Configuration",                                           // Route name
					"Configuration/{name}",                            // URL with parameters
					new { controller = "Configuration", action = "Index" }  // Parameter defaults
				);


				routes.MapRoute(
					name: "default",
					template: "{controller=Home}/{action=Index}/{id?}");
			});
		}
	}
}
