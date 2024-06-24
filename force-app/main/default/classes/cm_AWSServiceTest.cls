/**************************************************************************************************
* @Author:      Rich Gozarin
* @Date:        17/05/2023
* @Description: Test class for CM_AWSService 
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
private class cm_AWSServiceTest {
    
    // Assertion Message
    static final String CONST_ASSERTION = 'Assertion Successful: ';
    // bkk log
    static final SEL_ExceptionLog__c BKK_LOG = new SEL_ExceptionLog__c();
    // ers log
    static final SEL_ExceptionLog__c ERS_LOG = new SEL_ExceptionLog__c();
    
    // Log type
    static final String AWS_LOG_TYPE = 'AWS-S3 ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
    static final List<SEL_ExceptionLog__c> AWS_LOGS = [SELECT SEL_Endpoint__c, SEL_ResponseCode__c 
                                                      FROM SEL_ExceptionLog__c WHERE SEL_SubType__c = :AWS_LOG_TYPE];
    
    // ERS Log type
    static final String ERS_LOG_TYPE = 'ERS ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
    static final List<SEL_ExceptionLog__c> ERS_LOGS = [SELECT SEL_Endpoint__c, SEL_ResponseCode__c 
                                                      FROM SEL_ExceptionLog__c WHERE SEL_SubType__c = :ERS_LOG_TYPE];
    
    @TestSetup
    static void datasetup() {
        BKK_LOG.SEL_Endpoint__c = 'callout:AWS_S3/nCino-inbound/nCino_Loan_BKK_1_20240411.csv';
        BKK_LOG.SEL_ResponseCode__c = 200;
        BKK_LOG.SEL_SubType__c = 'AWS-S3 ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
        insert BKK_LOG;

        ERS_LOG.SEL_Endpoint__c = 'callout:ERS/trusted-partners/e/ers-risk-assessment/v1/account-orignation/product-types/loan/identifier/300026770/assess-risk';
        ERS_LOG.SEL_ResponseCode__c = 200;
        ERS_LOG.SEL_SubType__c = 'ERS ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
        insert ERS_LOG;
    }

    @isTest
    static void testExportFileInS3(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.cm_Ready_for_Booking_Date_Time__c = datetime.now();
        loan.cm_Ready_for_Booking__c = true;
        loan.LLC_BI__Stage__c = 'Pre-Fulfilment';
        loan.LLC_BI__Approved_Loan_Amount__c = 99000;
        loan.LLC_BI__Amount__c = 99000;
        insert loan;
        
        List<String> csvLoanList = new List<String>{};
		String csvFileBody = 'Id,Record,Name';
        csvLoanList.add(csvFileBody);
        csvFileBody += '001,XXX,Loan1';
        csvLoanList.add(csvFileBody);

        Attachment afile = new Attachment();
        afile.Name = 'nCino_BKK_Loan.csv';
        afile.Body = Blob.valueOf(String.join(csvLoanList, '\r\n'));
        afile.ParentId = loan.Id;
        afile.ContentType = 'text/csv';
        insert afile;
        
        test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ID jobID = System.enqueueJob(new CM_AWSService('S3_AWSAPI', loan.Id ));
        test.stopTest();
        
        System.assertEquals(200, AWS_LOGS.get(0).SEL_ResponseCode__c, CONST_ASSERTION);
    }
    
    @isTest
    static void testERS_RISK_API(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.cm_Ready_for_Booking_Date_Time__c = datetime.now();
        loan.cm_Ready_for_Booking__c = true;
        loan.LLC_BI__Stage__c = 'Pre-Fulfilment';
        loan.LLC_BI__Approved_Loan_Amount__c = 99000;
        loan.LLC_BI__Amount__c = 99000;
        insert loan;
        
        List<String> csvLoanList = new List<String>{};
		String csvFileBody = 'Id,Record,Name';
        csvLoanList.add(csvFileBody);
        csvFileBody += '001,XXX,Loan1';
        csvLoanList.add(csvFileBody);

        Attachment afile = new Attachment();
        afile.Name = 'nCino_BKK_Loan.csv';
        afile.Body = Blob.valueOf(String.join(csvLoanList, '\r\n'));
        afile.ParentId = loan.Id;
        afile.ContentType = 'text/csv';
        insert afile;
        
        test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ID jobID = System.enqueueJob(new CM_AWSService('ERS_Risk_API', loan.Id ));
        test.stopTest();
        
        System.assertEquals(200, ERS_LOGS.get(0).SEL_ResponseCode__c, CONST_ASSERTION);
    }

    @isTest
    static void testRetryAWSCall() {
        cm_LoanBooking__c loanBooking = new cm_LoanBooking__c();
        loanBooking.Name = 'BKK Loan Files';
        insert loanBooking;
        List<string> idList = new List<string>{loanBooking.Id};
        Test.startTest();
        CM_AWSServiceHelper.retryAWSCall(idList);
        Test.stopTest();
        system.assert(CM_AWSServiceHelper.retryAWSCall(idList)[0] != null);
    }
    
    @isTest
    static void testRetryAWSCallNotAvailable() {
        List<string> idList = new List<string>{null};
        Test.startTest();
        CM_AWSServiceHelper.retryAWSCall(idList);
        Test.stopTest();
        system.assertEquals('Not Available', CM_AWSServiceHelper.retryAWSCall(idList)[0]);
    }
    
    private class HttpMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            String fullJson = '[]'; 
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(201);
            return res;
        }

    }
}