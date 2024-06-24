/**************************************************************************************************
* @Author:    Kuldeep Parihar 
* @Date:      06/02/2023
* @Description: This class will handle Call out to AWS S3 .
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class CM_AWSService extends SEL_IntegrationsOutboundMessageBase implements Queueable,Database.AllowsCallouts {
    // use a property
    public final id recId;
    public CM_AWSService(String integrationDeveloperName , id recId) {
        //You can use abstract class constructor using super. 
        super(integrationDeveloperName);
        this.recId = recId;
    }
    
    public void execute(QueueableContext context) {
        try{
            List<Attachment> files = new List<Attachment>();
            if(Attachment.SObjectType.getDescribe().isAccessible()) {
                files =[Select id, Name, Body   
                        FROM Attachment 
                        WHERE ParentId = :recId ];
            }
            Map <HttpRequest,HttpResponse> logs = new  Map <HttpRequest,HttpResponse>();
            HttpResponse res  = new HttpResponse();                               
            if (files.size() > 0) {
                for(Attachment file  : files){
                    String attachmentBody = EncodingUtil.base64Encode(file.Body);
                    String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                    String filename = file.Name;
                    Map<String,String> overrideMap = new Map<String,String>();
                    overrideMap.put('Date' ,formattedDateString); // Overriding Header]
                    overrideMap.put('FileName', filename); // Overriding Endpoint]
                    //Update the content-type based on the file type being attached
                    HttpRequest request =  getHttpRequest('', overrideMap); //Overloaded method
                    Blob xlBlob = EncodingUtil.base64Decode(attachmentBody);
                    request.setBodyAsBlob(xlBlob);
                    isBulkEnabled = true;
                    res =  send(request);
                    logs.put(request, res);
                }
            }
            for(HttpRequest key : logs.keySet())  {
                cm_ExceptionLog.log(recId, key, logs.get(key));
                res = logs.get(key);
                if(res.getStatusCode() != 200 ){
                    cm_ExceptionLog.log(CM_AWSService.class.getName(), 'execute', res.getStatus(), res.getBody(), recId);  
                }
            } 
        }catch (Exception ex){
            cm_ExceptionLog.log(CM_AWSService.class.getName(), 'execute', ex, recId );
        }
    } 
}