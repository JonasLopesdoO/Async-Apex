@isTest
private class UpdateContactAddressSchedulerTest {
    @isTest
    static void testScheduler() {
        String CRON_EXP = '0 0 0 15 3 ? 2023';
        UpdateContactAddressScheduler scheduler = new UpdateContactAddressScheduler();

        Test.startTest();
            String jobId = System.schedule('SCHEDULE JOB', CRON_EXP, scheduler);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id =: jobId];
        Test.stopTest();

        System.assert(jobId != null, 'JobId not created');
        System.assertEquals(CRON_EXP, ct.CronExpression, 'The expressions are not the same');
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2023-03-15 00:00:00', String.valueOf(ct.NextFireTime));
    }
}
