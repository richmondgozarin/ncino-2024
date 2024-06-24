/**************************************************************************************************
* @Author:    Rolie John Ewican
* @Date:      06/06/2023
* @Description: This class will handled the two features in BKK scheduler,
				Daily Schedule Job Settings and On-Demand Batch Job Settings 
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class cm_BookingBatchSchedulerController {

    
/**************************************************************************************************
* @Author:    Jan Reimil Cabantog
* @Date:      06/06/2023
* @Description: This methods gets the current Cron Expression in the CM_BKK_Scheduler__mdt
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled(Cacheable = true)
    public static List<CM_BKK_Scheduler__mdt> getcronSchedule(){
            List<CM_BKK_Scheduler__mdt> schedulerMdt = new List<CM_BKK_Scheduler__mdt>();
            
        for(CM_BKK_Scheduler__mdt schedMdt : [SELECT Id, MasterLabel, cm_Batch_Order__c, Cron_Expression__c, CM_Batch_Name__c FROM CM_BKK_Scheduler__mdt 
                    WHERE isActive__c = true and DeveloperName != :cm_Constant.BKK_SCHEDULER_TEST_CASE ORDER BY cm_Batch_Order__c ASC]){
                schedulerMdt.add(schedMdt);
        }
        return schedulerMdt;
    }

/**************************************************************************************************
* @Author:    Jan Reimil Cabantog
* @Date:      06/06/2023
* @Description: This methods gets the updated Cron Expression value in the CM_BKK_Scheduler__mdt
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled
    public static List<CM_BKK_Scheduler__mdt> getBookingSchedule(){
        List<CM_BKK_Scheduler__mdt> bauSchedulerList = new List<CM_BKK_Scheduler__mdt>();
                
        for(cm_BKK_Scheduler__mdt bauSched : [SELECT Id, MasterLabel, CM_Batch_Name__c, cm_Batch_Order__c, Cron_Expression__c, DeveloperName 
                                            FROM cm_BKK_Scheduler__mdt WHERE isActive__c = true 
                                            and DeveloperName != :cm_Constant.BKK_SCHEDULER_TEST_CASE ORDER BY cm_Batch_Order__c ASC]){
            bauSchedulerList.add(bauSched);
        }
        
        return bauSchedulerList;
    }

/**************************************************************************************************
* @Author:    Jan Reimil Cabantog
* @Date:      06/06/2023
* @Description: This will run Daily Schedule Jobs in Booking Batch
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@AuraEnabled()
public static String runFrequencyScheduler(){
    cm_BookingBatchScheduler schedule = new cm_BookingBatchScheduler();
    schedule.schedule();

    cm_BookingBatchController batchController = new cm_BookingBatchController();
    return batchController.getBatchId;
}

/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This methods run the On-Demand Scheduler for Booking Batch
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static String runScheduler(date startDate, date endDate){
        String thisStartDate = string.valueOf(startDate);
        String thisEndDate = string.valueOf(endDate);
            cm_BookingBatchController executeBatch = new cm_BookingBatchController();
            executeBatch.run(thisStartDate, thisEndDate);

            return executeBatch.getBatchId;
    }

/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This method will get the latest loan bookings record
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled()
    public static cm_LoanBooking__c csvFilesLocation(){
        return [SELECT Id, Name FROM cm_LoanBooking__c ORDER By CreatedDate DESC LIMIT 1];
    }

/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This method will get the current running Batch Id
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
   @AuraEnabled()
    public static AsyncApexJob getBatchId(Id batchId){
        return [SELECT Id, Status, ExtendedStatus, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE Id =:batchId];
    }
    
/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This method will get the list of records from the Holiday Object
				to be used in the BKK Scheduler
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled()
    public static List<Holiday> getListOfHolidays(){
        List<Holiday> todaysHoliday = new List<Holiday>();
        Map<Date, Holiday> mapHolidays = new Map<Date, Holiday>();
        for(Holiday holidayList : [SELECT Id, Name, Description, ActivityDate FROM Holiday ORDER BY ActivityDate DESC]){
            mapHolidays.put(holidayList.ActivityDate, holidayList);
        }
        system.debug(mapHolidays);
        
        if(!mapHolidays.containskey(CM_Constant.DATE_TODAY)){
            return null;
        }
        todaysHoliday.add(mapHolidays.get(CM_Constant.DATE_TODAY));
        return todaysHoliday;
    }
/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This method will determined if there's a running schedule for BKK
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled()
    public static Boolean checkScheduler(List<String> batchNames){    	
        Boolean isMatch = false;
        
        @TestVisible
        List<CronTrigger> cronData = new List<CronTrigger>();
        
        for(CronTrigger cron : [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name IN: batchNames]){
            cronData.add(cron);
        }
        if(cronData != null && cronData.size() == getcronSchedule().size()){
            isMatch = true;
        }
        
        return isMatch;
    }
    
/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      06/06/2023
* @Description: This method will determined if there's a running schedule for BKK
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    @AuraEnabled()
    public static String returnHolidayURL(){
        @TestVisible
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/setup/Holiday/home';
        
        return baseUrl;
    }
}