@isTest
public class TestVerifyDate {
     @isTest static void checkDateWithin30DaysPositive() {
         Date date1 = Date.newInstance(2016, 12, 9);
         Date date2 = (date1.addDays(5));
         Date resDate = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2,resDate);
    }
    
    @isTest static void checkDateWithin30DaysNegative() {
         Date date1 = Date.newInstance(2016, 12, 9);
         Date date2 = (date1.addDays(35));
         Date resDate = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date1,resDate);
    }
}