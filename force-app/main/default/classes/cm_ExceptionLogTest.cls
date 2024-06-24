/**************************************************************************************************
* @Author:      Jan Reimil Cabantog
* @Date:        10/05/2023
* @Description: Test class for cm_ExceptionLog class
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]
***************************************************************************************************/
@isTest
public class cm_ExceptionLogTest{
	
	//Reusable Line of Codes
	static String endpoint = 'http://endpoint.com';
    static String classname = 'apexclasstestname';
    static String post = 'POST';
    static String fieldMissing = 'REQUIRED_FIELD_MISSING';
    
    @isTest
    public static void log(){
        test.startTest();
        try { 
            Account m = new Account(); 
            insert m; 
        } catch (Exception e) { 
            cm_ExceptionLog.log(classname,'dmlException',e); 
            system.assertEquals(e.getMessage().contains(fieldMissing), true);                   
        } 
        test.StopTest();
    }
    //negative scenario for log catch block
    @isTest
    public static void logexceptionfail(){
        test.startTest();
        try { 
            Account m = new Account(); 
            insert m; 
        } catch (Exception e) { 
            cm_ExceptionLog.log(null,'dmlException',null);
            system.assertEquals(e.getMessage().contains(fieldMissing), true);     
        } 
        test.StopTest();    
    }
    
	@isTest
    public static void logString(){
        account m = new Account();
        test.startTest();
        try{
            Insert m;
        }catch(Exception e){
            cm_Exceptionlog.log(e.getMessage());
            system.assertEquals(e.getMessage().contains(fieldMissing), true);
        }
        test.stopTest();
        
    }    
    
    @isTest
    public static void logErrorCode(){
        string errorCode = '404';
        String errMessage = fieldMissing;
        account m = new account();
        test.startTest();
        try{
            insert m;
        }catch(Exception E){
            cm_Exceptionlog.log(errMessage);
            system.assertEquals(e.getMessage().contains(errMessage), true);
        }
        test.StopTest();
    }
    
    @isTest
    public static void logException(){
        String errMessage = fieldMissing;
        account m = new account();
        test.startTest();
        try{
            insert m;
        }catch(Exception e){
            cm_Exceptionlog.log(errMessage);
            system.assertEquals(e.getMessage().contains(errMessage), true);                
        }
        test.StopTest();
    }
        
    @isTest
    public static void invocableTest(){
        final string flowName = 'error flow';
        final string methodName = 'method name';
        final string faultMessage = 'fault message';
        final string type = 'type';
        
        cm_ExceptionLog.ErrorLogFlow errorflow = new cm_ExceptionLog.ErrorLogFlow();
		SEL_ExceptionLog__c exce = new SEL_ExceptionLog__c();
        exce.SEL_SubType__c = type;
        exce.SEL_Message__c = faultMessage;
        
        errorflow.faultMessage = faultMessage;
        errorflow.flowName = flowname;
        errorflow.methodName = methodName;
        errorflow.type = type;
        List<cm_ExceptionLog.ErrorLogFlow> errorflowlist = new List<cm_ExceptionLog.ErrorLogFlow>();
        errorflowlist.add(errorflow);
        test.startTest();
           cm_ExceptionLog.log(errorflowlist);
        test.stopTest();
        system.assertEquals('type',exce.SEL_SubType__c);
        system.assertEquals('fault message', exce.SEL_Message__c);
    }
    //negative scenario for invocable catch block
    @isTest
    public static void invocableTestFail(){
        string flowName;
        string methodName;
        string faultMessage;
        string type;        
        cm_ExceptionLog.ErrorLogFlow errorflow = null;
        List<cm_ExceptionLog.ErrorLogFlow> errorflowlist = new List<cm_ExceptionLog.ErrorLogFlow>();
        errorflowlist.add(errorflow);
        test.startTest();
            cm_ExceptionLog.log(errorflowlist);
        test.stopTest();
    }   

    @isTest 
    public static void service_call() {

    	Test.setMock(HttpCalloutMock.class, new cm_ExceptionLogMock());
        string type = 'DECISION API';
    	Test.startTest();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.SetBody('');
            request.setMethod(post);
            request.setEndpoint(endpoint);
            HttpResponse response = http.send(request);
            cm_Exceptionlog.log(type,request,response);
    	Test.StopTest();
    }
	//negative scenario for logcallout catch block
    @isTest 
    public static void service_callFail() {

    	Test.setMock(HttpCalloutMock.class, new cm_ExceptionLogMock());
        string type = 'DECISION API';
    	Test.startTest();
        	Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.SetBody('');
            request.setMethod(post);
            request.setEndpoint(endpoint);
            HttpResponse response = http.send(request);
            cm_Exceptionlog.log(type,null,response);
    	Test.StopTest();
    }
	//negative scenario for createlogattachment catch block
	@isTest
    public static void createlogattachmentfail(){
        test.startTest();
       	   Test.setMock(HttpCalloutMock.class, new cm_ExceptionLogMock());
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.SetBody('');
            request.setMethod(post);
            request.setEndpoint(endpoint);
            HttpResponse response = http.send(request);
            cm_Exceptionlog.createLogAttachments('',request,response);
        test.stopTest();
    } 
    
	//Inner class for the mock class that will be use on cm_ExceptionLogTest
    public class cm_ExceptionLogMock implements HttpCalloutMock{
            public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'Exception Log Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
}