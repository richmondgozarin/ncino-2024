@isTest
private class cm_RCC_CopyTTMtoValidforCalcBatchTest {

    @isTest
    static void testBatch() {
  
        // Create test data - loan
         LLC_BI__Loan__c createLoan = new LLC_BI__Loan__c();
            createLoan.Name = 'Test Loan';
            createLoan.LLC_BI__Product_Line__c = 'SB&A';
           // createLoan.LLC_BI__Product_Type__c = productType;
            //createLoan.LLC_BI__Product__c = product;
            //createLoan.cm_Loan_Purpose__c = loanPurpose;
            createLoan.LLC_BI__Term_Months__c = 24;
            createLoan.LLC_BI__Status__c = 'Open';
            createLoan.LLC_BI__Amount__c = 10000;
            //createLoan.cm_Ready_for_Booking_Date_Time__c = Datetime.valueOf(CONST_DATETIME);
            createLoan.cm_Account_Number__c = '12345678';
            createLoan.cm_MarketClassification__c = '011';
            //createLoan.cm_Sort_Code__c = sortCode;
            createLoan.cm_Term__c = '3 months';
            //createLoan.LLC_BI__Product_Package__c = productPackage;
            //createLoan.LLC_BI__Product_Reference__c = productReference;
                                                       
    insert createLoan;
        
        //Create Monthly statement
        MonthlyStatement__c testRecord = new MonthlyStatement__c(cm_MonthEndDate__c = system.today() - 60, loan__c = createLoan.ID );
        insert testRecord;

        // Start the batch
        Test.startTest();
        cm_RCC_CopyTTMtoValidforCalcBatch batchJob = new cm_RCC_CopyTTMtoValidforCalcBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Verify that the field2 value is copied correctly
        MonthlyStatement__c updatedRecord = [SELECT Id, cm_TTM__c, cm_ValidforCalc__c FROM MonthlyStatement__c WHERE Id = :testRecord.Id LIMIT 1];
        System.assertEquals(updatedRecord.cm_TTM__c, updatedRecord.cm_ValidforCalc__c);
    }
}