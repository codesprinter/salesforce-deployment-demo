@RestResource(urlMapping='/v1/accounts/*')
global with sharing class AccountAPI {

    @HttpGet
    global static List<Account> getAccounts() {
        return [SELECT Id, Name, Industry FROM Account LIMIT 10];
    }

    @HttpPost
    global static String createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc.Id;
    }
}