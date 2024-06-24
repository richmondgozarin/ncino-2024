/**************************************************************************************************
 * DEPRECATED
* @Author:    Jan Reimil Cabantog 
* @Date:      18/05/2023
* @Description: This class is test class for cm_ERS_GetDecisionHandler apex class
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
public class cm_ERS_GetDecisionHandlerTest {
	/*
    @testSetup
    static void testdatasetup(){
        
        //create test record for Account
        Account acc = new Account();
        acc.Name = 'ERSTestAccount';
		//acc.cm_SortCode__c = '111111';
        acc.Type = 'Sole Trader';
        //acc.cm_MainAccountNumber__c = '12312312';
        acc.LLC_BI__Credit_Rating__c = '123123';
        //acc.LLC_BI__Monthly_Income__pc = 1000.00;
        //acc.LLC_BI__Marital_Status__pc = 'Single';
        //acc.LLC_BI__Number_of_Dependents__pc = 1;
        acc.LLC_BI__Status__c = 'Customer';
        insert acc;
        system.debug('acc:>>'+acc);
 
        //create test data for LLC_BI__Loan__c
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        //loan.Name = 'ERSTest';
        loan.LLC_BI__Amount__c = 10000;
        loan.LLC_BI__Term_Months__c = 12;
        loan.LLC_BI__Account__c = acc.Id;
        loan.LLC_BI__Stage__c = 'Booked';
        loan.LLC_BI__Status__c = 'Open';
        loan.LLC_BI__Product_Line__c = 'SB&A';
        loan.LLC_BI__Product_Type__c = 'Loan Account';
        loan.LLC_BI__Product__c = 'Ordinary Loan Account';
        loan.cm_Loan_Purpose__c = 'Working Capital';
        //loan.cm_Term__c = '24 months';
		loan.cm_living_Arrangements__c = 'Homeowner';        
        loan.cm_Account_Number__c = '12345678';
        insert loan;
        system.debug('loan:>>'+loan);
       
        //Create test record for LLC_BI__Legal_Entities__c
        LLC_BI__Legal_Entities__c le = new LLC_BI__Legal_Entities__c();        
        le.LLC_BI__Loan__c = loan.Id;
        le.Name = 'ERTestLegalEntityData';
        le.LLC_BI__Borrower_Type__c = 'Borrower';
        le.LLC_BI__Account__c = acc.Id;
        insert le;
        system.debug('le:>>'+le);
        //Create 4 ccr record
       	
        List<BOI_CCR__c> ccrlist = new List<BOI_CCR__c>();
        for(Integer i = 0; i<3; i++){
            BOI_CCR__c ccr = new BOI_CCR__c();
            ccr.cm_CourseGrade__c = '7';
            ccr.cm_Loan__c = loan.id;
            ccr.cm_Relationship__c = acc.id;
            ccrlist.add(ccr);
        }
        insert ccrlist;
        
        
    }
        
    @isTest
    static void validateLoanDetailsTest(){
        //Name is being updated by flow
       LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c FROM LLC_BI__Loan__c LIMIT 1];
        system.debug('@@loanrec:'+loan);
        loan.LLC_BI__Stage__c = 'Booked';
        loan.cm_Term__c = '24 months';
        Test.startTest();
			//cm_ERS_GetDecisionHandler.validateLoanDetails(string.valueOf(loan.Id));
        Test.StopTest();
        System.assertEquals('Booked',loan.LLC_BI__Stage__c);
    }
    
    @isTest
    static void validateLoanDetailsTestStage(){
        //Name is being updated by flow
       LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c FROM LLC_BI__Loan__c LIMIT 1];
        system.debug('@@loanrec:'+loan);
        Test.startTest();
            loan.LLC_BI__Stage__c = 'Pre-Decision Analysis';
        	loan.cm_Term__c = '24 months';
        	update loan;
			cm_ERS_GetDecisionHandler.validateLoanDetails(string.valueOf(loan.Id));
        Test.StopTest();
        System.assertEquals('Pre-Decision Analysis',loan.LLC_BI__Stage__c);
    }
    
	@isTest
    static void validateLoanDetailsNullTerm(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c FROM LLC_BI__Loan__c LIMIT 1];
        system.debug('@@loanrec:'+loan);
        loan.LLC_BI__Stage__c = 'Booked';
        loan.LLC_BI__Term_Months__c = null;
        Test.startTest();
			cm_ERS_GetDecisionHandler.validateLoanDetails(string.valueOf(loan.Id));
        Test.StopTest();
        System.assertEquals(null,loan.LLC_BI__Term_Months__c);
    }
    //Need to work on how to force error to cover cath block
    @isTest
    static void validateLoanDetailsError(){
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        test.startTest();
            cm_ERS_GetDecisionHandler.validateLoanDetails(string.valueOf(loan.Id));
        test.stopTest();
    }
    
    @isTest
    static void updateLoanDetails(){
        //set result data
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        result.ersStatus = 'Approve';
        //set loan data
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        test.startTest();
        	cm_ERS_GetDecisionHandler.updateLoanDetails(string.valueOf(loan.Id),result);
        test.stopTest();
        System.assertEquals('Approve',result.ersStatus);
    }
    
    //successful callout 1
    @isTest
    static void callERSServicetest(){
        Test.setMock(HttpCalloutMock.class, new cm_ERS_GetDecisionMock());
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        string devname = 'DecisionAPI';
        test.StartTest();
        	cm_ERS_GetDecisionHandler ers = new cm_ERS_GetDecisionHandler(devname);
        	ers.callERSSerice(string.valueOf(loan.Id));
        test.stopTest();
        System.assertEquals('Booked',loan.LLC_BI__Stage__c);    
    }
    
    //successful callout 2 (loan purpose / stocking loan indicator)
    @isTest
    static void callERSServicetest2(){
        Test.setMock(HttpCalloutMock.class, new cm_ERS_GetDecisionMock());
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        Account acc = [SELECT Id,Name,Type FROM Account LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        string devname = 'DecisionAPI';
        test.StartTest();
        	acc.Type = 'School';
        	update acc;
        	loan.cm_Loan_Purpose__c = 'Short-Term Livestock Purchase';
        	update loan;
        	cm_ERS_GetDecisionHandler ers = new cm_ERS_GetDecisionHandler(devname);
        	ers.callERSSerice(string.valueOf(loan.Id));
        test.stopTest();
        System.assertEquals('Short-Term Livestock Purchase',loan.cm_Loan_Purpose__c);    
    }

    //successful callout 3 (bridging loan purpose)
    @isTest
    static void callERSServicetest3(){
        Test.setMock(HttpCalloutMock.class, new cm_ERS_GetDecisionMock());
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result();
        string devname = 'DecisionAPI';
        test.StartTest();
        	loan.cm_Loan_Purpose__c = 'Bridging Loans';
        	update loan;
        	cm_ERS_GetDecisionHandler ers = new cm_ERS_GetDecisionHandler(devname);
        	ers.callERSSerice(string.valueOf(loan.Id));
        test.stopTest();
        System.assertEquals('Bridging Loans',loan.cm_Loan_Purpose__c);    
    }     
    
    //unsuccessful callout
    @isTest
    static void callERSServicetestfail(){
        Test.setMock(HttpCalloutMock.class, new cm_ERS_GetDecisionMockfail());
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result(); 
        string devname = 'DecisionAPI';
        test.StartTest();
        	cm_ERS_GetDecisionHandler ers = new cm_ERS_GetDecisionHandler(devname);
        	ers.callERSSerice(string.valueOf(loan.Id));
        test.stopTest();
        System.assertEquals('Booked',loan.LLC_BI__Stage__c);  
    }
    
    //unsuccessful callout
    @isTest
    static void callERSServicetestfailnull(){
        Test.setMock(HttpCalloutMock.class, new cm_ERS_GetDecisionMocknull());
        LLC_BI__Loan__c loan = [SELECT   Name,Id,LLC_BI__Stage__c,LLC_BI__Term_Months__c,LLC_BI__Credit_Approval_Date__c FROM LLC_BI__Loan__c LIMIT 1];
        cm_ERS_GetDecisionWrapper.Result result = new cm_ERS_GetDecisionWrapper.Result(); 
        string devname = 'DecisionAPI';
        test.StartTest();
        	cm_ERS_GetDecisionHandler ers = new cm_ERS_GetDecisionHandler(devname);
        	ers.callERSSerice(string.valueOf(loan.Id));
        test.stopTest();
    }    
    
    
    //Inner class successful mock that will be use on cm_ERS_GetDecisionHandlerTest
    public class cm_ERS_GetDecisionMock implements HttpCalloutMock{
            public HTTPResponse respond(HTTPRequest req) {
            //Set response mock data
            SEL_IntegrationDataMock__mdt mock = [SELECT MasterLabel,DeveloperName,SEL_Body__c,SEL_Header__c,SEL_Status__c,SEL_StatusCode__c FROM SEL_IntegrationDataMock__mdt WHERE MasterLabel = 'ERS Response Test Data'];
            system.debug('mock:'+mock);
            string fulljson = mock.SEL_Body__c;
			
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    //Inner class unsuccessful mock that will be use on cm_ERS_GetDecisionHandlerTest
    public class cm_ERS_GetDecisionMockfail implements HttpCalloutMock{
            public HTTPResponse respond(HTTPRequest req) {
            //Set response mock data
            SEL_IntegrationDataMock__mdt mock = [SELECT MasterLabel,DeveloperName,SEL_Body__c,SEL_Header__c,SEL_Status__c,SEL_StatusCode__c FROM SEL_IntegrationDataMock__mdt WHERE MasterLabel = 'ERS Response Test Data'];
            system.debug('mock:'+mock);
            string fulljson = mock.SEL_Body__c;
			
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(400);
            return res;
        }
    }
    
    //Inner class null response mock that will be use on cm_ERS_GetDecisionHandlerTest to cover exceptions
    public class cm_ERS_GetDecisionMocknull implements HttpCalloutMock{
            public HTTPResponse respond(HTTPRequest req) {
            //Set response mock data
            SEL_IntegrationDataMock__mdt mock = [SELECT MasterLabel,DeveloperName,SEL_Body__c,SEL_Header__c,SEL_Status__c,SEL_StatusCode__c FROM SEL_IntegrationDataMock__mdt WHERE MasterLabel = 'ERS Response Test Data'];
            system.debug('mock:'+mock);
            string fulljson = mock.SEL_Body__c;
			
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(null);
            res.setStatusCode(400);
            return res;
        }
    }

	
    //Test method for cm_ERS_GetDecisionProvider.getMockedRequest
	@isTest
    static void getMockedRequesttest(){
        test.startTest();
        	string jsonBody = cm_ERS_GetDecisionProvider.getMockedRequest();
        test.stopTest();
        system.assertNotEquals(null, jsonBody);
    }
    */
}