using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace BeerCollectionAPI.Probes;

public class HealthCheck : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = new CancellationToken())
    {
        var isHealthy = true; // TODO:  Do some more sophisticated health checking

        return isHealthy
            ? Task.FromResult(HealthCheckResult.Healthy("Healthy"))
            : Task.FromResult(new HealthCheckResult(context.Registration.FailureStatus, "Unhealthy"));
    }
}
