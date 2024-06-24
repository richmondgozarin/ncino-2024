@isTest
public class CM_CreditActionRequestTest {
    @TestSetup
    static void buildInformation() {
      LLC_BI__Product_Package__c pp = new LLC_BI__Product_Package__c();
      pp.Name = 'testpp';
      insert pp;

      LLC_BI__Product_Package__c tp = new LLC_BI__Product_Package__c();
      tp.Name = 'testtarget';
      insert tp;

      Account a = new Account();
      a.Name = 'testa';
      a.cm_TradingName__c = 'test';
      a.Type = 'Private Limited Company';
      a.AccountNumber = '12345678';
      insert a;
        
      Account conAccount = new Account();
      conAccount.FirstName = 'test';
      conAccount.LastName = 'Con';
      conAccount.Type = 'Individual';
      conAccount.Salutation = 'Mr.';
      

      // Create Loan Record
      LLC_BI__Loan__c l = new LLC_BI__Loan__c();
      l.Name = 'testLoan';
      l.LLC_BI__Product_Package__c = pp.Id;
      l.LLC_BI__Product_Line__c = 'SB&A';
      l.LLC_BI__Product_Type__c = 'Loan Account';
      l.LLC_BI__Product__c = 'Ordinary Loan Account';
      l.cm_Loan_Purpose__c = 'Working Capital';
      l.cm_Term__c = '24 months';
      l.LLC_BI__Stage__c = 'Booked';
      l.LLC_BI__Status__c = 'Open';
      l.LLC_BI__Amount__c = 10000;
      l.LLC_BI__Account__c = a.Id;
      l.cm_Account_Number__c = '12345678';
      insert l;
        
      // Create entity involvement
      LLC_BI__Legal_Entities__c e = new LLC_BI__Legal_Entities__c();
      e.LLC_BI__Loan__c = l.Id;
      e.LLC_BI__Account__c = a.Id;
      e.LLC_BI__Borrower_Type__c = 'Borrower';
      e.LLC_BI__Contingent_Type__c = 'Joint & Several';
      e.LLC_BI__Contingent_Amount__c = 1500;
      insert e;
    }
    
    // Mock Class for nForce service
    public class MockCrossPackageService extends nFORCE.ACrossPackageService {
 
        public MockCrossPackageService() {
 
            // Required to prevent failures in consuming class
            addSupportedInputParameter(
                'contextId',
                true,
                String.class,
                ''
            );
            addSupportedInputParameter(
                'facilityActions',
                true,
                String.class,
                ''
            );
            addSupportedInputParameter(
                'targetPackageId',
                false,
                String.class,
                ''
            );
            addSupportedInputParameter(
                'async',
                false,
                String.class,
                ''
            );
        }

        public virtual override void execute() {
          //outputs for usage by consuming implementation can be added here
          setOutputParameter('response', 'CreditActionDto:[attributes={targetPackageId=a2e0C000000ZfIzQAK, treeLoanIdLookup={"a0i0C000002nNhcQAE":"a0i0C000002nQnxQAE"}}, identity=null]}');
        }
    }
    
    @IsTest
    static void performCreditActionTestAsyncTrue() {

        //enable the local namespace ClassTypeProvider
        nFORCE.BeanRegistry.getInstance().registerBean(
          'ClassTypeProvider',
          nFORCE.ClassTypeProvider.class,
          ClassTypeProvider.class,
          true
        );

        //register your mock process
        nFORCE.BeanRegistry.getInstance().registerBean(
          'LLC_BI.CreditActionSoaXPkg',
          nFORCE.ACrossPackageService.class,
          MockCrossPackageService.class,
          true
        );

        LLC_BI__Loan__c cl = [Select Id, cm_Account_Number__c, LLC_BI__Product_Package__c from LLC_BI__Loan__c where cm_Account_Number__c = '12345678' LIMIT 1];
        LLC_BI__Product_Package__c  tp = [Select Id from LLC_BI__Product_Package__c where Name = 'testtarget' LIMIT 1];

        // Create a test CreditActionReq object      
        CM_CreditActionRequest.CreditActionReq testReq = new CM_CreditActionRequest.CreditActionReq();
        testReq.contextId = cl.LLC_BI__Product_Package__c;
        testReq.currentLoanID = cl.Id;
        testReq.targetPackageId =  tp.Id;
        testReq.isAsync = true;
        
        
        List<CM_CreditActionRequest.CreditActionReq> testReqList = new List<CM_CreditActionRequest.CreditActionReq>();
        testReqList.add(testReq);

        // Call the performCreditAction method
        Test.startTest();
        CM_CreditActionRequest.performCreditAction(testReqList);
        Test.stopTest();

        //System.debug(CM_CreditActionRequest.performCreditAction(testReqList));
        // Check if loanId is not null
        List<CM_CreditActionRequest.CreditActionResult> res = new List<CM_CreditActionRequest.CreditActionResult>();
        for (CM_CreditActionRequest.CreditActionResult r : CM_CreditActionRequest.performCreditAction(testReqList)) {
          res.add(r);
        }

        System.assert(res.size() > 0);
    }
    
    @IsTest
    static void performCreditActionTestAsyncFalse() {

        //enable the local namespace ClassTypeProvider
        nFORCE.BeanRegistry.getInstance().registerBean(
          'ClassTypeProvider',
          nFORCE.ClassTypeProvider.class,
          ClassTypeProvider.class,
          true
        );

        //register your mock process
        nFORCE.BeanRegistry.getInstance().registerBean(
          'LLC_BI.CreditActionSoaXPkg',
          nFORCE.ACrossPackageService.class,
          MockCrossPackageService.class,
          true
        );

        LLC_BI__Loan__c cl = [Select Id, cm_Account_Number__c, LLC_BI__Product_Package__c from LLC_BI__Loan__c where cm_Account_Number__c = '12345678' LIMIT 1];
        LLC_BI__Product_Package__c  tp = [Select Id from LLC_BI__Product_Package__c where Name = 'testtarget' LIMIT 1];

        // Create a test CreditActionReq object      
        CM_CreditActionRequest.CreditActionReq testReq1 = new CM_CreditActionRequest.CreditActionReq();
        testReq1.contextId = cl.LLC_BI__Product_Package__c;
        testReq1.currentLoanID = cl.Id;
        testReq1.targetPackageId =  tp.Id;
        testReq1.isAsync = false;
        
        List<CM_CreditActionRequest.CreditActionReq> testReqList1 = new List<CM_CreditActionRequest.CreditActionReq>();
        testReqList1.add(testReq1);
        
        system.debug('testReqList1 : ' + testReqList1);
        // Call the performCreditAction method
        Test.startTest();
        CM_CreditActionRequest.performCreditAction(testReqList1);
        Test.stopTest();

        // Check if loanId is not null
        List<CM_CreditActionRequest.CreditActionResult> res = new List<CM_CreditActionRequest.CreditActionResult>();
        for (CM_CreditActionRequest.CreditActionResult r : CM_CreditActionRequest.performCreditAction(testReqList1)) {
          res.add(r);
        }
        
        System.assert(res.size() > 0);
        
    }
    
    @isTest
    static void performActionResponseTest(){
        LLC_BI__Loan__c cl = [Select Id, cm_Account_Number__c, LLC_BI__Product_Package__c from LLC_BI__Loan__c where cm_Account_Number__c = '12345678' LIMIT 1];
        LLC_BI__Product_Package__c  tp = [Select Id from LLC_BI__Product_Package__c where Name = 'testtarget' LIMIT 1];
        
        CM_CreditActionFacility loanWithAction = new CM_CreditActionFacility();
        List<CM_CreditActionFacility> facilityActionsTest = new List<CM_CreditActionFacility>();
        
        test.startTest();
        loanWithAction.contextId = cl.LLC_BI__Product_Package__c; 
        loanWithAction.actionType = 'Modify';  
        loanWithAction.modificationType = 'Collateral Modification';
        facilityActionsTest.add(loanWithAction);
        test.stopTest();
        
        String expected = '[{"modificationType":"Collateral Modification","contextId":"' + facilityActionsTest[0].contextId + '","actionType":"Modify"}]';
        String facilityActionsString = JSON.serialize(facilityActionsTest);
        system.assertEquals(expected, facilityActionsString, 'Assertion Failed - '); 
    }
}