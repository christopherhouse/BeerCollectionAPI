using BeerCollectionAPI.Models.Requests;

namespace BeerCollectionAPI.Data.Models;

public class Beer
{
    public string Id { get; set; }

    public string BeerName { get; set; }

    public string Brewery { get; set; }

    public string Style { get; set; }

    public string ImagePath { get; set; }

    public string TastingNotes { get; set; }

    public int? Vintage { get; set; }

    public decimal? Rating { get; set; }

    public int QuantityOnHand { get; set; }

    public static Beer FromCreateBeerRequest(CreateBeerRequest request)
    {
        return new Beer
        {
            BeerName = request.BeerName,
            Brewery = request.Brewery,
            Style = request.Style,
            ImagePath = request.ImagePath,
            TastingNotes = request.TastingNotes,
            Vintage = request.Vintage,
            Rating = request.Rating,
            QuantityOnHand = request.QuantityOnHand,
        };
    }
}
