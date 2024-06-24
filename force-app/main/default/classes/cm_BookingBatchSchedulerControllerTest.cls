/**************************************************************************************************
* @Author:      Rolie John Ewican
* @Date:        07/25/2023
* @Description: Test class for cm_BookingBatchSchedulerController
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
private class cm_BookingBatchSchedulerControllerTest {
	
    static final String CONST_ASSERTION = 'Assertion Failed: ';
    static List<String> batchNames = new List<String>();
    static List<CronTrigger> cronData = new List<CronTrigger>();
    
    @testSetup
    static void Setup(){
        // Create test record for Loan Bookings
        cm_LoanBooking__c loanBooking = new cm_LoanBooking__c();
        loanBooking.Name = 'loan booking Test';
        insert loanBooking;
        
        // Create List for Running BKK Scheduler
        for(CM_BKK_Scheduler__mdt schedMdt : customMetadata){
            batchNames.add(schedMdt.CM_Batch_Name__c);
        }
        
        for(CronTrigger cron : [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name IN: batchNames]){
             cronData.add(cron);
        }
        
    }
    
    @isTest
    static void getBookingScheduleTest(){
        List<CM_BKK_Scheduler__mdt> schedulerMdt = new List<CM_BKK_Scheduler__mdt>();
        Test.startTest();
        cm_BookingBatchSchedulerController.getcronSchedule();
        cm_BookingBatchSchedulerController.getBookingSchedule();
        Test.stopTest();
        
        system.assertEquals(4, customMetadata.size(), CONST_ASSERTION);
    }
    
    @isTest
    static void runSchedulerTest(){
        date startDate = date.newInstance(2023, 07, 23);
        date endDate = date.newInstance(2023, 07, 24);
        
        	cm_BookingBatchController executeBatch = new cm_BookingBatchController();
            executeBatch.run(string.valueOf(startDate), string.valueOf(endDate));
        
        Test.startTest();
        	cm_BookingBatchSchedulerController.runFrequencyScheduler();
        	cm_BookingBatchSchedulerController.runScheduler(startDate, endDate);
        	cm_BookingBatchSchedulerController.getBatchId(executeBatch.getBatchId);
        Test.stopTest();
        
        // To check if Schedule job is recorded
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];
        
        Assert.areEqual('cm_BookingBatchScheduler', jobsScheduled[0].ApexClass.Name, CONST_ASSERTION);
        
        // To check if BatchApex job is recorded
        List<AsyncApexJob> jobsBatchApex = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        
        Assert.areEqual('cm_BookingBatch', jobsBatchApex[0].ApexClass.Name, 'Assertion Field: ');
    }

	@isTest
    static void csvFileLocationTest(){
         cm_LoanBooking__c[] loanBookings = [SELECT Id, Name FROM cm_LoanBooking__c WHERE Name = 'loan booking Test' LIMIT 1];
        Test.startTest();
        	cm_BookingBatchSchedulerController.csvFilesLocation();
        Test.stopTest();
        
        System.assertEquals(1, loanBookings.size());
    }
    
    @isTest
    static void checkRunningSchedulerTest(){
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler();
        
        // To check if Schedule job is recorded
        Test.startTest();
        	scheduler.schedule();
        	cm_BookingBatchSchedulerController.checkScheduler(batchNames);
        Test.stopTest();
        Boolean isMatch = cronData != null && cronData.size() == customMetadata.size();
        
        if(isMatch){
            system.assertEquals(isMatch, true, CONST_ASSERTION);
        }
         system.assertEquals(isMatch, false, CONST_ASSERTION);
    }
    
    @isTest
    static void holidayList(){
        date dateToday = date.today();
        Holiday holidayTestRecord = cm_TestDataFactory.createHolidayRecord(dateToday);
        
        Test.startTest();
        	cm_BookingBatchSchedulerController.getListOfHolidays();
        Test.stopTest();
        List<Holiday> holidayList = cm_BookingBatchSchedulerController.getListOfHolidays(); 
        system.debug('holidayList > ' + holidayList);
        system.assertEquals(1, holidayList.size());
    }
    
    @isTest
    static void returnHolidayURLTest(){
        String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        String Hyperlink = '/lightning/setup/Holiday/home';
        
        test.startTest();
        	cm_BookingBatchSchedulerController.returnHolidayURL();
        test.stopTest();
        
      system.assertEquals(baseURL + Hyperlink, cm_BookingBatchSchedulerController.returnHolidayURL(), 'Assertion Failed');
    }

   @testVisible static List<CM_BKK_Scheduler__mdt> customMetadata {
       get {
           if ( customMetadata == null )
               customMetadata = [SELECT Id, MasterLabel, cm_Batch_Order__c, Cron_Expression__c, CM_Batch_Name__c FROM CM_BKK_Scheduler__mdt 
                    WHERE isActive__c = true and DeveloperName != :cm_Constant.BKK_SCHEDULER_TEST_CASE ORDER BY cm_Batch_Order__c ASC]; 
           return customMetadata;
       } set;
   }
}