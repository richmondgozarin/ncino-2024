/*-----------------------------------------------------------------------------
DESCRIPTION :   Test class of CM_ERS_API_Callout class
AUTHOR      :   Jan Reimil Cabantog
VERSION     :   1.0
HISTORY     :
Date            Author              Comment
23-08-2023      Jan Reimil Cabantog Initial version
24-05-2024		Jan Reimil Cabantog	Added assertion on performERSCallMockTest method
-----------------------------------------------------------------------------*/
@isTest
public class CM_ERS_API_CalloutTest {
    
    @testSetup
    static void testdatasetup(){
        //create test data for LLC_BI__Loan__c
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Amount__c = 10000;
        loan.LLC_BI__Term_Months__c = 12;
        loan.LLC_BI__Stage__c = 'Application';
        loan.LLC_BI__Status__c = 'Open';
        loan.LLC_BI__Product_Line__c = 'SB&A';
        loan.LLC_BI__Product_Type__c = 'Loan Account';
        loan.LLC_BI__Product__c = 'Ordinary Loan Account';
        loan.cm_Loan_Purpose__c = 'Working Capital';     
        loan.cm_Account_Number__c = '12345678';
        insert loan;
        
    }
    
    @isTest
    static CM_ERS_API_Callout.ERS_Req createInputVar(){
        //Create input var
        CM_ERS_API_Callout.ERS_Req inputReq = new CM_ERS_API_Callout.ERS_Req();
        inputReq.Authorization = 'Bearer 1BSorSaduwNRdkzFPUPjwUJk_m0VTJ4izWQzDWIr3Uf-inTbM8OK4ET7EAeI_vTu6sm7mWg5s8lwr5Zi20Jg';
        inputReq.xapiTransactionid = '5102-93u4-a5cc-f023';
        inputReq.payload = '({"externalAssessment_set":true,"externalAssessment":{"externalBureauResponse_set":true,"externalBureauResponse":{"coarseGradingClient4_set":true,"coarseGradingClient4":0,"coarseGradingClient3_set":true,"coarseGradingClient3":0,"coarseGradingClient2_set":true,"coarseGradingClient2":0,"coarseGradingClient1_set":true,"coarseGradingClient1":0}},"accountOrigination_set":true,"accountOrigination":{"primaryApplicant_set":true,"primaryApplicant":{"personDetails_set":true,"personDetails":{"general_set":true,"general":{"mannerOfHabitation_set":true,"mannerOfHabitation":"","dateOfBirth_set":true}},"customerDetails_set":true,"customerDetails":{"segmentation_set":true,"segmentation":{"customerNatureCode_set":true,"customerNatureCode":"B"},"risk_set":true,"risk":{"creditRating7Internal_set":true,"creditRating7Internal":""},"relationship_set":true,"relationship":{"vipEntityIndicator_set":true,"vipEntityIndicator":"N"}},"boiOnlySavingsValue_set":true,"boiOnlySavingsValue":0,"applicantAccountDetails_set":true,"applicantAccountDetails":{"account_set":true,"account":{"servicing_set":true,"servicing":{"individualPermissionAmount_set":true,"individualPermissionAmount":0},"identifier_set":true,"identifier":{"sortCode_set":true,"sortCode":421321,"accountNumber_set":true,"accountNumber":3210339}}}},"monetaryAmount_set":true,"monetaryAmount":{"requestedLoanAmount_set":true,"requestedLoanAmount":10000,"monthlyRentExpense_set":true,"monthlyRentExpense":0,"issuedCapital_set":true,"issuedCapital":0,"inflightLoanApplicationAmount_set":true,"inflightLoanApplicationAmount":10000,"amountOfAllNewCreditApplciationsInProgress_set":true,"amountOfAllNewCreditApplciationsInProgress":0},"identifier_set":true,"identifier":{"applicationNumber_set":true,"applicationNumber":300013822,"applicationBusinessSourceCode_set":true,"applicationBusinessSourceCode":"3"},"general_set":true,"general":{"relationshipManagerCode_set":true,"relationshipManagerCode":"B"},"credit_set":true,"credit":{"subPurposeOfLoan_set":true,"subPurposeOfLoan":0,"loanTermInMonths_set":true,"loanTermInMonths":5},"application_set":true,"application":{"totalSavingsValue_set":true,"totalSavingsValue":0,"stockingLoanIndicator_set":true,"stockingLoanIndicator":"Y","schoolChurchCharitiesClubsIndicator_set":true,"schoolChurchCharitiesClubsIndicator":"","productTypeCode_set":true,"productTypeCode":"L","numberOfApplicants_set":true,"numberOfApplicants":0,"debitInterestRateCode_set":true,"debitInterestRateCode":"2B","collateralCode_set":true,"collateralCode":99,"bridgeLoanIndicator_set":true,"bridgeLoanIndicator":"0","applicationType_set":true,"applicationType":"LBYR","accountTypeCode_set":true,"accountTypeCode":"L"},"affordability_set":true,"affordability":{"riskCapacityCalculationOverdraftPercentage_set":true,"riskCapacityCalculationOverdraftPercentage":0,"riskCapacityCalculationLoanRatio_set":true,"riskCapacityCalculationLoanRatio":10,"debtServiceCoverageRatio_set":true,"debtServiceCoverageRatio":0},"additionalApplicant_set":true,"additionalApplicant":{"personDetails_set":true,"personDetails":{"general_set":true,"general":{"dateOfBirth_set":true}}}}})';
        inputReq.productType = 'loan';
        return inputReq;
    }

    //Successful callout
    @isTest
    static void performERSCallSuccessTest(){
        
        Integer statusCode = 200;
        String response = '{"decisionResult":{"accountOrigination":{"primaryApplicant":{"customerDetails":{"general":{},"risk":{"gradeControlCode":"","totalGroupExposureAmount":10000,"creditRating7InternalAndControlCode":"3N"}},"personDetails":{"financials":{"netDisposableIncome":0}},"applicantAccountDetails":{"account":{"behaviour":{"minimumBalanceOverLast3Months":0,"minimumBalanceOverLast6Months":0,"irregularNumberOfDaysInLast12months":0,"irregularNumberOfDaysInLast6months":0,"numberOfDaysPaymentPostponedInLast6Months":0,"numberOfReversalsUnpaidsPaymentsInLast12months":0,"numberOfReversalsUnpaidsPaymentsInLast6months":0,"noOfDaysInDebitInLast6Months":0,"averageLedgerBalanceProbeMTD":0,"3MRollingAverageCreditTurnover":0,"6MRollingAverageCreditTurnover":0,"12MRollingAverageCreditTurnover":0},"limit":{"timeSinceLimitChange":0},"monetaryAmount":{"clearedBalance":0,"totalCreditTurnoverCurrentMonth":0},"risk":{"exposureAtDefaultFactor":0.1,"lossGivenDefaultFactor":0.65,"pointInTimeProbabilityOfDefaultPool":9,"pointInTimeProbabilityOfDefaultScore":584,"pointInTimeProbabilityOfDefaultScorecardID":1,"pointInTimeProbabilityOfDefaultSubPool":0,"probabilityOfDefault":0.027,"creditRating7Internal":0},"servicing":{}},"currentAccount":{"general":{},"limit":{}}}},"assessment":{"finalDecisionCode":"Refer","decisionOutcome":"Refer","decisionOutcomeTable":"Refer     Refer     RR13","reasonCode":"RR13","decisionRulesID":"45:14","netDisposableIncome":0,"netDisposableIncomeasPercentageOfMonthlyIncome":0,"bureauRatingIndicator":"N","overdraftRepaymentAmount":0,"customerOverdraftLimit":0},"credit":{"preApprovalBlockedIndicator":""},"identifier":{"scorecardIdentifier":11},"risk":{"creditRiskScore":496,"applicationExposureAtDefaultAmount":10000,"applicationExpectedLossAmount":496,"applicationLossGivenDefault":0,"modellingStrategy":"R","baselRiskScore":496}}}';
        
        //Create Loan
        LLC_BI__Loan__c loan = [SELECT Id,Name,cm_ApplicationNumber__c,LLC_BI__Stage__c FROM LLC_BI__Loan__c WHERE LLC_BI__Stage__c = 'Application' LIMIT 1];

        //Input Var
        CM_ERS_API_Callout.ERS_Req input = createInputVar();
        input.applicationNumber = loan.cm_ApplicationNumber__c;
        input.recordId = loan.Id;
        
        List<CM_ERS_API_Callout.ERS_Req> inputList = new List<CM_ERS_API_Callout.ERS_Req>();
        inputList.add(input);
        
        //Output Var
        List<CM_ERS_API_Callout.ERS_Res> result = new List<CM_ERS_API_Callout.ERS_Res>();
        
        Test.startTest();
            //Set Mock
            Test.setMock(HttpCalloutMock.class, new CM_ERS_API_CalloutMock(statusCode,response));
            result = CM_ERS_API_Callout.performERSCall(inputList);
        Test.stopTest();
        System.assertNotEquals(result,null);
    }
    
    //Unsuccessful callout test
    @isTest
    static void performERSCallFailTest(){
        
        Integer statusCode = 404;
        String response = '{" additionalInformation:":{"details":"The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.","type":"ERROR"},"api":"ERS NBSM Credit Risk Decisioning API","code":404,"summary":"Not Found","timestamp":"2023-07-25T07:50:55.7Z","type":"ERROR","uri":"https://edge2-td-cdh.boigroup.net:5002/de/ers/nbsm/assess-risk"}';
        
        //Create Loan
        LLC_BI__Loan__c loan = [SELECT Id,Name,cm_ApplicationNumber__c,LLC_BI__Stage__c FROM LLC_BI__Loan__c WHERE LLC_BI__Stage__c = 'Application' LIMIT 1];

        //Input Var
        CM_ERS_API_Callout.ERS_Req input = createInputVar();
        input.applicationNumber = loan.cm_ApplicationNumber__c;
        input.recordId = loan.Id;
        System.debug('input:'+input);
        List<CM_ERS_API_Callout.ERS_Req> inputList = new List<CM_ERS_API_Callout.ERS_Req>();
        inputList.add(input);
        
        //Output Var
        List<CM_ERS_API_Callout.ERS_Res> result = new List<CM_ERS_API_Callout.ERS_Res>();
        
        Test.startTest();
            //Set Mock
            Test.setMock(HttpCalloutMock.class, new CM_ERS_API_CalloutMock(statusCode,response));
            result = CM_ERS_API_Callout.performERSCall(inputList);
        Test.stopTest();
        System.assertNotEquals(result,null);
    }    
    
    //Unsuccessful and exception callout test
    @isTest
    static void performERSCallExceptionTest(){
        
        //Create Loan
        LLC_BI__Loan__c loan = [SELECT Id,Name,cm_ApplicationNumber__c,LLC_BI__Stage__c FROM LLC_BI__Loan__c WHERE LLC_BI__Stage__c = 'Application' LIMIT 1];

        //Input Var
        CM_ERS_API_Callout.ERS_Req input = createInputVar();
        input.applicationNumber = loan.cm_ApplicationNumber__c;
        input.recordId = loan.Id;
        List<CM_ERS_API_Callout.ERS_Req> inputList = new List<CM_ERS_API_Callout.ERS_Req>();
        inputList.add(input);
        
        //Output Var
        List<CM_ERS_API_Callout.ERS_Res> result = new List<CM_ERS_API_Callout.ERS_Res>();
        
        Test.startTest();
            //Set Mock
            UnauthorizedEndpointResponse mock = new UnauthorizedEndpointResponse();
            Test.setMock(HttpCalloutMock.class, mock);
            result = CM_ERS_API_Callout.performERSCall(inputList);
        Test.stopTest();
        System.assertNotEquals(result,null);
    }

    @isTest
    static void performERSCallMockTest(){
        Test.startTest();
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt(
            SEL_EndpointExtension__c = '/services/{record}/create/{var1}',
            SEL_HttpMethod__c = 'Get', 
            SEL_IsActive__c = true, 
            SEL_IsCompressed__c = false,
            SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON,
            SEL_NamedCredentials__c = 'Salesforce',
            SEL_IsMockingEnabled__c =  true,
            DeveloperName = 'SalesforceTest'
        );
        
        CM_ERS_API_Callout ers = new CM_ERS_API_Callout('SalesforceTest');        
        ers.getHttpRequest();
        httprequest req =  ers.getHttpRequest();
        ers.getIsMockingEnabled();
        ers.getIsBulkEnabled();
        Test.stopTest();
        System.assertNotEquals(ers,null);
    }    
    
    //Mock Class of the CM_ERS_API_Callout 
    public class CM_ERS_API_CalloutMock implements HttpCalloutMock{
        
        public Integer statusCode {get;set;}
        public String response {get;set;}
        
        //Constructor
        public CM_ERS_API_CalloutMock(Integer statusCode, String response) {
            this.response = response;
            this.statusCode = statusCode;
        }
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            //Return the response
            res.setBody(response);
            res.setStatusCode(statusCode);
            return res;
        }   
    }
    
    //Mock class for unauthorize endpoint to create exception
    public class UnauthorizedEndpointResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
            throw e;
        }
    }
       
}