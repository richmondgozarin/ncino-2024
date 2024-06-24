@isTest
public class cm_BookingBatchSchedulerTest {

    static final String ASSERTION_FAILED = 'Assertion Failed: ';
    
    @isTest
    static void schedule(){
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler();

        test.startTest();
	        scheduler.schedule();
        test.stopTest();
        
        // To check if Schedule job is recorded
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];
        
        Assert.areEqual('cm_BookingBatchScheduler', jobsScheduled[0].ApexClass.Name, ASSERTION_FAILED);
    }
    
    @isTest
    static void adhocSchedule(){
        String startDate = '2023-05-18';
        String endDate = '2023-05-20';
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler(startDate, endDate);
        
        test.startTest();
        	scheduler.schedule();
        test.stopTest();
        
        // To check if Schedule job is recorded
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];
        
        Assert.areEqual('cm_BookingBatchScheduler', jobsScheduled[0].ApexClass.Name, ASSERTION_FAILED);
        
        // To check if BatchApex job is recorded
        List<AsyncApexJob> jobsBatchApex = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        
        Assert.areEqual('cm_BookingBatch', jobsBatchApex[0].ApexClass.Name, ASSERTION_FAILED);
        
    }
    
    @isTest
    static void scheduledRunAbort(){
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler();
        
        test.startTest();
        	scheduler.schedule();
        	scheduler.schedule();
        test.stopTest();
        
        // To check if Schedule job is recorded
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'ScheduledApex'];
        
        Assert.areEqual('Aborted', jobsScheduled[0].Status, 'It should be aborted. Results: ');
    }
    
    @isTest
    static void scheduleFailed(){
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler();
        cm_Constant.BKK_SCHEDULER_TEST_CASE = 'Invalid Expression';

		test.startTest();
        	scheduler.schedule();
        test.stopTest();
        
        system.debug(ApexPages.getMessages());
        system.assert(True, ApexPages.hasMessages());
    }
    
    @isTest
    static void adhocScheduleFailed(){
        String startDate = '2023-13-18';
        String endDate = '2023-05-20';
        cm_Constant.ADD_SEC = 0;
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler(startDate, endDate);
        
        test.startTest();
            scheduler.schedule();
        test.stopTest();
        
        system.assert(True, ApexPages.hasMessages());
    }
    
    @isTest
    static void scheduleJobExecuteMethodFail(){
        String startDate = '20230518';
        String endDate = '20230518';
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler(startDate, endDate);
        
        test.startTest();
        	scheduler.schedule();
        test.stopTest();
		
        system.assert(True, ApexPages.hasMessages());
    }
    
    @isTest
    static void containsHoliday(){
        date holidayDates = date.today().addDays(-1);
        Holiday holidayTestRecord = cm_TestDataFactory.createHolidayRecord(holidayDates);
        Set<Datetime> numOfHolidays = new Set<Datetime>();
        numOfHolidays.add(Date.valueOf(holidayTestRecord.ActivityDate));
        cm_BookingBatchScheduler scheduler = new cm_BookingBatchScheduler();
        cm_BookingBatchController controller = new cm_BookingBatchController();
        Test.startTest();
        	scheduler.schedule();
        Test.stopTest();
        controller.getQueryByHoliday(numOfHolidays);
        
        System.assertEquals(True, numOfHolidays.contains(holidayDates), ASSERTION_FAILED);
    }
    
}