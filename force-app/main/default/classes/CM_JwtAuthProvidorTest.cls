/*-----------------------------------------------------------------------------
DESCRIPTION	:	Test class of CM_JwtAuthProvidor class
AUTHOR		:	Jan Reimil Cabantog
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
18-08-2023		Jan Reimil Cabantog	Initial version
-----------------------------------------------------------------------------*/
@isTest
public class CM_JwtAuthProvidorTest {
    
	private Integer statusCode;
    
    @isTest
    static void requestAccessTokenTest(){
        //Mock data
        string mockBody = '{"access_token": "3RzcI5yUsSzy1kZJ3JItKrdks-oKDw5Nfr6DO3RzDlP0bKm-0bgrjSu7cpqoyniIlIfEqUuq-oS1cnUosPADiT","token_type": "Bearer","expires_in": 300}';
        CM_JwtAuthProvidorMock mock = new CM_JwtAuthProvidorMock();
        mock.createResponse(mockBody,200);
        Test.setMock(HttpCalloutMock.class, mock);
        CM_JwtAuthProvidor.Token token = new CM_JwtAuthProvidor.Token();
        List<CM_JwtAuthProvidor.Token> result = new List<CM_JwtAuthProvidor.Token>();
        test.StartTest();
        result = CM_JwtAuthProvidor.requestAccessToken();
        test.StopTest();
        System.assertNotEquals(result,null);
    }
    
    @isTest
    static void requestAccessTokenTestFail(){
        //Mock data
        string mockBody = '{"access_token": "","token_type": "","expires_in": 300}';
        CM_JwtAuthProvidorMock mock = new CM_JwtAuthProvidorMock();
        mock.createResponse(mockBody,400);
        Test.setMock(HttpCalloutMock.class, mock);
        CM_JwtAuthProvidor.Token token = new CM_JwtAuthProvidor.Token();
        List<CM_JwtAuthProvidor.Token> result = new List<CM_JwtAuthProvidor.Token>();
        test.StartTest();
        result = CM_JwtAuthProvidor.requestAccessToken();
        test.StopTest();
        System.assertNotEquals(result,null);
    }
    
    
    @isTest
    static void requestAccessTokenTestException(){
        Test.setMock(HttpCalloutMock.class, new UnauthorizedEndpointResponse());
        CM_JwtAuthProvidor.Token token = new CM_JwtAuthProvidor.Token();
        List<CM_JwtAuthProvidor.Token> result = new List<CM_JwtAuthProvidor.Token>();
        test.StartTest();
        result = CM_JwtAuthProvidor.requestAccessToken();
        test.StopTest();
        System.assertNotEquals(result,null);
    }
    
    //Test method of extractJsonField method
    @isTest
    static void extractJsonField(){
        string mockBody = '{"access_token": "3RzcI5yUsSzy1kZJ3JItKrdks-oKDw5Nfr6DO3RzDlP0bKm-0bgrjSu7cpqoyniIlIfEqUuq-oS1cnUosPADiT","token_type": "Bearer","expires_in": 300}';
        string accesstoken = 'access_token';
        string result;
        test.startTest();
        	result = CM_JwtAuthProvidor.extractJsonField(mockBody,accesstoken);
        test.stopTest();
        System.assertNotEquals(result,null);
    }
    

    //Mock Class of the CM_JwtAuthProvidor class
    public class CM_JwtAuthProvidorMock implements HttpCalloutMock{
        
        HttpResponse res;
        
        /***************************************************
        * @description Create mock response
        * @param Integer Response Status Code
        * @param String Response Body
        * @return Void
        ****************************************************/
        public void createResponse(String body,Integer statusCode) {
            HttpResponse response = new HttpResponse();
            response.setBody(body);
            response.setStatusCode(statusCode);
            res = response;
        }
        
        /***************************************************
        * @description HttpCalloutMock Interface method to return the response
        * @param HttpRequest The request
        * @return HttpResponse The Response
        ****************************************************/
        public HttpResponse respond(HttpRequest request) {
            return res;
        }	
    }
    
    //Mock class for unauthorize endpoint to create exception
    public class UnauthorizedEndpointResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
            throw e;
        }
	}
}