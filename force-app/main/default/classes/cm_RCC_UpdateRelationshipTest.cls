@isTest
private class cm_RCC_UpdateRelationshipTest {
    
    // Global variables that can be reused
    static Decimal AvgCreditBalance = 1000;
    static Decimal WorstBalance = 2000;
    static Decimal Turnover = 3000;
    
    
    
    @testSetup
    static void setup() {
        
        // Create two relationships with Business Record Type
        Id businessRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<Account> testAcc = cm_TestDataFactory.createAccountWithRecordtype(2, businessRecordType);
        
        List<LLC_BI__Loan__c> listLoans = new List<LLC_BI__Loan__c>();
        
        // Create two loans for each relationship
        LLC_BI__Loan__c loan1Acct1 = new LLC_BI__Loan__c(LLC_BI__Account__c = testAcc[0].Id,
                                                         LLC_BI__Product__c = 'Ordinary Current Account', 
                                                         LLC_BI__Stage__c = 'Booked',
                                                         LLC_BI__Status__c = 'Open');
        listLoans.add(loan1Acct1);
        LLC_BI__Loan__c loan2Acct1 = new LLC_BI__Loan__c(LLC_BI__Account__c = testAcc[0].Id,
                                                         LLC_BI__Product__c = 'Ordinary Current Account', 
                                                         LLC_BI__Stage__c = 'Booked',
                                                         LLC_BI__Status__c = 'Open');
        listLoans.add(loan2Acct1);
        LLC_BI__Loan__c loan1Acct2 = new LLC_BI__Loan__c(LLC_BI__Account__c = testAcc[1].Id,
                                                         LLC_BI__Product__c = 'Ordinary Current Account', 
                                                         LLC_BI__Stage__c = 'Booked',
                                                         LLC_BI__Status__c = 'Open');
        listLoans.add(loan1Acct2);
        LLC_BI__Loan__c loan2Acct2 = new LLC_BI__Loan__c(LLC_BI__Account__c = testAcc[1].Id,
                                                         LLC_BI__Product__c = 'Ordinary Current Account', 
                                                         LLC_BI__Stage__c = 'Booked',
                                                         LLC_BI__Status__c = 'Open');
        listLoans.add(loan2Acct2);
        
        insert listLoans;
       
        cm_TestDataFactory.createMonthlyStatements(loan1Acct1.Id, AvgCreditBalance, WorstBalance, Turnover);
        cm_TestDataFactory.createMonthlyStatements(loan2Acct1.Id, AvgCreditBalance * 2, WorstBalance * 2, Turnover * 2);
        cm_TestDataFactory.createMonthlyStatements(loan1Acct2.Id, AvgCreditBalance, WorstBalance, Turnover);
        cm_TestDataFactory.createMonthlyStatements(loan2Acct2.Id, AvgCreditBalance * 2, WorstBalance * 2, Turnover * 2);
    }
    
    @isTest
    static void testRCCUpdateRelationship() {
        
        // Start the batch
        Test.startTest();
        // Execute batch that copies TTM to ValidforCalc first
        cm_RCC_CopyTTMtoValidforCalcBatch ttmToValidforCalcBatch = new cm_RCC_CopyTTMtoValidforCalcBatch();
        Database.executeBatch(ttmToValidforCalcBatch);
        
        cm_RCC_UpdateRelationship updateRelationshipBatch = new cm_RCC_UpdateRelationship();
        Database.executeBatch(updateRelationshipBatch);
        Test.stopTest();
        
        // TODO: Verify Aggr Credit Balance, Aggr Minimum Balance, Max Turnover
        List<Account> accountList = [ SELECT Id, Name, cm_AggrCreditBalance__c, cm_AggrMinimumBalance__c, cm_MaxTurnover__c
                                     FROM Account ];
        
        // Expected Max Turnover, Aggr Credit Balance, Aggr Minimum Balance calculation: (m1Turnover + m2Turnover ... + m12Turnover) /12
        for(Account acct : accountList) {
            System.debug('Account ID: ' + acct.Id);
            System.debug('Max Turnover: ' + acct.cm_MaxTurnover__c);
            System.debug('Aggr Credit Blance: ' + acct.cm_AggrCreditBalance__c);
            System.debug('Aggr Minimum Balance: ' + acct.cm_AggrMinimumBalance__c);
            //Assert.areEqual(6000, account.cm_MaxTurnover__c);
            //Assert.areEqual(3000, account.cm_AggrCreditBalance__c);
            //Assert.areEqual(6000, account.cm_AggrMinimumBalance__c);
        }
    }
}