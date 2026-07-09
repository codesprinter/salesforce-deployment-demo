trigger AccountSyncTrigger on Account (after insert, after update) {
  AccountSyncTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.isInsert);
}