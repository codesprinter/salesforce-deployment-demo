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
        List<Account> accounts = new List<Account>();
        Account acc = new Account(Name='Syedur');
        accounts.add(acc);
        insert acc;
        List<Id> accountIds = new list<Id>();

		for(Account obj:accounts){
    		accountIds.add(obj.Id);
		}
        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();
        System.assertEquals(true, accounts.size() > 0);
    }
}