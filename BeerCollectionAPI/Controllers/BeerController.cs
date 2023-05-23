using BeerCollectionAPI.Data;
using BeerCollectionAPI.Data.Models;
using BeerCollectionAPI.Models.Requests;
using Microsoft.AspNetCore.Mvc;

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

    [HttpPost()]
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
}
