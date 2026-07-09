public with sharing class AccountProcessor {
    // public AccountProcessor() {

    // }
    @future
    public static void countContacts(List<Id> recordIds) {
        List<Account> accounts = new List<Account>([
    		Select Id, Name,(Select Id, Name from Contacts) from Account Where Id IN :recordIds
		]);

		for(Account obj:accounts){
    		//System.debug(obj.Contacts.size());
    		obj.Number_Of_Contacts__c = obj.Contacts.size();
		}
        update accounts;
    }
}