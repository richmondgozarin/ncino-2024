/**************************************************************************************************
 * DEPRECATED
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1: Base wrapper to be extended for Lightning Web Components
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
global without sharing virtual class cm_BaseWrapper { 
    
    @AuraEnabled
    public Parameter parameter {get; set;}
    @AuraEnabled
    public Result result {get; set;}
    
    
    /**********************************************************************************************
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1: Constructor to create inner classes
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public cm_BaseWrapper() {
        this.parameter = new Parameter();
        this.result = new Result();
        
    }
    
    /**********************************************************************************************
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1: This is to be used for passing parameters from Lightning Web Components to the AEPX
*               controller
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    global without sharing virtual class Parameter {
        @AuraEnabled
        public String recordId {get; set;}
    }
    
    /**********************************************************************************************
* @Author:      Kuldeep Parihar 
* @Date:        14/02/2023
* @Description: FR1: This is to be used to store the results of an action
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    global without sharing virtual class Result {
        @AuraEnabled
        public Boolean hasError {get; set;} //there has been exception, show message
        @AuraEnabled
        public Boolean hasWarning {get; set;} //confirmation required, show message
        @AuraEnabled
        public Boolean hasInfo {get; set;} //success, show message
        @AuraEnabled
        public String message {get; set;} //the user facing message
        @AuraEnabled
        public String code {get; set;} //error code to aid debugging of issues
        @AuraEnabled
        public String recordId {get; set;} //record id effected by an action
        @AuraEnabled
        public List<Exception> exceptionList {get; set;} 
        /******************************************************************************************
* @Author:      Kuldeep Parihar 
* @Date:       14/02/2023
* @Description: FR1: set boolean flags on construction
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]  //
*******************************************************************************************/
        public Result() {
            this.hasError = false;
            this.hasWarning = false;
            this.hasInfo = false;
            this.exceptionList = new  List<Exception>();
        }
    }
    
    
}