using System;
using System.Collections.Generic;
using System.Linq;

public class ContactController
{
    private KCCDbContext db = new KCCDbContext();

    // Add contact form submission
    public void AddContact(ContactForm contact)
    {
        contact.SubmittedAt = DateTime.Now;
        db.ContactForms.Add(contact);
        db.SaveChanges();
    }

    // Get all contact forms (admin)
    public List<ContactForm> GetAllContacts()
    {
        return db.ContactForms
            .OrderByDescending(c => c.SubmittedAt)
            .ToList();
    }

    // Delete contact form
    public void DeleteContact(int id)
    {
        var contact = db.ContactForms.Find(id);
        if (contact == null) return;
        db.ContactForms.Remove(contact);
        db.SaveChanges();
    }
}