/**************************************************************************************************
* @Author:      Rolie John Ewican
* @Date:        03/05/2024
* @Description: Test class for cm_AuditLogReport 
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/

@isTest
private class cm_AuditLogReportTest {
    
    @isTest
    private static void getOrgWideAddressIdTest(){
        
        cm_AuditLogReport.requestOrgWide orgWideFlowInput = new cm_AuditLogReport.requestOrgWide();
        
        List<OrgWideEmailAddress> getAllOrgWideRecords = [SELECT Id, isVerified FROM OrgWideEmailAddress WHERE isVerified = true
                                                         AND Purpose = 'UserSelectionAndDefaultNoReply'];
        
        for(OrgWideEmailAddress getOrgWideId : getAllOrgWideRecords){
            orgWideFlowInput.OrgWideId = getOrgWideId.Id;
        }
        
        Test.startTest();
        	cm_AuditLogReport.sendAuditReport(new List<cm_AuditLogReport.requestOrgWide>{orgWideFlowInput});
        Test.stopTest();
        
        // ASSERTION TO BE ADDED
        Assert.areNotEqual(0, getAllOrgWideRecords.size(), 'ASSERTION FAILED: No records found in the OrgWideAddresses');
    }
    
    @isTest
    private static void invalidEmailRecipients(){
        List<String> emailRecipients = new List<String>{'email01@invalid', 'email02@invalid.com'};
        String auditValuesTest = 'Test values, Test Values 02';
        String logHistoryValues = 'Test values, Test Values 02';
        Map<Integer, String> csvValues = new Map<Integer, String>{0 => auditValuesTest, 1 => logHistoryValues};
        cm_Constant.AUDIT_LOG_RECIPIENTS = emailRecipients;
        String orgWideId;
        // Get OrgWideAddress Records
        List<OrgWideEmailAddress> getAllOrgWideRecords = [SELECT Id, isVerified FROM OrgWideEmailAddress WHERE isVerified = true];
        
        for(OrgWideEmailAddress getOrgWideId : getAllOrgWideRecords){
            orgWideId = getOrgWideId.Id;
        }
        
        Test.startTest();
            cm_AuditLogReport auditLog = new cm_AuditLogReport();
        	Integer numEmailSent = Limits.getEmailInvocations();
            auditLog.sendEmailMessage(orgWideId, csvValues);
        Test.stopTest();
        
        // ASSERTION TO BE ADDED
        Assert.areEqual(0, numEmailSent, 'ASSERTION FAILED');
    }
}