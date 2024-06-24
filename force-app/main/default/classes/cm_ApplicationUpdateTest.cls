@isTest
public class cm_ApplicationUpdateTest {
    // Commented out while build is in progress
    /*static final Integer NUMBER_OF_MONTHLY_STATEMENTS = 20;
    
    // This method is used to create initial data for the test methods
    @TestSetup
    static void buildData() {
        // Create Relationship record
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        // Create Monthly Statement records
        List<MonthlyStatement__c> monthlyStmtsList = new List<MonthlyStatement__c>();
        for(Integer i = 1; i <= NUMBER_OF_MONTHLY_STATEMENTS; i++) {
            monthlyStmtsList.add(new MonthlyStatement__c(cm_Relationship__c = acc.Id,
                                                         cm_ValidforCalc__c = true,
                                                         cm_AverageCreditBalance__c = generateRandomNumber(),
                                                         cm_WorstBalance__c = generateRandomNumber(),
                                                         cm_Turnover__c = generateRandomNumber(),
                                                         cm_MonthEndDate__c = Date.today() - 1
                                                        ));
        }
        insert monthlyStmtsList;
        
        // Create Application record
        LLC_BI__Application__c app = new LLC_BI__Application__c();
        app.nPortal__Account__c = acc.Id;
        insert app;
    }

    @isTest
    static void updateApplicationComplete() {
        Account acc = [ SELECT Id, cm_TestAverageCreditBalance__c, cm_TestAverageWorstBalance__c, cm_TestAverageTurnover__c FROM Account LIMIT 1 ];
        LLC_BI__Application__c app = [ SELECT nPortal__Status__c FROM LLC_BI__Application__c LIMIT 1 ];
        Decimal sumAvgCreditBalance = 0;
        Decimal sumWorstBalance = 0;
        Decimal sumTurnover = 0;
        List<MonthlyStatement__c> monthlyStmtList = [ SELECT cm_Relationship__c,
                                                     cm_AverageCreditBalance__c,
                                                     cm_WorstBalance__c,
                                                     cm_Turnover__c,
                                                     cm_TTM__c,
                                                     cm_ValidforCalc__c
                                                     FROM MonthlyStatement__c
                                                     WHERE cm_Relationship__c = :acc.Id AND cm_TTM__c = true AND cm_ValidforCalc__c = true ];
        // Calculate SumAvgBalance, SumWorstBalance, SumTurnover
        for(MonthlyStatement__c monthlyStmt : monthlyStmtList) {
            sumAvgCreditBalance += monthlyStmt.cm_AverageCreditBalance__c;
            sumWorstBalance += monthlyStmt.cm_WorstBalance__c;
            sumTurnover += monthlyStmt.cm_Turnover__c;
        }
        
        // Verify AvgCreditBalance, AvgWorstBalance, and AvgTurnover is empty before application is updated
        Assert.isNull(acc.cm_TestAverageCreditBalance__c);
        Assert.isNull(acc.cm_TestAverageWorstBalance__c);
        Assert.isNull(acc.cm_TestAverageTurnover__c);
        
        
        Test.startTest();
        app.nPortal__Status__c = 'Complete';
        update app;
        Test.stopTest();
        
        // Verify AvgCreditBalance, AvgWorstBalance and AvgTurnover were updated after Application is completed
        acc = [ SELECT Id, cm_TestAverageCreditBalance__c, cm_TestAverageWorstBalance__c, cm_TestAverageTurnover__c FROM Account LIMIT 1 ];
        System.debug('Relationship after update: ' + acc);
        Assert.areEqual(sumAvgCreditBalance/monthlyStmtList.size(), acc.cm_TestAverageCreditBalance__c);
        Assert.areEqual(sumWorstBalance/monthlyStmtList.size(), acc.cm_TestAverageWorstBalance__c);
        Assert.areEqual(sumTurnover/monthlyStmtList.size(), acc.cm_TestAverageTurnover__c);
        
    }
    
    // This method generates random number from 500-1000
    static Integer generateRandomNumber() {
        return Integer.valueof(((Math.random()+1) * 500));
    } */
}