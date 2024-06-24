/**************************************************************************************************
* @Author:    Kuldeep Parihar 
* @Date:      06/02/2023
* @Description: This class will handle Call out to ERS.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public without sharing class cm_ERS_GetDecisionProvider {
    
    
    /**************************************************************************************************
* @Author:      Kuldeep Parihar  
* @Date:        06/02/2023
* @Description: Method to fetch  facility details
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static  LLC_BI__Loan__c[] getLoanDetails( string appID) { 
        
        LLC_BI__Loan__c[] loans=[SELECT   Name,
                                 LLC_BI__Amount__c,
                                 LLC_BI__Pricing_Basis__c,
                                 LLC_BI__Term_Months__c, 
                                 LLC_BI__First_Payment_Date__c,
                                 LLC_BI__Account__c, 
                                 LLC_BI__Account__r.Name, 
                                 LLC_BI__Stage__c,
                                 LLC_BI__Status__c,
                                 LLC_BI__CRA_Type_Code__c,
                                 LLC_BI__Product__c,
                                 LLC_BI__Credit_Approval_Date__c,
                                 cm_ApplicationNumber__c,
                                 cm_Loan_Purpose__c,
                                 LLC_BI__Monthly_Payment__c,
                                 LLC_BI__Account__r.cm_SortCode__c,
                                 LLC_BI__Account__r.Type,
                                 LLC_BI__Account__r.AccountNumber,
                                 LLC_BI__Account__r.LLC_BI__Credit_Rating__c,
                                 LLC_BI__Total_Monthly_Debt__c,
                                 LLC_BI__Account__r.LLC_BI__Monthly_Income__pc,
                                 // cm_living_Arrangements__c,
                                 //LLC_BI__Product_Reference__r.cm_AccountType__c,
                                 //LLC_BI__Account__r.cm_SBA_RM__c // field use to store the value for ERS 4
                                 LLC_BI__Account__r.LLC_BI__Marital_Status__pc,
                                 LLC_BI__Account__r.LLC_BI__Number_of_Dependents__pc,
                                 createdDate,
                                 // LLC_BI__Account__r.cm_Living_Arrangements__c,
                                 LLC_BI__Account__r.LLC_BI__Status__c,
                                 LLC_BI__Account__r.PersonBirthdate,
                                 LLC_BI__Account__r.cm_monthlyRentExpense__c, //ERS 7 field to be created
                                 LLC_BI__Account__r.cm_boiOnlySavingsValue__c, //ERS 93 field to be created
                                 cm_MarketClassification__c,
                                 LLC_BI__Loan__c.cm_DebtServiceCoverage__c,
                                 LLC_BI__Account__r.cm_MainAccountNumber__c,
                                 cm_RepaymentLoanRatio__c,
                                 cm_RepaymentOverdraftRatio__c,
                                 cm_Term__c,
                                 //cm_Overdraft_Temporary_Duration__c,
                                 cm_Account_Number__c,
                                 LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.cm_AccountType__c,
                                 //(SELECT Id,Name,LLC_BI__Product_Type__r.cm_AccountType__c FROM LLC_BI__Product_Reference__r),
                                 //(SELECT Id,Name,LLC_BI__Borrower_Type__c,LLC_BI__Account__r.PersonBirthdate FROM LLC_BI__Legal_Entities__r),
                                 (SELECT Id,Name,LLC_BI__Borrower_Type__c,LLC_BI__Account__r.PersonBirthdate,LLC_BI__Account__r.cm_boiOnlySavingsValue__c FROM LLC_BI__Legal_Entities__r),//ERS 93
                                 (SELECT Id,Name,cm_CourseGrade__c FROM CCR__r),
                                 (SELECT Id,LLC_BI__Index__c,LLC_BI__Rate__c,LLC_BI__Applied_Rate__c,LLC_BI__Pricing_Stream__r.LLC_BI__Loan__c FROM Pricing_Rate_Components__r WHERE LLC_BI__Pricing_Stream__r.LLC_BI__Loan__c != '' AND LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c = true),
                                 LLC_BI__Product_Type__c,
                                 cm_MainCurrentAccount__c,
                                 cm_SortCode__c,
                                 LLC_BI__Account__r.cm_MarketClassification__c
                                 FROM LLC_BI__Loan__c 
                                 where Id = : appID
                                 LIMIT 1];
        
        return loans;
    } 
    /**************************************************************************************************
* @Author:      Jan Reimil Cabantog
* @Date:        02/05/2023
* @Description: Method to fetch  sum of loan amount details
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/  
    public static List<AggregateResult> getsumOfLoanAmount( string relationshipId){
        List<AggregateResult> sumOfLoanAmount = [SELECT sum(LLC_BI__Amount__c)sumOfAmount FROM LLC_BI__Loan__c WHERE LLC_BI__Stage__c != 'Booked' AND LLC_BI__Stage__c != 'Complete' AND LLC_BI__Account__r.Id =: relationshipId];
        return sumOfLoanAmount;
    }
/*    /**************************************************************************************************
* @Author:      Jan Reimil Cabantog
* @Date:        04/05/2023
* @Description: Method to fetch  loanpurpose from metadata details
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/      
   /* public static ERS_Loan_Purpose__mdt getloanPurpose(string strloanpurpose){
        ERS_Loan_Purpose__mdt loanpurpose = [SELECT MasterLabel,Characteristic__c FROM ERS_Loan_Purpose__mdt WHERE MasterLabel =: strloanpurpose LIMIT 1];
        return loanpurpose;
    }*/
    
    /**************************************************************************************************
* @Author:      Kuldeep Parihar  
* @Date:        06/02/2023
* @Description: Method to fetch  facility details
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static  String getMockedRequest( ) { 
        StaticResource sr = [SELECT Id, Body 
                             FROM StaticResource 
                             WHERE Name = 'ERS_Request' LIMIT 1];
        
        String body = sr.Body.toString();
        return body;
    }
}