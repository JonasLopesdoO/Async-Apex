public with sharing class UpdateContactAddresses implements Database.Batchable<SObject>, Database.Stateful {
    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, BillingStreet, BillingCity, BillingState, BillingCountry, ' +
            '(SELECT ID, MailingStreet, MailingCity, MailingState, MailingCountry FROM Contacts) ' +
            'FROM Account ' +
            'Where BillingCountry = \'USA\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> records) {
        List<Contact> contacts = new List<Contact>();
        
        for (Account account : records) {
            for (Contact contact : account.contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingCountry = account.BillingCountry;
                contacts.add(contact);
                this.recordsProcessed += 1;
            }
        }

        update contacts;
    }

    public void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                            FROM AsyncApexJob 
                            WHERE Id = :bc.getJobId()];
        System.debug('How much records processed? - ' + this.recordsProcessed);
        EmailUtils.sendEmailMessageByJob(job, 'jonas.lopes@engdb.com.br', this.recordsProcessed, 'Salesforce execution');
    }
}
