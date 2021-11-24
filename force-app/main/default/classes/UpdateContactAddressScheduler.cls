public class UpdateContactAddressScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        UpdateContactAddresses batch = new UpdateContactAddresses();
        Database.executeBatch(batch);
    }
}
