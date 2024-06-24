public class POC_JWTAuthProvider extends Auth.AuthProviderPluginClass {
    
    public static final String CUSTOM_MDT_NAME = 'BOI_JWT2'; 
    public static final String DUMMY_CODE='9999';
    public static final String RESOURCE_CALLBACK = '/services/authcallback/';

    @TestVisible private final static String CON_MDT_API_NAME = 'BOI_JWT_OAuth__mdt';
    @TestVisible private final static String CON_ASSERTION_TYPE = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer';
    @TestVisible private final static String CON_JWT_TYPE = 'JWT'; 
    @TestVisible private final static String CON_ACCESS_TOKEN = 'access_token';
    @TestVisible private final static String CON_UTF8= 'UTF-8';  
    @TestVisible private final static String CON_HEADER_ACCEPT= 'application/json';
    @TestVisible private final static String CON_HTTP_POST= 'POST';
    
    private class Header {
        String alg;
        String typ;
        String kid;
        
        Header(String alg, String typ , String kid) {
            this.alg = alg; //
            this.typ = typ; //jwt
            this.kid = kid;// 
        }
    }
    
    private class Body {
        String iss;
        String sub;
        String aud;
        String jti;
        String exp;
        String iat;
        
        Body(String iss, String sub, String aud, String jti, String exp, String iat) {
            this.iss = iss;
            this.sub = sub;
            this.aud = aud;
            this.jti = jti;
            this.exp = exp;
            this.iat = iat;
        }
    }
    public String getCustomMetadataType(){
         return CON_MDT_API_NAME;
    }
    
    public Auth.UserData getUserInfo(Map<String,String> params, Auth.AuthProviderTokenResponse response) {
        return null;
    }

    public Auth.AuthProviderTokenResponse handleCallback(Map<String,String> params, Auth.AuthProviderCallbackState state) {
        return null;
    }
    
    private String getCallbackUrl(Map<string,string> config) {
        // https://{salesforce-hostname}/services/authcallback/{urlsuffix}
        final String generatedUrl = URL.getSalesforceBaseUrl().toExternalForm() + RESOURCE_CALLBACK + CUSTOM_MDT_NAME ;
        return generatedUrl;
    }
    
    
    
    public System.PageReference initiate(Map<String,String> config, String stateToPropagate){
        System.debug('initiate');
        final PageReference pageRef = new PageReference(getCallbackUrl(config)); //NOSONAR
        pageRef.getParameters().put('state',stateToPropagate);
        pageRef.getParameters().put('code',DUMMY_CODE); // Empirically found this is required, but unused
        System.debug(pageRef.getUrl());
        return pageRef;
    }
    
     private String getAuthToken() {
         BOI_JWT_OAuth__mdt mdt =  BOI_JWT_OAuth__mdt.getInstance(Con_MDT_API_NAME);
            Map<String, String> m = new Map<String, String>();
            m.put('client_assertion_type', CON_ASSERTION_TYPE);
            m.put('scope', String.valueOf(mdt.Scope__c)); 
            m.put('client_id', String.valueOf(mdt.Client_ID__c)); 
            String jwsToken = createToken(mdt);
            m.put('client_assertion', jwsToken);    
            m.put('grant_type', 'client_credentials');
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Accept', CON_HEADER_ACCEPT);
            String txnId = getUUID();
            req.setHeader('x-api-transaction-id',txnId);
            req.setHeader('x-api-correlation-id',txnId);
            req.setEndpoint(String.valueOf(mdt.host__c) + String.valueOf(mdt.Token_Endpoint_URL__c));
            req.setMethod(CON_HTTP_POST);
            req.setTimeout(60 * 1000);
            req.setBody(formEncode(m));
            
            HttpResponse res = new Http().send(req);
          if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                String access_token = extractJsonField(res.getBody(), CON_ACCESS_TOKEN);
                return access_token;
            }
         else{
              String access_token = '';
              return access_token;
         }
     }
    private Static String formEncode(Map<String, String> m) {
        
        String s = '';
        for (String key : m.keySet()) {
            if (s.length() > 0) {
                s += '&';
            }
            s += key + '=' + EncodingUtil.urlEncode(m.get(key), CON_UTF8);
        }
        return s;
    }
    
    private Static String extractJsonField(String body, String field) {
        
        JSONParser parser = JSON.createParser(body);
        String access_Token;
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME
                && parser.getText() == field) {
                    parser.nextToken();
                    access_Token = parser.getText();
                }
        }
        return access_Token;
    }
    
    private Static String createToken(BOI_JWT_OAuth__mdt mdt) {
        
        String alg = String.valueOf(mdt.JWT_Algorithm__c); //String.valueOf(mdt.JWT_Algorithm__c)
        String typ = CON_JWT_TYPE;
        String kid = String.valueOf(mdt.JWT_Kid__c); // Unique Id  String.valueOf(mdt.Token_Endpoint_URL__c)
        
        String iss =  String.valueOf(mdt.JWT_Issuer__c);
        String sub =  String.valueOf(mdt.JWT_Subject__c);
        String aud =  String.valueOf(mdt.JWT_Audience__c);
        String jti = getUUID();
        String exp = String.valueOf(System.currentTimeMillis() + 3 * 1000);
        String iat = String.valueOf(System.currentTimeMillis());
        
        String headerJson = JSON.serialize(new Header(alg, typ, kid)); 
        String bodyJson =  JSON.serialize(new Body(iss, sub, aud, jti, exp, iat ));        
        String token = base64UrlSafe(Blob.valueOf(headerJson))
            + '.' + base64UrlSafe(Blob.valueOf(bodyJson));     
        String signature = base64UrlSafe(Crypto.signWithCertificate(
            String.valueOf(mdt.JWT_Signing_Algorithm__c),
            Blob.valueOf(token),
            String.valueOf(mdt.JWT_Signing_Certificate_Name__c)
        ));
        token += '.' + signature;
        return token;
    }
    
    private Static String base64UrlSafe(Blob b) {
        return EncodingUtil.base64Encode(b).replace('+', '-').replace('/', '_').replace('=', '');
    }
    
    private static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,4)+ '-' + h.SubString(4,8) + '-' + h.SubString(8,12) + '-' + h.SubString(12,16);
        return guid;
    }
     
}