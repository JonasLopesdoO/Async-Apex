public with sharing class EmailUtils {
    public static void sendEmailMessageByJob(AsyncApexJob job, String email, Integer recordsProcessed, String displayName) {
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {email};
        
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(email);
        mail.setSenderDisplayName(displayName);
        mail.setSubject('Job Information');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(
            'Records processed: ' + recordsProcessed + ';'
            + 'Job: ' + job + '.'
        );
        mail.setHtmlBody(
            '<b>Records processed:</b> ' + recordsProcessed + ';'
            + '<br>'
            + '<b>Job:</b> ' + job + '.'
        );

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}
