﻿using BeerCollectionAPI.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace BeerCollectionAPI.Data;

public class BeerCollectionContext : DbContext
{
    public BeerCollectionContext(DbContextOptions<BeerCollectionContext> options) : base(options)
    {
    }

    public DbSet<Beer> Beers { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(BeerCollectionContext).Assembly);
    }
}
