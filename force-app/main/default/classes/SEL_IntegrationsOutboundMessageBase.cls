/*---------------------------------------------------------------------------------
DESCRIPTION	:	The abstract base class of the Integration Framework. Implement 
this class to leverage the features built into the framework.
LIBRARY		:	Salesforce Enterprise Library (SEL) - Integration Framework
VERSION		:	1.0
AUTHORS		:	Kuldeep Parihar			
HISTORY		:
Date			Author				Comment
JUL-11-2022	   Kuldeep Parihar	 Initial version
Nov-07-2023    Kuldeep           SonarQube Fix
---------------------------------------------------------------------------------*/
public abstract class SEL_IntegrationsOutboundMessageBase 
{
    private Boolean isMockingEnabled = false;
    public Boolean isBulkEnabled = false;
    private SEL_IntegrationSetting__mdt integrationSetting = new SEL_IntegrationSetting__mdt();
    private SEL_IntegrationsTransformService transformService = null;
    
    public SEL_IntegrationsOutboundMessageBase(String integrationDeveloperName) 
    {
        if(String.isNotBlank(integrationDeveloperName))
        {
            this.integrationSetting = new SEL_IntegrationsSelector().selectByDeveloperName(integrationDeveloperName);
            // Might be good idea to throw an exception if the integrationSetting is blank.
            this.isMockingEnabled = this.integrationSetting.SEL_IsMockingEnabled__c;
            this.transformService = new SEL_IntegrationsTransformService(this.integrationSetting);
        }
    }
    
    // USAGE
    // Use this to generate a message WITHOUT any message parameters
    public HttpRequest getHttpRequest()
    {
        return this.getHttpRequest('', null);
    }
    
    // USAGE
    // Use this to generate a message body using a text and and Key-Value Map
    public HttpRequest getHttpRequest(String body, Map<String, String> keyValue)
    {
        HttpRequest request = new HttpRequest();
        Map<String, String> headerMap = new Map<String, String>();
        
        // SET Client Certificate
        if(String.isNotBlank(this?.integrationSetting?.SEL_ClientCertificate__c)) 
        {
            request.setClientCertificateName(this.integrationSetting.SEL_ClientCertificate__c);
        }
        
        // SET Compression
        if(this?.integrationSetting?.SEL_IsCompressed__c != null) 
        {
            request.setCompressed(this.integrationSetting.SEL_IsCompressed__c);
        }
        
        // SET Endpoint
        request.setEndpoint(this.transformService.getEndpoint());
        
        // SET Override Endpoint 
        if(keyValue != null && keyValue.size() > 0)
        {
            request.setEndpoint(this.transformService.getEndpoint(keyValue));
        }
        
        // SET Header
        headerMap = this.transformService.getHeaders(keyValue);
        for(String key : headerMap.keySet())
        {
            request.setHeader(key, headerMap.get(key));
        }
        
        // SET Http Method
        if(String.isNotBlank(this?.integrationSetting?.SEL_HttpMethod__c)) 
        {
            request.setMethod(this.integrationSetting.SEL_HttpMethod__c);
        }
        
        // SET Message Body
        if(String.isNotBlank(body)) 
        {
            request.setBody(body);
        }
        
        // SET Timeout
        if(this?.integrationSetting?.SEL_Timeout__c != null) 
        {
            request.setTimeout(Integer.valueOf(this.integrationSetting.SEL_Timeout__c));
        }
        
        return request;
    }
    
    // USAGE
    // Use this to do the call out and return the response
    @SuppressWarnings('PMD.CognitiveComplexity')
    public HttpResponse send(HttpRequest request)
    {
        HttpResponse result = null;
        
        if(this.isMockingEnabled || Test.isRunningTest())
        {
            result = new HttpResponse();
            
            // SET Mocked Response Body
            if(String.isNotBlank(this.integrationSetting?.SEL_IntegrationDataMockId__r?.SEL_Body__c))
            {
                result.setBody(this.integrationSetting.SEL_IntegrationDataMockId__r.SEL_Body__c);
            }
            
            // SET Mocked Response Status Code
            if(this.integrationSetting?.SEL_IntegrationDataMockId__r?.SEL_StatusCode__c != null)
            {
                result.setStatusCode(Integer.valueOf(this.integrationSetting.SEL_IntegrationDataMockId__r.SEL_StatusCode__c));
            }
            
            // SET Mocked Response Status
            if(String.isNotBlank(this.integrationSetting?.SEL_IntegrationDataMockId__r?.SEL_Status__c))
            {
                result.setStatus(this.integrationSetting.SEL_IntegrationDataMockId__r.SEL_Status__c);
            }
            
            // SET Mocked Response Header
            if(String.isNotBlank(this.integrationSetting?.SEL_IntegrationDataMockId__r?.SEL_Header__c))
            {
                Map<String, String> mockedHeader = (Map<String,String>) JSON.deserialize(this.integrationSetting.SEL_IntegrationDataMockId__r.SEL_Header__c, Map<String,String>.class);
               // SonarQube Cognitive Complexity 07/11/2023
                result =  processHeaders(result, mockedHeader);
            }
        }
        else if (request != null)
        {
            Http webRequest = new Http();
            result = webRequest.send(request);
        }
        //i: save request and response as attachments
        if(this.integrationSetting.SEL_isLogEnabled__c && !this.isBulkEnabled ){
            cm_ExceptionLog.log(this.integrationSetting.MasterLabel,  request, result );
        }
        return result;
    }
    
    private HttpResponse processHeaders(HttpResponse result , Map<String, String> mockedHeader){
        for(String key : mockedHeader.keySet())
        {
            result.setHeader(key, mockedHeader.get(key));
        }
        return result;
    }
    
    public Boolean getIsMockingEnabled()
    {
        return this.isMockingEnabled;
    }
    
    public Boolean getIsBulkEnabled()
    {
        return this.isBulkEnabled;
    }
}