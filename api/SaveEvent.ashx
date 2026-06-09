<%@ WebHandler Language="C#" Class="SaveEvent" %>

using System;
using System.IO;
using System.Web;

public class SaveEvent : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            var db = new KCCDbContext();

            int id = Convert.ToInt32(
                context.Request.Form["id"] ?? "0"
            );

            Event ev;

            if (id > 0)
            {
                ev = db.Events.Find(id);

                if (ev == null)
                {
                    context.Response.Write(
                        "{\"success\":false,\"message\":\"Event not found\"}"
                    );
                    return;
                }
            }
            else
            {
                ev = new Event();
                ev.CreatedAt = DateTime.Now;

                db.Events.Add(ev);
            }

            ev.Title = context.Request.Form["title"];
            ev.Description = context.Request.Form["description"];
            ev.Location = context.Request.Form["location"];
            ev.Status = context.Request.Form["status"];
            ev.Visibility = context.Request.Form["visibility"];

            DateTime eventDate;

            if (DateTime.TryParse(
                context.Request.Form["date"],
                out eventDate))
            {
                ev.EventDate = eventDate;
            }

            HttpPostedFile image =
                context.Request.Files["image"];

            if (image != null && image.ContentLength > 0)
            {
                string uploadsFolder =
                    context.Server.MapPath("~/uploads/");

                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                }

                string fileName =
                    Guid.NewGuid().ToString()
                    + Path.GetExtension(image.FileName);

                string fullPath =
                    Path.Combine(uploadsFolder, fileName);

                image.SaveAs(fullPath);

                ev.ImageUrl = "/uploads/" + fileName;
            }

            db.SaveChanges();

            context.Response.Write("{\"success\":true}");
        }
        catch (Exception ex)
        {
            context.Response.Write(
                "{\"success\":false,\"message\":\""
                + ex.Message.Replace("\"", "")
                + "\"}"
            );
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}