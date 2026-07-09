public with sharing class AccountSyncJob implements Queueable, Database.AllowsCallouts {
  private final Id accountId;

  public AccountSyncJob(Id accountId) {
    this.accountId = accountId;
  }

  public void execute(QueueableContext context) {
    System.debug(LoggingLevel.INFO, 'AccountSyncJob.execute >> accountId=' + accountId);

    Account accountRecord = [
      SELECT
        Id,
        External_Key__c,
        Name,
        Phone,
        Email__c,
        BillingStreet,
        BillingCity,
        BillingCountry,
        CreatedDate,
        LastModifiedDate
      FROM Account
      WHERE Id = :accountId
      LIMIT 1
    ];

    System.debug(LoggingLevel.FINE, 'AccountSyncJob.execute >> name=' + accountRecord.Name + ' email=' + accountRecord.Email__c);

    Map<String, Object> payload = new Map<String, Object>{
      'salesforceId'    => accountRecord.Id,
      'externalKey'     => accountRecord.External_Key__c,
      'name'            => accountRecord.Name,
      'phone'           => accountRecord.Phone,
      'email'           => accountRecord.Email__c,
      'billingAddress'  => accountRecord.BillingStreet,
      'billingCity'     => accountRecord.BillingCity,
      'billingCountry'  => accountRecord.BillingCountry,
      'createdDate'     => accountRecord.CreatedDate,
      'lastModifiedDate' => accountRecord.LastModifiedDate
    };

    AccountSyncClient.SyncResponse result = AccountSyncClient.sendAccount(String.valueOf(accountRecord.Id), payload);

    if (result.error != null) {
      System.debug(LoggingLevel.ERROR, 'AccountSyncJob.execute << sync failed. correlationId=' + result.correlationId + ' error=' + result.error);
    } else {
      System.debug(LoggingLevel.INFO, 'AccountSyncJob.execute << sync accepted. correlationId=' + result.correlationId);
    }
  }
}