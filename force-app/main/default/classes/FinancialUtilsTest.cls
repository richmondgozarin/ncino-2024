@isTest
public class FinancialUtilsTest {
    
    @isTest
    static void testCalculateMonthlyPmt() {
        FinancialUtils.LoanInput loanInput = new FinancialUtils.LoanInput();
        FinancialUtils.LoanOutput loanOutput = new FinancialUtils.LoanOutput();
        
        loanInput.principal = 100;
        loanInput.annualInterestRate = 1.01;
        loanInput.loanTermMonths = 12;
       
        List<FinancialUtils.LoanInput> loanInputList = new List<FinancialUtils.LoanInput>();
        List<FinancialUtils.LoanOutput> loanOutputListResult = new List<FinancialUtils.LoanOutput>();
        loanInputList.add(loanInput);
        loanOutputListResult = FinancialUtils.execCalculation(loanInputList);
        
        loanOutput = loanOutputListResult[0];
        
        Assert.areEqual(101.01, loanOutput.fv);
        Assert.areEqual(8.38, loanOutput.pmt);
        
        
        // Add Asserrtions here
    }
}