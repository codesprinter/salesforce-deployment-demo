@isTest
private class AccountTrigger_Test {
    private class HttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"accepted":true,"correlationId":"test-123","error":null}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest static void TestCreateNewAccountInBulk() {
        Test.setMock(HttpCalloutMock.class, new HttpMock());
        // Test Setup data
        // Create 50 new Accounts
        List<Account> accts = new List<Account>();
        for(Integer i=0; i < 50; i++) {
            Account acct = new Account(Name='Test Account ' + i);
            accts.add(acct);
        }              
        // Perform Test
        Test.startTest();
        insert accts;                               
        Test.stopTest();
        // Verify that 50 new Accounts were inserted
        List<Account> verifyAccts = [SELECT Id FROM Account];
        System.assertEquals(50, verifyAccts.size());    
        // Also verify that 50 new Opportunities were inserted
        List<Opportunity> verifyOpps = [SELECT Id FROM Opportunity];                              
        System.assertEquals(50, verifyOpps.size());                             
    }
}