/*-----------------------------------------------------------------------------
DESCRIPTION :   Constants file for Core Library
AUTHOR      :   Kuldeep    
LIBRARY     :   Salesforce Enterprise Library (SEL) - Core
VERSION     :   1.0

HISTORY     :
Date            Author              Comment
APR-21-2022     Kuldeep    Initial version
-----------------------------------------------------------------------------*/
public with sharing class SEL_CoreConstants 
{
    // DML
    public static final String DML_DELETE = 'delete';
    public static final String DML_INSERT = 'insert';
    public static final String DML_UNDELETE = 'undelete';
    public static final String DML_UPDATE = 'update';
    public static final String DML_UPSERT = 'upsert';


    public static final String LOG_REQUEST_ATTACHMENT_NAME = 'Request.txt' ;
    public static final String LOG_RESPONSE_ATTACHMENT_NAME = 'Response.txt';
    public static final String CONSTANT_VAR_ENDPOINT = '\nEndpoint: ';
    public static final String CONSTANT_VAR_METHOD = '\nMethod: ';
    public static final String CONSTANT_VAR_BODY = '\nBody: ';
    public static final String CONSTANT_VAR_STATUSCODE = '\nStatus Code: ';
    public static final String CONSTANT_VAR_STATUS = '\nStatus: ';
    public static final String CONSTANT_VAR_REQUESTDATA = 'Request Data: ';
    public static final String CONSTANT_VAR_RESPONSEDATA = 'Response Data:';

    public static final String GENERIC_MESSAGE = '***SEL Logger*** ';
    public static final String DEBUG_LEVEL_ERROR_CODE = 'Error';
    public static final String CONSTANT_VAR_LOG = 'log';
    public static final String CONSTANT_VAR_AT = 'at ';
    public static final String CONSTANT_VAR_NULL = '';
    public static final String CONSTANT_METHOD = 'SEND';
    public static final String CONSTANT_INTEGRATION = 'INTEGRATION';
    public static final String CONSTANT_FLOW = 'FLOW';
    public static final String CONSTANT_CREATE_ATTACHEMENT = 'createLogAttachments';
    public static final String CONSTANT_HTTP_LOG = 'HTTP LOG';
    public static final String CONSTANT_ERROR_LOG = 'ERROR LOG';
    
	// Integration Value
    public final static String IV_VALUE_TYPE_STATIC = 'Static';
	public final static String IV_VALUE_TYPE_DYNAMIC = 'Dynamic';
	public final static String HEADER   = 'Header';
	public final static String ENDPOINT = 'Endpoint';
    
    public final static String FORMAT_JSON = 'json';
    // Error Messaages
	public final static String ERROR_INACTIVE = 'The Integration Setting that you are trying to access is inactive or does not exists. Reach out to your System Administrator and try again.';
	public final static String ERROR_NAMEDCREDENTIAL_INVALID = 'The Named Credential API you configured does not exist.';
        
    @TestVisible
    private static String getUnitTest()
    {
        // IMPORTANT
        // This is added as the Salesforce Enteprise Library is currently lifted 
        // and shifted to client Salesforce orgs using a non-pakage based
        // deployments. Remove this once SEL transitions to unlocked packaging.

        return SEL_CoreConstants.DML_INSERT;
    }
}