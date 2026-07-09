public with sharing class OrderSyncJob implements Queueable, Database.AllowsCallouts {
  private final Id orderId;

  public OrderSyncJob(Id orderId) {
    this.orderId = orderId;
  }

  public void execute(QueueableContext context) {
    System.debug(LoggingLevel.INFO, 'OrderSyncJob.execute >> orderId=' + orderId);

    Order orderRecord = [
      SELECT Id, AccountId, OpportunityId, Status, TotalAmount, EffectiveDate
      FROM Order
      WHERE Id = :orderId
      LIMIT 1
    ];

    System.debug(LoggingLevel.FINE, 'OrderSyncJob.execute >> orderStatus=' + orderRecord.Status + ' totalAmount=' + orderRecord.TotalAmount);

    Map<String, Object> payload = new Map<String, Object>{
      'salesforceOrderId' => orderRecord.Id,
      'accountId' => orderRecord.AccountId,
      'opportunityId' => orderRecord.OpportunityId,
      'status' => orderRecord.Status,
      'totalAmount' => orderRecord.TotalAmount,
      'effectiveDate' => orderRecord.EffectiveDate
    };

    OrderSyncClient.SyncResponse result = OrderSyncClient.sendOrder(String.valueOf(orderRecord.Id), payload);

    if (result.error != null) {
      System.debug(LoggingLevel.ERROR, 'OrderSyncJob.execute << sync failed. correlationId=' + result.correlationId + ' error=' + result.error);
    } else {
      System.debug(LoggingLevel.INFO, 'OrderSyncJob.execute << sync accepted. correlationId=' + result.correlationId);
    }
  }
}