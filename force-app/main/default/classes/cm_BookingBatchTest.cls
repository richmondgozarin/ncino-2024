/**************************************************************************************************
* @Author:      Derek Jan Ventura
* @Date:        09/05/2023
* @Description: Test class for cm_BookingBatch
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
private class cm_BookingBatchTest {
  	
    	// Reusable Line of Codes
    	static String loanAccount = 'Loan Account';
    	static String currentAccount = 'Current Account';
    	static String ordinaryLoanAccount = 'Ordinary Loan Account';
    	static String workingCapital = 'Working Capital';
    	static String assertionFailed = 'Assertion Failed: ';
    	static String paramsLendingO = '{"DeveloperName":"Lending_Officer_Code","cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"cm_TotalSMEExposure__c","cm_Target_Csv_File__c":"Loan Account"}';
        static String sd = '2023-05-25';
        static String ed = '2023-06-05';
        static String loanRecordType = 'Loan Account';
    	static String fieldValue;
    	static String loanFieldValueResult;
        static String Borrower = 'Borrower';
        static String Applicant = 'Applicant';
        static String loanQuery = cm_TestDataFactory.returnLoanQuery(sd, ed);
        static LLC_BI__Loan__c[] loanData = Database.query(loanQuery);
        static List<String> bookingTargetFile = new List<String>{loanAccount, currentAccount, 'Overdraft', 'Control'};
        static Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings = cm_TestDataFactory.bookingSettings();
    
  	@testSetup
    static void Setup(){
        LLC_BI__Product_Package__c pp = cm_TestDataFactory.createProductPackage();
        
        //nominated
        LLC_BI__Loan__c nominated = cm_TestDataFactory.createNominated();

		//productLine
        LLC_BI__Product_Line__c pl = cm_TestDataFactory.createProductLine();

		//product type
        LLC_BI__Product_Type__c pt = cm_TestDataFactory.createProductType('05', pl.Id);

        LLC_BI__Product_Type__c ptv2 = cm_TestDataFactory.createProductType('04', pl.Id);

		//product reference
        LLC_BI__Product__c pr = cm_TestDataFactory.createProductReference('11', pt.Id, 'Solicitors etc. Office Loan Account');
        LLC_BI__Product__c prv2 = cm_TestDataFactory.createProductReference('00', ptv2.Id, ordinaryLoanAccount);

        //account with nominate
        List<Account> acc = cm_TestDataFactory.createAcc(3, nominated.Id, 'Individual', '2M', 1000000);
        List<Account> accSole = cm_TestDataFactory.createAcc(2, nominated.Id, 'Sole Trader', '', 300000);
        List<Account> lnding120k = cm_TestDataFactory.createAcc(1, nominated.Id, 'Sole Trader', '', 120000);
        List<Account> lnding1M = cm_TestDataFactory.createAcc(1, nominated.Id, 'Individual', '', 1100000);
        List<Account> lndingZero = cm_TestDataFactory.createAcc(1, nominated.Id, 'Individual', '', 0);

        
		//Loan
		cm_TestDataFactory.LoanWrapper loan1 = new cm_TestDataFactory.LoanWrapper();
        loan1.numOfLoans = 3;
        loan1.loanName = loanAccount;
        loan1.productType = loanAccount;
        loan1.productPackage = pp.Id;
        loan1.product = ordinaryLoanAccount;
        loan1.productReference = prv2.Id;
        loan1.loanPurpose = workingCapital;
        loan1.sortCode = '123345';
        loan1.account = accSole[0].Id;
        
        List<LLC_BI__Loan__c> loan = cm_TestDataFactory.createLoan(loan1); //with sole trader acc
        
        cm_TestDataFactory.LoanWrapper loan2 = new cm_TestDataFactory.LoanWrapper();
        loan2.numOfLoans = 1;
        loan2.loanName = loanAccount;
        loan2.productType = loanAccount;
        loan2.productPackage = pp.Id;
        loan2.product = ordinaryLoanAccount;
        loan2.productReference = prv2.Id;
        loan2.loanPurpose = workingCapital;
        loan2.sortCode = '123345';
        loan2.account = lnding120k[0].Id;

        List<LLC_BI__Loan__c> loanLnding120k = cm_TestDataFactory.createLoan(loan2); //with sole trader acc
        
        cm_TestDataFactory.LoanWrapper loan3 = new cm_TestDataFactory.LoanWrapper();
        loan3.numOfLoans = 1;
        loan3.loanName = loanAccount;
        loan3.productType = loanAccount;
        loan3.productPackage = pp.Id;
        loan3.product = ordinaryLoanAccount;
        loan3.productReference = prv2.Id;
        loan3.loanPurpose = workingCapital;
        loan3.sortCode = '123345';
        loan3.account = lnding1M[0].Id;
        
        List<LLC_BI__Loan__c> loanLnding1M = cm_TestDataFactory.createLoan(loan3); //with sole trader acc
        
        cm_TestDataFactory.LoanWrapper loan4 = new cm_TestDataFactory.LoanWrapper();
        loan4.numOfLoans = 2;
        loan4.loanName = 'Current Account Test';
        loan4.productType = currentAccount;
        loan4.productPackage = pp.Id;
        loan4.product = 'Ordinary Current Account';
        loan4.productReference = pr.Id;
        loan4.loanPurpose = 'Machinery & Equipment';
        loan4.sortCode = '192922';
        loan4.account = acc[0].Id;
        
        List<LLC_BI__Loan__c> loanv2 = cm_TestDataFactory.createLoan(loan4);
        
        cm_TestDataFactory.LoanWrapper loan5 = new cm_TestDataFactory.LoanWrapper();
        loan5.numOfLoans = 1;
        loan5.loanName = 'Current Account Test';
        loan5.productType = currentAccount;
        loan5.productPackage = pp.Id;
        loan5.product = 'Ordinary Current Account';
        loan5.productReference = pr.Id;
        loan5.loanPurpose = 'Machinery & Equipment';
        loan5.sortCode = '192922';
        loan5.account = lndingZero[0].Id;
        
        List<LLC_BI__Loan__c> loanLndingZero = cm_TestDataFactory.createLoan(loan5);
        
        cm_TestDataFactory.LoanWrapper loan6 = new cm_TestDataFactory.LoanWrapper();
        loan6.numOfLoans = 1;
        loan6.loanName = loanAccount;
        loan6.productType = loanAccount;
        loan6.productPackage = pp.Id;
        loan6.product = ordinaryLoanAccount;
        loan6.productReference = prv2.Id;
        loan6.loanPurpose = workingCapital;
        loan6.sortCode = '123345';
        loan6.account = acc[0].Id;
        
        List<LLC_BI__Loan__c> loanPopulateLedger = cm_TestDataFactory.createLoan(loan6);

		//ledger
		List<LLC_BI__Legal_Entities__c> legalPopulateLedgerBorrower = cm_TestDataFactory.createLegalEntity(1, loanPopulateLedger[0].Id, acc[1].Id, False, Borrower);
        List<LLC_BI__Legal_Entities__c> legalPopulateLedgerApplicant = cm_TestDataFactory.createLegalEntity(2, loanPopulateLedger[0].Id, acc[1].Id, False, Applicant);
        List<LLC_BI__Legal_Entities__c> legalPrimary = cm_TestDataFactory.createLegalEntity(1, loan[1].Id, accSole[0].Id, True, Borrower);
        List<LLC_BI__Legal_Entities__c> legalGuarantor = cm_TestDataFactory.createLegalEntity(3, loan[0].Id, accSole[0].Id, False, Applicant);
        List<LLC_BI__Legal_Entities__c> legalIndividualType = cm_TestDataFactory.createLegalEntity(1, loanv2[1].Id, acc[0].Id, True, Borrower);
        List<LLC_BI__Legal_Entities__c> legalLnding120k = cm_TestDataFactory.createLegalEntity(1, loanLnding120k[0].Id, lnding120k[0].Id, True, Borrower);
        List<LLC_BI__Legal_Entities__c> legalLnding1M = cm_TestDataFactory.createLegalEntity(1, loanLnding1M[0].Id, lnding1M[0].Id, True, Borrower);
        List<LLC_BI__Legal_Entities__c> legalLndingZero = cm_TestDataFactory.createLegalEntity(1, loanLndingZero[0].Id, lndingZero[0].Id, True, Borrower);
        
		//pricing stream
        LLC_BI__Pricing_Stream__c pricingStream = cm_TestDataFactory.createPricingStream(loan[2].Id);

		//pricing rate
        LLC_BI__Pricing_Rate_Component__c pricingRate = cm_TestDataFactory.createPricingRate(loan[0].Id, pricingStream.Id);
    }

	@isTest
    static void testUpdateLoanFields(){

        List<LLC_BI__Loan__c> testLoans = [SELECT Id, cm_BKK_Status__c, cm_Sent_to_BKK__c FROM LLC_BI__Loan__c];
        Test.startTest();
        	cm_BookingBatchHelper.updateLoanFields(testLoans);
        Test.stopTest();
        
        List<LLC_BI__Loan__c> updatedLoan = [SELECT Id, cm_BKK_Status__c, cm_Sent_to_BKK__c FROM LLC_BI__Loan__c WHERE Id IN : testLoans];
        
        for(LLC_BI__Loan__c loan : updatedLoan){
            System.assertEquals('IN PROGRESS', loan.cm_BKK_Status__c);
            System.assertNotEquals(null, loan.cm_Sent_to_BKK__c);
        }
    }
    
    @isTest
    static void testSetColumnHeader(){
        String columnHeader = '';
        List<cm_BKK_Loan_Mapping__mdt> bkkList = new List<cm_BKK_Loan_Mapping__mdt>();
        cm_BKK_Loan_Mapping__mdt customBkk = new cm_BKK_Loan_Mapping__mdt(
            cm_Target_Csv_File__c = 'Test_Target_File.csv',
            cm_Target_Column__c = 'Test Column'
        );
        bkkList.add(customBkk);
        String bkkTargetFile = 'Test Target File.csv';
        Boolean isTarget = bkkList[0].cm_Target_Csv_File__c.replace('_', ' ').contains(bkkTargetFile);
        
       String objectName = bkkList[0].cm_Target_Column__c;
        columnHeader += '' + String.escapeSingleQuotes(objectName) + ' |'; 

        Test.startTest();         
        String result = cm_BookingBatchHelper.setColumnHeader(bkkList, bkkTargetFile);
        Test.stopTest();
        
        system.assertEquals(true, isTarget, 'Assertion Failed!');
    }

    @isTest
    static void testCreateAttachment(){
        cm_LoanBooking__c testLoan = new cm_LoanBooking__c();
        insert testLoan;

        String fileName = 'TestFile.csv';
        List<String> csvFileBody = new List<String>{'Column 1, Column 2, Column 3', 'Value 1, Value 2, Value 3'};

        Test.startTest();
        cm_BookingBatchHelper.createAttachment(fileName, csvFileBody, testLoan);
        Test.stopTest();

        List<Attachment> testFile = [SELECT Id FROM Attachment WHERE ParentId =: testLoan.Id];
        System.assertEquals(1, testFile.size(), 'Attachment should have been created.');
    }
    
    @isTest
    static void mdtSourceFieldNotNull(){
        String params = '[';
        params += '{"DeveloperName":"Test Record","cm_Source_Object__c":"LLC_BI__Loan__c","cm_Date_Type__c":"Get Day","cm_Source_Field__c":"cm_Ready_for_Booking_Date_Time__c","cm_Is_Padding__c":true,"cm_Padding_Direction__c":"Left"}';
        params += ']';

        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        String sourceField = customMetadata[0].cm_Source_Field__c;
        Boolean isTrue = String.isNotBlank(sourceField);
        
        test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        System.assertEquals(true, isTrue, assertionFailed);
    }
    
    @isTest
    static void mdtParentObjAndFieldNotNull(){
        
        String params = '[';
        params += '{"DeveloperName":"Test Record","cm_Date_Type__c":"Next Due Date","cm_Parent_Object__c":"LLC_BI__Account__r","cm_Parent_Field__c":"Name","cm_Is_Padding__c":true,"cm_Padding_Direction__c":"Right", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"TestColumn", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"LLC_BI__Product_Type__c"}';
        params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        	
        fieldValue = (string) loanData[1].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        
        String parentObject = customMetadata[0].cm_Parent_Object__c;
        String parentField = customMetadata[0].cm_Parent_Field__c;
        
        Boolean isTrue = String.isNotBlank(parentObject) && String.isNotBlank(parentField);
        
        test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        System.assertEquals(true, isTrue, assertionFailed);
    }
    
    @isTest
    static void mdtChildObjAndChildFieldNotNull(){

       String params = '[';
       params += '{"DeveloperName":"Test Record","cm_Date_Type__c":"Get Current Date","cm_Child_Field__c":"LLC_BI__Index__c","cm_Child_Object__c":"Pricing_Rate_Components__r"}';
       params += ']';

       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        
       String childObj = customMetadata[0].cm_Child_Object__c;
       String childField = customMetadata[0].cm_Child_Field__c;
        
        Boolean isTrue = String.isNotBlank(childObj) && String.isNotBlank(childField);
        List<LLC_BI__Loan__c> pricingRecordList = new List<LLC_BI__Loan__c>();
        for (LLC_BI__Loan__c records: loanData) {
            if (records.getSObjects('Pricing_Rate_Components__r') != null) {
                for (LLC_BI__Pricing_Rate_Component__c pricingRecords: records.getSObjects('Pricing_Rate_Components__r')) {
                    if (pricingRecords.LLC_BI__Index__c != null) {
                        pricingRecordList.add(records);
                    }
            	}
            }
        }
        
        test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(pricingRecordList[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();

        system.assertEquals(true, isTrue, assertionFailed);
    }
    
    @isTest
    static void mdtSourceParentChildDateTypeIsNull(){
        String params = '[';
       params += '{"DeveloperName":"Test Record","cm_Date_Type__c":"","cm_Source_Field__c":"","cm_Parent_Field__c":"", "cm_Child_Field__c":""}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        String dateType = customMetadata[0].cm_Date_Type__c;
        String sourceField = customMetadata[0].cm_Source_Field__c;
        String parentField = customMetadata[0].cm_Parent_Field__c;
        String childField = customMetadata[0].cm_Child_Field__c;
        
        test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assert(String.isBlank(dateType),'cm_Date_Type__c should be empty');
        system.assert(String.isBlank(sourceField),'cm_Source_Field__c should be empty');
        system.assert(String.isBlank(parentField),'cm_Parent_Field__c should be empty');
        system.assert(String.isBlank(childField),'cm_Child_Field__c should be empty');
    }
    
    @isTest
    static void parentObjectContainsDot(){
        String params = '[';
       params += '{"DeveloperName":"Customer_Type","cm_Parent_Field__c":"Name","cm_Parent_Object__c":"LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r"}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       	String getObject = customMetadata[0].cm_Parent_Object__c;
        Boolean isTrue = getObject.contains('.');
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assertEquals(True, isTrue, assertionFailed);
    }
    
    @isTest
    static void sourceFieldContainMonths(){
        String params = '[';
        params += '{"DeveloperName":"Test Record","cm_Date_Type__c":"Get Day","cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_Term__c"}';
        params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       	
        fieldValue = (string) loanData[1].get(customMetadata[0].cm_Source_Field__c); 
        fieldValue = fieldValue.substringBefore(' ');
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assertEquals('9', fieldValue);
    }
    
    @isTest
    static void testMultiLvlImplementation(){
        String params = '[';
        params += '{"DeveloperName":"Test_Ledger","cm_Date_Type__c":"Get Day","cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_Term__c","cm_Child_Object__c":"Child Object", "cm_Child_Field__c":"Test.Child Field"}';
        params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        String childField = customMetadata[0].cm_Child_Field__c;
        Boolean isTrue = childField.contains('.');
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assertEquals(true, isTrue, assertionFailed);
    }
    
    @isTest
    static void testMarketClass(){
        String params = '[';
        params += '{"DeveloperName":"Market_Class", "cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_MarketClassification__c", "cm_Target_Csv_File__c":"Loan Account"}';
		params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        
        fieldValue = (string) loanData[1].get(customMetadata[0].cm_Source_Field__c); 
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest(); 
        
        system.assertEquals('011', fieldValue, assertionFailed);
    }
    
    @isTest
    static void testFarmLoanAgri(){
        String farmLoanValue;
        String params = '[';
        params += '{"DeveloperName":"Farm_Loan", "cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_MarketClassification__c", "cm_Target_Csv_File__c":"Loan Account"}';
		params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        fieldValue = (string) loanData[1].get(customMetadata[0].cm_Source_Field__c); 
        
        if(CM_Constant.AGRI_INDICATOR.contains(fieldValue)){
            farmLoanValue = '1';
        }
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest(); 
        
        system.assertEquals('1', farmLoanValue, assertionFailed);
    }
    
    @isTest
    static void testFarmLoanNotAgri(){
        String farmLoanValue;
        String params = '[';
        params += '{"DeveloperName":"Farm_Loan", "cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_MarketClassification__c", "cm_Target_Csv_File__c":"Loan Account"}';
		params += ']';
        loanData[1].cm_MarketClassification__c = '061';
        update loanData[1];
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        fieldValue = (string) loanData[1].get(customMetadata[0].cm_Source_Field__c); 
        
        if(!CM_Constant.AGRI_INDICATOR.contains(fieldValue)){
            farmLoanValue = '0';
        }
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest(); 
        
        system.assertEquals('0', farmLoanValue, assertionFailed);
    }
    
    @isTest
    static void testChildFieldContainsDot(){
        String params = '[';
       params += '{"DeveloperName":"Ledger_Title_Line_1","cm_Child_Object__c":"LLC_BI__Legal_Entities__r","cm_Child_Field__c":"LLC_BI__Account__r.Name"}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       	String getChildField = customMetadata[0].cm_Child_Field__c;
        Boolean isTrue = getChildField.contains('.');
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assertEquals(True, isTrue, assertionFailed);
    }
    
    @isTest
    static void fieldNameNotLedger(){
       String params = '[';
       params += '{"DeveloperName":"Test_Ledger_Title_Line_1","cm_Child_Object__c":"LLC_BI__Legal_Entities__r","cm_Child_Field__c":"LLC_BI__Account__r.Name"}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       String getChildField = customMetadata[0].cm_Child_Field__c;
       String[] childObjectList = getChildField.replace('.', ',').split(',');
       SObject[] childObject = loanData[1].getSObjects(customMetadata[0].cm_Child_Object__c);
        
        String devName = customMetadata[0].DeveloperName;
        String[] checkFieldName = devName.split('_');
        Boolean isTrue = checkFieldName[0] != cm_Constant.LEDGER;
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        System.assertEquals(true, isTrue, assertionFailed);
    }
    
    @isTest
    static void testPopulateLedger(){
        String params = '[';
       params += '{"DeveloperName":"Ledger_Title_Line_1", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"},';
       params += '{"DeveloperName":"Ledger_Title_Line_2", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"},';
       params += '{"DeveloperName":"Ledger_Title_Line_3", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"},';
       params += '{"DeveloperName":"Ledger_Title_Line_4", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"},';
       params += '{"DeveloperName":"Ledger_Title_Line_5", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       List<LLC_BI__Loan__c> individualLoanRecords = new List<LLC_BI__Loan__c>();
       for (LLC_BI__Loan__c records: loanData) {
           if (records.getSObject('LLC_BI__Account__r') != null && records.getSObject('LLC_BI__Account__r').get('type') == 'Individual') {
               individualLoanRecords.add(records);
           }
       }

        Test.startTest();
            // Sole Trader Scenario
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[2], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
            // Business/S4C/Partnership Scenario
            cm_BookingBatchHelper.getAllRecordsByLoanRecordType(individualLoanRecords[4], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();

        LLC_BI__Legal_Entities__c legalEntity = [SELECT Id, cm_PrimaryGuarantorApplicant__c, LLC_BI__Loan__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: loanData[2].Id];
        
        system.assertEquals(true, legalEntity.cm_PrimaryGuarantorApplicant__c, assertionFailed);
    }
    
    @isTest
    static void testLegalPrimaryFalse(){
        String params = '[';
       params += '{"DeveloperName":"Ledger_Title_Line_1", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);

        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        LLC_BI__Legal_Entities__c legalEntity = [SELECT Id, cm_PrimaryGuarantorApplicant__c, LLC_BI__Loan__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: loanData[1].Id LIMIT 1];
        
        system.assertEquals(false, legalEntity.cm_PrimaryGuarantorApplicant__c, assertionFailed);
    }
    
    @isTest
    static void testChildFieldNotContainsDot(){
        String params = '[';
       params += '{"DeveloperName":"Debit_Rate_Code","cm_Child_Object__c":"Pricing_Rate_Components__r","cm_Child_Field__c":"LLC_BI__Rate__c", "cm_Parent_Object__c":""}';
       params += ']';
       cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
       	String getChildField = customMetadata[0].cm_Child_Field__c;
        Boolean isTrue = !getChildField.contains('.');
        List<sObject> childRecords = loanData[3].getSObjects(customMetadata[0].cm_Child_Object__c);
        system.debug('childRecords > ' + childRecords);
        
        Test.startTest();
        cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[3], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        system.assertEquals(True, isTrue, assertionFailed);
    }

    @isTest
    static void testCalculateAge(){
        String params = '[';
        params += '{"DeveloperName":"Date_of_Review","cm_Date_Type__c":"Calculate Age","cm_Parent_Object__c":"LLC_BI__Account__r","cm_Parent_Field__c":"PersonBirthdate","cm_Source_Field__c":"cm_Ready_for_Booking_Date_Time__c","cm_Is_Padding__c":true,"cm_Padding_Direction__c":"Left"}';
        params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        Date personBirth = (Date) loanData[3].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        system.debug('personBirth > ' + personBirth);
        fieldValue = cm_Utilities.formatDate(personBirth);
        system.debug('fieldValue > ' + fieldValue);
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
        
        System.assertEquals('20230525', fieldValue, assertionFailed);
    }

    @isTest
    static void testDebitRateCode() {
        String params = '[';
        params += '{"DeveloperName":"Debit_Rate_Code","cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"cm_DebitRateCode__c","cm_Is_Padding__c":true,"cm_Padding_Direction__c":"Right"}';
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);

        List<LLC_BI__Loan__c> debitCodeList = new List<LLC_BI__Loan__c>();
        for (LLC_BI__Loan__c records: loanData) {
            if (records.cm_DebitRateCode__c != null) {
                debitCodeList.add(records);
            }
        }

        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(debitCodeList[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }

    @isTest
    static void testDebitInterestRate() {
        String params = '[';
        params += '{"DeveloperName":"Debit_Interest_Rate","cm_Source_Object__c":"LLC_BI__Loan__c","cm_Source_Field__c":"LLC_BI__InterestRate__c","cm_Is_Padding__c":true,"cm_Padding_Direction__c":"Right"}';
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);

        List<LLC_BI__Loan__c> interestRateList = new List<LLC_BI__Loan__c>();
        for (LLC_BI__Loan__c records: loanData) {
            if (records.LLC_BI__InterestRate__c != null) {
                interestRateList.add(records);
            }
        }
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(interestRateList[0], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }

    @isTest
    static void getLendingOfficerCodeLocNumberTest(){
        String params = '[';
        params += paramsLendingO;
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
  		
        Decimal getLendngAmount = (Decimal) loanData[1].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        integer lending = getLendngAmount.intValue();
        
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[1], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    @isTest
    static void LendingAmountBelow120k(){
        String params = '[';
        params += paramsLendingO;
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
  		
        Decimal getLendngAmount = (Decimal) loanData[1].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        integer lending = getLendngAmount.intValue();
        fieldValue = string.valueOf(lending);
        
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[4], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    @isTest
    static void LendingAmount800k(){
        String params = '[';
        params += paramsLendingO;
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
  		
        Decimal getLendngAmount = (Decimal) loanData[6].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        integer lending = getLendngAmount.intValue();
        fieldValue = string.valueOf(lending);
        
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[6], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    @isTest
    static void LendingAmount1M(){
        String params = '[';
        params += paramsLendingO;
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
  		
        Decimal getLendngAmount = (Decimal) loanData[5].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        integer lending = getLendngAmount.intValue();
        fieldValue = string.valueOf(lending);
        
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[5], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    @isTest
    static void LendingAmountZero(){
        String params = '[';
        params += paramsLendingO;
        params += ']';
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
  		
        Decimal getLendngAmount = (Decimal) loanData[8].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        integer lending = getLendngAmount.intValue();
        fieldValue = string.valueOf(lending);
        
        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[8], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    
    @isTest
    static void devCustomerType(){
        String params = '[';
        params += '{"DeveloperName":"Customer_Type","cm_Parent_Object__c":"LLC_BI__Product_Reference__r", "cm_Parent_Field__c":"cm_AccountType__c","cm_Target_Csv_File__c":"Loan Account"}';
        params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        
        String customerTypeValue = (String) loanData[1].getSObject(customMetadata[0].cm_Parent_Object__c).get(customMetadata[0].cm_Parent_Field__c);
        system.debug('customerTypeValue > ' + customerTypeValue);
        Boolean isTrue = customerTypeValue == cm_Constant.NUM_ELVN;
        system.debug('isTrue > ' + isTrue);
        
        Test.startTest();
        	if(isTrue){
                cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[6], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
            }else{
                cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[2], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
            }
        
        test.stopTest();
    }
    
    @isTest 
    static void testDropDoubleQoutes(){
        fieldValue = '+00000';
        
        test.startTest();
        	cm_BookingBatchHelper.dropDoubleQuotes(fieldValue, False);
        test.stopTest();
    }
    
    @isTest
    static void testMdtDefaultValueNotNull(){
        String params = '[';
        params += '{"DeveloperName":"testDefault", "cm_Target_Column__c":"td", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"Type", "cm_Target_Csv_File__c":"Loan_Account.Current_Account", "cm_Default_Value__c":"N","cm_Is_Sole_Trader__c":true}';
       	params += ']';
        
        cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);

        Test.startTest();
        	cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loanData[2], customMetadata[0], '', bookingSettings, '', loanRecordType, bookingTargetFile);
        test.stopTest();
    }
    
	@isTest
    static void testSuccessBKKBatch(){
         String params = cm_TestDataFactory.returnParams();
        
         cm_BookingBatchTest.customMetadata  = (List<cm_BKK_Loan_Mapping__mdt>) JSON.deserialize(params, List<cm_BKK_Loan_Mapping__mdt>.class);
        cm_BookingBatch bkkBatchDateRanged = new cm_BookingBatch(customMetadata, loanQuery, bookingSettings, bookingTargetFile, sd, ed);
        cm_BookingBatch bkkBatch = new cm_BookingBatch(customMetadata, loanQuery, bookingSettings, bookingTargetFile);
        
        Test.startTest();
        	Database.executeBatch(bkkBatch);
        	Database.executeBatch(bkkBatchDateRanged);
        test.stopTest();
    }    
    
    @testVisible static List<cm_BKK_Loan_Mapping__mdt> customMetadata {
      get {
        if ( customMetadata == null )
            customMetadata = [SELECT DeveloperName, cm_Source_Object__c,cm_Target_Column__c,cm_Target_Csv_File__c,cm_Date_Type__c,cm_Parent_Field__c,cm_Is_Padding__c,cm_Padding_Direction__c,cm_Padding_Count__c,cm_Padding_Value__c,cm_Parent_Object__c,cm_Source_Field__c,cm_Child_Object__c,cm_Child_Field__c,cm_Default_Value__c FROM cm_BKK_Loan_Mapping__mdt WHERE cm_Is_Active__c=TRUE]; 
        return customMetadata;
      } set;
    }
}