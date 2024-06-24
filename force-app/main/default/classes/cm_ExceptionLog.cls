/*-----------------------------------------------------------------------------
DESCRIPTION	:	Log request response into file for Core Library
AUTHOR		:	Kuldeep
LIBRARY		:	Salesforce Enterprise Library (SEL) - Core
VERSION		:	1.0

HISTORY		:
Date			Author				Comment
05-02-2023		Kuldeep Parihar	Initial version
-----------------------------------------------------------------------------*/
public with sharing class cm_ExceptionLog {

    public static void log(string message){
        {
            SEL_ExceptionLog__c exceptionObj = new SEL_ExceptionLog__c();
            exceptionObj.SEL_Message__c = message;   
            Database.insert(exceptionObj) ;
        }    
    }

   public static void log(String className, String methodName, Exception ex){
        log(className,methodName, ex, Null);
   }
    
    public static void log( String className, String methodName,String subType, String msg, String recId){
    try{   
        SEL_ExceptionLog__c exceptionLogObj = new SEL_ExceptionLog__c();
        exceptionLogObj.SEL_Record_ID__c = recId ;
        exceptionLogObj.SEL_Source__c = className;
        exceptionLogObj.SEL_SourceFunction__c = methodName;
        exceptionLogObj.SEL_SubType__c = subType;
        exceptionLogObj.SEL_Message__c = msg;
        Database.insert(exceptionLogObj) ;
        }
    catch(Exception exp){
        cm_ExceptionLog.log( exp.getMessage()); 
    } 
   }
    
   public static void log( String className, String methodName, Exception ex, String recId){
    try{   
        SEL_ExceptionLog__c exceptionLogObj = new SEL_ExceptionLog__c();
        exceptionLogObj.SEL_Record_ID__c = recId ;
        exceptionLogObj.SEL_Source__c = className == null ? null : className;
        exceptionLogObj.SEL_SourceFunction__c = methodName == null ? null : methodName;
        exceptionLogObj.SEL_StackTrace__c = ex.getStackTraceString() == null ? null : ex.getStackTraceString();
        exceptionLogObj.SEL_LineNumber__c= ex.getLineNumber() == null ? 0 :  ex.getLineNumber();
        exceptionLogObj.SEL_SubType__c = ex.getTypeName() == null ? null : ex.getTypeName();
        exceptionLogObj.SEL_Message__c = ex.getMessage() == null ? null : ex.getMessage();
        Database.insert(exceptionLogObj) ;
        }
    catch(Exception exp){
        cm_ExceptionLog.log( exp.getMessage()); 
    } 
   }

   public static void log ( String recordId,
                            HttpRequest request,
                            HttpResponse response ) {
        SEL_ExceptionLog__c excLog = new SEL_ExceptionLog__c();
        try{
            String className  = SEL_IntegrationsOutboundMessageBase.class.getName();
            String methodName = SEL_CoreConstants.CONSTANT_METHOD;
            excLog.SEL_Record_ID__c = request.getHeader('x-api-transaction-id') == null? recordId:request.getHeader('x-api-transaction-id') ;
            excLog.SEL_Source__c = className == null ? null : className;
            excLog.SEL_SourceFunction__c = methodName == null ? null : methodName;  
            excLog.SEL_Type__c = SEL_CoreConstants.CONSTANT_HTTP_LOG;
            if (request!= Null && request.getEndpoint().containsIgnoreCase('ERS') )
            excLog.SEL_SubType__c = 'ERS ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
            else if (request!= Null && request.getEndpoint().containsIgnoreCase('AWS') )
            excLog.SEL_SubType__c = 'AWS-S3 ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
            else if (request!= Null && request.getEndpoint().containsIgnoreCase('oauth2') )
            excLog.SEL_SubType__c = 'oAuth ' + SEL_CoreConstants.CONSTANT_INTEGRATION;
            else   
            excLog.SEL_SubType__c = SEL_CoreConstants.CONSTANT_INTEGRATION;    
            
            excLog.SEL_Message__c = response.getBody();
            excLog.SEL_Endpoint__c = request.getEndpoint();
            excLog.SEL_ResponseCode__c = response.getStatusCode();    
        }catch(Exception exObj){
            cm_ExceptionLog.log( exObj.getMessage() + ' ' + exObj.getStackTraceString() );
        }                                   
        Database.insert(excLog);
        createLogAttachments ( excLog.id, request, response );
    }   
   
    public static void createLogAttachments ( String logId, 
                                              HttpRequest request, 
                                              HttpResponse response ) 
    {
        try { 
            List<Attachment> calloutDataList = new List<Attachment>();
            
            if (request != null) {
                Attachment requestAttachment = new Attachment();
                requestAttachment.ParentId = logId;
                requestAttachment.Name = SEL_CoreConstants.LOG_REQUEST_ATTACHMENT_NAME;
                String requestData = SEL_CoreConstants.CONSTANT_VAR_REQUESTDATA;                               
                requestData = requestData + SEL_CoreConstants.CONSTANT_VAR_ENDPOINT + request.getEndpoint();   
                requestData = requestData + SEL_CoreConstants.CONSTANT_VAR_METHOD + request.getMethod();       
                requestData = requestData + SEL_CoreConstants.CONSTANT_VAR_BODY + request.getBody();           
                requestAttachment.Body =  Blob.valueOf(requestData);
                calloutDataList.add(requestAttachment);
            }
            
            if (response != null
            ) {
                Attachment responseAttachment = new Attachment();
                responseAttachment.ParentId = logId;
                responseAttachment.Name = SEL_CoreConstants.LOG_RESPONSE_ATTACHMENT_NAME;
                String responseData = SEL_CoreConstants.CONSTANT_VAR_RESPONSEDATA;                                   
                responseData = responseData + SEL_CoreConstants.CONSTANT_VAR_STATUSCODE + response.getStatusCode();   
                responseData = responseData + SEL_CoreConstants.CONSTANT_VAR_STATUS + response.getStatus();            
                responseData = responseData + SEL_CoreConstants.CONSTANT_VAR_BODY + response.getBody();                
                responseAttachment.Body =  Blob.valueOf(responseData);
                calloutDataList.add(responseAttachment);
            }
            

            if (calloutDataList.size() > 0 && schema.SObjectType.Attachment.isAccessible()) {
                    Database.insert(calloutDataList);
                }    
            }
        catch(exception attachmentExp){
                cm_ExceptionLog.log(
                    cm_ExceptionLog.class.getName(), 
                    SEL_CoreConstants.CONSTANT_CREATE_ATTACHEMENT ,  
                    attachmentExp
                );
            }    
        }
    
    @InvocableMethod(label='error log Flow' description='error log Flow') 
    public static void log( List<ErrorLogFlow> params) {
        List<SEL_ExceptionLog__c> selExceptionLogList = new List<SEL_ExceptionLog__c>();
        for (ErrorLogFlow error: params) {
            try{
                System.debug('error.faultmessage:'+error.faultMessage);
                SEL_ExceptionLog__c exceptionLogObj = new SEL_ExceptionLog__c();
                exceptionLogObj.SEL_Record_ID__c = error?.recordId;
                exceptionLogObj.SEL_Source__c = error?.flowName;
                exceptionLogObj.SEL_SourceFunction__c = error?.methodName;
                exceptionLogObj.SEL_Type__c = SEL_CoreConstants.CONSTANT_ERROR_LOG;
                exceptionLogObj.SEL_SubType__c = error.subtype +' '+ SEL_CoreConstants.CONSTANT_FLOW;
                exceptionLogObj.SEL_Message__c = error?.faultMessage;
                exceptionLogObj.SEL_ResponseCode__c = error.responseCode == '' ? null : Integer.valueOf(error.responseCode);
                exceptionLogObj.cm_NextAction__c = error?.nextActionMessage;
                selExceptionLogList.add(exceptionLogObj);
                
            }
            catch(Exception exp){
                cm_ExceptionLog.log( exp.getMessage()); 
            }
        }
        if(selExceptionLogList.size() > 0){
            Database.insert(selExceptionLogList);
        }
    }
    
    public class ErrorLogFlow {
        @InvocableVariable 
        public String flowName;  
        @InvocableVariable
        public String methodName;
        @InvocableVariable
        public String faultMessage;
        @InvocableVariable
        public String type;
        @InvocableVariable
        public String subtype;
        @InvocableVariable
        public String responseCode;
        @InvocableVariable
        public String recordId;
        @InvocableVariable
        public String nextActionMessage;
    }
}