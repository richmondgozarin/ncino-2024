/**************************************************************************************************
* @Author:    Bhanu Adinarayana
* @Date:      30/01/2024
* @Description: This class will copy value from TTM__c to validforCalc overnight .
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
global class cm_RCC_CopyTTMtoValidforCalcBatch implements Database.Batchable<SObject>, Schedulable {

    // Define the object and fields
    private String objectApiName = 'MonthlyStatement__c';
    private String field1 = 'cm_TTM__c';
    private String field2 = 'cm_ValidforCalc__c';
    private String field3 = 'cm_MonthEndDate__c';

    // Implement the start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, ' + field1 + ', ' + field2 + ' FROM ' + objectApiName +
                       ' WHERE ' + field3 + ' != null AND(' + field2 + ' = True OR '+ field1 + ' = True)';
        return Database.getQueryLocator(query);
    }

    // Implement the execute method
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<SObject> recordsToUpdate = new List<SObject>();

        for (SObject record : scope) {
            System.debug('@@@record.get(field2): '+record.get(field2));
            System.debug('@@@record.get(field1): '+record.get(field1));
            if(record.get(field2) != record.get(field1)){
                record.put(field2, record.get(field1));
                System.debug('@@@record: '+record);
                recordsToUpdate.add(record);
            }
        }

        System.debug('@@@recordsToUpdate: '+recordsToUpdate);
        // Update the records
        update recordsToUpdate;
    }

    // Implement the finish method
    global void finish(Database.BatchableContext BC) {
       
    }
    
       // Implement the execute method for Schedulable
    global void execute(SchedulableContext sc) {
        // Schedule the batch to run daily at midnight 1am
        //String jobName = 'CopyTTMtoValidforCalcJob';
        //String cronExp = '0 0 1 * * ?';
        //System.schedule(jobName, cronExp, new cm_RCC_CopyTTMtoValidforCalcBatch());
        cm_RCC_CopyTTMtoValidforCalcBatch batch = new cm_RCC_CopyTTMtoValidforCalcBatch();
        System.debug('@@@schedulable execute');
        database.executeBatch(batch);
    }
   }