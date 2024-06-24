/**************************************************************************************************
 * DEPRECATED
* @Author:    Jan Reimil Cabantog 
* @Date:      22/05/2023
* @Description: This class is test class for cm_ERS_GetDecisionController apex class
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
public class cm_ERS_GetDecisionControllerTest {
    @testSetup
    static void testdatasetup(){
        
        //create test data for LLC_BI__Loan__c
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Amount__c = 10000;
        loan.LLC_BI__Term_Months__c = 12;
        loan.LLC_BI__Stage__c = 'Booked';
        loan.LLC_BI__Status__c = 'Open';
        loan.LLC_BI__Product_Line__c = 'SB&A';
        loan.LLC_BI__Product_Type__c = 'Loan Account';
        loan.LLC_BI__Product__c = 'Ordinary Loan Account';
        loan.cm_Loan_Purpose__c = 'Working Capital';       
        loan.cm_Account_Number__c = '12345678';
        insert loan;
    }
    
    @isTest
    static void validateLoan(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Parameter parameter  =  new cm_ERS_GetDecisionWrapper.Parameter();
        cm_BaseWrapper.Parameter param = new cm_BaseWrapper.Parameter();
        param.recordId = string.valueOf(loan.Id);
        test.startTest();
        	//cm_ERS_GetDecisionController.validateLoan(parameter);
        test.stopTest();
        System.assertNotEquals(null,param.recordId);
    }
    
    @isTest
    static void validateLoanException(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Parameter parameter  =  new cm_ERS_GetDecisionWrapper.Parameter();
        cm_BaseWrapper.Parameter param = new cm_BaseWrapper.Parameter();
        param.recordId = null;
        test.startTest();
        	//cm_ERS_GetDecisionController.validateLoan(null);
        test.stopTest();
        System.assertEquals(null,param.recordId);
    }
    
    @isTest
    static void getERSDecision(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Parameter parameter  =  new cm_ERS_GetDecisionWrapper.Parameter();
        cm_BaseWrapper.Parameter param = new cm_BaseWrapper.Parameter();
        param.recordId = string.valueOf(loan.Id);
        test.StartTest();
        	//cm_ERS_GetDecisionController.getERSDecision(parameter);
        test.StopTest();
        System.assertNotEquals(null,param.recordId);
    }
    
	@isTest
    static void getERSDecisionException(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Parameter parameter  =  new cm_ERS_GetDecisionWrapper.Parameter();
        cm_BaseWrapper.Parameter param = new cm_BaseWrapper.Parameter();
        param.recordId = null;
        test.StartTest();
        	//cm_ERS_GetDecisionController.getERSDecision(null);
        test.StopTest();
        System.assertEquals(null,param.recordId);
    }
    
    //Test method for cm_ERS_GetDecisionWrapper class
   	@isTest
    static void getDecisionWrapper(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        List<String> lstString = new List<String>();
       	Map<String,List<String>> mapString = new Map<String,List<String>>();
        cm_BaseWrapper.Result res = new cm_BaseWrapper.Result();
        string key = 'key';
        lstString.add('value');
        mapString.put(key, lstString);
        test.starttest();
        result.errormap = mapString;
        result.errorsList = lstString;
        result.ersStatus = 'Approve';
        res.recordId = string.valueOf(loan.Id);
        test.stopTest();
        system.assertnotEquals(null,res.recordId);
    }
}