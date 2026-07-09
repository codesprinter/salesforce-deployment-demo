public with sharing class LeadConvertTest {
    public LeadConvertTest() {

    }
    public static void sampleBatch(){
        List<Lead> leadsToConvert = [SELECT Id, LastName, Company, Email FROM Lead WHERE IsConverted != true];
        string MASTER_LABEL = 'Converted';
        bulkLeadConvertion(leadsToConvert, MASTER_LABEL);
    }
    
    public static void bulkLeadConvertion(List<Lead> leadsToConvert, String MASTER_LABEL){
        List<Database.Error> errors = new List<Database.Error>();
        
        //mapping existing accounts
        Map<String, ID> accMap = new Map<String, ID>();
        for(Account acc : [SELECT Id, Name FROM Account]){
            accMap.put(acc.Name, acc.Id);
        }
        //mapping exisiting contacts 
        Map<String, ID> contactMap = new Map<String, ID>();
        Map<Id,Contact> contactSobjectMap = new Map<Id, Contact>([SELECT Id, Email, AccountId FROM Contact]);
        for(Contact con : contactSobjectMap.values()){
            contactMap.put(con.Email, con.Id);
        }
                    
        for(Lead theLead : leadsToConvert){
            Database.LeadConvert lc = new Database.LeadConvert();            
            lc.setLeadId(theLead.Id);
            lc.setDoNotCreateOpportunity(true);
            
            //Check existing Account to associate
            if(accMap.containsKey(theLead.Company)){
                lc.setAccountId(accMap.get(theLead.Company));
                System.debug('Found Account by the name: ' + theLead.Company);
            }
            
            //Check existing Contact to Merge
            if(contactMap.containsKey(theLead.Email)){
                lc.setContactId(contactMap.get(theLead.Email));
                
                //Checks if Contact found with out an Account, Try to find associated Account
                if(lc.getAccountId() == null){
                    lc.setAccountId(
                        contactSobjectMap.get(lc.getContactId()).AccountId
                    );
                }
                System.debug('Found Contact by the name: ' + theLead.Email);
            }
            lc.setConvertedStatus(MASTER_LABEL);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            
            //Storing newly created Account, Contact and Errors in Map 
            if(lcr.isSuccess()){
               accMap.put(theLead.Company, lcr.getAccountId());
               contactMap.put(theLead.Email, lcr.getContactId());
            }else{
            	errors.addAll(lcr.getErrors());
            }
        }
        System.debug(JSON.serializePretty(errors));
    }
}