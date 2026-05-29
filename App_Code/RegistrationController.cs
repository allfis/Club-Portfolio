using System;
using System.Collections.Generic;
using System.Linq;

public class RegistrationController
{
    private KCCDbContext db = new KCCDbContext();

    // Add registration
    public void AddRegistration(Registration reg)
    {
        reg.RegisteredAt = DateTime.Now;
        db.Registrations.Add(reg);
        db.SaveChanges();
    }

    // Get all registrations (admin)
    public List<Registration> GetAllRegistrations()
    {
        return db.Registrations
            .OrderByDescending(r => r.RegisteredAt)
            .ToList();
    }

    // Get registrations by event
    public List<Registration> GetByEvent(string eventName)
    {
        return db.Registrations
            .Where(r => r.EventName == eventName)
            .OrderByDescending(r => r.RegisteredAt)
            .ToList();
    }

    // Delete registration
    public void DeleteRegistration(int id)
    {
        var reg = db.Registrations.Find(id);
        if (reg == null) return;
        db.Registrations.Remove(reg);
        db.SaveChanges();
    }
}