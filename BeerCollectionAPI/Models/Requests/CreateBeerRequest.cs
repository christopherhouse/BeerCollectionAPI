namespace BeerCollectionAPI.Models.Requests;

public class CreateBeerRequest
{
    public string BeerName { get; set; }

    public string Brewery { get; set; }

    public string Style { get; set; }

    public string ImagePath { get; set; }

    public string TastingNotes { get; set; }

    public int? Vintage { get; set; }

    public decimal? Rating { get; set; }

    public int QuantityOnHand { get; set; }
}
