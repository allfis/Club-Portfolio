using System.Data.Entity;

public class KCCDbContext : DbContext
{
    public KCCDbContext() : base("name=KCCDb")
    {
    }

    public DbSet<Event> Events { get; set; }
    public DbSet<Registration> Registrations { get; set; }
    public DbSet<ContactForm> ContactForms { get; set; }
}