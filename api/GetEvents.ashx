<%@ WebHandler Language="C#" Class="GetEvents" %>
using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Linq;

public class GetEvents : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            var db = new KCCDbContext();
            string type = (context.Request.QueryString["type"] ?? "all").ToLower().Trim();
            string idStr = context.Request.QueryString["id"];
            var serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;

            // Single event by ID
            if (!string.IsNullOrEmpty(idStr))
            {
                int id = int.Parse(idStr);
                var ev = db.Events.Find(id);
                if (ev == null)
                {
                    context.Response.Write("{\"error\":\"Not found\"}");
                    return;
                }
                context.Response.Write(serializer.Serialize(ev));
                return;
            }

            object events;

            if (type == "upcoming")
            {
                events = db.Events
                    .Where(e => e.Status.ToLower() == "upcoming" && e.Visibility.ToLower() == "visible")
                    .OrderBy(e => e.EventDate).ToList();
            }
            else if (type == "past")
            {
                events = db.Events
                    .Where(e => e.Status.ToLower() == "past" && e.Visibility.ToLower() == "visible")
                    .OrderByDescending(e => e.EventDate).ToList();
            }
            else if (type == "admin")
            {
                events = db.Events
                    .OrderByDescending(e => e.CreatedAt).ToList();
            }
            else if (type == "home")
            {
                // Homepage: max 4, upcoming first then past
                var upcoming = db.Events
                    .Where(e => e.Status.ToLower() == "upcoming" && e.Visibility.ToLower() == "visible")
                    .OrderBy(e => e.EventDate).ToList();
                var past = db.Events
                    .Where(e => e.Status.ToLower() == "past" && e.Visibility.ToLower() == "visible")
                    .OrderByDescending(e => e.EventDate).ToList();
                upcoming.AddRange(past);
                events = upcoming.Take(4).ToList();
            }
            else
            {
                // all visible
                var upcoming = db.Events
                    .Where(e => e.Status.ToLower() == "upcoming" && e.Visibility.ToLower() == "visible")
                    .OrderBy(e => e.EventDate).ToList();
                var past = db.Events
                    .Where(e => e.Status.ToLower() == "past" && e.Visibility.ToLower() == "visible")
                    .OrderByDescending(e => e.EventDate).ToList();
                upcoming.AddRange(past);
                events = upcoming;
            }

            context.Response.Write(serializer.Serialize(events));
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"error\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}