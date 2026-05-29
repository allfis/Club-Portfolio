<%@ WebHandler Language="C#" Class="SubmitContact" %>
using System;
using System.Web;

public class SubmitContact : IHttpHandler
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
            string email = context.Request.Form["email"];
            string message = context.Request.Form["message"];

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
            {
                context.Response.Write("{\"success\":false,\"message\":\"Missing required fields\"}");
                return;
            }

            var contact = new ContactForm
            {
                FullName = fullName,
                StudentId = studentId,
                Department = department,
                Email = email,
                Message = message,
                SubmittedAt = DateTime.Now
            };

            var controller = new ContactController();
            controller.AddContact(contact);

            context.Response.Write("{\"success\":true,\"message\":\"Message sent successfully\"}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}