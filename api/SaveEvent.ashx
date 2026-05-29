<%@ WebHandler Language="C#" Class="SaveEvent" %>
using System;
using System.Web;

public class SaveEvent : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            string idStr = context.Request.Form["id"];
            string title = context.Request.Form["title"];
            string description = context.Request.Form["description"];
            string location = context.Request.Form["location"];
            string dateStr = context.Request.Form["date"];
            string status = context.Request.Form["status"];
            string visibility = context.Request.Form["visibility"];

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(dateStr))
            {
                context.Response.Write("{\"success\":false,\"message\":\"Missing required fields\"}");
                return;
            }

            var ev = new Event
            {
                Title = title,
                Description = description,
                Location = location,
               EventDate = string.IsNullOrEmpty(dateStr) ? DateTime.Now : DateTime.Parse(dateStr),
                Status = status,
                Visibility = visibility
            };

            var controller = new EventController();

            if (!string.IsNullOrEmpty(idStr) && idStr != "0")
            {
                ev.Id = int.Parse(idStr);
                controller.UpdateEvent(ev);
            }
            else
            {
                controller.AddEvent(ev);
            }

            context.Response.Write("{\"success\":true}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message + "\"}");
        }
    }

       public bool IsReusable
{
    get { return false; }
}
}