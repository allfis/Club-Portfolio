<%@ WebHandler Language="C#" Class="GetRegistrations" %>
using System;
using System.Web;
using System.Web.Script.Serialization;

public class GetRegistrations : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            string eventName = context.Request.QueryString["event"];
            var controller = new RegistrationController();
            object regs;

            if (!string.IsNullOrEmpty(eventName))
                regs = controller.GetByEvent(eventName);
            else
                regs = controller.GetAllRegistrations();

            var serializer = new JavaScriptSerializer();
            context.Response.Write(serializer.Serialize(regs));
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}