public class AmortizationRecord {
        @AuraEnabled @InvocableVariable public String endingBalance;
        @AuraEnabled @InvocableVariable public String unpaidInterest;
        @AuraEnabled @InvocableVariable public String principal;
        @AuraEnabled @InvocableVariable public String interest;
        @AuraEnabled @InvocableVariable public String payment;
        @AuraEnabled @InvocableVariable public String beginningBalance;
        @AuraEnabled @InvocableVariable public String pmtdate;
        @AuraEnabled @InvocableVariable public String index;
        @AuraEnabled @InvocableVariable public String type;
    }