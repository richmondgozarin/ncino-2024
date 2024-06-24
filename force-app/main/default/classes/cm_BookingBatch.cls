/**************************************************************************************************
* @Author:    Ronce Allyson Balita
* @Date:      09/05/2023
* @Description: This class will generate a CSV files for the loan objects with the related parent and child objects.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
global class cm_BookingBatch implements Database.Batchable<sObject>, Database.Stateful{

    global final List<String> csvLoanList = new List<String>{};
    global final List<String> csvOverDraftList = new List<String>{};
    private List<cm_BKK_Loan_Mapping__mdt> bkkMdt;
    private Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bkkSettings;
    private List<String> bkkTargetFiles;
    global final List<LLC_BI__Loan__c> loanList = new List<LLC_BI__Loan__c>();
    
    private String bkkQuery;
    private Date startDate;
    private Date endDate;

	public cm_BookingBatch(List<cm_BKK_Loan_Mapping__mdt> metadata, 
                           String customQuery,
                           Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings, 
                           List<String> bookingTargetFiles,
                           String fromDate, String toDate) {

        bkkMdt = metadata;
        bkkQuery = customQuery;
        bkkSettings = bookingSettings;
        bkkTargetFiles = bookingTargetFiles;
        startDate = date.valueOf(fromDate);
        endDate = date.valueOf(toDate);
    }
    
    public cm_BookingBatch(List<cm_BKK_Loan_Mapping__mdt> metadata,
                           String customQuery,
                           Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings,
                           List<String> bookingTargetFiles) {                       
        bkkMdt = metadata;
        bkkQuery = customQuery;
        bkkSettings = bookingSettings;
        bkkTargetFiles = bookingTargetFiles;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(bkkQuery);  
    }
    
    global void execute(Database.BatchableContext bc, List<LLC_BI__Loan__c> Booking){
        try {
            
            List<cm_BKK_Loan_Mapping__mdt> fieldList = bkkMdt;
                
            if(csvLoanList.isEmpty()){
                String loanHeader = cm_Constant.EMPTY_STRING;
                loanHeader = cm_BookingBatchHelper.setColumnHeader(fieldList, bkkTargetFiles[0]);
                csvLoanList.add(loanHeader);
            }
            if (csvOverDraftList.isEmpty()) {
                String overDraftHeader = cm_Constant.EMPTY_STRING;
                overDraftHeader = cm_BookingBatchHelper.setColumnHeader(fieldList, bkkTargetFiles[1]); 
                csvOverDraftList.add(overDraftHeader);
            }
            for(LLC_BI__Loan__c loan : Booking){
                String csvLine = cm_Constant.EMPTY_STRING;
                
                for(cm_BKK_Loan_Mapping__mdt metadata : fieldList) {
                    String fieldValue = cm_Constant.EMPTY_STRING;
                    
                    
                    
                    // Write to csv
                    Boolean isTarget =  metadata.cm_Target_Csv_File__c.replace('_', ' ').contains(loan.LLC_BI__Product_Type__c);
                    if (isTarget) {
                        csvLine = cm_BookingBatchHelper.getAllRecordsByLoanRecordType(loan, metadata, fieldValue,
                                                                                      bkkSettings, csvLine,
                                                                                      loan.LLC_BI__Product_Type__c, 
                                                                                      bkkTargetFiles);
                    }
                }

                csvLine = csvLine.removeEnd(cm_Constant.DELIMITER);
                
                if (loan.LLC_BI__Product_Type__c == bkkTargetFiles[0]) {
                    csvLoanList.add(csvLine);
                }
                
                if (loan.LLC_BI__Product_Type__c == bkkTargetFiles[1]) {
                    csvOverDraftList.add(csvLine);
                } 
            
                loanList.add(loan);
            }   
        } catch(Exception ex){
            cm_ExceptionLog.log(cm_BookingBatch.class.getName(), 'execute', ex);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        try{
            List<cm_BKK_Loan_Mapping__mdt> fieldList = bkkMdt;  
            cm_LoanBooking__c record = new cm_LoanBooking__c();
            record.Name = cm_Constant.BKK_CSV_FILE_NAME;
            insert record;

            cm_BookingBatchHelper.updateLoanFields(loanList);
            
            String getDate = cm_Utilities.formatDate(Datetime.now());
            String bkkBatchHr = string.valueOf(Datetime.now()).substringAfter(' ').substringBefore(':');
            String dropNo = cm_Constant.BKK_DROP_COUNTER.containsKey(bkkBatchHr) ? cm_Constant.BKK_DROP_COUNTER.get(bkkBatchHr) + '_' : cm_Constant.DROP_NO4 + '_';
            
            if (startDate != null && endDate != null) {
                getDate = cm_Utilities.formatDate(endDate);
            }

            // Adds the header in list, if final list size for loan and overdraft is empty
            if (csvLoanList.size() <= 0 && csvLoanList.isEmpty()) {
                string loanHeader = cm_BookingBatchHelper.setColumnHeader(fieldList, bkkTargetFiles[0]);
                csvLoanList.add(loanHeader);
            }

            if (csvOverDraftList.size() <= 0 && csvOverDraftList.isEmpty()) {
                string overDraftHeader = cm_BookingBatchHelper.setColumnHeader(fieldList, bkkTargetFiles[1]);
                csvOverDraftList.add(overDraftHeader);
            }

            for (String productType : bkkTargetFiles) {
                String product = productType.substringBefore(' ');
                String fileName = cm_Constant.CSV_FILE_NAME_INTRO + cm_Constant.BOOKING_FILES_MAP.get(product) + cm_Constant.CSV_FILE_NAME_MID + dropNo + getDate + cm_Constant.CSV_FILE_EXTENSION;
                String overdraftName = cm_Constant.BOOKING_FILES_MAP.get(bkkTargetFiles[1].substringBefore(' '));

                switch on product {
                    when 'Loan'  {
                        cm_BookingBatchHelper.createAttachment(fileName, csvLoanList, record);
                    }
                    when 'Current'  {
                        cm_BookingBatchHelper.createAttachment(fileName, csvOverDraftList, record);
                    }
                    when else {
                        List<String> csvControlFile = new List<String>();
                        Integer loan_size = Integer.valueOf(csvLoanList.size())-1;
                        Integer overdraft_size = Integer.valueOf(csvOverDraftList.size())-1;
                        csvControlFile.add(dropNo.substringBefore('_') + cm_Constant.DELIMITER + getDate);
                        csvControlFile.add(bkkTargetFiles[0].substringBefore(' ') + cm_Constant.DELIMITER + loan_size);
                        csvControlFile.add(overdraftName + cm_Constant.DELIMITER + overdraft_size);
                        
                        cm_BookingBatchHelper.createAttachment(fileName, csvControlFile, record);
                    }
                }
            }

            // Call the AWS Service
            ID jobID = System.enqueueJob(new CM_AWSService('S3_AWSAPI', record.Id ));
            
        } catch (Exception ex){
            cm_ExceptionLog.log(cm_BookingBatch.class.getName(), 'Booking Batch', ex);
        }
    }
}