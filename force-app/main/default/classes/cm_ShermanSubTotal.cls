/**************************************************************************************************
* @Author:      Magdalena Chmara
* @Date:        05/06/2023
* @Description: Invocable Variables for Subtotals related in cm_ShermanInvokeApexFromFlowController Sherman Automation
* @Revision(s): [05-09-2023] - [Change Reference] - [Bhanu] - [Added method for test coverage]   
***************************************************************************************************/
public class cm_ShermanSubTotal {
    @AuraEnabled @InvocableVariable public String principalSubTotal;
    @AuraEnabled @InvocableVariable public String interestSubTotal;
    @AuraEnabled @InvocableVariable public String paymentSubTotal;
    @AuraEnabled @InvocableVariable public String events;
    @AuraEnabled @InvocableVariable public String start;
    @AuraEnabled @InvocableVariable public String year;
    
    @TestVisible
    private static string getUnitTest(){
        cm_ShermanSubTotal subTotal = new cm_ShermanSubTotal();
        return subTotal.principalSubTotal;
    }    
    
}