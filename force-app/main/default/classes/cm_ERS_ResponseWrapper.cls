/**************************************************************************************************
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1:  wrapper for ERS Call out
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/

public class cm_ERS_ResponseWrapper {
    
    public decisionResult decisionResult;
	public class decisionResult {
		public accountOrigination accountOrigination;
	}
    
    public class AccountOrigination {
         public Assessment assessment;
         public PrimaryApplicant primaryApplicant;
         public Credit credit;
         public Identifier identifier;
         public Risk_Z risk;
    }
   
    public class Assessment {
         public String finalDecisionCode;
         public String decisionOutcome;
         public String decisionOutcomeTable;
         public String reasonCode;
         public Decimal recommendedMaximumLoanAmount;
         public Decimal recommendedOverdraftAbsoluteValue;
         public String overdraftCalculationType;
         public Double overdraftAsIncomePercentage;
         public Integer recommendedOverdraftMaximumValue;
         public String decisionRulesID;
         public decimal roundedOverdraftAmountInHomeCurrency;
         public Decimal netDisposableIncome; 
         public Double netDisposableIncomeasPercentageOfMonthlyIncome;
         public String bureauRatingIndicator;
         public Decimal overdraftRepaymentAmount;
         public Decimal customerOverdraftLimit;
    }
    
    public class PrimaryApplicant{
         public CustomerDetails customerDetails;
         public PersonDetails personDetails;
         public ApplicantAccountDetails applicantAccountDetails;
    }
    
    public class CustomerDetails{
         public General_X general;
         public Risk_X risk;
    }
    //primaryApplicant.customerDetails.general
    public class General_X{
         public String boiFinanceCustomerIndicator;
    }
    //primaryApplicant.customerDetails.risk
    public class Risk_X{
         public String gradeControlCode;
         public Decimal totalGroupExposureAmount;
         public String creditRating7InternalAndControlCode;
    }
    //primaryApplicant.perSonDetails
    public class PersonDetails{
          public Financials financials;
    }
    //primaryApplicant.perSonDetails.financials
    public class Financials{
          public double netDisposableIncome;
    }
    //primaryApplicant.applicantAccountDetails
    public class ApplicantAccountDetails{
         public Account account;
         public CurrentAccount currentAccount;
    }
    //primaryApplicant.applicantAccountDetails.account
    public class Account{
         public Behaviour behaviour;
         public Limit_X x_limit; //account.limit
         public MonetaryAmount monetaryAmount;
         public Risk_Y risk;
         public Servicing servicing;
    }
    //primaryApplicant.applicantAccountDetails.account.behaviour
    public class Behaviour{
         public Decimal minimumBalanceOverLast3Months;
         public Decimal minimumBalanceOverLast6Months;
         public Integer irregularNumberOfDaysInLast12months;
         public Integer irregularNumberOfDaysInLast6months;
         public Integer numberOfDaysPaymentPostponedInLast6months;
         public Integer numberOfReversalsUnpaidsPaymentsInLast12months;
         public Integer numberOfReversalsUnpaidsPaymentsInLast6months;
         public Integer noOfDaysInDebitInLast6Months;
         public Decimal averageLedgerBalanceProbeMTD;
         public Decimal x_3MRollingAverageCreditTurnover;
         public Decimal x_6MRollingAverageCreditTurnover;
         public Decimal x_12MRollingAverageCreditTurnover;
    }
    //primaryApplicant.applicantAccountDetails.account.limit
    public class Limit_X{
         public Decimal timeSinceLimitChange;
    }
    //primaryApplicant.applicantAccountDetails.account.monetaryAmount
    public class MonetaryAmount{
         public Decimal clearedBalance;
         public Decimal totalCreditTurnoverCurrentMonth;
    }
    //primaryApplicant.applicantAccountDetails.account.risk
    public class Risk_Y{
         public double exposureAtDefaultFactor;
         public double lossGivenDefaultFactor;
         public Integer pointInTimeProbabilityOfDefaultPool;
         public Integer pointInTimeProbabilityOfDefaultScore;
         public double pointInTimeProbabilityOfDefaultScorecardID;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable1;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable2;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable3;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable4;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable5;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable6;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable7;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable8;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable9;
         public String pointInTimeProbabilityOfDefaultScorecardResultsTable10;
         public double pointInTimeProbabilityOfDefaultSubPool;
         public double probabilityOfDefault;
         public Integer capitalRequirementK;
         public double riskWeightedAsset;
         public Integer creditRating7Internal;
    }
    //primaryApplicant.applicantAccountDetails.account.servicing
    public Class Servicing{
        public String ppiIndicator;
    }
    //primaryApplicant.applicantAccountDetails.currentAccount
    public Class CurrentAccount{
         public General_Y general;
         public Limit_Y x_limit; //currentAccount.limit
    }
    //primaryApplicant.applicantAccountDetails.currentAccount.general
    public class General_Y{
         public String chequeBookIndicator;
         public String chequecCardIndicator;
         public String passCardIndicator;
         public String debitCardIndicator;
    }
    //primaryApplicant.applicantAccountDetails.currentAccount.limit
    public class Limit_Y{
         public Integer lowestCreditLimitUsed;
         public double creditLimitUsedPercentage;
    }
    //accountOrigination.credit
    public class Credit{
         public String preApprovalBlockedIndicator;
    }
    //accountOrigination.identifier
    public class Identifier{
         public integer scorecardIdentifier;
    }
    //accountOrigination.risk
    public class Risk_Z{
         public Integer creditRiskScore;
         public Decimal applicationExposureAtDefaultAmount;
         public Decimal applicationExpectedLossAmount;
         public Double applicationLossGivenDefault;
         public Double creditCorrelationPDEAD;
         public String modellingStrategy;
         public Integer baselRiskScore;
    }
    
    @TestVisible
    private static cm_ERS_ResponseWrapper.Assessment getUnitTest(){
		cm_ERS_ResponseWrapper.Assessment assessment = new cm_ERS_ResponseWrapper.Assessment();

        return assessment;
    } 
}