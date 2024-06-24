@isTest
public class cm_MonthlyStatementAfterSaveFlowTest {

    @testSetup
    static void testDataSetup(){
        
        LLC_BI__Loan__c nominatedLoanRecord = cm_TestDataFactory.createNominated();
        Account accountRecord = cm_TestDataFactory.createSingleAccount(nominatedLoanRecord.Id, 'Sole Trader', '2M', 5);
        //LLC_BI__Product_Type__c productTypeRecord = cm_TestDataFactory.createProductType('Sole Trader', 'SB&A');
        cm_TestDataFactory.createSingleLoan(null, null, null, null, 'Bridging Loans', '123456', accountRecord.Id);
        
    }
    
    @isTest
    static void updateParentLoanOnMonthlyStatementInsert(){
        List<LLC_BI__Loan__c> loanRecordList = [SELECT Id,cm_Sort_Code__c FROM LLC_BI__Loan__c WHERE cm_Sort_Code__c = '123456' LIMIT 1];
        System.debug('@@@loanRecordList: '+loanRecordList);
        
        MonthlyStatement__c msRecord = new MonthlyStatement__c();
        msRecord.cm_BKKCreditGrade__c = '2M';
        msRecord.Loan__c = loanRecordList[0].Id;
        msRecord.cm_MonthEndDate__c = System.today()+30;
        msRecord.cm_ValidforCalc__c = true;
        msRecord.cm_AverageCreditBalance__c = 3000000;
        msRecord.cm_Turnover__c = 500000;
        msRecord.cm_WorstBalance__c = 800000;
        insert msRecord;
        
        List<LLC_BI__Loan__c> loanAssertRecordList = [SELECT Id,cm_Sort_Code__c,cm_CreditGrade__c FROM LLC_BI__Loan__c WHERE cm_Sort_Code__c = '123456' LIMIT 1];
        
        //Expected,Actual
        System.assertEquals(msRecord.cm_BKKCreditGrade__c, loanAssertRecordList[0].cm_CreditGrade__c);
    }
}