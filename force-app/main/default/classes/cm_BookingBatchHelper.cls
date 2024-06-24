/**************************************************************************************************
* @Author:    Mark John Amadeo
* @Date:      11/07/2023
* @Description: This class will contain all utility functions related to BKK.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class cm_BookingBatchHelper {
    
    public static void updateLoanFields(List<LLC_BI__Loan__c> loans) {
        List<LLC_BI__Loan__c> toUpdateList = new List<LLC_BI__Loan__c>();
        
        for (LLC_BI__Loan__c loan : loans) {
            
            LLC_BI__Loan__c loanContainer = new LLC_BI__Loan__c();
            system.debug(getFirstPaymentDate(loan.cm_StandingOrderSpan__c));
            loanContainer.Id = loan.Id;
            loanContainer.cm_BKK_Status__c = cm_Constant.BKK_STATUS_IN_PROGRESS;
            loanContainer.cm_Sent_to_BKK__c = cm_Constant.DATE_TIME_TDY;
            loanContainer.cm_ActualFirstPaymentDate__c = getFirstPaymentDate(loan.cm_StandingOrderSpan__c);  
            
			toUpdateList.add(loanContainer);
        }
        Database.SaveResult[] updateResults = Database.update(toUpdateList, false);
    }
	
    public static Date getFirstPaymentDate(String soSpanValue){
        Date firstPayDate;
        if(soSpanValue != null || soSpanValue != ''){
            cm_Utilities.addBussinessDays(cm_Constant.DATE_TODAY , Integer.valueOf(soSpanValue));
        }
        return firstPayDate;
    }
    
    public static String setColumnHeader(List<cm_BKK_Loan_Mapping__mdt> fieldList, String bkkTargetFile) {
        String columnHeader = cm_Constant.EMPTY_STRING;
        for(cm_BKK_Loan_Mapping__mdt metadata : fieldList) {
            
            Boolean isTarget = metadata.cm_Target_Csv_File__c.replace('_', ' ').contains(bkkTargetFile);
            
            if (isTarget) {
                String objectName = metadata.cm_Target_Column__c;
                columnHeader += cm_Constant.EMPTY_STRING + String.escapeSingleQuotes(objectName) + cm_Constant.EMPTY_STRING + cm_Constant.DELIMITER; 
            }
        }
        columnHeader = columnHeader.removeEnd(cm_Constant.DELIMITER);
        return columnHeader;
    }
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      13/07/2023
* @Description: Method used to consolidate all records populated in csv.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String getAllRecordsByLoanRecordType(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue, 
                                                       Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings, 
                                                       String csvLine, String recordTypeParam, List<String> bkkTargetFiles) {
                                                           
                                                           if (loan.LLC_BI__Product_Type__c == recordTypeParam) {
                                                               String mdtDefaultValue = String.isNotBlank(metadata.cm_Default_Value__c) ? metadata.cm_Default_Value__c : cm_Constant.EMPTY_STRING;
                                                               
                                                               if(String.isNotBlank(metadata.cm_Date_Type__c)) {
                                                                   csvLine += setDateType(metadata, fieldValue);
                                                               }
                                                               
                                                               if(String.isNotBlank(metadata.cm_Source_Field__c)) {
                                                                   String loanFieldValueResult = setBookingFields(loan, metadata, bkkSettings, fieldValue, bkkTargetFiles);
                                                                   fieldValue = validateFieldValue(loanFieldValueResult, mdtDefaultValue, loanFieldValueResult, fieldValue);
                                                                   
                                                                   csvLine += writeCSVLine(metadata, fieldValue);
                                                               } 
                                                               else if(String.isNotBlank(metadata.cm_Parent_Object__c) && String.isNotBlank(metadata.cm_Parent_Field__c)) {
                                                                   fieldValue = parentValues(isMultiLevelParent(metadata), fieldValue, mdtDefaultValue, loan, metadata, bkkSettings);
                                                                   csvLine += writeCSVLine(metadata, fieldValue);
                                                               }
                                                               else if (String.isNotBlank(metadata.cm_Child_Field__c) && String.isNotBlank(metadata.cm_Child_Object__c)) {
                                                                   String childFieldValueResult = findChildRecords(loan, metadata);
                                                                   fieldValue = validateFieldValue(childFieldValueResult, mdtDefaultValue, childFieldValueResult, fieldValue);
                                                                   
                                                                   csvLine += writeCSVLine(metadata, fieldValue);
                                                               }
                                                               else if (String.isBlank(metadata.cm_Source_Field__c) && String.isBlank(metadata.cm_Parent_Field__c) && 
                                                                        String.isBlank(metadata.cm_Child_Field__c) && String.isBlank(metadata.cm_Date_Type__c)) {
                                                                            csvLine += writeCSVLine(metadata, mdtDefaultValue);
                                                                        }
                                                           }
                                                           return csvLine;
                                                       }
    
    public static String validateFieldValue(String fieldValueParam, String defaultValue, String expectedValue, String fieldValue) {
        fieldValue = String.isBlank(fieldValueParam) ? defaultValue : expectedValue;
        return fieldValue;
    }
    
    public static boolean isMultiLevelParent(cm_BKK_Loan_Mapping__mdt metadata) {
        boolean isMultiLevel = false;
        if (metadata.cm_Parent_Object__c.contains('.')) {
            isMultiLevel = true;
        }
        return isMultiLevel; 
    }
    
    public static String parentValues(boolean isMultiLevelParent, String fieldValue, String mdtDefaultValue, 
                                      LLC_BI__Loan__c loan,cm_BKK_Loan_Mapping__mdt metadata, 
                                      Map<String, List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                          if (isMultiLevelParent) {
                                              String parentMultiLvlFieldValueResult = findParentMultiLvlRecords(loan, metadata, fieldValue, bkkSettings);
                                              fieldValue = validateFieldValue(parentMultiLvlFieldValueResult, mdtDefaultValue, parentMultiLvlFieldValueResult, fieldValue);
                                          }
                                          else {
                                              fieldValue = findParentRecords(loan, metadata, fieldValue, bkkSettings);
                                          }
                                          return fieldValue;
                                      }
    
    /**************************************************************************************************
* @Author:    Rich Gozarin
* @Date:      13/07/2023
* @Description: This Method is used to write csv lines, padding, drop double quotes
* @Revision(s): 14/06/2024 - Incident: INC0686138 - Winlyn Luena - Filename is being checked to append appropriate linebreaks
***************************************************************************************************/
    public static String writeCSVLine(cm_BKK_Loan_Mapping__mdt metadata, String fieldValue) {
        fieldValue = applyPadding(metadata, fieldValue);
        String quoteDelimiter = dropDoubleQuotes(fieldValue, true);
        return quoteDelimiter + fieldValue + quoteDelimiter + cm_Constant.DELIMITER;
    }
    public static void createAttachment(String filename, List<string> csvFileBody, cm_LoanBooking__c loanRecord) {
        
        Attachment afile = new Attachment();
        afile.Name = filename;
        //Added for Incident#INC0686138
        List<String> csvFileNames = Label.BKK_File_Names.split(',');
        if(csvFileNames.contains(filename.removeEnd(filename.right(15)))){
            afile.Body = Blob.valueOf(String.join(csvFileBody, '\r\n'));
        }
        else{
            afile.Body = Blob.valueOf(String.join(csvFileBody, '\n'));   
        }
        afile.ParentId = loanRecord.Id;
        afile.ContentType = cm_Constant.CONTENT_TYPE;
        insert afile;
    }
    
    /**************************************************************************************************
* @Author:    Rich Gozarin
* @Date:      13/07/2023
* @Description: Set all fields defined in Booking Metadata
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String setBookingFields(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata,
                                           Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings,
                                           String fieldValue, List<String> bkkTargetFiles) {
                                               try {
                                                   
                                                   Object sourceRecord = loan.get(metadata.cm_Source_Field__c);
                                                   fieldValue = valueNotNullValidation(sourceRecord, String.valueOf(sourceRecord), cm_Constant.EMPTY_STRING, fieldValue);
                                                   fieldValue = setSourceRecordDateValue(loan, metadata, fieldValue);
                                                   fieldValue = setMonthsValue(fieldValue);
                                                   fieldValue = setParentFieldValue(loan, fieldValue, metadata, bkkTargetFiles);
                                                   fieldValue = setMarketClassValue(fieldValue, metadata);
                                                   fieldValue = setFarmLoanValue(fieldValue, metadata);
                                                   fieldValue = setDebitRateCodeValue(fieldValue, metadata);
                                                   fieldValue = setDebitRateInterestValue(fieldValue, metadata, loan);
                                                   fieldValue = setPrivateBankingIndicatorValue(fieldValue, metadata);            
                                                   fieldValue = setSOCategory(loan, metadata, fieldValue);
                                                   fieldValue = setTwoDecimalAmountValue(loan, metadata, fieldValue, cm_Constant.SO_START_AMOUNT);
                                                   fieldValue = checkPayOff(loan, metadata, fieldValue, cm_Constant.DRAWDOWN_AMOUNT);
                                                   fieldValue = checkPayOff(loan, metadata, fieldValue, cm_Constant.DD_NSC);
                                                   fieldValue = checkPayOff(loan, metadata, fieldValue, cm_Constant.DD_ACCOUNT);
                                                   fieldValue = setFrequencySpan(sourceRecord, metadata, fieldValue);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.RETRY_INDICATOR);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.SO_Retry_Indicator);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.Account_Re_Opening_Indicator);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.Payments_Retry_Indicator);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.Permission_Amend_Retry_Indicator);
                                                   fieldValue = setIndicatorFieldValue(sourceRecord, metadata, fieldValue, cm_Constant.Overdraft_Retry_Indicator);
                                                   fieldValue = setStringChars(sourceRecord, metadata, fieldValue, cm_Constant.BENF_NAME).toUppercase();
                                                   fieldValue = setStringChars(sourceRecord, metadata, fieldValue, cm_Constant.PAYER_NAME).toUppercase();
                                                   fieldValue = setTargetFile(loan, bkkTargetFiles, fieldValue);
                                                   fieldValue = transformationSourceField(metadata, bkkSettings, fieldValue);
                                                   
                                                   return fieldValue;
                                               } catch(Exception e) {
                                                   cm_ExceptionLog.log(metadata.cm_Source_Field__c, 'setBookingFields', e, loan.Id);
                                                   return cm_Constant.EMPTY_STRING;
                                               }
                                           }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      18/01/2024
* @Description: Method used for limiting the character count
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String setStringChars(Object sourceRecord, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue, String fieldName) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == fieldName && sourceRecord != null) {
            string string_value = string.valueOf(sourceRecord);
            integer charCount = (Integer)metadata.cm_Padding_Count__c;
            fieldValue = string_value.left(charCount);
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    Ally Balita
* @Date:      31/01/2024
* @Description: Method used for checking the pay off loan
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String checkPayOff(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue, String fieldName){
        if(loan != null && loan.get(metadata.cm_Source_Field__c) != null){
            if (string.isNotBlank(fieldValue) && loan.cm_Doyouwanttopayoffexistingdebt__c == cm_Constant.PAYOFF_NO && 
                (metadata.DeveloperName == cm_Constant.DD_ACCOUNT || metadata.DeveloperName == cm_Constant.DD_NSC)) {
                    fieldValue = String.valueOf(loan.get(metadata.cm_Source_Field__c)); 
                }
            else if (string.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.DRAWDOWN_AMOUNT && loan.cm_Doyouwanttopayoffexistingdebt__c == cm_Constant.PAYOFF_NO) {
                decimal amountDecimal = (Decimal)loan.get(metadata.cm_Source_Field__c);
                fieldValue = String.valueOf(math.abs(amountDecimal.setScale(2))); 
            }
            else if(string.isNotBlank(fieldValue) && metadata.DeveloperName == fieldName && loan.cm_Doyouwanttopayoffexistingdebt__c == cm_Constant.PAYOFF_YES){
                fieldValue = metadata.cm_Default_Value__c;
            }
        }  
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      06/12/2023
* @Description: Method used for setting the value of Indicators Fields in loan
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String setIndicatorFieldValue(Object sourceRecord, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue, String fieldName) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == fieldName && sourceRecord != null) {
            fieldValue = boolean.valueOf(sourceRecord) ?  cm_Constant.Y_VALUE : cm_Constant.N_VALUE;
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      06/12/2023
* @Description: Method used for setting the value of frequency span field
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String setFrequencySpan(Object sourceRecord, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.SO_FREQ_SPAN && sourceRecord != null) {
            integer freqSpan = integer.valueOf(sourceRecord);
            fieldValue = freqSpan >= 1 && freqSpan <= 12 ? string.valueOf(freqSpan) : cm_Constant.NUM_ZERO;
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      06/12/2023
* @Description: Method used to set the scale of amount value
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String setTwoDecimalAmountValue(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue, String fieldName) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == fieldName && loan != null && loan.get(metadata.cm_Source_Field__c) != null) {
            decimal amountDecimal = (Decimal)loan.get(metadata.cm_Source_Field__c);
            fieldValue = string.valueOf(math.abs(amountDecimal.setScale(2)));
            if (amountDecimal > 0) {
                string finalAmountValue  = string.valueOf(amountDecimal.setScale(2));
                fieldValue = finalAmountValue;
            }
            
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      06/12/2023
* @Description: Method used to set the SOCategory
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String setSOCategory(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.SO_CATEGORY) {
            if (loan.get(metadata.cm_Source_Field__c) == cm_Constant.THIRTEEN) {
                fieldValue = cm_Constant.N_VALUE;
            }
            else if (loan.get(metadata.cm_Source_Field__c) == cm_Constant.TWENTY_THREE) {
                fieldValue = cm_Constant.Y_VALUE;
            }
        }
        return fieldValue;
    }
    
    public static String valueNotNullValidation(Object fieldValueParam, String ifValue, String elseValue, String fieldValue) {
        fieldValue =  fieldValueParam != null ? ifValue : elseValue;
        return fieldValue;
    }
    
    private static String setParentFieldValue(LLC_BI__Loan__c loan,String fieldValue, cm_BKK_Loan_Mapping__mdt metadata, List<String> bkkTargetFiles) {
        if(String.isNotBlank(metadata.cm_Parent_Object__c) && String.isNotBlank(metadata.cm_Parent_Field__c) && loan.LLC_BI__Product_Type__c == bkkTargetFiles[0]) {
            fieldValue = setParentValue(loan, fieldValue, metadata);
        }
        return fieldValue;
    }
    
    private static String setParentValue(LLC_BI__Loan__c loan,String fieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (loan.getSObject(metadata.cm_Parent_Object__c) != null && loan.getSObject(metadata.cm_Parent_Object__c).get(metadata.cm_Parent_Field__c) != null) {
            fieldValue = (string) loan.getSObject(metadata.cm_Parent_Object__c).get(metadata.cm_Parent_Field__c);
        }
        return fieldValue;
    }
    
    private static String setTargetFile(LLC_BI__Loan__c loan, List<String> bkkTargetFiles, String fieldValue) {
        if (loan.LLC_BI__Product_Type__c == bkkTargetFiles[1]) {
            fieldValue = fieldValue.substringBefore('_');
        }
        return fieldValue;
    }
    
    private static String setPrivateBankingIndicatorValue(String fieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (string.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.PRIV_BNKNG_INDCTR) {
            if (fieldValue == cm_Constant.PRIV_BNKNG_INDCTR_VALUE) {
                fieldValue = cm_Constant.NUM_ONE;
            }
            else {
                fieldValue = cm_Constant.EMPTY_STRING;
            }
        }
        return fieldValue;
    }
    
    private static String setDebitRateInterestValue(String fieldValue, cm_BKK_Loan_Mapping__mdt metadata, LLC_BI__Loan__c loan) {
        if (String.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.DEBIT_INTEREST_RATE && loan.get(metadata.cm_Source_Field__c) != null) {
            decimal rate_value = (Decimal)loan.get(metadata.cm_Source_Field__c);
            string debit_rate_value = string.valueOf(rate_value.setScale(3));
            fieldValue = debit_rate_value;
        }
        else {
            fieldValue = removeDecimalNumbers(fieldValue); 
        }
        return fieldValue;
    }
    
    private static String setDebitRateCodeValue(String fieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (String.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.DEBIT_RATE_CODE) {
            fieldValue = fieldValue.replace('-', '').left(2);
        }
        return fieldValue;
    }
    
    private static String setFarmLoanValue(String fieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (String.isNotBlank(fieldValue) && metadata.DeveloperName == cm_Constant.FARM_LOAN) {
            if (CM_Constant.AGRI_INDICATOR.contains(fieldValue)) {
                fieldValue = cm_Constant.NUM_ONE;
            }
            else{
                fieldValue = cm_Constant.NUM_ZERO;
            }
        }
        return fieldValue;
    }
    
    private static String setMarketClassValue(String fieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (metadata.DeveloperName == cm_Constant.MARKET_CLASS) {
            fieldValue = String.isNotBlank(fieldValue) ? fieldValue : null;
        }
        return fieldValue;
    }
    
    private static String setMonthsValue(String fieldValue) {
        if (fieldValue.contains('months')) {
            fieldValue = fieldValue.substringBefore(' ');
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      06/12/2023
* @Description: Method used for setting the SO Startdate value
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String setSourceRecordDateValue(LLC_BI__Loan__c loan, cm_BKK_Loan_Mapping__mdt metadata, String fieldValue) {
        Date firstPayDate;
        //Date firstPayDate = ;
        if(metadata.DeveloperName == cm_Constant.SO_START_DATE && loan.cm_StandingOrderSpan__c != cm_Constant.EMPTY_STRING){
            firstPayDate = cm_Utilities.addBussinessDays(cm_Constant.DATE_TODAY , Integer.valueOf(loan.cm_StandingOrderSpan__c));
        }
		fieldValue = cm_Utilities.formatDate(firstPayDate);   
        return fieldValue;
    }
    
    private static String transformationSourceField(cm_BKK_Loan_Mapping__mdt metadata,
                                                    Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings,
                                                    String fieldValue) {
                                                        
                                                        // Dynamic Transformation
                                                        for (String sourceAPIKey : bkkSettings.keySet()) {
                                                            if (sourceAPIKey == metadata.cm_Source_Field__c && metadata.DeveloperName != cm_Constant.BOI_NSC) {
                                                                fieldValue = mdtTransformation(fieldValue, sourceAPIKey, bkkSettings);
                                                            }
                                                        }
                                                        return fieldValue;
                                                    }
    
    private static String findChildRecords(LLC_BI__Loan__c loan, 
                                           cm_BKK_Loan_Mapping__mdt metadata) {
                                               String childObject = metadata.cm_Child_Object__c;
                                               String childField = metadata.cm_Child_Field__c;
                                               String childValue = cm_Constant.EMPTY_STRING;
                                               String meta = metadata.DeveloperName;
                                               
                                               if (childField != null && childObject != null) {
                                                   
                                                   // Check if childField contains(.) then do the multilevel implementation, else do the original implementation
                                                   if (childField.contains('.')) {
                                                       childValue = generateLedgerLineItems(meta, loan, childObject, childField, childValue);
                                                   }
                                                   else {
                                                       // Original implementation of getting child records
                                                       childValue = setLoanChildRecord(loan, childObject, childField, childValue);
                                                   }
                                               }
                                               return childValue;
                                           }
    
    /**
* setLoanChildRecord
* @return string
*/
    private static String setLoanChildRecord(LLC_BI__Loan__c loan, String childObject, String childField, String childValue) {
        List<sObject> childRecords = loan.getSObjects(childObject);
        
        if(childRecords != null && childRecords.size() > 0) {
            for (sObject records : childRecords) {
                childValue = setChildValue(records, childValue, childField);
            }
        }
        return childValue;
    }
    
    private static String setChildValue(sObject records, string childValue, String childField) {
        if(records.get(childField) != null) {
            Object childFieldValue = records.get(childField);
            if (childFieldValue instanceOf Date || childFieldValue instanceOf Datetime){
                childValue = cm_Utilities.formatDate(records.get(childField));
            }
            else {
                childValue = records.get(childField) != null ? string.valueOf(records.get(childField)) : cm_Constant.EMPTY_STRING;
            }
            
            if (records.get(cm_Constant.FIELD_NAME[5]) != null && childField == cm_Constant.FIELD_NAME[5]) {
                string debitRateCode = string.valueOf(records.get(cm_Constant.FIELD_NAME[5]));
                childValue = debitRateCode.substringAfter('_');
            }
        }
        return childValue;
    }
    
    /**
* Genereate Ledger Line Item
* @return String
*/
    private static String generateLedgerLineItems(String meta, LLC_BI__Loan__c loan, String childObject, String childField, String childValue) {
        String[] checkFieldName = meta.split('_');
        if (checkFieldName[0] == cm_Constant.LEDGER) {
            String regex = cm_Constant.string_to_number;
            String extractLabelIndexNumber = meta.replaceAll(regex, cm_Constant.EMPTY_STRING).replace('_', cm_Constant.EMPTY_STRING);
            Integer indexNumber = integer.valueOf(extractLabelIndexNumber);
            List<string> containerValuesList = new List<string>();
            
            if (loan.getSObject(cm_Constant.S_OBJECTS[0]) != null) {
                childValue = populateLedgerLineItems(loan, childField, indexNumber); 
            }
        }
        else {
            String[] childObjectList = childField.replace('.', ',').split(',');
            if (childObjectList.size() > 0) {
                for (SObject record: loan.getSObjects(childObject)) {
                    if (record.getSObject(childObjectList[0]) != null) {
                        childValue = (string) record.getSObject(childObjectList[0]).get(childObjectList[1]); 
                    }
                }
            }
        }
        return childValue;
    }
    
    private static String findParentRecords(LLC_BI__Loan__c loan, 
                                            cm_BKK_Loan_Mapping__mdt metadata, 
                                            String fieldValue, 
                                            Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                                
                                                String parentObject = metadata.cm_Parent_Object__c;
                                                String parentField = metadata.cm_Parent_Field__c;
                                                String developerName = metadata.DeveloperName;
                                                
                                                if(loan.getSObject(parentObject) != null && loan.getSObject(parentObject).get(parentField) != null){
                                                    Object parentFieldValue = loan.getSObject(parentObject).get(parentField);
                                                    
                                                    fieldValue = setParentSoleTrader(fieldValue, parentFieldValue, metadata);
                                                    
                                                    fieldValue = setParentFieldName(fieldValue, parentField, parentFieldValue, metadata);
                                                    
                                                    fieldValue = setCustomerType(fieldValue, parentFieldValue, developerName);
                                                    
                                                    fieldValue = getLendingOfficerCodeLocNumber(loan, fieldValue, developerName);
                                                    
                                                    fieldValue = dynamicParentFieldTransformation(parentField, fieldValue, bkkSettings);
                                                }
                                                
                                                return fieldValue;
                                            }
    
    private static String setParentSoleTrader(String fieldValue, Object parentFieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if(metadata.cm_Is_Sole_Trader__c && String.isNotBlank(metadata.cm_Default_Value__c)) {
            if (parentFieldValue == cm_Constant.SOLE_TRADER) {
                fieldValue = metadata.cm_Default_Value__c;
            } else {
                fieldValue = cm_Constant.EMPTY_STRING;
            }
        }
        else if (metadata.cm_Is_Sole_Trader__c == false && parentFieldValue == null && String.isNotBlank(metadata.cm_Default_Value__c)) {
            fieldValue = String.isNotBlank(metadata.cm_Default_Value__c) ? metadata.cm_Default_Value__c : cm_Constant.EMPTY_STRING;
        }
        else {
            fieldValue = String.valueOf(parentFieldValue);
        }
        return fieldValue;
    }
    
    private static String setParentFieldName(String fieldValue, String parentField, Object parentFieldValue, cm_BKK_Loan_Mapping__mdt metadata) {
        if (parentField == cm_Constant.FIELD_NAME[1]) {
            fieldValue = applyPadding(metadata, String.valueOf(parentFieldValue).replaceAll(cm_Constant.SPCL_CHAR, cm_Constant.EMPTY_STRING));
            fieldValue = fieldValue.left(21).toUppercase() + cm_Constant.SHRT_NAME_SFX;
        }
        return fieldValue;
    }
    
    private static String setCustomerType(String fieldValue, Object parentFieldValue, String developerName) {
        String accountSubType = cm_Constant.NUM_ELVN;
        if(developerName == cm_Constant.CUST_TYPE){
            String customerTypeValue = String.valueOf(parentFieldValue);  
            if(accountSubType == customerTypeValue){
                fieldValue = cm_Constant.ZERO_TWO;
            }
            else if(accountSubType != customerTypeValue){
                fieldValue = cm_Constant.DBL_ZERO;
            }
        }
        return fieldValue;
    }
    
    
    private static String dynamicParentFieldTransformation(String parentField, String fieldValue,
                                                           Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                                               for (String sourceAPIKey : bkkSettings.keySet()) {
                                                                   if (sourceAPIKey == parentField) {
                                                                       fieldValue = mdtTransformation(fieldValue, sourceAPIKey, bkkSettings);
                                                                   }
                                                               }
                                                               return fieldValue;
                                                           }
    
    private static String mdtTransformation(String fieldValue, String sourceAPIKey,
                                            Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                                for(Map<String,CM_TransformationSetting_CMD__mdt> config : bkkSettings.get(sourceAPIKey)) {
                                                    for (String sourceTextKey : config.keySet()) {
                                                        if (fieldValue == sourceTextKey && config.get(sourceTextKey) != null) {
                                                            fieldValue = config.get(sourceTextKey).CM_TargetValue__c;
                                                        }
                                                    }
                                                }
                                                return fieldValue;
                                            }
    
    private static String findParentMultiLvlRecords(LLC_BI__Loan__c loan,
                                                    cm_BKK_Loan_Mapping__mdt metadata,
                                                    String fieldValue,
                                                    Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                                        String parentObject = metadata.cm_Parent_Object__c;
                                                        String parentField = metadata.cm_Parent_Field__c;
                                                        
                                                        String ts = parentObject.replace('.', ',');
                                                        List<String> obs = ts.split(',');
                                                        
                                                        if (obs != null && loan != null && loan.getSObject(obs[0]) != null && loan.getSObject(obs[0]).getSObject(obs[1]) != null 
                                                            && loan.getSObject(obs[0]).getSObject(obs[1]).get(parentField) != null) {
                                                                
                                                                Object parentFieldValue = loan.getSObject(obs[0]).getSObject(obs[1]).get(parentField);
                                                                fieldValue = setParentField(parentFieldValue, fieldValue);
                                                                
                                                                // Dynamic Transformation : This covers the account type 01 - Current Account, 04 - Loan Account
                                                                String account_type_obj = obs[0] + '.' + obs[1];
                                                                fieldValue = dynamicFieldTransformation(account_type_obj, parentObject, fieldValue, bkkSettings);
                                                            }
                                                        
                                                        return fieldValue;
                                                    }
    
    /**
* setParentField
* @return string
*/
    private static String setParentField(Object parentFieldValue, String fieldValue) {
        if(parentFieldValue instanceOf Date || parentFieldValue instanceOf Datetime){
            fieldValue = cm_Utilities.formatDate(parentFieldValue);
        } else {
            if(parentFieldValue != null){
                fieldValue = String.valueOf(parentFieldValue);
            } else {
                fieldValue = cm_Constant.EMPTY_STRING;
            }
        }
        return fieldValue;
    }
    
    /**
* dynamicFieldTransformation
* @return string
*/
    private static String dynamicFieldTransformation(String account_type_obj, String parentObject, String fieldValue,
                                                     Map<String, List<Map<String, CM_TransformationSetting_CMD__mdt>>> bkkSettings) {
                                                         if (parentObject == account_type_obj) {
                                                             for (String sourceAPIKey : bkkSettings.keySet()) {
                                                                 fieldValue = mdtTransformation(fieldValue, sourceAPIKey, bkkSettings);
                                                             }
                                                         }
                                                         return fieldValue;
                                                     }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      13/07/2023
* @Description: Method used to populate the ledger line items, this will get the borrower names of specific loan record.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]
* 22/06/2024 - INC0688049 - John Gamboa - change the map key to index parameter and value to ledger names
***************************************************************************************************/
    private static String populateLedgerLineItems(LLC_BI__Loan__c loan, String childField, Integer indexNumber) {
        String childValue = cm_Constant.EMPTY_STRING;
        List<String> containerValuesList = new List<String>();
        Map<Integer, String> containerMapNum = new Map<Integer, String>();
        Boolean isPrimary = false;
        string loanLegalEntityType = (string) loan.getSObject(cm_Constant.S_OBJECTS[0]).get(cm_Constant.FIELD_NAME[0]);
        
        if (containerValuesList == null || containerValuesList.size() == 0) {
            for (SObject record: loan.getSObjects(cm_Constant.S_OBJECTS[1])) {
                String[] childObjectList = childField.replace('.', ',').split(',');
                if (childObjectList.size() > 0) {
                    string legalEntityNames = (string) record.getSObject(cm_Constant.S_OBJECTS[0]).get(cm_Constant.FIELD_NAME[1]);
                    string borrowerType = (string) record.get(cm_Constant.FIELD_NAME[4]);
                    string recordName = (string) record.get(cm_Constant.FIELD_NAME[4]);
                    if (loanLegalEntityType == cm_Constant.SOLE_TRADER) {
                        if (recordName == cm_Constant.BORROWER) {
                            containerMapNum.put(1, legalEntityNames);
                        }
                    }
                    else {
                        string legalEntityType = (string) record.getSObject(cm_Constant.S_OBJECTS[0]).get(cm_Constant.FIELD_NAME[0]);
                        boolean isPrimaryGuarantor = boolean.valueOf(record.get(cm_Constant.S_OBJECTS[2]));
                        isPrimary = isNotSoleTrader(recordName, containerMapNum, containerValuesList, legalEntityType, isPrimaryGuarantor, isPrimary, legalEntityNames, borrowerType);
                    }
                }
            }
        }
        
        childValue = removeSpecialChar(childValue, containerMapNum, indexNumber);
        
        integer productType = containerMapNum.size();
        childValue = setProductType(childValue, productType, indexNumber, loan);
        
        return childValue.left(cm_Constant.LDGR_MAX_CHAR);
    }
    
    private static boolean isNotSoleTrader(string recordName, Map<integer, string> containerMapNum, List<String> containerValuesList,string legalEntityType, boolean isPrimaryGuarantor, boolean isPrimary, string legalEntityNames, string borrowerType) {
        boolean primaryResult = isPrimary;
        if (recordName == cm_Constant.BORROWER) {
            containerMapNum.put(1, legalEntityNames);
        }
        else if (cm_Constant.BORROWER_TYPES.contains(borrowerType)) {
            primaryResult = isPrimaryGuarantor(isPrimary, isPrimaryGuarantor, containerValuesList, containerMapNum, legalEntityNames);
        }
        return primaryResult;
    }
    
    private static boolean isPrimaryGuarantor(Boolean isPrimary, Boolean isPrimaryGuarantor, List<String> containerValuesList, Map<Integer, String> containerMapNum, String legalEntityNames) {
        boolean primaryResult = isPrimary;
        if (isPrimaryGuarantor) {
            containerMapNum.put(2, legalEntityNames);
            primaryResult = true;
        }
        else {
            containerMapNum.put(containerMapNum.size() + 1, legalEntityNames);
        }

        return primaryResult;
    }
    
    private static String removeSpecialChar(String childRecordValue, Map<Integer, String> containerMapNum, Integer indexNumber) {
        String childValue = childRecordValue;
        for (integer entityIndexNumber: containerMapNum.keySet()) {
            if (entityIndexNumber == indexNumber) {
                childValue = containerMapNum.get(indexNumber).replaceAll(cm_Constant.SPCL_CHAR, cm_Constant.EMPTY_STRING).toUppercase();
            }
        }
        return childValue;
    }
    
    private static String setProductType(String childValue, Integer productType, Integer indexNumber, LLC_BI__Loan__c loan) {
        Integer productTypeValue = productType;
        String childRecord = childValue;
        if (productTypeValue <= cm_Constant.FOUR) {
            productTypeValue += 1;
        }
        else {
            productTypeValue = cm_Constant.FIVE;
        }
        
        if (productTypeValue == indexNumber) {
            childRecord = loan.LLC_BI__Product_Type__c.toUpperCase('tr');
        }
        
        return childRecord;
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      13/07/2023
* @Description: Method used to get the lending officer code requirements.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String getLendingOfficerCodeLocNumber(LLC_BI__Loan__c loan, string fieldValue, string devName) {
        // Initial code for getting lending officer code
        if (devName == cm_Constant.LOC) {
            @testVisible integer lending = integer.valueOf(loan.getSObject(cm_Constant.S_OBJECTS[0]).get(cm_Constant.FIELD_NAME[6]));
            fieldValue = getLendingOfficerCode(lendingValue(lendingAccountIsNotEmpty(loan), lendingIsNotEmpty(lending), loan), fieldValue);
        }
        return fieldValue;
    }
    
    private static Boolean lendingAccountIsNotEmpty(LLC_BI__Loan__c loan) {
        boolean isNotEmpty = false;
        if (loan.getSObject(cm_Constant.S_OBJECTS[0]) != null) {
            isNotEmpty = true;
        }
        return isNotEmpty;
    }
    
    private static Boolean lendingIsNotEmpty(integer lending) {
        boolean isNotEmpty = false;
        if (lending != null) {
            isNotEmpty = true;
        }
        return isNotEmpty;
    }
    
    private static Integer lendingValue(boolean lendingAccountIsNotEmpty, boolean lendingIsNotEmpty, LLC_BI__Loan__c loan) {
        integer lending;
        if (lendingAccountIsNotEmpty && lendingIsNotEmpty) {
            lending = integer.valueOf(loan.getSObject(cm_Constant.S_OBJECTS[0]).get(cm_Constant.FIELD_NAME[6]));
        }
        return lending;
    }
    
    private static String getLendingOfficerCode(integer lending, string fieldValue) {
        if (lending >= 0 && lending <= cm_Constant.LENDG_VALUE_120K) {
            fieldValue = cm_Constant.NUM_ONE;
        }
        else if (lending > cm_Constant.LENDG_VALUE_120K && lending <= cm_Constant.LENDG_VALUE_500K) {
            fieldValue = cm_Constant.NUM_THREE;
        }
        else if (lending > cm_Constant.LENDG_VALUE_500K && lending <= cm_Constant.LENDG_VALUE_1M) {
            fieldValue = cm_Constant.NUM_FIVE;
        }

        else if (lending > cm_Constant.LENDG_VALUE_1M) {
            fieldValue = cm_Constant.NUM_FIVE;
        }
        else {
            fieldValue = cm_Constant.NUM_ZERO; 
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    Rich Gozarin
* @Date:      13/07/2023
* @Description: This Method is used to set current date values.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String setDateType(cm_BKK_Loan_Mapping__mdt metadata, String fieldValue) {
        
        switch on metadata.cm_Date_Type__c {
            when 'Get Day' {
                fieldValue = String.valueOf(cm_Constant.DATE_TODAY.day());
            }
            when 'Next Due Date' {
                fieldValue = cm_Utilities.formatDate(cm_Constant.DATE_TODAY.addMonths(12));
            }
            when 'Get Current Date' {
                fieldValue = cm_Utilities.formatDate(cm_Constant.DATE_TODAY);
            }
            when else {
                fieldValue = cm_Constant.EMPTY_STRING;
            }
        }
        
        return writeCSVLine(metadata, fieldValue);
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      13/07/2023
* @Description: Method used to remove double quote when value is number.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String dropDoubleQuotes(String fieldValue, Boolean isDropAll) {
        String convertToString = cm_Constant.EMPTY_STRING;
        
        if (isDropAll) {
            return convertToString;
        } else {
            Pattern valid_characters = Pattern.compile(cm_Constant.numbers_value_regex);
            Matcher check_chars = valid_characters.matcher(fieldValue);
            
            Pattern withDecimal = Pattern.compile(cm_Constant.numbers_with_decimal_regex);
            Matcher checkDecimalChars = withDecimal.matcher(fieldValue);
            
            if (check_chars.matches() || checkDecimalChars.matches()) {
                convertToString = cm_Constant.EMPTY_STRING;
            }
            else {
                convertToString = '"';
            }
            
            return convertToString;
        }
    }
    
    /**************************************************************************************************
* @Author:    John Gamboa
* @Date:      13/07/2023
* @Description: Check if the fieldValue is number and consist of decimal number then convert it to whole number.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String removeDecimalNumbers(string fieldValue) {
        if (fieldValue != null) {

            Pattern valid_characters = Pattern.compile(cm_Constant.numbers_value_regex);
            Matcher check_chars = valid_characters.matcher(fieldValue);

            Pattern withDecimal = Pattern.compile(cm_Constant.numbers_with_decimal_regex);
            Matcher checkDecimalChars = withDecimal.matcher(fieldValue);
            
            if (checkDecimalChars.matches() && !check_chars.matches()) {
                Decimal getDecimalNumber = decimal.valueOf(fieldValue);
                Integer wholeValue = getDecimalNumber.intValue();
                fieldValue = string.valueOf(wholeValue);
            }
        }
        return fieldValue;
    }
    
    /**************************************************************************************************
* @Author:    Rich Gozarin
* @Date:      14/07/2023
* @Description: Add custom padding based on the values set on metadata.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    private static String applyPadding(cm_BKK_Loan_Mapping__mdt metadata, String value) {
        try {
            if (metadata.cm_Is_Padding__c) {
                switch on metadata.cm_Padding_Direction__c {
                    when 'Left' {
                        value = value.leftPad((Integer)metadata.cm_Padding_Count__c, metadata.cm_Padding_Value__c);
                    }
                    
                    when 'Right' {
                        value = value.rightPad((Integer)metadata.cm_Padding_Count__c);
                    }
                    
                    when else {
                        return value;
                    }
                }
            }
            return value;
        } catch(Exception e) {
            cm_ExceptionLog.log(cm_BookingBatchHelper.class.getName(), 'Booking Batch', e);
            return null;
        }
        
    }
}