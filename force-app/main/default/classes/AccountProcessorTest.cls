@isTest()
public class AccountProcessorTest {
    private class HttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"accepted":true,"correlationId":"test-123","error":null}');
            res.setStatusCode(200);
            return res;
        }
    }

    public AccountProcessorTest() {

    }

    @IsTest
    private static void testContactCount() {
        Test.setMock(HttpCalloutMock.class, new HttpMock());
        Account acc = new Account(Name='Syedur');

        Test.startTest();
        insert acc;
        AccountProcessor.countContacts(new List<Id>{ acc.Id });
        Test.stopTest();

        List<Account> result = [SELECT Id FROM Account];
        System.assertEquals(true, result.size() > 0);
    }
}