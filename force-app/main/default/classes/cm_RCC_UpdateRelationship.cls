/**************************************************************************************************
* @Author:    Mark John Amadeo
* @Date:      27/03/2024
* @Description: This class will aggregate the values from loan(Aggr Credit Balance, Aggr Minimum Balance)
* 				and RCC(Max Turnover) to relationship.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
global class cm_RCC_UpdateRelationship implements Database.Batchable<SObject>, Schedulable {
    // Global variables
    
    private Decimal m1MaxTurnover = 0;
    private Decimal m2MaxTurnover = 0;
    private Decimal m3MaxTurnover = 0;
    private Decimal m4MaxTurnover = 0;
    private Decimal m5MaxTurnover = 0;
    private Decimal m6MaxTurnover = 0;
    private Decimal m7MaxTurnover = 0;
    private Decimal m8MaxTurnover = 0;
    private Decimal m9MaxTurnover = 0;
    private Decimal m10MaxTurnover = 0;
    private Decimal m11MaxTurnover = 0;
    private Decimal m12MaxTurnover = 0;
    private Decimal aggrCreditBalance = 0;
    private Decimal aggrMinimumBalance = 0;
    
    // Implement start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Account WHERE IsPersonAccount = false';
        return Database.getQueryLocator(query);
    }
    
    // Implement the execute method
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        try {
            Decimal mnthlyStmntsMaxTurnover = 0;
            
            List<Account> acctsToUpdateList = new List<Account>();
            Set<ID> accountIDsList = new Set<ID>();
            
            for(Account acct : scope) {
                accountIDsList.add(acct.Id);
            }
            
            List<AggregateResult> loansListAggr = [ SELECT LLC_BI__Account__c, SUM(cm_AvgCreditBalance__c) avgCreditBalance, SUM(cm_AvgMinimumBalance__c) avgMinimumBalance
                                               FROM LLC_BI__Loan__c
                                               WHERE LLC_BI__Account__c IN :accountIDsList AND LLC_BI__Product__c = 'Ordinary Current Account' AND LLC_BI__Stage__c = 'Booked' AND LLC_BI__Status__c = 'Open'
                                               GROUP BY LLC_BI__Account__c ];
            
            List<LLC_BI__Loan__c> loansList = [ SELECT Id, LLC_BI__Account__c, cm_AvgCreditBalance__c, cm_AvgMinimumBalance__c, cm_AvgTurnover__c
                                               FROM LLC_BI__Loan__c
                                               WHERE LLC_BI__Account__c IN :accountIDsList AND LLC_BI__Product__c = 'Ordinary Current Account' AND LLC_BI__Stage__c = 'Booked' AND LLC_BI__Status__c = 'Open' ];
            
            List<MonthlyStatement__c> mnthlyStmntsList = [ SELECT Id, cm_Turnover__c, cm_Month__c, Loan__c
                                                          FROM MonthlyStatement__c
                                                          WHERE Loan__c IN :loansList AND cm_TTM__c = true ORDER BY cm_Month__c ASC ];
            
            Map<Id, Account> accountsMap = new Map<Id, Account>(scope);
            
            // Test approach to remove apex time limit issue - JA
            /*set<Id> filteredLoanId = new set<Id>();
            set<Id> filteredAccountId = new set<Id>();
            
            Map<string, string> loanIds = new Map<string, string>();
            for (LLC_BI__Loan__c l: loansList) {
                loanIds.put(l.LLC_BI__Account__c, l.Id);
            }
            
            for (Account scopeT: scope) {
                if (loanIds.containsKey(scopeT.Id)) {
                    for (String acctId: loanIds.keySet()) {
                        if (scopeT.Id == acctId) {
                            //filteredLoanId.add(loanIds.get(scopeT.Id));
                            filteredAccountId.add(scopeT.Id);
                        }
                    }
                }
            }
            
            //Map<Id, Decimal> aggrCreditBal = new Map<Id, Decimal>();
            //Map<Id, Decimal> aggrAvgMinimumBal = new Map<Id, Decimal>();
            
            for (LLC_BI__Loan__c loanRecord: [Select Id, LLC_BI__Account__c, cm_AvgCreditBalance__c, cm_AvgMinimumBalance__c, cm_AvgTurnover__c FROM LLC_BI__Loan__c where LLC_BI__Account__c in :filteredAccountId]) {
                //system.debug('filtered loan records : ' + loanRecord);
                aggrCreditBalance += loanRecord.cm_AvgCreditBalance__c;
                aggrMinimumBalance += loanRecord.cm_AvgMinimumBalance__c;
                //aggrCreditBal.put(loanRecord.LLC_BI__Account__c, loanRecord.cm_AvgCreditBalance__c);
                //aggrAvgMinimumBal.put(loanRecord.LLC_BI__Account__c, loanRecord.cm_AvgMinimumBalance__c);
                processMonthlyStatements(loanRecord.Id, mnthlyStmntsList);
                
            }
            for (Account updateAccounts: [Select Id, cm_AggrCreditBalance__c, cm_AggrMinimumBalance__c, cm_MaxTurnover__c from Account where id in :filteredAccountId]) {
                mnthlyStmntsMaxTurnover = (m1MaxTurnover + m2MaxTurnover + m3MaxTurnover + m4MaxTurnover + m5MaxTurnover + m6MaxTurnover + m7MaxTurnover + m8MaxTurnover + m9MaxTurnover + m10MaxTurnover + m11MaxTurnover + m12MaxTurnover) / 12;
                updateAccounts.cm_AggrCreditBalance__c = aggrCreditBalance;
                updateAccounts.cm_AggrMinimumBalance__c = aggrMinimumBalance;
                //updateAccounts.cm_AggrCreditBalance__c = aggrCreditBal.get(updateAccounts.Id);
                //updateAccounts.cm_AggrMinimumBalance__c = aggrAvgMinimumBal.get(updateAccounts.Id);
                updateAccounts.cm_MaxTurnover__c = mnthlyStmntsMaxTurnover;
                acctsToUpdateList.add(updateAccounts);
                //resetRCCValues();
            } */
            
            // Approach 1 - Nested For Loops
            
            /*for(Account account : scope) {
            // Loop through related loans and increment the Credit Balance and Minimum Balance
            for(LLC_BI__Loan__c loan : loansList) {
            
            if(loan.LLC_BI__Account__c == account.Id) {
            aggrCreditBalance += loan.cm_AvgCreditBalance__c;
            aggrMinimumBalance += loan.cm_AvgMinimumBalance__c;
            }
            processMonthlyStatements(loan.Id, mnthlyStmntsList);
            }
            
            mnthlyStmntsMaxTurnover = (m1MaxTurnover + m2MaxTurnover + m3MaxTurnover + m4MaxTurnover + m5MaxTurnover + m6MaxTurnover + m7MaxTurnover + m8MaxTurnover + m9MaxTurnover + m10MaxTurnover + m11MaxTurnover + m12MaxTurnover) / 12;
            
            account.cm_AggrCreditBalance__c = aggrCreditBalance;
            account.cm_AggrMinimumBalance__c = aggrMinimumBalance;
            account.cm_MaxTurnover__c = mnthlyStmntsMaxTurnover;
            
            acctsToUpdateList.add(account);
            
            // Reset monthly turnovers, aggr credit balance, and aggr minimum balance after each relationship iteration
            resetRCCValues();
            } */
            
            // Approach 2 - Aggregated SOQL Query
            // 1. Process Average Credit Balance and Average Minimum Balance
            Map<Id, Map<String, Decimal>> accRccParamsMap = new Map<Id, Map<String, Decimal>>();
            for(AggregateResult aggr : loansListAggr) {
                Id accountId = (Id)aggr.get('LLC_BI__Account__c');
                Map<String, Decimal> rccParamsMap = new Map<String, Decimal>();
                if(accountId != null && !accRccParamsMap.containsKey(accountId)) {
                    accRccParamsMap.put(accountId, rccParamsMap);
                }
                rccParamsMap.put('AvgCreditBalance', (Decimal)aggr.get('avgCreditBalance'));
                rccParamsMap.put('AvgMinimumBalance', (Decimal)aggr.get('avgMinimumBalance'));
                accRccParamsMap.get(accountId).putAll(rccParamsMap);
            }
            
            // 2. Process Max Turnover from Monthly Statements
            
            // 3. Update Account
            for(Id accountId : accRccParamsMap.keySet()) {
                Account acct = new Account();
                acct.Id = accountId;
                acct.cm_AggrCreditBalance__c = accRccParamsMap.get(accountId).get('AvgCreditBalance');
                acct.cm_AggrMinimumBalance__c = accRccParamsMap.get(accountId).get('AvgMinimumBalance');
                acctsToUpdateList.add(acct);
            }
            
            update acctsToUpdateList;
            
        } catch (Exception ex){
            cm_ExceptionLog.log(cm_RCC_UpdateRelationship.class.getName(), 'execute', ex);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    // Implement the execute method for Schedulable
    global void execute(SchedulableContext sc) {
        // Schedule the batch to run daily at midnight 1:30 am
        //String jobName = 'RCCUpdateRelationshipJob';
        //String cronExp = '0 30 1 * * ?';
        //System.schedule(jobName, cronExp, new cm_RCC_UpdateRelationship());
        cm_RCC_UpdateRelationship batch = new cm_RCC_UpdateRelationship();
        System.debug('@@@schedulable execute');
        database.executeBatch(batch);
    }
    
    // helper function to process monthly statements
    public void processMonthlyStatements(Id loanId, List<MonthlyStatement__c> mnthlyStmntsList) {
        
        // Loop through all monthly statements related to the loan and get the turnovers for each month
        for(MonthlyStatement__c mnthlyStmnts : mnthlyStmntsList) {
            if(mnthlyStmnts.Loan__c == loanId) {
                switch on Integer.valueOf(mnthlyStmnts.cm_Month__c) {
                    when 1 {
                        m1MaxTurnover = mnthlyStmnts.cm_Turnover__c > m1MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m1MaxTurnover;
                    }
                    when 2 {
                        m2MaxTurnover = mnthlyStmnts.cm_Turnover__c > m2MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m2MaxTurnover;
                    }
                    when 3 {
                        m3MaxTurnover = mnthlyStmnts.cm_Turnover__c > m3MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m3MaxTurnover;
                    }
                    when 4 {
                        m4MaxTurnover = mnthlyStmnts.cm_Turnover__c > m4MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m4MaxTurnover;
                    }
                    when 5 {
                        m5MaxTurnover = mnthlyStmnts.cm_Turnover__c > m5MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m5MaxTurnover;
                    }
                    when 6 {
                        m6MaxTurnover = mnthlyStmnts.cm_Turnover__c > m6MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m6MaxTurnover;
                    }
                    when 7 {
                        m7MaxTurnover = mnthlyStmnts.cm_Turnover__c > m7MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m7MaxTurnover;
                    }
                    when 8 {
                        m8MaxTurnover = mnthlyStmnts.cm_Turnover__c > m8MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m8MaxTurnover;
                    }
                    when 9 {
                        m9MaxTurnover = mnthlyStmnts.cm_Turnover__c > m9MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m9MaxTurnover;
                    }
                    when 10 {
                        m10MaxTurnover = mnthlyStmnts.cm_Turnover__c > m10MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m10MaxTurnover;
                    }
                    when 11 {
                        m11MaxTurnover = mnthlyStmnts.cm_Turnover__c > m11MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m11MaxTurnover;
                    }
                    when 12 {
                        m12MaxTurnover = mnthlyStmnts.cm_Turnover__c > m12MaxTurnover ? mnthlyStmnts.cm_Turnover__c : m12MaxTurnover;
                    }
                } // end switch
            } // end if
        } // end for loop
    } // end processMonthlyStatements
    
    private void resetRCCValues() {
        aggrCreditBalance = 0;
        aggrMinimumBalance = 0;
        m1MaxTurnover = 0;
        m2MaxTurnover = 0;
        m3MaxTurnover = 0;
        m4MaxTurnover = 0;
        m5MaxTurnover = 0;
        m6MaxTurnover = 0;
        m7MaxTurnover = 0;
        m8MaxTurnover = 0;
        m9MaxTurnover = 0;
        m10MaxTurnover = 0;
        m11MaxTurnover = 0;
        m12MaxTurnover = 0;
    }
}