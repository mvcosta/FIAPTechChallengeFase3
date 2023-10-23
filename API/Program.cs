using Infrastructure.Payment.MercadoPago;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using System.Reflection;
using System.Text.Json.Serialization;
using System.Xml.Linq;

namespace API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.IgnoreNullValues = true;
                options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
            });

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            Infrastructure.Persistence.Settings.PostgreSQLConnectionString = Settings.PostgreSQLConnectionString;

            builder.Services.AddTransient<Application.Interfaces.UseCases.IClienteUseCase, Application.Implementations.ClienteUseCase>();
            builder.Services.AddTransient<Application.Interfaces.Repositories.IClienteRepository, Infrastructure.Persistence.Repositories.ClienteRepository>();

            builder.Services.AddTransient<Application.Interfaces.UseCases.IProdutoUseCase, Application.Implementations.ProdutoUseCase>();
            builder.Services.AddTransient<Application.Interfaces.Repositories.IProdutoRepository, Infrastructure.Persistence.Repositories.ProdutoRepository>();

            builder.Services.AddTransient<Application.Interfaces.UseCases.IPedidoUseCase, Application.Implementations.PedidoUseCase>();
            builder.Services.AddTransient<Application.Interfaces.Repositories.IPedidoRepository, Infrastructure.Persistence.Repositories.PedidoRepository>();

            builder.Services.AddTransient<Application.Interfaces.UseCases.IPaymentUseCase, MercadoPagoUseCase>();


            ConfigSwagger(builder);

            var app = builder.Build();
            // Configure the HTTP request pipeline.

            app.UseSwagger();
            app.UseSwaggerUI();



            app.UseHttpsRedirection();
            app.UseAuthorization();
            app.MapControllers();

            app.UseRouting();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapGet("/", context =>
                {
                    context.Response.Redirect("/swagger/");
                    return Task.CompletedTask;
                });

                // outros mapeamentos de endpoints
            });

            app.Run();
        }


        static void ConfigSwagger(WebApplicationBuilder builder)
        {
            builder.Services.AddSwaggerGen(doc =>
            {
                doc.SwaggerDoc("v1", new OpenApiInfo { Title = "API Fiap", Version = "v1" });
                doc.CustomSchemaIds(x => x.FullName.Replace($"{AppDomain.CurrentDomain.FriendlyName}.", ""));


                var xmlPathApi = Path.Combine(AppContext.BaseDirectory, "API.xml");
                var xmlPathDto = Path.Combine(AppContext.BaseDirectory, "Application.xml");

                var mergedXmlPath = MergeXmlDocs(xmlPathApi, xmlPathDto);
                doc.IncludeXmlComments(mergedXmlPath);


                //doc.CustomSchemaIds(type => type.FullName);
                //var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
                //var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
                //doc.IncludeXmlComments(xmlPath);

                //var xmlDtoPath = Path.Combine(AppContext.BaseDirectory, "Application.xml");
                //doc.IncludeXmlComments(xmlDtoPath);
            });
        }

        static string MergeXmlDocs(string xmlPath1, string xmlPath2)
        {
            var xml1 = XDocument.Load(xmlPath1);
            var xml2 = XDocument.Load(xmlPath2);

            foreach (var element in xml2.Root.Element("members").Elements())
            {
                xml1.Root.Element("members").Add(element);
            }

            var mergedXmlPath = Path.Combine(AppContext.BaseDirectory, "MergedSwagger.xml");
            xml1.Save(mergedXmlPath);

            return mergedXmlPath;
        }
    }
}