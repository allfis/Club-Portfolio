using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class EventController
{
    private KCCDbContext db = new KCCDbContext();

    // Get all visible events
    public List<Event> GetVisibleEvents()
    {
        return db.Events
            .Where(e => e.Visibility == "visible")
            .OrderByDescending(e => e.EventDate)
            .ToList();
    }

    // Get upcoming events only
    public List<Event> GetUpcomingEvents()
    {
        return db.Events
            .Where(e => e.Visibility == "visible" && e.Status == "upcoming")
            .OrderBy(e => e.EventDate)
            .ToList();
    }

    // Get past events only
    public List<Event> GetPastEvents()
    {
        return db.Events
            .Where(e => e.Visibility == "visible" && e.Status == "past")
            .OrderByDescending(e => e.EventDate)
            .ToList();
    }

    // Get all events (admin)
    public List<Event> GetAllEvents()
    {
        return db.Events
            .OrderByDescending(e => e.CreatedAt)
            .ToList();
    }

    // Add event
    public void AddEvent(Event ev)
    {
        ev.CreatedAt = DateTime.Now;
        db.Events.Add(ev);
        db.SaveChanges();
    }

    // Edit event
    public void UpdateEvent(Event ev)
    {
        var existing = db.Events.Find(ev.Id);
        if (existing == null) return;
        existing.Title = ev.Title;
        existing.Description = ev.Description;
        existing.Location = ev.Location;
        existing.EventDate = ev.EventDate;
        existing.Status = ev.Status;
        existing.Visibility = ev.Visibility;
        existing.ImageUrl = ev.ImageUrl;
        db.SaveChanges();
    }

    // Toggle visibility
    public void ToggleVisibility(int id)
    {
        var ev = db.Events.Find(id);
        if (ev == null) return;
        ev.Visibility = ev.Visibility == "visible" ? "hidden" : "visible";
        db.SaveChanges();
    }

    // Delete event
    public void DeleteEvent(int id)
    {
        var ev = db.Events.Find(id);
        if (ev == null) return;
        db.Events.Remove(ev);
        db.SaveChanges();
    }
}