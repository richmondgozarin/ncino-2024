/**************************************************************************************************
* @Author:    Jan Reimil Cabantog
* @Date:      18/01/2024
* @Description: Class handler of Loan Document Trigger
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]

//NOT USED
***************************************************************************************************/
public without sharing class cm_LoanDocumentTriggerHandler {

    public static void onBeforeInsert(List<LLC_BI__LLC_LoanDocument__c> loanDoclist){
        loanDocValidation(loanDoclist);
    }
    
    //Validation Method
    public static void loanDocValidation(List<LLC_BI__LLC_LoanDocument__c> loanDoclist){
        
        System.debug('loanDoclist:'+loanDoclist);
        
        Set<Id> loanDocIdSet = new Set<Id>();
        for(LLC_BI__LLC_LoanDocument__c doc: loanDoclist){
            System.debug('doc.LLC_BI__Loan__c:'+ doc.LLC_BI__Loan__c);
            loanDocIdSet.add(doc.LLC_BI__Loan__c);
        }
        //Check loanDocIdSet
        System.debug('loanDocIdSet:'+loanDocIdSet);
        
        List<LLC_BI__Checklist__c> checkList = [SELECT Id,Name,LLC_BI__Loan__r.Id FROM LLC_BI__Checklist__c WHERE LLC_BI__Loan__r.Id =: loanDocIdSet];
        System.debug('checkList:'+checkList);
        
        List<LLC_BI__Requirement__c> requirementList = [SELECT Id,Name,LLC_BI__Checklist__c,LLC_BI__Needed_By__c,cm_Needed_By__c,LLC_BI__Status__c FROM LLC_BI__Requirement__c WHERE LLC_BI__Checklist__c =: checkList];
        System.debug('requirementList'+requirementList);
        
        List<LLC_BI__Requirement__c> pendingSCLlist = new List<LLC_BI__Requirement__c>();
        
        LLC_BI__Loan__c loan = [SELECT Id,Name,cm_Record_Deleted_Flag__c FROM LLC_BI__Loan__c WHERE Id =: loanDocIdSet LIMIT 1];
        System.debug('loan:'+loan);
        
        for(LLC_BI__Requirement__c req: requirementList){
            if(req.cm_Needed_By__c == 'Doc Prep' && (req.LLC_BI__Status__c != 'Complete' || req.LLC_BI__Status__c != 'Waived')){
                System.debug('requirements hereee @@');
                pendingSCLlist.add(req);
            }
        }
        System.debug('pendingSCLlist:'+pendingSCLlist);
        
        //Get current user info
        string recipientId = UserInfo.getUserId();
        System.debug('recipientId:'+recipientId);

        
        //Set dummy target id
        string targetId = '000000000000000AAA';
        
        for(LLC_BI__LLC_LoanDocument__c doc: loanDoclist){
            if(pendingSCLlist != null && !pendingSCLlist.isEmpty() && (doc.Name == 'Loan Sanction Letter' || doc.Name == 'Overdraft Sanction Letter')){
                System.debug('Throw Error!');
                loan.cm_Record_Deleted_Flag__c = true;
                notifyUsers(recipientId,targetId);
                //doc.addError('Pending Smart Checklist Item'); //commented out add error prevents dml
            }
        }
        System.debug('code run after error');
        try{
            System.debug('loan:@@@'+loan);
            if(loan != null){
            	Update loan;
			                
            }
        }catch(Exception e){
            System.debug('Error sending custom notification: ' + e.getMessage());
        }
    }
    
    public static void notifyUsers(String recipientId, string targetId) {
	   System.debug('recipientId'+recipientId);
       System.debug('targetId'+targetId);
       try {
           
            Messaging.CustomNotification notification = new Messaging.CustomNotification(); 
            notification.setBody('Theres smart checklist items that are needed action.');
            notification.setTitle('Smart Checklist Error');
           
           	//define sender id and check if the sender has permission to send notification
            //notification.setSenderId(Userinfo.getUserId()); 
            // Get the Id for our custom notification type
        	CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName 
                 FROM CustomNotificationType 
                 WHERE DeveloperName='Loan_Document_Validation_Notification']; 
            notification.setNotificationTypeId(notificationType.id); 
            notification.setTargetId(targetId); // target object id 
           
           System.debug('Send Notification @@@@@');
           System.debug('@@@recipientId:'+recipientId);
            notification.send(new Set<String> { recipientId });
            
        } catch (Exception e) {
            System.debug('Error sending custom notification: ' + e.getMessage());
        }
    }
    
}