<%@ WebHandler Language="C#" Class="DeleteItem" %>
using System;
using System.Web;

public class DeleteItem : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            string type = context.Request.Form["type"];
            int id = int.Parse(context.Request.Form["id"]);

            if (type == "event")
            {
                var controller = new EventController();
                controller.DeleteEvent(id);
            }
            else if (type == "registration")
            {
                var controller = new RegistrationController();
                controller.DeleteRegistration(id);
            }
            else if (type == "contact")
            {
                var controller = new ContactController();
                controller.DeleteContact(id);
            }

            context.Response.Write("{\"success\":true}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}