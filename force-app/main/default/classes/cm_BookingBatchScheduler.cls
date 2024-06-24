/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      09/05/2023
* @Description: This class will hadled dynamically scheduler for Apex/Batch Apex
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/

global class cm_BookingBatchScheduler implements Schedulable {
    
    private String defaultDate;
    private String startDate;
    private String endDate;
    
    public cm_BookingBatchScheduler(String fromDate, String toDate) {
        this.startDate = fromDate;
        this.endDate = toDate;
    }
    public cm_BookingBatchScheduler(){
        this.defaultDate = cm_Constant.TODAY;
    }

/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      09/05/2023
* @Description: This class will handled the logic for both BAU and Adhoc Process
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
global void runStandardSchedule(){
    try {
        Map<String, String> jobNameAndCronMap = new Map<String, String>();
        
        for(cm_BKK_Scheduler__mdt config : [SELECT Id, CM_Batch_Name__c, MasterLabel, Cron_Expression__c, DeveloperName 
                                            FROM cm_BKK_Scheduler__mdt WHERE isActive__c = true AND DeveloperName != :cm_Constant.BKK_SCHEDULER_TEST_CASE]){
                
			jobNameAndCronMap.put(config.Cron_Expression__c, config.CM_Batch_Name__c);                                  
		}
        
        // Abort job if found existing Job name
        for(CronTrigger job : [SELECT Id, CronJobDetail.Name 
                               FROM CronTrigger WHERE CronJobDetail.Name IN :jobNameAndCronMap.values()]){
            System.abortJob(job.Id);
        }
        
        // Run the schedule
        for(String cronKey : jobNameAndCronMap.Keyset()){
            System.schedule(jobNameAndCronMap.get(cronKey), cronKey, new cm_BookingBatchScheduler());
        }
    } catch(Exception ex) {
        cm_ExceptionLog.log(cm_BookingBatchScheduler.class.getName(), 'BKK Standard Scheduler', ex);
    }
}
global void runAdhoc(){
    try {
        // Handled adhoc feature
        // Schedule will run, after 10 seconds of the current time
        Datetime sysTime = Datetime.now().addSeconds( cm_Constant.ADD_SEC );
        String hour = String.valueOf(sysTime.hour());
        String min = String.valueOf(sysTime.minute()); 
        String ss = String.valueOf(sysTime.second());
        String month = String.valueOf(sysTime.month());
        String day = String.valueOf(sysTime.day());
        String year = String.valueOf(sysTime.year());
       
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
        
        String jobName = cm_Constant.ADHOC_JOB_NAME_PREFIX + '_' + sysTime;
        
        System.schedule(jobName, nextFireTime, new cm_BookingBatchScheduler(this.startDate, this.endDate));
        
    } catch(Exception ex) {
        cm_ExceptionLog.log(cm_BookingBatchScheduler.class.getName(), 'Adhoc/On-Demand Scheduler', ex);
    }
}
global void schedule(){
    switch on this.defaultDate {
        when 'TODAY' {
            this.runStandardSchedule();
        }
        when else {
            this.runAdhoc();
        }
    }
}


global void execute(SchedulableContext sc){
    try{
        if(this.defaultDate == cm_Constant.TODAY){
            cm_BookingBatchController controller = new cm_BookingBatchController();
            controller.run(this.defaultDate);
        }
        else{
            cm_BookingBatchController controller = new cm_BookingBatchController();
            controller.run(this.startDate, this.endDate);
        }
    }catch(Exception ex){
        cm_ExceptionLog.log(cm_BookingBatchScheduler.class.getName(), 'Execute Scheduler to run the Booking Batch Class ', ex);
    }
}
}