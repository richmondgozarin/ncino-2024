/**************************************************************************************************
* @Author:    Mark John Amadeo
* @Date:      27/03/2024
* @Description: This class will contain all utility functions related to RCC_UpdateRelationship.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class cm_RCC_UpdateRelationshipHelper {
    // helper function to process monthly statements
/*
    public static void processMonthlyStatements(Id loanId, List<MonthlyStatement__c> listMnthlyStmnts) {
        
        // Loop through all monthly statements related to the loan and get the turnovers for each month
        for(MonthlyStatement__c mnthlyStmnts : listMnthlyStmnts) {
            if(mnthlyStmnts.Loan__c == loanId) {
                System.debug('Month: ' + Integer.valueOf(mnthlyStmnts.cm_Month__c));
                System.debug('Max Turnover: ' + mnthlyStmnts.cm_Turnover__c);
                switch on Integer.valueOf(mnthlyStmnts.cm_Month__c) {
                    when 1 {
                        cm_RCC_UpdateRelationship.m1MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m1MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m1MaxTurnover;
                    }
                    when 2 {
                        cm_RCC_UpdateRelationship.m2MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m2MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m2MaxTurnover;
                    }
                    when 3 {
                        cm_RCC_UpdateRelationship.m3MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m3MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m3MaxTurnover;
                    }
                    when 4 {
                        cm_RCC_UpdateRelationship.m4MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m4MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m4MaxTurnover;
                    }
                    when 5 {
                        cm_RCC_UpdateRelationship.m5MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m5MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m5MaxTurnover;
                    }
                    when 6 {
                        cm_RCC_UpdateRelationship.m6MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m6MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m6MaxTurnover;
                    }
                    when 7 {
                        cm_RCC_UpdateRelationship.m7MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m7MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m7MaxTurnover;
                    }
                    when 8 {
                        cm_RCC_UpdateRelationship.m8MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m8MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m8MaxTurnover;
                    }
                    when 9 {
                        cm_RCC_UpdateRelationship.m9MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m9MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m9MaxTurnover;
                    }
                    when 10 {
                        cm_RCC_UpdateRelationship.m10MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m10MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m10MaxTurnover;
                    }
                    when 11 {
                        cm_RCC_UpdateRelationship.m11MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m11MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m11MaxTurnover;
                    }
                    when 12 {
                        cm_RCC_UpdateRelationship.m12MaxTurnover = mnthlyStmnts.cm_Turnover__c > cm_RCC_UpdateRelationship.m12MaxTurnover ? mnthlyStmnts.cm_Turnover__c : cm_RCC_UpdateRelationship.m12MaxTurnover;
                    }
                } // end switch
            } // end if
        } // end for loop
    } // end processMonthlyStatements */
}