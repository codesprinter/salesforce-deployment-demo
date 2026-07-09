@isTest
public class AnimalLocatorTest {
    @isTest static void checkNameMatchAsExpected() {
        // Set up mock HTTP response
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        // Start test execution of batch class
        Test.startTest();
        String name = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();
        
        // Assert that all records were processed successfully
        System.assertEquals('chicken', name);
    }
}