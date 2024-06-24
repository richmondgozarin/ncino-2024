/*---------------------------------------------------------------------------------
DESCRIPTION	:	Transformation class specific to Integration rules and limitations.
LIBRARY		:	Salesforce Enterprise Library (SEL) - Integration Framework
VERSION		:	1.0
AUTHORS		:	Kuldeep 
METHODS	
+ getHeaders()
+ getHeaders(Map<String , String> overrideData)
+ getEndpoint()
+ getEndpoint(Map<String , String> overrideData)
HISTORY		:
Date			Author				Comment
FEB-06-2022		Kuldeep Parihar	Initial version
Nov-07-2023     Kuldeep         Create new method to Fix SonarQube issue
---------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.CognitiveComplexity')
public with sharing class SEL_IntegrationsTransformService 
{
    
    @TestVisible
    private String endpointUrl = null;
    @TestVisible
    private String messageFormat = null;
    @TestVisible
    private Map<String,String> headerStaticMap = new Map<String, String>();
    @TestVisible
    private Map<String,String> headerDynamicMap = new Map<String, String>();
    @TestVisible
    private Map<String,String> endpointStaticMap = new Map<String, String>();
    @TestVisible
    private Map<String,String> endpointDynamicMap = new Map<String, String>();
    
    // CONSTRUCTOR
    // To use this transform service to generate JSON message
    public SEL_IntegrationsTransformService(SEL_IntegrationSetting__mdt config)
    {
        if(config?.SEL_IsActive__c == true)
        {
            this.endpointUrl = this.endpointUrl = 'callout:' + config.SEL_NamedCredentials__c + (String.isBlank(config?.SEL_EndpointExtension__c) ? '' : config?.SEL_EndpointExtension__c);
            this.messageFormat = config.SEL_MessageFormat__c;
            // SET
            // Headers and endpoint extensions parameters
            this.groupValuesByType(config?.SEL_IntegrationValues__r);
        }
        else 
        {
            // Throw exception
            //throw new SEL_ConfigurationException(SEL_IntegrationConstants.ERROR_INACTIVE);
        }
    }
    
    
    
    // USAGE
    // Use this to group values into their respective maps. Values encompass both header
    // and endpoint data, which are further classified as either static or dynamic
    @TestVisible
    private void groupValuesByType(List<SEL_IntegrationValue__mdt> values)
    {
        if(values.isEmpty() == false)
        {
            for(SEL_IntegrationValue__mdt setting : values)
            {
                if(setting.SEL_Type__c.equalsIgnoreCase(SEL_CoreConstants.HEADER))
                {
                    //SonarQube Fix
                    headerStaticMap =  processHeadersOrEndpoint (SEL_CoreConstants.IV_VALUE_TYPE_STATIC , setting , headerStaticMap);
                    headerDynamicMap = processHeadersOrEndpoint (SEL_CoreConstants.IV_VALUE_TYPE_DYNAMIC, setting , headerDynamicMap);
                } 
                else if(setting.SEL_Type__c.equalsIgnoreCase(SEL_CoreConstants.ENDPOINT))
                {
                    //SonarQube Fix
                    endpointStaticMap = processHeadersOrEndpoint (SEL_CoreConstants.IV_VALUE_TYPE_STATIC , setting , endpointStaticMap);
                    endpointDynamicMap = processHeadersOrEndpoint (SEL_CoreConstants.IV_VALUE_TYPE_DYNAMIC, setting , endpointDynamicMap);
                }
            }
        }
    }
    
    private Map<String,String> processHeadersOrEndpoint(String httpHeaderorEndpointType , SEL_IntegrationValue__mdt setting , Map<String,String> currentMap ){
        if(setting.SEL_SourceValueType__c.equalsIgnoreCase(httpHeaderorEndpointType))
        {
            currentMap.put(setting.SEL_Key__c, setting.SEL_Value__c);
        }
        return currentMap;
    }
    
    // USAGE
    // Generates the header with static values. 
    public Map<String, String> getHeaders()
    { 
        return getHeaders(null);
    }
    
    // USAGE
    // Generates the header with static and dynamic values. 
    public Map<String, String> getHeaders(Map<String , String> overrideData)
    {
        if(overrideData != null && overrideData.size() > 0)
        {
            for(String key : overrideData.keySet())
            {
                if(this.headerDynamicMap.containsKey(key))
                {
                    this.headerStaticMap.put(key, overrideData.get(key));
                }
            }
        }
        return this.headerStaticMap;
    }
    
    //Usage
    //Generate the endpoint URL including variable available in Integration value.
    public String getEndpoint()
    { 
        return this.getEndpoint(null);
    }
    
    // USAGE
    // Generate the endpoint URL including variable available in Integration value.
    // Use this method to override dynamic Endpoint
    @SuppressWarnings('PMD.CognitiveComplexity')
    public String getEndpoint(Map<String , String> overrideData)
    { 
        String result = '';
        
        if(String.isNotBlank(this.endpointUrl))
        {
            result = this.endpointUrl;
            if(overrideData != null && overrideData.size() > 0 && this.endpointDynamicMap.size() > 0)
            {
                // RULE
                // If dynamic values are found, move those values to the static map
                for(String key : overrideData.keySet())
                { 
                    if(this.endpointDynamicMap.containsKey(key))
                    {
                        this.endpointStaticMap.put(key, overrideData.get(key));
                    }
                }
            }
                //SonarQube Fix
                // IMPORTANT
                // Key is case sensitive
                for(String key : this.endpointStaticMap.keySet()){
                    result = result.replace('{' + key + '}', this.endpointStaticMap.get(key));
                }
            
        }
        
        return result;
    }
}