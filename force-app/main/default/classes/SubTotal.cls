public class SubTotal {
        @AuraEnabled @InvocableVariable public String principalSubTotal;
        @AuraEnabled @InvocableVariable public String interestSubTotal;
        @AuraEnabled @InvocableVariable public String paymentSubTotal;
        @AuraEnabled @InvocableVariable public String events;
        @AuraEnabled @InvocableVariable public String start;
        @AuraEnabled @InvocableVariable public String year;
    }