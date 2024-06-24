/**************************************************************************************************\
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1:  wrapper for ERS Call out
* @Revision(s): [Date] - [Change RefaccountOriginationerence] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class cm_ERS_RequestWrapper {
   
    public class Account {
       public General_X general;
       public Identifier_Y identifier;
       public Segmentation_Z segmentation;
       public Servicing servicing;
    }
    
    public class AdditionalApplicant {
      public PersonDetails_Z personDetails;
    }
    
   public AccountOrigination accountOrigination ;
   public ExternalAssessment externalAssessment ;
    
    public class Segmentation {
    	public String customerNatureCode; //ERS 53
    }
    
    public class Risk {
        public String creditRating7Internal; //ERS 51
    }
    
    public class PrimaryApplicant {
        public Decimal  boiOnlySavingsValue; //ERS 93
        public CustomerDetails customerDetails;
        public PersonDetails personDetails;
        public ApplicantAccountDetails applicantAccountDetails;
    }
    
    public class Servicing {
        public Decimal individualPermissionAmount; //ERS 55
    }
    
    public class CustomerDetails {
        public General_Z general;
        public Identifier_Z identifier;
        public Contact contact;
        public Relationship relationship;
        public Risk risk;
        public Segmentation segmentation;
    }
    
    public class ExternalBureauResponse {
        public Decimal  coarseGradingClient1; //ERS 70 //change from string to double
        public Decimal  coarseGradingClient2; //ERS 71
        public Decimal  coarseGradingClient3; //ERS 72
        public Decimal  coarseGradingClient4; //ERS 73
    }
    
    public class AccountOrigination {
        public General general;
        public Identifier identifier;
        public Application application;
        public Affordability affordability; //move affordability obj here base on the sample ERS Request Reimil 06/05/2023
        public Credit credit;
        public MonetaryAmount monetaryAmount;
        public PrimaryApplicant primaryApplicant;
        public AdditionalApplicant additionalApplicant;
    }
    
    public class PersonDetails {
        public General_Y general;
        public Employment employment;
        public Financials financials;
    }
    
    public class ExternalAssessment {
        public ExternalBureauResponse externalBureauResponse;
    }
    
    public class Identifier {
        public Integer applicationNumber; //change to integer ERS 1
        public String applicationBusinessSourceCode;//ERS 21
    }
    
    public class Credit {
         public Integer subPurposeOfLoan; //ERS 17
         public Integer loanTermInMonths; //ERS 22
    }
    
    public class Employment {
        
    }
    
    public class Financials {

    }
    
    public class Segmentation_Z {

    }
    
    public class MonetaryAmount {
         public Decimal inflightLoanApplicationAmount;//ERS 14
         public Decimal requestedLoanAmount; //change from integer to decimal to capture decimal //ERS 12
         public Decimal amountOfAllNewCreditApplciationsInProgress; //change to dobule from integer to capture decimal places Jan Reimil Cabantog //ERS 62
         public Decimal monthlyRentExpense; //ERS 7
         public Decimal issuedCapital; //ERS 74
    }
    
    public class General_W {
         public string dateOfBirth; //ERS 24
    }
    
    public class General_X {
      
    }
    
    public class General_Y {
         public String dateOfBirth; //ERS 26
         public String mannerOfHabitation; //ERS 35
    }
    
    public class General_Z {

    }
    
    public class Contact {

    } 
    
    public class ApplicantAccountDetails {
         public Account account;
    }
    
    public class PersonDetails_Z {
         public General_W general;
         public Employment employment;
    }
    
    public class Relationship {
         public String vipEntityIndicator; //ERS 50
    }
    
    public class Identifier_Y {
         public Integer accountNumber; //change to integer from string //ERS 75
         public Integer sortCode; //ERS 78
    }
    
    public class General {
         public String relationshipManagerCode;//ERS 4
    }

    public class Application {
         public String debitInterestRateCode; //ERS 60
         public Integer collateralCode; //ERS 8
         public String stockingLoanIndicator;//ERS 10
         public String schoolChurchCharitiesClubsIndicator; //ERS 9
         public String applicationType; //ERS 23
         public String accountTypeCode; //ERS 13
         public String productTypeCode; //ERS 16
         public Integer numberOfApplicants; //ERS 15
         public String bridgeLoanIndicator;//ERS 27
         public Decimal totalSavingsValue; //ERS 94
    }
    
    public class Identifier_Z {
        
    }
    
    public class Affordability{
         public Decimal riskCapacityCalculationLoanRatio; //ERS 95 from rccOutputLoans
         public Decimal riskCapacityCalculationOverdraftPercentage; //ERS 96 from rccOutputOverdraft
         public Decimal debtServiceCoverageRatio; //ERS 98 from dscOutput
        
    }
    
    @TestVisible
    private static cm_ERS_RequestWrapper.Identifier getUnitTest(){
		cm_ERS_RequestWrapper.Identifier identifier = new cm_ERS_RequestWrapper.Identifier();

        return Identifier;
    }    
}