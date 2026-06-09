<%@ WebHandler Language="C#" Class="chatbot" %>

using System;
using System.IO;
using System.Web;

public class chatbot : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        try
        {
            string body =
                new StreamReader(context.Request.InputStream).ReadToEnd();

            body = body.ToLower();

            string answer = "";

            if (body.Contains("join"))
            {
                answer = "Students can join KUET Career Club (KCC) through our Facebook page, email (kuetcareerclub@gmail.com), or by using the contact form on the website. Membership is open to all KUET students.";
            }
            else if (body.Contains("event"))
            {
                answer = "KCC organizes BizBash, BCS On The Run, Career Seminars, Study Abroad Sessions, Skill Development Workshops, Career Festivals, and Alumni Mentorship programs.";
            }
            else if (body.Contains("bizbash") || body.Contains("biz bash"))
            {
                answer = "BizBash is KCC's flagship business case competition. It helps students develop business, problem-solving, presentation, and teamwork skills through real-world case challenges.";
            }
            else if (body.Contains("bcs"))
            {
                answer = "KCC organizes 'BCS On The Run', where successful BCS cadres share preparation strategies, experiences, and guidance with KUET students.";
            }
            else if (body.Contains("study abroad") ||
                     body.Contains("higher study") ||
                     body.Contains("scholarship"))
            {
                answer = "KCC provides higher study guidance including GRE, IELTS, TOEFL preparation, SOP writing tips, scholarship information, and study abroad sessions.";
            }
            else if (body.Contains("contact"))
            {
                answer = "You can contact KCC via email: kuetcareerclub@gmail.com or phone: +880 1842-222493.";
            }
            else if (body.Contains("president"))
            {
                answer = "The President of KUET Career Club (KCC) is Md. Jubaer Rahman.";
            }
            else if (body.Contains("vice president") ||
                     body.Contains("vp"))
            {
                answer = "The Vice President of KUET Career Club (KCC) is Abdullah Al Naeem.";
            }
            else if (body.Contains("location") ||
                     body.Contains("where") ||
                     body.Contains("address"))
            {
                answer = "KCC is based at Khulna University of Engineering & Technology (KUET), Khulna-9203, Bangladesh.";
            }
            else if (body.Contains("hello") ||
                     body.Contains("hi") ||
                     body.Contains("hey"))
            {
                answer = "Hello! 👋 I'm the KCC Assistant. Ask me about KCC events, membership, BizBash, BCS preparation, study abroad opportunities, and more.";
            }
            else if (body.Contains("hello") ||
         body.Contains("hi") ||
         body.Contains("hey"))
{
    answer = "Hello! 👋 Welcome to KUET Career Club (KCC). I'm here to help you with information about our events, membership, BCS preparation, study abroad opportunities, and more.";
}
else if (body.Contains("how are you"))
{
    answer = "I'm doing great! 😊 Thank you for asking. How can I help you with KUET Career Club today?";
}
else if (body.Contains("who are you"))
{
    answer = "I'm KCC Assistant 🤖, the virtual assistant of KUET Career Club. I can answer questions about KCC programs, events, membership, and career development opportunities.";
}
else if (body.Contains("thank you") ||
         body.Contains("thanks"))
{
    answer = "You're welcome! 😊 Feel free to ask if you have any other questions about KUET Career Club.";
}
else if (body.Contains("bye") ||
         body.Contains("goodbye"))
{
    answer = "Goodbye! 👋 Have a great day and stay connected with KUET Career Club.";
}
else if (body.Contains("membership"))
{
    answer = "KCC membership is open to all KUET students. You can contact us through our Facebook page, email, or website contact form for membership details.";
}
else if (body.Contains("email"))
{
    answer = "📧 KCC Email: kuetcareerclub@gmail.com";
}
else if (body.Contains("phone") ||
         body.Contains("mobile") ||
         body.Contains("number"))
{
    answer = "📞 KCC Contact Number: +880 1842-222493";
}
else if (body.Contains("facebook"))
{
    answer = "🌐 You can find KCC on Facebook at: facebook.com/kuetcareerclub";
}
else if (body.Contains("youtube"))
{
    answer = "▶️ KCC YouTube Channel: youtube.com/c/KUETCareerClub";
}
else if (body.Contains("linkedin"))
{
    answer = "💼 KCC LinkedIn: bd.linkedin.com/company/kuetcareerclub";
}
else if (body.Contains("workshop"))
{
    answer = "KCC regularly organizes workshops on MS Excel, presentation skills, prompt engineering, career planning, and professional development.";
}
else if (body.Contains("career"))
{
    answer = "KCC helps students prepare for their future careers through seminars, competitions, mentorship programs, networking opportunities, and skill development workshops.";
}
else if (body.Contains("podcast"))
{
    answer = "🎙️ KCC runs the 'On The Run' podcast where successful professionals and BCS cadres share their experiences and career journeys.";
}
else if (body.Contains("mou") ||
         body.Contains("interactive cares"))
{
    answer = "KCC has collaborated with Interactive Cares through an MoU to provide learning opportunities and benefits for students.";
}
            else
            {
                answer = "I can help with KCC-related topics such as membership, BizBash, BCS preparation, study abroad guidance, events, leadership, and contact information. Please ask a specific question.";
            }

            context.Response.Write(
                "{\"reply\":\"" +
                EscapeJson(answer) +
                "\"}"
            );
        }
        catch (Exception ex)
        {
            context.Response.Write(
                "{\"reply\":\"Error: " +
                EscapeJson(ex.Message) +
                "\"}"
            );
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }

    private string EscapeJson(string text)
    {
        if (text == null) return "";

        return text
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("\r", "")
            .Replace("\n", "\\n");
    }
}