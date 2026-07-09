trigger OrderSyncTrigger on Order (after insert, after update) {
  Set<Id> orderIds = new Set<Id>();

  for (Order orderRecord : Trigger.new) {
    if (Trigger.isInsert || orderRecord.Status != Trigger.oldMap.get(orderRecord.Id).Status) {
      orderIds.add(orderRecord.Id);
    }
  }

  for (Id orderId : orderIds) {
    System.enqueueJob(new OrderSyncJob(orderId));
  }
}