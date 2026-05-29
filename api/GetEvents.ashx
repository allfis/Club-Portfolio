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
            string type = (context.Request.QueryString["type"] ?? "all").ToLower().Trim();
            var db = new KCCDbContext();
            var query = db.Events.AsQueryable();

            if (type == "upcoming")
                query = query.Where(e => e.Status.ToLower() == "upcoming" && e.Visibility.ToLower() == "visible");
            else if (type == "past")
                query = query.Where(e => e.Status.ToLower() == "past" && e.Visibility.ToLower() == "visible");
            else if (type == "admin")
                query = query.OrderByDescending(e => e.CreatedAt);
            else
                query = query.Where(e => e.Visibility.ToLower() == "visible");

            var events = query.OrderByDescending(e => e.CreatedAt).ToList();
            var serializer = new JavaScriptSerializer();
            context.Response.Write(serializer.Serialize(events));
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"error\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}