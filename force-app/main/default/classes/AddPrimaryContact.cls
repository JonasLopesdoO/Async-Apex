public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState =: this.state LIMIT 200];
        List<Contact> contacts = new List<Contact>(); 

        for (Account acc : accounts) {
            Contact contactClone = this.contact.clone();
            contactClone.AccountId = acc.Id;
            contacts.add(contactClone);
        }

        insert contacts;
    }
    
}