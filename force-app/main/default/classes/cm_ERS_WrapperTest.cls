/*-----------------------------------------------------------------------------
DESCRIPTION	:	Test class for ERS Request and Response wrapper class
AUTHOR		:	Jan Reimil Cabantog
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
05-09-2023		Jan Reimil Cabantog	Initial version
-----------------------------------------------------------------------------*/
@IsTest 
public with sharing class cm_ERS_WrapperTest {
    
    //Test method to for cm_ERS_RequestWrapper class
	@IsTest 
	private static void getUnitTestERSRequestWrapper()
	{
        Test.startTest();
			cm_ERS_RequestWrapper.Identifier identifier = cm_ERS_RequestWrapper.getUnitTest();
            identifier.applicationNumber = 300012274;
        Test.stopTest();
        System.assertEquals(identifier.applicationNumber, 300012274);
	}
    
    //Test method to for cm_ERS_ResponseWrapper class
	@IsTest 
	private static void getUnitTestERSResponseWrapper()
	{
        Test.startTest();
			cm_ERS_ResponseWrapper.assessment assessment = cm_ERS_ResponseWrapper.getUnitTest();
            assessment.decisionOutcome = 'Refer';
        Test.stopTest();
        System.assertEquals(assessment.decisionOutcome, 'Refer');
	}
}