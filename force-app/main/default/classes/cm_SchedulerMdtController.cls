public class cm_SchedulerMdtController {
    public final Map<String, CM_BKK_Scheduler__mdt> schedulesByApiName {get; set;}
    
    public final List<CM_BKK_Scheduler__mdt> schedules {get;set;}
    
    public cm_SchedulerMdtController() { 
        schedules = new List<CM_BKK_Scheduler__mdt>();
        schedulesByApiName = new Map<String, CM_BKK_Scheduler__mdt>();
        for (CM_BKK_Scheduler__mdt config : [SELECT QualifiedApiName, MasterLabel, CM_Batch_Name__c, Cron_Expression__c, cm_Description__c
                                                 FROM CM_BKK_Scheduler__mdt
                                                 WHERE isActive__c = true]) { 
                                                     schedules.add(config);
                                                     schedulesByApiName.put(config.QualifiedApiName, config);
                                                 }
    }
    public PageReference save() {        
        // Create a metadata container.
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        List<String> scheduleNames = new List<String>();
        for (String recordName : schedulesByApiName.keySet()) {
            scheduleNames.add('BAU_Schedule_Process.' + recordName);
        }
        List<Metadata.Metadata> records = 
            Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, 
                                         scheduleNames);
        for (Metadata.Metadata record : records) {
            Metadata.CustomMetadata scheduleRecord = (Metadata.CustomMetadata) record;
            scheduleRecord.fullName = record.fullName;
            System.debug('scheduleRecord : ' + scheduleRecord);
            String scheduleRecordName = scheduleRecord.fullName.substringAfter('.');
            System.debug('scheduleRecordName : ' + scheduleRecordName);
            CM_BKK_Scheduler__mdt mdtToCopy = schedulesByApiName.get(scheduleRecordName);
            for (Metadata.CustomMetadataValue mdtRecValue : scheduleRecord.values) {
                if (mdtRecValue.field == 'Cron_Expression__c') {
                    mdtRecValue.value = 'Now Invalid Expression';
                } else {
                    mdtRecValue.value = mdtToCopy.get(mdtRecValue.field);    
                }
            }
            // Add record to the container.
            container.addMetadata(scheduleRecord);
        }   
        // Deploy the container with the new components. 
        Id asyncResultId = Metadata.Operations.enqueueDeployment(container, null);
        return null;
    }
    
    /*
     * Create 1 metadata record 
     */
    public void create() {
        // Create a metadata container.
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        
        Metadata.CustomMetadata cmMetadata = new Metadata.CustomMetadata();
        cmMetadata.fullName = 'BAU_Schedule_Process.' + 'Sample_Record';
        cmMetadata.label = 'Sample_Record';
        List<String> scheduleNames = new List<String>();
        
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Cron_Expression__c';
        customField.value = 'New value';
        cmMetadata.values.add(customField);
        
        Metadata.CustomMetadataValue isActiveField = new Metadata.CustomMetadataValue();
        isActiveField.field = 'isActive__c';
        isActiveField.value = true;
        cmMetadata.values.add(isActiveField);
        
        Metadata.CustomMetadataValue batchNameField = new Metadata.CustomMetadataValue();
        batchNameField.field = 'CM_Batch_Name__c';
        batchNameField.value = 'Sample';
        cmMetadata.values.add(batchNameField);
        
        // Add record to the container.
        container.addMetadata(cmMetadata);
        
        // Deploy the container with the new components. 
        Id asyncResultId = Metadata.Operations.enqueueDeployment(container, null);
        
    }
    
    /*
     * Retrieves all metadata
     */
    public Map<String, List<Metadata.CustomMetadataValue>> retrieveAllMetadata() {
        List<String> componentNameList = new List<String>();
        Map<String, List<Metadata.CustomMetadataValue>> config = new Map<String, List<Metadata.CustomMetadataValue>>();
        // List fullnames of components we want to retrieve
        for (String recordName : schedulesByApiName.keySet()) {
            componentNameList.add('BAU_Schedule_Process.' + recordName);
        }
    
        // Retrieve components that are records of custom metadata types
        // based on name
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, componentNameList);

        for (Metadata.Metadata record : components) {
            
            Metadata.CustomMetadata mdRecord = (Metadata.CustomMetadata) record;
            
            // Check fields of retrieved component
            system.debug('md Label :: ' + mdRecord.label);
            config.put(mdRecord.label, mdRecord.values);
            
            for (Metadata.CustomMetadataValue mdValue : mdRecord.values) {
                system.debug('mdField :: ' + mdValue.field);
                system.debug('mdValue :: ' + mdValue.value);
            }
        }
        system.debug('md config :: ' + config);
        return config;
    }
    
    /*
     * Retrieve metadata by qualified name
     */
    public void retrieveMetadataByQualifiedName(String recordName) {
        // List fullnames of components we want to retrieve
        List<String> componentNameList = new List<String>{'BAU_Schedule_Process.' + recordName};

        // Retrieve components that are records of custom metadata types
        // based on name
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, componentNameList);
        Metadata.CustomMetadata mdRecord = (Metadata.CustomMetadata) components.get(0);
        
        // Check fields of retrieved component
        List<Metadata.CustomMetadataValue> mdValues = mdRecord.values;
        for (Metadata.CustomMetadataValue mdValue : mdValues) {
            system.debug('mdField :: ' + mdValue.field);
            system.debug('mdValue :: ' + mdValue.value);
        }
    }

    @AuraEnabled
    public static void runScheduler(date startDate, date endDate){
        String thisStartDate = string.valueOf(startDate);
        String thisEndDate = string.valueOf(endDate);
        try {
            system.debug('thisStartDate ---- ' + thisStartDate);
            system.debug('thisEndDate ---- ' + thisEndDate);
            cm_BookingBatchScheduler run = new cm_BookingBatchScheduler(thisStartDate, thisEndDate);
            run.schedule();

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static cm_LoanBooking__c loanBookingsCSVFile(){
        try {
            return [SELECT Id, CreatedDate FROM cm_LoanBooking__c ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getBatchIdController() {
      List<String> currentBid = cm_BookingBatch.getCurrentBatchId();
        system.debug('currentBid >> ' + currentBid);
      return currentBid;
    }
}