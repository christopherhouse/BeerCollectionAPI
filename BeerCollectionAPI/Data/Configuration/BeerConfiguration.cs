using BeerCollectionAPI.Data.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace BeerCollectionAPI.Data.Configuration;

public class BeerConfiguration : IEntityTypeConfiguration<Beer>
{
    public void Configure(EntityTypeBuilder<Beer> builder)
    {
        builder.HasPartitionKey(_ => _.Brewery);
        builder.UseETagConcurrency();
        builder.ToContainer("beers");
        builder.Property(_ => _.Id)
            .ToJsonProperty("id")
            .ValueGeneratedOnAdd();
        builder.Property(_ => _.BeerName)
            .ToJsonProperty("beerName");
        builder.Property(_ => _.Brewery)
            .ToJsonProperty("brewery");
        builder.Property(_ => _.Style)
            .ToJsonProperty("style");
        builder.Property(_ => _.ImagePath)
            .ToJsonProperty("imagePath");
        builder.Property(_ => _.TastingNotes)
            .ToJsonProperty("tastingNotes");
        builder.Property(_ => _.Vintage)
            .ToJsonProperty("vintage");
        builder.Property(_ => _.Rating)
            .ToJsonProperty("rating");
        builder.Property(_ => _.QuantityOnHand)
            .ToJsonProperty("quantityOnHand");
    }
}
