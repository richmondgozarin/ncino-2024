/*-----------------------------------------------------------------------------
DESCRIPTION	:	Test class of the SEL_IntegrationsTransformService class.
AUTHOR		:	Kuldeep Parihar
LIBRARY		:	Salesforce Enterprise Library (SEL) - Integration Frameworks

Time (MS)		Method
35				constructorNormal
-----------------------------------------------------------------------------*/
@IsTest
public with sharing class SEL_IntegrationsTransformService_TEST 
{
    static final String SINGLE_VAL_CONST = 'There must be one value.';
    static final String IDEMPOTENCY_KEY = 'Idempotency-Key';
    
    @IsTest
    private static void constructorNormal() 
    {
        Test.startTest();
        
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt( SEL_IsActive__c = true, SEL_NamedCredentials__c = 'namedCredential', SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON);
        SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(setting);
        
        // ASSERT
        System.assert(service.getEndpoint().startsWithIgnoreCase('callout:namedCredential'), 'The generated endpont must start with callout');
        
        Test.stopTest();
    }
    
    @IsTest
    private static void constructorError() 
    {
        try 
        {
            // TEST SCENARIO
            SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(null);
        } 
        catch (Exception ex) 
        {
            // ASSERT
            System.assert(ex.getMessage().equalsIgnoreCase(SEL_CoreConstants.ERROR_INACTIVE), 'Passing a null parameter must set the configuration invalid');
        }
    }
    
    @IsTest
    private static void groupValuesByTypeHeader()
    {
        Test.startTest();
        
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt( SEL_IsActive__c = true, SEL_NamedCredentials__c = 'namedCredential', SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON);
        SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(setting);
        SEL_IntegrationValue__mdt staticHeader = new SEL_IntegrationValue__mdt( SEL_Type__c = 'Header', SEL_SourceValueType__c = 'Static', SEL_Key__c = 'H1', SEL_Value__c = 'HeaderTest');
        SEL_IntegrationValue__mdt dynamicHeader = new SEL_IntegrationValue__mdt( SEL_Type__c = 'Header', SEL_SourceValueType__c = 'Dynamic', SEL_Key__c = 'H2', SEL_Value__c = 'HeaderTestDynamic');
        
        // TEST SCENARIO
        service.groupValuesByType(new List<SEL_IntegrationValue__mdt> { dynamicHeader, staticHeader });
        
        // ASSERT
        System.assert(service.headerStaticMap.size() == 1, SINGLE_VAL_CONST);
        System.assert(service.headerStaticMap.containsKey('H1') == true, 'There must be a key = H1');
        System.assert(service.headerStaticMap.get('H1').equalsIgnoreCase('HeaderTest') == true, 'The value must be HeaderTest');
        System.assert(service.headerDynamicMap.size() == 1, SINGLE_VAL_CONST);
        System.assert(service.headerDynamicMap.containsKey('H2') == true, 'There must be a key = H2');
        System.assert(service.headerDynamicMap.get('H2').equalsIgnoreCase('HeaderTestDynamic') == true, 'The value must be HeaderTestDynamic');
        
        Test.stopTest();	
    }
    
    @IsTest
    private static void groupValuesByTypeEndPoint()
    {
        Test.startTest();
        
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt( SEL_IsActive__c = true, SEL_NamedCredentials__c = 'namedCredential', SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON);
        SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(setting);
        SEL_IntegrationValue__mdt staticEndpoint = new SEL_IntegrationValue__mdt( SEL_Type__c = 'Endpoint', SEL_SourceValueType__c = 'Static', SEL_Key__c = 'E1', SEL_Value__c = 'EndpointTest');
        SEL_IntegrationValue__mdt dynamicEndpoint = new SEL_IntegrationValue__mdt( SEL_Type__c = 'Endpoint', SEL_SourceValueType__c = 'Dynamic', SEL_Key__c = 'E2', SEL_Value__c = 'EndpointTestDynamic');
        
        
        // TEST SCENARIO
        service.groupValuesByType(new List<SEL_IntegrationValue__mdt> { dynamicEndpoint, staticEndpoint });
        
        // ASSERT
        System.assert(service.endpointStaticMap.size() == 1, SINGLE_VAL_CONST);
        System.assert(service.endpointStaticMap.containsKey('E1') == true, 'There must be a key = E1');
        System.assert(service.endpointStaticMap.get('E1').equalsIgnoreCase('EndpointTest') == true, 'The value must be EndpointTest');
        System.assert(service.endpointDynamicMap.size() == 1, SINGLE_VAL_CONST);
        System.assert(service.endpointDynamicMap.containsKey('E2') == true, 'There must be a key = E2');
        System.assert(service.endpointDynamicMap.get('E2').equalsIgnoreCase('EndpointTestDynamic') == true, 'The value must be EndpointTestDynamic');
        
        Test.stopTest();	
    }
    @isTest
    private static void getHeaders()
    {
        Test.startTest();
        
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt(
            SEL_EndpointExtension__c = '/services/{record}/create/{var1}',
            SEL_HttpMethod__c = 'Post', 
            SEL_IsActive__c = true,
            SEL_IsCompressed__c = false,
            SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON,
            SEL_NamedCredentials__c = 'Salesforce'
        );
        SEL_IntegrationValue__mdt val1 = new SEL_IntegrationValue__mdt(SEL_Key__c = 'Accept', SEL_Value__c = 'application/json', SEL_Type__c = 'Header', SEL_SourceValueType__c = 'Static' );
        SEL_IntegrationValue__mdt val2 = new SEL_IntegrationValue__mdt(SEL_Key__c = IDEMPOTENCY_KEY, SEL_Value__c = '', SEL_Type__c = 'Header', SEL_SourceValueType__c = 'Dynamic' );
        SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(setting);
        service.groupValuesByType(new List<SEL_IntegrationValue__mdt> {val1 , val2});
        
        // TEST
        Map<String,String> headerMap = service.getHeaders(new Map<String,String>{ IDEMPOTENCY_KEY => 'importantKey', 'connection' => 'keep-alive'});
        
        // ASSERT
        // Using Static header
        system.assert(service.getHeaders().get('Accept').equalsIgnoreCase('application/json'), 'The result must by application/json.');
        
        // ASSERT
        // Using Dynamic Header
        system.assert(headerMap.get(IDEMPOTENCY_KEY).equalsIgnoreCase('importantKey'), 'The value of dynamic header must be "importantKey".');
        
        // ASSERT
        // Using Invalid Header 
        system.assert(headerMap.size() == 2, 'There must be only 2 headers.');
        
        Test.stopTest();
    }
    
    @isTest
    private static void getEndpoint()
    {
        Test.startTest();
        
        // DATA
        SEL_IntegrationSetting__mdt setting = new SEL_IntegrationSetting__mdt(
            SEL_EndpointExtension__c = '/services/{record}/create/{var1}',
            SEL_HttpMethod__c = 'Get', 
            SEL_IsActive__c = true, 
            SEL_IsCompressed__c = false,
            SEL_MessageFormat__c = SEL_CoreConstants.FORMAT_JSON,
            SEL_NamedCredentials__c = 'Salesforce'
        );
        SEL_IntegrationValue__mdt val1 = new SEL_IntegrationValue__mdt( SEL_Key__c = 'var1',  SEL_Value__c = '324',  SEL_Type__c = 'Endpoint', SEL_SourceValueType__c = 'Static' );
        SEL_IntegrationValue__mdt val2 = new SEL_IntegrationValue__mdt( SEL_Key__c = 'record',  SEL_Value__c = '',  SEL_Type__c = 'Endpoint', SEL_SourceValueType__c = 'Dynamic' );
        SEL_IntegrationsTransformService service = new SEL_IntegrationsTransformService(setting);
        service.groupValuesByType(new List<SEL_IntegrationValue__mdt> {val1 , val2});
        
        // TEST
        // Using Static Endpoint
        String ep = service.getEndpoint();
        System.assert(ep.equalsIgnoreCase('callout:Salesforce/services/{record}/create/324'), 'The endpoint must match.');
        
        // TEST 
        // Dynamic Endpoint
        ep = service.getEndpoint(new Map<String, String>{ 'record' => 'testRecord' });
        System.assert(ep.equalsIgnoreCase('callout:Salesforce/services/testRecord/create/324'), 'The Endpint should contain record value');
        
        Test.stopTest();
    }
}