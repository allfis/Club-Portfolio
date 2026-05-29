using System;

public class Event
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public string ImageUrl { get; set; }
    public string Location { get; set; }
    public DateTime EventDate { get; set; }
    public string Status { get; set; }      // "upcoming" or "past"
    public string Visibility { get; set; }  // "visible" or "hidden"
    public DateTime CreatedAt { get; set; }
}