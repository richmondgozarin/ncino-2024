/**************************************************************************************************
 * DEPRECATED
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1: Base wrapper to be extended for Lightning Web Components
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public class cm_ERS_GetDecisionWrapper extends cm_BaseWrapper {
    
    public without sharing  class Parameter extends cm_BaseWrapper.Parameter {
    }
    
    public without sharing class Result extends cm_BaseWrapper.Result { 
        @AuraEnabled
        public List<String> errorsList {get; set;} 
        @AuraEnabled
        public map<String, List<String>> errormap {get; set;}
        @AuraEnabled
        public String ersStatus {get; set;}
        
    }
    
}