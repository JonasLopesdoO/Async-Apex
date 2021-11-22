@isTest
private class AccountProcessorTest {
    @isTest
    static void testAccountProcessor() {
        Account account = new Account(Name = 'test');
        insert account;
        Contact contact = new Contact(LastName = 'testContact', AccountId = account.Id);
        insert contact;
        
        Test.startTest();
            AccountProcessor.countContacts(new List<Id>{account.Id});
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Number_Of_Contacts__c FROM Account];

        for (Account acc : accounts) {
            System.assert(acc.Number_Of_Contacts__c != null, 'Number of contacts not changed');
        }
    }
}
