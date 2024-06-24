/**************************************************************************************************
 * DEPRECATED
* @Author:    Kuldeep Parihar 
* @Date:      06/02/2023
* @Description: This method will handle Call out to ERS.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public without sharing class cm_ERS_GetDecisionController {
    
	/*
    @AuraEnabled
    public static String validateLoan(cm_ERS_GetDecisionWrapper.Parameter recordStr){
        cm_ERS_GetDecisionHandler handler =  new cm_ERS_GetDecisionHandler('DecisionAPI');
        cm_ERS_GetDecisionWrapper.Result result  =  new cm_ERS_GetDecisionWrapper.Result();  
        try{
            cm_ERS_GetDecisionWrapper.Parameter param = recordStr;
            result = cm_ERS_GetDecisionHandler.validateLoanDetails(param.recordId);
        }
        catch(Exception ex){
            result.hasError = true;
            result.message = ex.getMessage();
            cm_ExceptionLog.log(cm_ERS_GetDecisionController.class.getName(), 
                                'validateLoan', 
                                ex);
        }
        return JSON.serialize(result); 
        
    }
    
    @AuraEnabled
    public static String getERSDecision(cm_ERS_GetDecisionWrapper.Parameter recordStr){
        cm_ERS_GetDecisionWrapper.Result result  =  new cm_ERS_GetDecisionWrapper.Result();  
        try{
            system.debug ('Debug ERS Param ' +  JSON.serialize(recordStr));     
            cm_ERS_GetDecisionWrapper.Parameter param = recordStr;
            cm_ERS_GetDecisionHandler handler =  new cm_ERS_GetDecisionHandler('DecisionAPI');
            result = handler.callERSSerice(param.recordId);
        }
        catch(Exception ex){
            result.hasError = true;
            result.message = ex.getMessage();
            cm_ExceptionLog.log(cm_ERS_GetDecisionController.class.getName(), 
                                'getERSDecision', 
                                ex);
        }
        return JSON.serialize(result); 
        
    }
    */
}