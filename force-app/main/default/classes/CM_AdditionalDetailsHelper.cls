public without sharing class CM_AdditionalDetailsHelper {
    @AuraEnabled(cacheable=true)
    public static List<BOI_KnowYourCustomer__c > getKYCList(String accountId) {
		
        return [Select id ,cm_PartytotheCustomerRelationship__c,
                cm_Loan__r.Name , cm_Countryofcitizenship__c, cm_Sameascitizenship__c, cm_Countryofbirth__c
                FROM BOI_KnowYourCustomer__c 
                WHERE cm_PartytotheCustomerRelationship__c =:accountId 
                AND cm_Loan__c !='' 
                AND cm_Loan__r.LLC_BI__Stage__c = 'Application']; 
 
    }
    
    /* @AuraEnabled(cacheable=true)
    public static List<Account> getRelationshipAcc(){ 
        return [Select Id, Relationship_Name_person__c, 
                LLC_BI__SS_PE__pc, Industry, PersonEmail, 
                PersonBirthdate, PersonMobilePhone, 
                cm_Residential_Address__pc, 
                cm_Incorrect_Personal_Details__pc, 
                cm_Whatpersonaldetailsincorrect__pc, 
                cm_Living_Arrangements__pc, cm_monthlyRentExpense__pc, 
                cm_boiOnlySavingsValue__pc, Additional_Info_Reqd2__c FROM Account WHERE Industry != null LIMIT 5];          
    } */
    
    @AuraEnabled()
    public static String returnBaseUrl(){
        @TestVisible
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        
        return baseUrl;
    }
    
    @AuraEnabled
    public static void updateFlag(String accId){
    	List<Account> updateAccList = new List<Account>();
    	/* NCINO-6275
        for(Account accs : [Select Id, cm_AdditionalInfoReqd__c FROM Account WHERE Id =:accId]){
            accs.cm_AdditionalInfoReqd__c = false;
            updateAccList.add(accs);
        }
		*/
        for(Account accs : [Select Id FROM Account WHERE Id =:accId]){
            updateAccList.add(accs);
        }
        
        system.debug('updateAccList > ' + updateAccList);
    	update updateAccList;
    }
    
}