/*-----------------------------------------------------------------------------
DESCRIPTION	:	Returns the ERS Response
AUTHOR		:	Kuldeep
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
17-08-2023		Kuldeep Parihar	Initial version
29-08-2023		Cabantog Jan Reimil Code updates to capture the fields with reserved keywords on response body
07-11-2023		Cabantog Jan Reimil/Ramirez Jasper Code updates for Sonar fixes
-----------------------------------------------------------------------------*/
public class CM_ERS_API_Callout extends SEL_IntegrationsOutboundMessageBase {
    
    @TestVisible  static String CON_MDT_NAME = 'ERS_Risk_API';
    @TestVisible private final static String CON_MDT_API_NAME = 'BOI_JWT';
    
    public CM_ERS_API_Callout(String integrationDeveloperName) {
        super(integrationDeveloperName);
    }
    
    @InvocableMethod(label='ERS API Callout' description='ERS API Callout') 
    public static List<ERS_Res> performERSCall(List <ERS_Req> reqList){
        
        CM_ERS_API_Callout api = new CM_ERS_API_Callout(CON_MDT_NAME);
        ERS_Res response = new ERS_Res();
        
        //Get transformation setting for Reason Code Narrative Transformation
        Map<String,List<Map<String,CM_TransformationSetting_CMD__mdt>>> transformationMap = cm_Utilities.getAllTransformationSetting();
        List<Map<String,CM_TransformationSetting_CMD__mdt>> ocNarList = transformationMap.get(CM_Constant.REASON_CODE_NARRATIVE);
        
        for(ERS_Req req : reqList){
            try{   
                Map<String,String> overrideMap = new Map<String,String>();
                overrideMap.put('Authorization',req.Authorization);
                overrideMap.put('x-api-transaction-id',req.xapiTransactionid);
                
                overrideMap.put('application-number', req.applicationNumber);
                overrideMap.put('product-type',req.productType);
                String reqBody = req.payload.substring( 1, req.payload.length() - 1 );
                
                cm_ERS_RequestWrapper wrap = (cm_ERS_RequestWrapper) System.JSON.deserialize(reqBody, cm_ERS_RequestWrapper.class);
                // These attributes will be always Null financials employment general segmentation contact identifier
                reqBody = System.JSON.serialize(wrap);
                
                String patN = ':null'; 
                reqBody = reqBody.replaceAll(patN, ':{}');
                
                //DOB of Primary/additional applicant may be Null 
                String patDOB = '"dateOfBirth":\\{}';
                reqBody = reqBody.replaceAll(patDOB, '');
                
                String patMOH = ',}';        //{"mannerOfHabitation":"",}
                reqBody = reqBody.replaceAll(patMOH, '}');
                String patDC = ',,';        // ,,patDC
                reqBody = reqBody.replaceAll(patDC, ',');
                //Generate the JWS
                BOI_JWT_OAuth__mdt mdt =  BOI_JWT_OAuth__mdt.getInstance(Con_MDT_API_NAME);
                String jws = CM_JwtAuthProvidor.createToken(mdt, reqBody);
                List<String> parts = jws.split('\\.');
                jws = parts[0]+'..'+parts[2];
                overrideMap.put('x-jws-signature',jws);
                
                HttpRequest request =  api.getHttpRequest(reqBody, overrideMap); //Overloaded method
                HttpResponse res = api.send(request);
                
                response = ERSStatusResponse(res,req.recordId,ocNarList);
                
            }
            catch(Exception ex){
                cm_ExceptionLog.log(CM_ERS_API_Callout.class.getName(), 'performERSCall', ex, req.recordId);
                response.isException = true;
                response.message = Label.cm_ErrorStatusCodeResponseBody ;
            }
        }
        
        List<ERS_Res> resList =  new List<ERS_Res>();
        resList.add(response);
        
        return resList;
    }
    
    public class ERS_Req{
        @InvocableVariable
        public String applicationNumber;
        @InvocableVariable
        public String Authorization;
        @InvocableVariable
        public String productType;
        @InvocableVariable
        public String xapiTransactionid;
        @InvocableVariable
        public String payload;
        @InvocableVariable
        public String recordId;  
    }
    
    public class ERS_Res{
        @InvocableVariable
        public Integer responseCode;
        @InvocableVariable
        public boolean isSuccess = false;
        @InvocableVariable
        public boolean isFail= false;
        @InvocableVariable
        public boolean isException= false;
        @InvocableVariable
        public cm_ERS__c ersPass;
        @InvocableVariable
        public String decisionOutcome;
        @InvocableVariable
        public String errorCode;
        @InvocableVariable
        public String message;
    }
    
    public class ERSExp {
        @AuraEnabled public String api;
        @AuraEnabled public String uri;
        @AuraEnabled public String timestamp;
        @AuraEnabled public String code;
        @AuraEnabled public String type;
        @AuraEnabled public String summary;
        @AuraEnabled public AdditionalInformation additionalInformation;
    }
    public class AdditionalInformation {
        @AuraEnabled public String type;
        @AuraEnabled public String details;
    }
    
    public static cm_ERS__c parseERSResponse(String resBody, String recId){
        
        // Replace reserve keywords
        String responseBody = cm_Utilities.replaceReservedKeywords(resBody);
        cm_ERS_ResponseWrapper decisionResp =  (cm_ERS_ResponseWrapper) JSON.deserialize(responseBody, cm_ERS_ResponseWrapper.class);
        cm_ERS_ResponseWrapper.decisionResult dr = decisionResp?.decisionResult;
        cm_ERS_ResponseWrapper.accountOrigination  ao = dr?.accountOrigination;//Used safe navigator operator to avoid null pointer exception
        cm_ERS_ResponseWrapper.Assessment assess = ao?.assessment;
        cm_ERS_ResponseWrapper.Credit credit = ao?.credit;
        cm_ERS_ResponseWrapper.Identifier identifier = ao?.identifier;
        cm_ERS_ResponseWrapper.Risk_Z riskz = ao?.risk;
        cm_ERS_ResponseWrapper.PrimaryApplicant primaryApplicant = ao?.primaryApplicant;
        cm_ERS_ResponseWrapper.CustomerDetails customerDetails = primaryApplicant?.customerDetails;
        cm_ERS_ResponseWrapper.General_X generalx = customerDetails?.general;
        cm_ERS_ResponseWrapper.Risk_X riskx = customerDetails?.risk;      
        cm_ERS_ResponseWrapper.PersonDetails personDetails = primaryApplicant?.personDetails;
        cm_ERS_ResponseWrapper.Financials financials = personDetails?.financials;
        cm_ERS_ResponseWrapper.ApplicantAccountDetails applicantAccountDetails = primaryApplicant?.applicantAccountDetails;
        cm_ERS_ResponseWrapper.Account account = applicantAccountDetails?.account;
        cm_ERS_ResponseWrapper.Behaviour behaviour = account?.behaviour;
        cm_ERS_ResponseWrapper.Limit_X x_limit = account?.x_limit;
        cm_ERS_ResponseWrapper.MonetaryAmount monetaryAmount = account?.monetaryAmount;
        cm_ERS_ResponseWrapper.Risk_Y risky = account?.risk;
        cm_ERS_ResponseWrapper.Servicing servicing = account?.servicing;
        cm_ERS_ResponseWrapper.CurrentAccount currentAccount = applicantAccountDetails?.currentAccount;
        cm_ERS_ResponseWrapper.General_Y generaly = currentAccount?.general;
        cm_ERS_ResponseWrapper.Limit_Y y_limit = currentAccount?.x_limit;
        
        //Create ERS record/obj with values from Response
        cm_ERS__c ERS = new cm_ERS__c();
        ERS.cm_PreApprovalBlockedIndicator__c = credit?.preApprovalBlockedIndicator;//ERS 100
        ERS.cm_NoOfDaysInDebitInLast6Months__c = behaviour?.noOfDaysInDebitInLast6Months; //ERS 101
        ERS.cm_TimeSinceLimitChange__c = x_limit?.timeSinceLimitChange; //limit not yet created //ERS 102
        ERS.cm_NetDisposableIncome_PF__c = financials?.netDisposableIncome; //ERS 104
        ERS.cm_NetDisposableICasPrcntgeOfMonthlyIC__c = assess?.netDisposableIncomeasPercentageOfMonthlyIncome;//ERS 105
        ERS.cm_NetDisposableIncome_AO__c = assess?.netDisposableIncome; //ERS 106
        ERS.cm_ApplicationExposureAtDefaultAmount__c = riskz?.applicationExposureAtDefaultAmount; //ERS 107
        ERS.cm_ExposureAtDefaultFactor__c = risky?.exposureAtDefaultFactor; //ERS 108
        ERS.cm_ApplicationExpectedLossAmount__c = riskz?.applicationExpectedLossAmount; //ERS 109
        ERS.cm_LossGivenDefaultFactor__c = risky?.lossGivenDefaultFactor; //ERS 110
        ERS.cm_ApplicationLossGivenDefault__c = riskz?.applicationLossGivenDefault; //ERS 111
        ERS.cm_PointInTimeProbabilityOfDefaultPool__c = risky?.pointInTimeProbabilityOfDefaultPool; //ERS 112
        ERS.cm_PointInTimeProbabilityOfDefaultScore__c = risky?.pointInTimeProbabilityOfDefaultScore; //ERS 113
        ERS.cm_PointInTimePDScorecardID__c = risky?.pointInTimeProbabilityOfDefaultScorecardID; //ERS 114
        ERS.cm_PtInTimeProbabilityOfDefaultSubPool__c = risky?.pointInTimeProbabilityOfDefaultSubPool; //ERS 125
        ERS.cm_ProbabilityOfDefault__c = risky?.probabilityOfDefault; //ERS 126
        ERS.cm_CreditCorrelationPDEAD__c = riskz?.creditCorrelationPDEAD; //ERS 127
        ERS.cm_CapitalRequirementK__c = risky?.capitalRequirementK; //ERS 128
        ERS.cm_ModellingStrategy__c = riskz?.modellingStrategy; //ERS 129
        ERS.cm_RiskWeightedAsset__c = risky?.riskWeightedAsset; //ERS 130
        ERS.cm_FinalDecisionCode__c = assess?.finalDecisionCode; //ERS 131
        ERS.cm_DecisionOutcomeTable__c = assess?.decisionOutcomeTable; //ERS 132
        ERS.cm_DecisionOutcome__c = assess?.decisionOutcome; //ERS 133
        ERS.cm_ReasonCode__c = assess?.reasonCode; //ERS 134
        ERS.cm_ChequeBookIndicator__c = generaly?.chequeBookIndicator; //ERS 135  
        ERS.cm_ChequeCardIndicator__c = generaly?.chequecCardIndicator; //ERS 136
        ERS.cm_PassCardIndicator__c = generaly?.passCardIndicator; //ERS 137
        ERS.cm_DebitCardIndicator__c = generaly?.debitCardIndicator; //ERS 138
        ERS.cm_CreditRating7InternalAndControlCode__c = riskx?.creditRating7InternalAndControlCode; //ERS 139
        ERS.cm_BoiFinanceCustomerIndicator__c = generalx?.boiFinanceCustomerIndicator; //ERS 140
        ERS.cm_PPIIndicator__c = servicing?.ppiIndicator; //ERS 141
        ERS.cm_RecommendedMaximumLoanAmount__c = assess?.recommendedMaximumLoanAmount; //ERS 142
        ERS.cm_RecommendedOverdraftAbsoluteValue__c = assess?.recommendedOverdraftAbsoluteValue; //ERS 143
        ERS.cm_OverdraftCalculationType__c = assess?.overdraftCalculationType; //ERS 144
        ERS.cm_OverdraftAsIncomePercentage__c = assess?.overdraftAsIncomePercentage; //ERS 145
        ERS.cm_RecommendedOverdraftMaximumValue__c = assess?.recommendedOverdraftMaximumValue; //ERS 146
        ERS.cm_DecisionRulesID__c = assess?.decisionRulesID; //ERS 147
        ERS.cm_LowestCreditLimitUsed__c = y_limit?.lowestCreditLimitUsed; //ERS 148
        ERS.cm_CreditLimitUsedPercentage__c = y_limit?.creditLimitUsedPercentage; //ERS 149 
        ERS.cm_RoundedOverdraftAmountInHomeCurrency__c = assess?.roundedOverdraftAmountInHomeCurrency; //ERS 150
        ERS.cm_CreditRiskScore__c = riskz?.creditRiskScore; //ERS 151
        ERS.cm_ScorecardIdentifier__c = identifier?.scorecardIdentifier; //ERS 152
        ERS.cm_BaselRiskScore__c = riskz?.baselRiskScore; //ERS 153
        ERS.cm_CreditRating7Internal__c = risky?.creditRating7Internal; //ERS 155
        ERS.cm_TotalGroupExposureAmount__c = riskx?.totalGroupExposureAmount; //ERS 92
        ERS.cm_OverdraftRepaymentAmount__c = assess?.overdraftRepaymentAmount; //ERS 158
        ERS.cm_CustomerOverdraftLimit__c = assess?.customerOverdraftLimit; //ERS 159
        ERS.cm_BureauRatingIndicator__c = assess?.bureauRatingIndicator; //ERS 80
        ERS.cm_GradeControlCode__c = riskx?.gradeControlCode; //ERS 81
        ERS.cm_RollingAverageCreditTurnover12M__c = behaviour?.x_12MRollingAverageCreditTurnover; //ERS 83
        ERS.cm_RollingAverageCreditTurnover3M__c = behaviour?.x_3MRollingAverageCreditTurnover; //ERS 84
        ERS.cm_RollingAverageCreditTurnover6M__c = behaviour?.x_6MRollingAverageCreditTurnover; //ERS 85
        ERS.cm_AverageLedgerBalanceProbeMTD__c = behaviour?.averageLedgerBalanceProbeMTD; //ERS 86
        ERS.cm_ClearedBalance__c = monetaryAmount?.clearedBalance; //ERS 87
        ERS.cm_TotalCreditTurnoverCurrentMonth__c = monetaryAmount?.totalCreditTurnoverCurrentMonth; //ERS 88
        ERS.cm_MinimumBalanceOverLast3Months__c = behaviour?.minimumBalanceOverLast3Months; //ERS 89
        ERS.cm_MinimumBalanceOverLast6Months__c = behaviour?.minimumBalanceOverLast6Months; //ERS 90
        ERS.cm_IrregularNumberOfDaysInLast12months__c = behaviour?.irregularNumberOfDaysInLast12months; //ERS 95
        ERS.cm_IrregularNumberOfDaysInLast6months__c = behaviour?.irregularNumberOfDaysInLast6months; //ERS 96
        ERS.cm_NumDaysPaymentPostponedInLast6Mos__c = behaviour?.numberOfDaysPaymentPostponedInLast6months; //ERS 97
        ERS.cm_NumReversalsUnpaidsPaymntsInLast12Mos__c = behaviour?.numberOfReversalsUnpaidsPaymentsInLast12months; //ERS 98
        ERS.cm_NumReversalsUnpaidsPaymentsInLast6Mos__c = behaviour?.numberOfReversalsUnpaidsPaymentsInLast6months; //ERS 99
        ERS.cm_DateTime__c = System.now();
        //Relate ERS to Loan
        ERS.cm_Loan__c = Id.valueOf(recId);
        return ERS;
    }
    
    public static ERS_Res ersStatusResponse(HttpResponse res,string recId,List<Map<String,CM_TransformationSetting_CMD__mdt>> ocNarList){
        ERS_Res response = new ERS_Res();
        
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {   
            response.responseCode = res.getStatusCode();
            response.isSuccess = true;
            response.ersPass = parseERSResponse(res.getBody(), recId);
            response.decisionOutcome = response?.ersPass?.cm_DecisionOutcome__c;
            //Set Narrative Field
            setNarrative(ocNarList,response); 
        }
        else{
            response.responseCode = res.getStatusCode();
            response.isFail = true;
            ERSExp exc = (ERSExp) System.JSON.deserialize(res.getBody(), ERSExp.class);
            response.errorCode = exc.code;
            response.message =  exc?.additionalInformation?.details;
            cm_ExceptionLog.log(CM_ERS_API_Callout.class.getName(), 'performERSCall', response.errorCode, response.message, recId);
        }
        
        return response;
    }
    
    public static ERS_Res setNarrative(List<Map<String,CM_TransformationSetting_CMD__mdt>> ocNarList,ERS_Res response){
        for(Map<String,CM_TransformationSetting_CMD__mdt> ocn: ocNarList){  
            if(ocn.get(response.ersPass.cm_DecisionRulesID__c) != null){
                response.ersPass.cm_ReasonCodeNarrative__c = ocn.get(response.ersPass.cm_DecisionRulesID__c).CM_TargetValue__c != null ? String.valueOf(ocn.get(response.ersPass.cm_DecisionRulesID__c).CM_TargetValue__c) : '';
            }               
        }
        return response;
    }
    
}