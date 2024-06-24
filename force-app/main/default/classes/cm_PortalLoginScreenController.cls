public with sharing class cm_PortalLoginScreenController {
    
    public User currentUser { get; set; }
    public String capturedURL { get; set; }
    
    public PageReference captureURLOnLoad() {
        capturedURL = System.currentPageReference().getURL();
        // You can now use the capturedURL variable in your Apex logic
        return null; // This is a required return statement for the action attribute
    }

    public cm_PortalLoginScreenController() {
        // Fetch the current user's information
        currentUser = [SELECT Id, cm_TermsofService__c , Account.Id FROM User WHERE Id = :UserInfo.getUserId()];  
    }
    
    public void updateUser() {
        
        // Update the custom field value
        currentUser.cm_TermsofService__c = true;
        update currentUser;
    }
    
    public PageReference FinishLoginFlowHome() {  
        
        String vfpAdditionalInfo = 'Portal_AdditionalDetails?recId=' +  currentUser.Account.Id;
        
        // Instantiate the controller
        cm_PortalLoginScreenController controllerInstance = new cm_PortalLoginScreenController();
        
        // Call the method on the controller instance
        controllerInstance.updateUser();  
        
        /* Defect NCINO-6275
        if (currentUser.Account.cm_AdditionalInfoReqd__c == true) {
            return  Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow + vfpAdditionalInfo);
        } else {
            return Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow);
        }
		*/
        return Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow);
    }
    
    public PageReference windowsloadFinishLoginFlowHome() {      

        Id userId = UserInfo.getUserId(); 
        String vfpAdditionalInfo = 'Portal_AdditionalDetails?recId=' +  currentUser.Account.Id;
        
        /* Defect NCINO-6275
        if (currentUser.Id == userId && currentUser.cm_TermsofService__c == true ) {
            if (currentUser.Account.cm_AdditionalInfoReqd__c == true) {
               return  Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow + vfpAdditionalInfo);
            } else {
                return  Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow);
            }            
        } else {
            return null;
        }
		*/
        if (currentUser.Id == userId && currentUser.cm_TermsofService__c == true ) {  
        	return  Auth.SessionManagement.finishLoginFlow(System.Label.BOI_CP_finishLoginFlow);    
        } else {
            return null;
        }        

    }  
    
}