<%@ WebHandler Language="C#" Class="RegisterEvent" %>
using System;
using System.Web;

public class RegisterEvent : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            string fullName = context.Request.Form["fullName"];
            string studentId = context.Request.Form["studentId"];
            string department = context.Request.Form["department"];
            string year = context.Request.Form["year"];
            string email = context.Request.Form["email"];
            string eventName = context.Request.Form["eventName"];

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(eventName))
            {
                context.Response.Write("{\"success\":false,\"message\":\"Missing required fields\"}");
                return;
            }

            var reg = new Registration
            {
                FullName = fullName,
                StudentId = studentId,
                Department = department,
                Year = year,
                Email = email,
                EventName = eventName,
                RegisteredAt = DateTime.Now
            };

            var controller = new RegistrationController();
            controller.AddRegistration(reg);

            context.Response.Write("{\"success\":true,\"message\":\"Registration successful\"}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}