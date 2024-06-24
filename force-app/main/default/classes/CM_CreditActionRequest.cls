/*-----------------------------------------------------------------------------
DESCRIPTION	:	contextId : The loan ID for the requested credit action.
actionType : The requested action type for credit action. 
The available action types are:Renewal  Modification
AUTHOR		:	Kuldeep
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
11-04-2023		Kuldeep Parihar	    Initial version
10-5-2023       John Gamboa         Added response return for CreditActionResult
-----------------------------------------------------------------------------*/
public without sharing class CM_CreditActionRequest {
    
    public String currentProductPackage;  // <Current Product Package>
    public String targetProductPackage; // '<TARGET_PP_ID>'
    public String contextId;
    public Boolean isAsync;    
    public String creditActionMode; // FORWARD_ACTION, ACTION_CHANGE, ROLLBACK_ACTION 
    
    List<CM_CreditActionFacility> facilityActions = new List<CM_CreditActionFacility>();
    
    @InvocableMethod(label='Get CreditAction Request' description='Iterate over CreditActionFacility') 
    public static List<CreditActionResult> performCreditAction(List <CreditActionReq> reqList){
        CM_CreditActionRequest caRequest = new CM_CreditActionRequest();
        String loanId = '';
        for(CreditActionReq req : reqList){
            caRequest.targetProductPackage = req.targetPackageId; // Prduct Package
            caRequest.currentProductPackage = req.contextId;
            caRequest.contextId = req.currentLoanID;
            caRequest.isAsync = req.isAsync != null ? req.isAsync : true;
            
            loanId = req.currentLoanID;
            
        }
        
        createShareRecord(loanId);
        
        List<CreditActionResult> results = caRequest.performAction();
        CreditActionResult ca = new CreditActionResult();
        
        for (CM_CreditActionRequest.CreditActionResult t : results) {
          ca.loanId = t.loanId;
        }
        
        return new List<CreditActionResult>{ca};
    }
    
    public List<CreditActionResult> performAction() {

        CM_CreditActionFacility loanWithAction = new CM_CreditActionFacility();
        loanWithAction.contextId = contextId; //Loan Id
        loanWithAction.actionType = 'Modify';  //'Renew';
        //loanWithAction.modificationType = 'Collateral Modification';
        facilityActions.add(loanWithAction);
        
        String facilityActionsString = JSON.serialize(facilityActions);
        
        Object aservice = nFORCE.BeanFactory.getInstance().getBeanByUniqueName('LLC_BI.CreditActionSoaXPkg');
        nFORCE.ACrossPackageService service = (nFORCE.ACrossPackageService) aservice;
        
        service.setInputParameter('contextId', currentProductPackage);
        
        if(targetProductPackage !=  null) {
            service.setInputParameter('targetPackageId', targetProductPackage); 
        }
        
        if(isAsync){ //  Queueable (true) or synchronously (false).
            service.setInputParameter('async', 'Queueable');
        }
        else{
            service.setInputParameter('async', 'synchronously');
        }

        
        service.setInputParameter('facilityActions', facilityActionsString);
        CreditActionResult ca = new CreditActionResult();
        try {
            service.executeService();
            // Parse the JSON string into a Map
            Map<String, Object> outputParams  = service.getOutputParameters();
            // Extract the CreditActionDto object from the Map
            Object obj  =  outputParams.get('response'); 
			Map<String, Object> m2 = (Map<String, Object>) service.getOutputParameters();
            String rawResponse = String.valueOf(m2.get('response'));
            Pattern patt = Pattern.compile('treeLoanIdLookup*?=\\{\\"*?([^\\r\\n\\t\\f\\v]+)"');
            Matcher matcher = patt.matcher(rawResponse);

            while(matcher.find()) {
                String loanIdString = matcher.group(1);
                loanIdString = loanIdString.replaceAll('"','');
                List<String> loanIds = loanIdString.split(':');
                ca.loanId = loanIds;
            }
        }
        catch(Exception ex) {
           cm_ExceptionLog.log(CM_CreditActionRequest.class.getName(), 'Credit Action', ex , contextId);
        }

        return new List<CreditActionResult>{ca};
    }

    public class CreditActionReq{
        /** Required Inputs*/
        @InvocableVariable 
        public String contextId;  // The Id of the Product Package associated to the action request.
        @InvocableVariable
        public String currentLoanID;   //	A serialized list of objects that contains complex sub-inputs. Refer to facilityActions inputs for more information.
        /** Optional Inputs*/
        @InvocableVariable
        public String targetPackageId;  //  The product package ID that houses the newly created/reparented actioned loans. If blank, the service uses the contextId as the target package ID.
        @InvocableVariable
        public Boolean isAsync; //  Queueable (true) or synchronously (false).
        @InvocableVariable
        public String creditActionMode; // FORWARD_ACTION, ACTION_CHANGE, ROLLBACK_ACTION 
    }
    
    public class CreditActionResult{
        @InvocableVariable(label='String collection variable')
        public List<String> loanId;
    }
    
    public static boolean createShareRecord(Id loanId){
      LLC_BI__Loan__Share loanShr  = new LLC_BI__Loan__Share();
      loanShr.ParentId = loanId;
      loanShr.UserOrGroupId = UserInfo.getUserId();
      loanShr.AccessLevel = 'Edit';
      loanShr.RowCause = Schema.LLC_BI__Loan__Share.RowCause.Manual;
      
      Database.SaveResult sr = Database.insert(loanShr,false);

      // Process the save results.
      if(sr.isSuccess()){
         // Indicates success
         //System.debug('SHARE LOAN Success >> '+sr);
         return true;
          
      }
      else {
         // Get first save result error.
         Database.Error err = sr.getErrors()[0];
         
         // Check if the error is related to trival access level.
         // Access level must be more permissive than the object's default.
         // These sharing records are not required and thus an insert exception is acceptable. 
         if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                  err.getMessage().contains('AccessLevel')){
            // Indicates success.
            return true;
         }
         else{
            // Indicates failure.
            return false;
         }
       }
    }
}