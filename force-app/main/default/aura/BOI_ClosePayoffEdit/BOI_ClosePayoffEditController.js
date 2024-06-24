({
    handleClick : function(component, event, helper) {        
        // Redirect to the loan record page
        
        var navService = component.find("navService");
        var recordId = component.get("v.loanRecord").cm_Payoff_Loan__c;
        var sObjectName = component.get("v.sObjectName");
        var pageReference = {
            "type": 'standard__recordPage',         
            "attributes": {              
                "recordId": recordId,
                "actionName": "view",               
                "objectApiName": sObjectName             
            }        
        };
        
        component.set("v.pageReference", pageReference);
        
        var pageReference = component.get("v.pageReference");
        navService.navigate(pageReference);
        
    },
})