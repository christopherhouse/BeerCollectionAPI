using System.Net;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace BeerCollectionAPI.Telemetry;

public class CloudRoleNameTelemetryInitializer : ITelemetryInitializer
{
    public void Initialize(ITelemetry telemetry)
    {
        telemetry.Context.Cloud.RoleName = "Beer Collection API Container";

        var instanceName = Dns.GetHostName();

        if (string.IsNullOrWhiteSpace(instanceName))
        {
            instanceName = Guid.NewGuid().ToString();
        }

        telemetry.Context.Cloud.RoleInstance = instanceName;

        Console.WriteLine($"**** Telemetry initialized Role={telemetry.Context.Cloud.RoleName}, Instance={instanceName} ****");
        Console.WriteLine($"**** iKey={telemetry.Context.InstrumentationKey} ****");
    }
}
