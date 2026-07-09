public with sharing class AccountSyncClient {
  public class SyncResponse {
    @AuraEnabled public Boolean accepted;
    @AuraEnabled public String correlationId;
    @AuraEnabled public String error;
  }

  private static String getBearerToken() {
    List<OrderSync_Settings__mdt> settings = [
      SELECT Bearer_Token__c
      FROM OrderSync_Settings__mdt
      WHERE DeveloperName = 'Default'
      LIMIT 1
    ];
    return settings.isEmpty() ? null : settings[0].Bearer_Token__c;
  }

  public static SyncResponse sendAccount(String accountId, Map<String, Object> payload) {
    String token = getBearerToken();
    if (String.isBlank(token)) {
      System.debug(LoggingLevel.ERROR, 'AccountSyncClient.sendAccount >> Bearer token not configured in OrderSync_Settings__mdt');
      SyncResponse err = new SyncResponse();
      err.error = 'Bearer token not configured';
      return err;
    }
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:Order_Sync_API/accounts/sync');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    request.setHeader('Authorization', 'Bearer ' + token);
    request.setHeader('X-Correlation-Id', String.valueOf(Crypto.getRandomLong()));
    request.setBody(JSON.serialize(payload));

    System.debug(LoggingLevel.INFO, 'AccountSyncClient.sendAccount >> accountId=' + accountId);
    System.debug(LoggingLevel.FINE, 'AccountSyncClient.sendAccount >> endpoint=' + request.getEndpoint());
    System.debug(LoggingLevel.FINE, 'AccountSyncClient.sendAccount >> requestBody=' + request.getBody());

    HttpResponse response = new Http().send(request);

    System.debug(LoggingLevel.INFO, 'AccountSyncClient.sendAccount << statusCode=' + response.getStatusCode());
    System.debug(LoggingLevel.FINE, 'AccountSyncClient.sendAccount << responseBody=' + response.getBody());

    SyncResponse parsed = (SyncResponse) JSON.deserialize(response.getBody(), SyncResponse.class);

    if (response.getStatusCode() >= 400) {
      parsed.error = String.isBlank(parsed.error) ? response.getBody() : parsed.error;
      System.debug(LoggingLevel.ERROR, 'AccountSyncClient.sendAccount << error=' + parsed.error);
    }

    return parsed;
  }
}