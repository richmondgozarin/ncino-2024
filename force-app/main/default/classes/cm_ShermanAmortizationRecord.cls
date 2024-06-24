/**************************************************************************************************
* @Author:      Magdalena Chmara
* @Date:        05/06/2023
* @Description: Invocable Variables for Amortization Record related in cm_ShermanInvokeApexFromFlowController Sherman Automation
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public class cm_ShermanAmortizationRecord {
    @TestVisible @AuraEnabled @InvocableVariable public String endingBalance;
    @TestVisible @AuraEnabled @InvocableVariable public String unpaidInterest;
    @TestVisible @AuraEnabled @InvocableVariable public String principal;
    @TestVisible @AuraEnabled @InvocableVariable public String interest;
    @TestVisible @AuraEnabled @InvocableVariable public String payment;
    @TestVisible @AuraEnabled @InvocableVariable public String beginningBalance;
    @TestVisible @AuraEnabled @InvocableVariable public String pmtdate;
    @TestVisible @AuraEnabled @InvocableVariable public String index;
    @TestVisible @AuraEnabled @InvocableVariable public String type;
    
    @TestVisible
    private static string getUnitTest(){
        cm_ShermanAmortizationRecord dataPrincipal = new cm_ShermanAmortizationRecord();
        return dataPrincipal.principal;
    }
}