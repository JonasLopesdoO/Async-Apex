@isTest
public class UpdateParentAccountTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add a parent account
        accounts.add(new Account(Name = 'Parent'));
        // add 100 child accounts
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                Name = 'Test Account'+i
            ));
        }

        insert accounts;
    }

    @isTest
    static void testQueueable() {
        // query for test data to pass to queueable class
        Id parentId = [SELECT Id FROM Account WHERE Name = 'Parent'][0].Id;
        List<Account> accounts = [SELECT id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        // Create our Queueable instance
        UpdateParentAccount updater = new UpdateParentAccount(accounts, parentId);
        // startTest/stopTest block to force async processes to run synchronously
        Test.startTest();
            System.enqueueJob(updater);
        Test.stopTest();
        // Validate the job ran. Check if record have correct parentId now
        System.assertEquals(100, [SELECT Count() FROM Account WHERE ParentId =: parentId]);
    }
}