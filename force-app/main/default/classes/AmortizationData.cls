public class AmortizationData {
        @AuraEnabled @InvocableVariable public String principalTotal;
        @AuraEnabled @InvocableVariable public String interestTotal;
        @AuraEnabled @InvocableVariable public String paymentTotal;
        @AuraEnabled @InvocableVariable public List<SubTotal> subTotals;
        @AuraEnabled @InvocableVariable public List<AmortizationRecord> amortizationRecords;
    }