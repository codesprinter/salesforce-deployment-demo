public class AnimalLocatorMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        res.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
}