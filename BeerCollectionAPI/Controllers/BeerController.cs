using BeerCollectionAPI.Data;
using Microsoft.AspNetCore.Mvc;

namespace BeerCollectionAPI.Controllers;

public class BeerController : ControllerBase
{
    private readonly BeerCollectionContext _dbContext;

    public BeerController(BeerCollectionContext dbContext)
    {
        _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
    }
}
