public class cm_CustomMetadataUtils implements Metadata.DeployCallback {
     
    //Inteface method
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            //Success
            System.debug('Success Result-' + result);
        } else {
            //Failed
            System.debug('Failed Result-' + result);
        }
    }
   
    @AuraEnabled  
    //Update Custom Metadata record
    public static void updateCustomMetadata(String metadataName, String recordDevName, String label, String cronvalue){
        //public static void updateCustomMetadata(String metdataName, String recordDevName, String label, Map<String, Object> metadataFieldValueMap)
        Metadata.CustomMetadata cMetadata = new Metadata.CustomMetadata();
        cMetadata.fullName = metadataName + '.' + recordDevName;
        cMetadata.label = label;
        Map<String,Object> metadataFieldValueMap = new Map<String,Object>();
        metadataFieldValueMap.put('Cron_Expression__c',cronvalue);
        system.debug('metadataFieldValueMap:'+metadataFieldValueMap);
        for(String key : metadataFieldValueMap.keySet()){
            Metadata.CustomMetadataValue cMetadataValue = new Metadata.CustomMetadataValue();
            cMetadataValue.Field = key;
            cMetadataValue.Value = metadataFieldValueMap.get(key); 
            cMetadata.values.add(cMetadataValue);
        }
         
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(cMetadata);
        cm_CustomMetadataUtils callback = new cm_CustomMetadataUtils();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
    //to Run Update on anonymous window
    // Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
    // metadataFieldValueMap.put('Cron_Expression__c', '0 0 6 ? * MON-SAT'); // will be use to put cron value from lwc to update the metadata record
    // CustomMetadataUtils.updateCustomMetadata('BAU_Schedule_Process__mdt','Runs_6AM_MON_FRI', 'CronUpdate',metadataFieldValueMap);
    //Inner class
    public class CustomMetadataCallBack implements Metadata.DeployCallback {
     
        //Inteface method 
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
                //Success
            } else {
                //Failed
            }
        }
    }
}