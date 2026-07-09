public with sharing class AccountSyncTriggerHandler {
  public static void handle(
    List<Account> newAccounts,
    Map<Id, Account> oldMap,
    Boolean isInsert
  ) {
    Set<Id> accountIds = new Set<Id>();

    for (Account acc : newAccounts) {
      if (isInsert) {
        accountIds.add(acc.Id);
      } else {
        Account oldAcc = oldMap.get(acc.Id);
        if (hasRelevantChange(acc, oldAcc)) {
          accountIds.add(acc.Id);
        }
      }
    }

    for (Id accountId : accountIds) {
      System.enqueueJob(new AccountSyncJob(accountId));
    }
  }

  private static Boolean hasRelevantChange(Account newAcc, Account oldAcc) {
    return newAcc.Name            != oldAcc.Name            ||
           newAcc.Phone           != oldAcc.Phone           ||
           newAcc.Email__c        != oldAcc.Email__c        ||
           newAcc.External_Key__c != oldAcc.External_Key__c ||
           newAcc.BillingStreet   != oldAcc.BillingStreet   ||
           newAcc.BillingCity     != oldAcc.BillingCity     ||
           newAcc.BillingCountry  != oldAcc.BillingCountry;
  }
}