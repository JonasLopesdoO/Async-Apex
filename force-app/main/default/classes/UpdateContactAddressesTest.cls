@isTest
private class UpdateContactAddressesTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 100; i++) {
            Account account = new Account(
                Name = 'Account ' + i,
                BillingCity = 'New York', 
                BillingCountry = 'USA',
                BillingState = 'NY',
                BillingStreet = '1301 Avenue of the Americas New York, NY 10019USA'
            );
            accounts.add(account);
        }

        insert accounts;
        
        for (Account account : accounts) {
            Contact contact = new Contact(
                FirstName = 'first',
                LastName = 'last', 
                AccountId = account.id
            );

            contacts.add(contact);
        }

        insert contacts;
    }

    @isTest static void testBatchJob() {
        Test.startTest();
            UpdateContactAddresses batch = new UpdateContactAddresses();
            Id batchId = Database.executeBatch(batch);
        Test.stopTest();

        Integer contactSize = [SELECT Count() 
                               FROM Contact 
                               WHERE MailingCity = 'New York' 
                               AND MailingState = 'NY' 
                               AND MailingCountry = 'USA' 
                               AND MailingStreet = '1301 Avenue of the Americas New York, NY 10019USA'];
        System.assertEquals(100, contactSize);
    }
}
