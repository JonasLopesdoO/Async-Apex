@isTest
private class AddPrimaryContactTest {
    @TestSetup
    static void createData(){
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < 500; i++) {
            Account account = new Account(Name = 'Test Account'+i);

            if (i < 250) {
                account.BillingState = 'NY';
            } else {
                account.BillingState = 'CA';
            }

            accounts.add(account);
        }
        
        insert accounts;

        Contact contact = new Contact(FirstName = 'YourFirstName', LastName = 'YourLastName');
        insert contact;
    }

    @isTest
    static void testAddPrimaryContact() {
        List<Contact> contact = [SELECT Id, AccountId, FirstName, LastName FROM Contact LIMIT 1];
        String state = 'NY';
        AddPrimaryContact queueable = new AddPrimaryContact(contact.get(0), state);

        Test.startTest();
            System.enqueueJob(queueable);
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE Account.BillingState =: state];
        System.assertEquals(200, contacts.size(), 'ERROR: Incorrect number of contacts');
    }
}