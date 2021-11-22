public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Name, Number_Of_Contacts__c, (SELECT Id FROM Contacts) FROM ACCOUNT];

        for (Account acc : accounts) {
            List<Contact> contacts = acc.contacts;
            acc.Number_Of_Contacts__c = contacts.size();
        }

        update accounts;
    }
}
