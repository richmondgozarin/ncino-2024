/**************************************************************************************************
* @Author:      Bhanu
* @Date:        05/06/2023
* @Description: Below code accepts a list of loan inputs, calculates the Monthly Payment PMT and future value for each input, returns a list of loan outputs containing the calculated results.
* @Revision(s): [Date] - [change ref] - [Aut] - [Decription]   
***************************************************************************************************/


public without sharing class FinancialUtils {
	@InvocableMethod(label = 'Calculate Monthly Payment')
	public static list<LoanOutput> execCalculation(List<LoanInput> loanInputs) {
		List<LoanOutput> results = new List<LoanOutput>();
		for (loanInput loanIns: loanInputs) {
			results.add(calculateMonthlyPayment(loanIns));
		}
		return results;
	}

	public static LoanOutput calculateMonthlyPayment(LoanInput loanInputs) {
		LoanOutput lno = new LoanOutput();
		try {
			Decimal principal = loanInputs.principal;
			Decimal annualInterestRate = loanInputs.annualInterestRate;
			Integer loanTermMonths = loanInputs.loanTermMonths;
			Decimal monthlyInterestRate = annualInterestRate / 12 / 100;
			Decimal numerator = principal * monthlyInterestRate * (1 + monthlyInterestRate).pow(loanTermMonths);
			Decimal denominator = (1 + monthlyInterestRate).pow(loanTermMonths) - 1;
			Decimal monthlyPayment = numerator / denominator;
			lno.pmt = monthlyPayment.setScale(2, System.RoundingMode.HALF_UP);
			Decimal futureValue = principal * (1 + monthlyInterestRate).pow(loanTermMonths);
			lno.fv = futureValue.setScale(2, System.RoundingMode.HALF_UP);

		} catch (Exception ex) {
			// Handle the exception or log the error message here
			System.debug('An error occurred: ' + ex.getMessage());
		}

		return lno;
	}

	public class LoanInput {
		@InvocableVariable(required = true)
		public Decimal principal;
		@InvocableVariable(required = true)
		public Decimal annualInterestRate;
		@InvocableVariable(required = true)
		public Integer loanTermMonths;
	}

	public class LoanOutput {
		@AuraEnabled @InvocableVariable
 public Decimal pmt;
		@AuraEnabled @InvocableVariable
 public Decimal fv;
	}
}
/*
public static Decimal calculateFutureValue(Decimal presentValue, Decimal interestRate, Integer periods) {
Decimal futureValue = presentValue * (1 + interestRate).pow(periods);
return futureValue.setScale(2, System.RoundingMode.HALF_UP);
}


Decimal presentValue = 65000;
Decimal interestRate = 0.004166667;
Integer periods = 12;

Decimal futureValue = FinancialUtils.calculateFutureValue(presentValue, interestRate, periods);
System.debug('Future Value: ' + futureValue);
System.debug('InterestOnlyPayment ' + (futureValue - presentValue)/12);

FV(rate,nper,pmt,[pv],[type])

*/
//Using Acural_360
/*  
public static Decimal calculateMonthlyPayment(Decimal principal, Decimal annualInterestRate, Integer loanTermMonths) {
Decimal monthlyInterestRate = annualInterestRate / 12 / 100;
Integer daysInYear = 360;
Integer daysInMonth = 30;
Decimal interestPerDay = monthlyInterestRate / daysInYear * daysInMonth;
Decimal numerator = principal * interestPerDay * (1 + interestPerDay).pow(loanTermMonths);
Decimal denominator = (1 + interestPerDay).pow(loanTermMonths) - 1;
Decimal monthlyPayment = numerator / denominator;

return monthlyPayment.setScale(2, System.RoundingMode.HALF_UP);
}
*/