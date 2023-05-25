using System.Net;
using BeerCollectionAPI.Data;
using BeerCollectionAPI.Data.Models;
using BeerCollectionAPI.Models.Requests;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BeerCollectionAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class BeerController : ControllerBase
{
    private readonly BeerCollectionContext _dbContext;

    public BeerController(BeerCollectionContext dbContext)
    {
        _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<Beer>), StatusCodes.Status200OK)]
    public async Task<IActionResult> Get()
    {
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
