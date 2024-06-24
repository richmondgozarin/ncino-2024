/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      04/29/2024
* @Description: This handled the email notification of the Audit Trail Logs for the day
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/

public with sharing class cm_AuditLogReport {
  	
    public class requestOrgWide{
        @InvocableVariable public String OrgWideId;
    }
    
/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      04/29/2024
* @Description: Receive inputs from Flow and execute the email notification
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/    
    @InvocableMethod(label='Send Audit Report Email' description='Generate all Audit Trail logs and send email report') 
    public static void sendAuditReport(List<requestOrgWide> getRequest){
        
     	cm_AuditLogReport auditReport = new cm_AuditLogReport();
       auditReport.parseAuditLogs(getRequest[0].OrgWideId);
        
    }
    
/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      04/29/2024
* @Description: Construct single email message to send which contains with the Audit Log report
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    
	public void sendEmailMessage(String orgWideId, Map<Integer, String> csvValues) {
		
		// Construct the Single Email Message with Attachment
        List<Messaging.EmailFileAttachment> getAttachment = new List<Messaging.EmailFileAttachment>();
        
        for(Integer getMapKey : csvValues.keySet()){
            Messaging.EmailFileAttachment csvFile = new Messaging.EmailFileAttachment();
            csvFile.setFileName(cm_Constant.AUDIT_FILE_NAMES[getMapKey] + ' ' + String.valueOf(cm_Constant.DATE_TIME_TDY.addDays(- + cm_Constant.AUDIT_DAY_PERIOD).formatGmt(cm_Constant.DD_MM_YYYY_FORMAT).replace('/', '-')) + cm_Constant.CSV_FILE_EXTENSION);
            csvFile.setBody(blob.valueOf(csvValues.get(getMapKey)));
            getAttachment.add(csvFile);
        }
        
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setOrgWideEmailAddressId(orgWideId);
        message.toAddresses = cm_Constant.AUDIT_LOG_RECIPIENTS;
		message.subject = cm_Constant.AUDIT_EMAIL_SUBJECT;
        message.setFileAttachments(getAttachment);
		message.plainTextBody = cm_Constant.AUDIT_MESSAGE_BODY;
        
		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
		} catch (Exception ex) {
            cm_ExceptionLog.log(cm_AuditLogReport.class.getName(), 'sendEmailMessage', ex);
        }
	}

/**************************************************************************************************
* @Author:    Rolie John Ewican 
* @Date:      04/29/2024
* @Description: Getting Login History of users and checking if made some changes then store in the CSV file attached on the email
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
	public void parseAuditLogs(String OrgWideId) {
        Map<Integer, String> csvValues = new Map<Integer, String>();
        String loginHistoryCsvValues = cm_Constant.EMPTY_STRING;
        String auditLogCsvValues = cm_Constant.EMPTY_STRING;
        List<String> userId = new List<String>();
        
        try{
            Map<Id, User> getUserRecords = new Map<Id, User>([SELECT Id, Profile.Name, Name, UserRole.Name 
                                                              FROM User WHERE Profile.Name IN : cm_Constant.AUDIT_LOG_USER_PROFILE WITH SECURITY_ENFORCED]);

            for(LoginHistory logHistory : [Select Id, UserId, LoginTime FROM LoginHistory 
                                           WHERE LoginTime >= :cm_Constant.SET_DATE_TIME.addDays(- + cm_Constant.AUDIT_DAY_PERIOD) 
                                           AND LoginTime <= :cm_Constant.SET_DATE_TIME AND UserId IN : getUserRecords.Keyset() WITH SECURITY_ENFORCED ORDER BY LoginTime DESC]){
                    
                    userId.add(logHistory.UserId);
                   
					if(getUserRecords.containsKey(logHistory.UserId)){
                       loginHistoryCsvValues += getUserRecords.get(logHistory.UserId).Profile.Name + ',' + getUserRecords.get(logHistory.UserId).UserRole.Name + ',' +
                           getUserRecords.get(logHistory.UserId).Name + ',' + logHistory.LoginTime.formatGmt(cm_Constant.DD_MM_YYYY_TIME_FORMAT) + ',' + cm_Constant.USER_ACTION + cm_Constant.NEW_LINE_BREAK;
                    }
                                            
            }
            csvValues.put(0, cm_Constant.AUDIT_CSV_HEADER[0] + cm_Constant.NEW_LINE_BREAK + loginHistoryCsvValues);
            
            for (SetupAuditTrail log : [SELECT Id, CreatedDate, CreatedBy.UserName, Section, DelegateUser, Display 
                                        FROM SetupAuditTrail WHERE CreatedDate >= :cm_Constant.SET_DATE_TIME.addDays(- + cm_Constant.AUDIT_DAY_PERIOD) 
                                        AND CreatedDate <= :cm_Constant.SET_DATE_TIME AND CreatedBy.Id IN :userId WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC]) {
                    
                if(log.Section != null && cm_Constant.AUDIT_EXCLUDE_SECTION.contains(log.Section.replace(' ', cm_Constant.EMPTY_STRING))){
                    continue;
                }
                auditLogCsvValues += log.CreatedDate.formatGmt(cm_Constant.DD_MM_YYYY_TIME_FORMAT) + ',' + log.CreatedBy.UserName + ',' + 
                log.Display.replace(',',cm_Constant.EMPTY_STRING).escapeCsv() + ',' + log.Section + ',' + log.DelegateUser + cm_Constant.NEW_LINE_BREAK;
                
            }
            csvValues.put(1, cm_Constant.AUDIT_CSV_HEADER[1] + cm_Constant.NEW_LINE_BREAK + auditLogCsvValues.replace('null', cm_Constant.EMPTY_STRING));
			
            sendEmailMessage(OrgWideId, csvValues);
        } catch (Exception ex) {
            cm_ExceptionLog.log(cm_AuditLogReport.class.getName(), 'parseAuditLogs', ex);
        }
	}
}