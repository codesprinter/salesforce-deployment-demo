public with sharing class AccountUtils {
    public static List<Account> accountsByState(String stateCode){
        List<Account> myAccounts = [SELECT Id, Name FROM Account WHERE BillingState = :stateCode];
        return myAccounts;
    }
}