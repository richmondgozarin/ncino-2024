/*-----------------------------------------------------------------------------
DESCRIPTION	:	Returns the Token for a custom OAuth-based authentication
AUTHOR		:	Kuldeep
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
17-08-2023		Kuldeep Parihar	Initial version
-----------------------------------------------------------------------------*/
public class CM_JwtAuthProvidor {
    
    @TestVisible private final static String CON_MDT_API_NAME = 'BOI_JWT';
    @TestVisible private final static String CON_ASSERTION_TYPE = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer';
    @TestVisible private final static String CON_JWT_TYPE = 'JWT'; 
    @TestVisible private final static String CON_ACCESS_TOKEN = 'access_token';
    @TestVisible private final static String CON_UTF8= 'UTF-8';  
    @TestVisible private final static String CON_HEADER_ACCEPT= 'application/json';
    @TestVisible private final static String CON_HTTP_POST= 'POST';
    @TestVisible private final static String CON_MOCK_ACCESS_TOKEN = '3RzcI5yUsSzy1kZJ3JItKrdks-oKDw5Nfr6DO3RzDlP0bKm-0bgrjSu7cpqoyniIlIfEqUuq-oS1cnUosPADiT';
    
    
    public class Token{
        @InvocableVariable
        public String access_token; 
    }
    
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
    
    /**
* @description Returns the Token for a custom OAuth-based authentication.
* @return      Access token and JWS signature authentication provider.
*/
    @InvocableMethod(label='Get JWT Access Token' description='Get Access token and JWS Token')
    public static  List<Token> requestAccessToken() {
        String txnId;
        try{
            BOI_JWT_OAuth__mdt mdt =  BOI_JWT_OAuth__mdt.getInstance(Con_MDT_API_NAME);
            Map<String, String> m = new Map<String, String>();
            m.put('client_assertion_type', CON_ASSERTION_TYPE);
            m.put('scope', String.valueOf(mdt.Scope__c)); 
            m.put('client_id', String.valueOf(mdt.Client_ID__c)); 
            String jwsToken = createToken(mdt , Null);
            m.put('client_assertion', jwsToken);    
            m.put('grant_type', 'client_credentials');
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Accept', CON_HEADER_ACCEPT);
            txnId = getUUID();
            req.setHeader('x-api-transaction-id',txnId);
            req.setHeader('x-api-correlation-id',txnId);
            req.setEndpoint(String.valueOf(mdt.host__c) + String.valueOf(mdt.Token_Endpoint_URL__c));
            req.setMethod(CON_HTTP_POST);
            req.setTimeout(60 * 1000);
            req.setBody(formEncode(m));
            
            HttpResponse res;
            Token result = new Token();
            List<Token> resultList = new List<Token>();
            //Mocking for Oauth
            if(mdt.cm_IsMockingEnabled__c){
                result.access_token = CON_MOCK_ACCESS_TOKEN;
                resultList.add(result);
                return resultList;
            }else{
               res = new Http().send(req); 
            }
              
            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                result.access_token = extractJsonField(res.getBody(), CON_ACCESS_TOKEN);
                resultList.add(result);
                return resultList;
            } else {
                result.access_token = Null;          
                resultList.add(result);
                cm_ExceptionLog.log(txnId, req, res);
                cm_ExceptionLog.log(CM_JwtAuthProvidor.class.getName(), 'requestAccessToken',res.getStatus(), res.getBody(), txnId);
                return resultList;
            }
        }
        catch(Exception ex){
              cm_ExceptionLog.log(CM_JwtAuthProvidor.class.getName(), 'requestAccessToken', ex , txnId);
              Token result = new Token();
              result.access_token = Null;   
              List<Token> resultList = new List<Token>();
              resultList.add(result);
              return resultList;
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
    
    @TestVisible
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
    
    public Static String createToken(BOI_JWT_OAuth__mdt mdt, String payload) {
        
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
        if(payload != Null){
            bodyJson = payload;
        }
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