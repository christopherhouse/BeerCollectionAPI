using System.Net;
using BeerCollectionAPI.Data;
using BeerCollectionAPI.Data.Models;
using BeerCollectionAPI.Models.Requests;
using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BeerCollectionAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class BeerController : ControllerBase
{
    private readonly BeerCollectionContext _dbContext;
    private readonly TelemetryClient _telemetryClient;
    private readonly IConfiguration _configuration;

    public BeerController(BeerCollectionContext dbContext, TelemetryClient telemetryClient, IConfiguration config)
    {
        _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
        _telemetryClient = telemetryClient ?? throw new ArgumentNullException();
        _configuration = config;
    }

    [HttpGet("/bad")]
    public async Task<IActionResult> Bad()
    {
        var cs = _configuration["appinsights-connection-string"];

        var thingToReturn = cs == null ? "NULL" : $"{cs.Substring(0, 25)}";

        return new OkObjectResult(new { cs = thingToReturn });
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<Beer>), StatusCodes.Status200OK)]
    public async Task<IActionResult> Get()
    {
        _telemetryClient.TrackEvent("HTTP GET - /beer");
        var beers = await _dbContext.Beers.ToListAsync();

        return new OkObjectResult(beers);
    }

    [HttpGet("{beerId}")]
    [ProducesResponseType(typeof(Beer), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(string beerId)
    {
        IActionResult result = null;

        var beer = await _dbContext.Beers.FirstOrDefaultAsync(_ => _.Id == beerId);

        if (beer != null)
        {
            result = new OkObjectResult(beer);
        }
        else
        {
            result = new NotFoundResult();
        }

        return result;
    }

    [HttpGet("/brewery/{breweryName}")]
    [ProducesResponseType(typeof(IEnumerable<Beer>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> SearchByBrewery(string breweryName)
    {
        IActionResult result;

        var beers = await _dbContext.Beers
            .Where(_ => _.Brewery == breweryName)
            .ToListAsync();

        if (beers.Any())
        {
            result = Ok(beers);
        }
        else
        {
            result = NotFound();
        }

        return result;
    }

    [HttpGet("/style/{styleName}")]
    [ProducesResponseType(typeof(IEnumerable<Beer>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> SearchByStyle(string styleName)
    {
        IActionResult result;

        var beers = await _dbContext.Beers
            .Where(_ => _.Style == styleName)
            .ToListAsync();

        if (beers.Any())
        {
            result = Ok(beers);
        }
        else
        {
            result = NotFound();
        }

        return result;
    }

    [HttpPost()]
    [ProducesResponseType(typeof(Beer), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Post(CreateBeerRequest? beerRequest)
    {
        IActionResult result;

        if (beerRequest != null)
        {
            var beer = Beer.FromCreateBeerRequest(beerRequest);
            await _dbContext.AddAsync(beer);
            await _dbContext.SaveChangesAsync();

            result = new OkObjectResult(beer);
        }
        else
        {
            result = new BadRequestResult();
        }

        return result;
    }

    [HttpDelete("{beerId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(string beerId)
    {
        IActionResult result;

        var beer = await _dbContext.Beers.FirstOrDefaultAsync(_ => _.Id == beerId);

        if (beer != null)
        {
            _dbContext.Beers.Remove(beer);
            await _dbContext.SaveChangesAsync();
            result = new NoContentResult();
        }
        else
        {
            result = new NotFoundResult();
        }

        return result;
    }
}
