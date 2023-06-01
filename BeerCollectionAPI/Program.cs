using System.Text.Json;
using BeerCollectionAPI.Data;
using BeerCollectionAPI.Probes;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.EntityFrameworkCore;

namespace BeerCollectionAPI;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddControllers()
            .AddJsonOptions(_ =>
            {
                _.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
                _.JsonSerializerOptions.WriteIndented = true;
            });

        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();
        builder.Services.AddHealthChecks().AddCheck<HealthCheck>("Health Check");
        builder.Services.AddDbContext<BeerCollectionContext>(options =>
            options.UseCosmos(builder.Configuration["cosmos-connection-string"],
                builder.Configuration["cosmos-database-name"]));
        builder.Services.AddApplicationInsightsTelemetry(_ => new ApplicationInsightsServiceOptions
        {
            ConnectionString = builder.Configuration["appinsights-connection-string"],
            EnableDependencyTrackingTelemetryModule = true,
            EnableRequestTrackingTelemetryModule = true,
            EnableDiagnosticsTelemetryModule = true,
            EnableQuickPulseMetricStream = true
        });
        
        var app = builder.Build();

        // Configure the HTTP request pipeline.
        app.UseSwagger();
        app.UseSwaggerUI();
        app.UseHttpsRedirection();

        app.UseAuthorization();

        app.MapHealthChecks("/healthz");

        app.MapControllers();

        app.Run();
    }
}
