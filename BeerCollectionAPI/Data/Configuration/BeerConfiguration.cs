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
    }
}
