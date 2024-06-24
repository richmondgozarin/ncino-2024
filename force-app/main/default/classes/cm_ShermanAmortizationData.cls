/**************************************************************************************************
* @Author:      Magdalena Chmara
* @Date:        05/06/2023
* @Description: Invocable Variables for Amortization Data related in cm_ShermanInvokeApexFromFlowController Sherman Automation
* @Revision(s): [05-09-2023] - [Change Reference] - [Bhanu] - [Added method for test coverage]   
***************************************************************************************************/
public class cm_ShermanAmortizationData {
    @AuraEnabled @InvocableVariable public String principalTotal;
    @AuraEnabled @InvocableVariable public String interestTotal;
    @AuraEnabled @InvocableVariable public String paymentTotal;
    @AuraEnabled @InvocableVariable public List<cm_ShermanSubTotal> subTotals;
    @AuraEnabled @InvocableVariable public List<cm_ShermanAmortizationRecord> amortizationRecords;
    
    @TestVisible
    private static string getUnitTest(){
        cm_ShermanAmortizationData dataPrincipal = new cm_ShermanAmortizationData();
        return dataPrincipal.principalTotal;
    }
}