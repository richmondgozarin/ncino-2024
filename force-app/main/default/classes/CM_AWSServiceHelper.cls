/**************************************************************************************************
* @Author:    Kuldeep Parihar 
* @Date:      06/09/2023
* @Description: This class will handle retry Call out to AWS S3 .
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public class CM_AWSServiceHelper {
    
    @InvocableMethod(label='Get retryAWS' description='Retry Failed Records')
    public Static List<String> retryAWSCall(List<String> rec){
        List<String> jobIds =new List<String>();
        if(rec[0]!=null){
            ID jobID = System.enqueueJob(new CM_AWSService('S3_AWSAPI', rec[0])); 
            jobIds = new List<String> {jobID};
                }else{
            jobIds = new List<String> {'Not Available'};       
                        }
        return jobIds ;
    }
}