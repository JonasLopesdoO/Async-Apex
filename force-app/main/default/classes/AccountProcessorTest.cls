@isTest
private class AccountProcessorTest {
    @isTest
    static void testAccountProcessor() {
        Test.startTest();

        Test.stopTest();

        List<Account> accounts = [SELECT Id, Number_Of_Contacts__c FROM Account];

        for (Account acc : accounts) {
            System.assert(acc.Number_Of_Contacts__c != null);
        }
    }
}
