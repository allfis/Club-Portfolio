<%@ WebHandler Language="C#" Class="GetContacts" %>
using System;
using System.Web;
using System.Web.Script.Serialization;

public class GetContacts : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            var controller = new ContactController();
            var contacts = controller.GetAllContacts();

            var serializer = new JavaScriptSerializer();
            context.Response.Write(serializer.Serialize(contacts));
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