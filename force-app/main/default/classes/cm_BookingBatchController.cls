/**************************************************************************************************
* @Author:    Ronce Allyson Balita
* @Date:      09/05/2023
* @Description: This class will handle all the query for the custom metadata, parent objects and child objects
that will be used in cm_BookingBatch.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public with sharing class cm_BookingBatchController {
    private Datetime bookingDate;
    private Date startDate;
    private Date endDate;
    private Id batchId;
    
    
    public void run(String dateParam) {
        this.bookingDate = dateParam == cm_Constant.TODAY ? cm_Constant.DATE_TIME_TDY : datetime.valueOf(dateParam);
        runner();
    }
    
    public void run(String fromDate, String toDate) {
        this.startDate = date.valueOf(fromDate);
        this.endDate = date.valueOf(toDate);
        runner();
    }
    
    private void runner() {
		Set<Datetime> numOfHolidays = new Set<Datetime>();
        List<Holiday> holidayList = [SELECT Id, Name, RecurrenceStartDate, ActivityDate FROM Holiday];
        
        for(Holiday holidays : holidayList){
            numOfHolidays.add(Date.valueOf(holidays.ActivityDate));
        }
        
        try {
            String metaQuery = 'SELECT DeveloperName, cm_Source_Object__c, cm_Source_Field__c, cm_Target_Column__c, cm_Order__c, ' +
                                'cm_Parent_Object__c, cm_Parent_Field__c, cm_Child_Object__c, cm_Child_Field__c, ' +
                				'cm_Default_Value__c, cm_Target_Csv_File__c, cm_Date_Type__c, cm_Is_Sole_Trader__c, ' +
                				'cm_Is_Padding__c, cm_Padding_Direction__c, cm_Padding_Count__c, cm_Padding_Value__c ' +
                                'FROM cm_BKK_Loan_Mapping__mdt WHERE cm_Is_Active__c = TRUE ORDER BY cm_Order__c ASC';
            
            List<cm_BKK_Loan_Mapping__mdt> metadata = Database.query(metaQuery);
            
            String childQuery = '';
            String loanFields = '';
            String targetColumns = '';
            String query = 'SELECT Id, ';
            String csvLine = '';
            Set<String> childObjects = new Set<String>();
            String payOffField = ',cm_Doyouwanttopayoffexistingdebt__c';

            for(cm_BKK_Loan_Mapping__mdt field : metadata) {     
                String fieldName = field.cm_Source_Field__c;
                String parentObject = field.cm_Parent_Object__c;
                String parentField = field.cm_Parent_Field__c;
                
                if(fieldName != null && !fieldName.trim().equals('')){
                    csvLine += String.escapeSingleQuotes(fieldName) + ',';
                    List<String> uniqueFields = new List<String>(new Set<String>(csvLine.split(',')));
                    loanFields = string.join(uniqueFields, ',');
                    
                    // Source field with Parent field
                    if(parentObject != null && parentField != null){
                        query += parentObject + '.' + parentField + ', ';
                    }
                }
                else if(parentObject != null && parentField != null){
                    query += parentObject + '.' + parentField + ', ';
                }
                else if(field.cm_Child_Object__c != null && field.cm_Child_Field__c != null){
                    childObjects.add(field.cm_Child_Object__c);
                    childQuery = getChildQuery(field.cm_Child_Object__c, childQuery);
                }
                else{
                    String targetName = field.cm_Target_Column__c;
                    targetColumns += String.escapeSingleQuotes(targetName) + ',';
                }
            }

            //check for duplicate fields
            List<String> tp = new List<String>(new Set<String>(query.split(',')));
            query = string.join(tp, ',');
            
            loanFields = loanFields.removeEnd(',');
            targetColumns = targetColumns.removeEnd(',');
            
            String objectName = metadata[0].cm_Source_Object__c;
            List<String> nl = new List<String>(new Set<String>(childQuery.split(',')));
            string newChildQuery = String.join(nl, ',');
            
            query += loanFields + payOffField + newChildQuery + ' FROM ' + objectName;
            query += ' WHERE LLC_BI__Is_Booked__c = false ';
            query+= 'and LLC_BI__Stage__c  = \'' + cm_Constant.PRE_FULFILMENT + '\' and cm_Ready_for_Booking__c = true ';

            query += queryBKKStatus(numOfHolidays);

            system.debug('Final Query >> ' + query);
            executeBatch(numOfHolidays, metadata, query);

        } catch (Exception ex) {
            cm_ExceptionLog.log(cm_BookingBatchController.class.getName(), 'runner', ex);
        }
    }
    
    private void executeBatch(Set<Datetime> numOfHolidays, List<cm_BKK_Loan_Mapping__mdt> metadata, String query) {
        Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings = cm_Utilities.getAllTransformationSetting();
        List<String> bookingTargetFiles = cm_Constant.BOOKING_TARGET_FILES;
		
        if(!numOfHolidays.contains(date.valueOf(this.bookingDate))) {
            cm_BookingBatch booking;
            if(date.valueOf(this.bookingDate) == cm_Constant.DATE_TODAY){
                booking = new cm_BookingBatch(metadata, query, bookingSettings, bookingTargetFiles);
            }else{
                booking = new cm_BookingBatch(metadata, query, bookingSettings, bookingTargetFiles, String.valueOf(this.startDate), String.valueOf(this.endDate));   
            }
            batchId = Database.executeBatch(booking);
        }
    }

    /**
     * Final Query for Standard and Adhoc
     */
    private String queryBKKStatus(Set<Datetime> numOfHolidays) {
        String query = '';
        if (date.valueOf(this.bookingDate) == cm_Constant.DATE_TODAY) {
            query += 'AND cm_BKK_Status__c IN ' + cm_Constant.BKK_STATUS_STANDARD + '' ;
            query += getQueryByHoliday(numOfHolidays);
        } else {
            query += 'AND cm_BKK_Status__c IN ' + cm_Constant.BKK_STATUS_ADHOC + '';
            Datetime toDateTime = datetime.newInstance(this.endDate, cm_Constant.TIME_SET);
            String formatEndDate = toDateTime.formatGmt(cm_Constant.FORMAT_GMT);
            //Pre-Decision Analysis
            query += ' and ' + cm_Constant.READY_FOR_BOOKING_DATE_TIME + ' >= ' + dateTimeFormat(this.startDate, cm_Constant.TIME_SET.addMinutes(1)) + '';
            query += ' and ' + cm_Constant.READY_FOR_BOOKING_DATE_TIME + ' <= ' + formatEndDate + '';
        }
		query += ' ORDER BY ' + cm_Constant.READY_FOR_BOOKING_DATE_TIME + '';
        
        return query;
    }
    
    /**
     * Include Holiday to the next batch
     */
    @TestVisible
    private String getQueryByHoliday(Set<Datetime> numOfHolidays) {
        try {
            date tempDates;
            Datetime dayOfWeek = (Datetime)cm_Constant.DATE_TODAY;
            String bkkDateFormat = bookingDate.formatGMT(cm_Constant.FORMAT_GMT);
            String query = ' and ' + cm_Constant.READY_FOR_BOOKING_DATE_TIME + ' <= ' + bkkDateFormat + '';
            date holidayDates = cm_Constant.DATE_TODAY;
            
            if(dayOfWeek.format(cm_Constant.DAY_FORMAT) == cm_Constant.MONDAY){
                tempDates = cm_Constant.DATE_TODAY.addDays(-3);
            }else{
                tempDates = cm_Constant.DATE_TODAY.addDays(-1);
            }
            
            while(holidayDates > tempDates) {
                holidayDates = holidayDates.addDays(-1);
                if(numOfHolidays.contains(holidayDates)){
                    query = ' and ' + cm_Constant.READY_FOR_BOOKING_DATE_TIME + ' <= ' + bkkDateFormat + '';
                }
            }
            
            return query;

        } catch (Exception ex) {
            cm_ExceptionLog.log(cm_BookingBatchController.class.getName(), 'getQueryByHoliday', ex);
            return '';
        }
    }
 

    private String getChildQuery(String childObjects, String childQuery){
        try {
            string chFields;
            string ledgerFields = '';
            string orderByCreatedDate = '';
            string childObject = '';
            
            List<String> childFields = new List<String>();

            for(cm_BKK_Loan_Mapping__mdt field : [SELECT DeveloperName, cm_Child_Field__c, cm_Child_Object__c 
                                               FROM cm_BKK_Loan_Mapping__mdt 
                                               WHERE cm_Child_Object__c = :childObjects 
                                               AND cm_is_Active__c = true 
                                               ORDER BY cm_Order__c asc]) {
                String[] checkFieldName = field.DeveloperName.split('_');
                
                if (checkFieldName[0] == cm_Constant.LEDGER) {
                    ledgerFields = ',LLC_BI__Borrower_Type__c,LLC_BI__Account__r.Type,cm_PrimaryGuarantorApplicant__c';
                    orderByCreatedDate = ' Order By CreatedDate ASC';
                }
                else {
                    ledgerFields = '';
                    orderByCreatedDate = '';
                }

                chFields = String.escapeSingleQuotes(field.cm_Child_Field__c) + ',';
                childObject = field.cm_Child_Object__c;
            }
            
            List<String> l = new List<String>(new Set<String>(chFields.split(',')));
            string fields = String.join(l, ',');
            childQuery += ', (SELECT ' + fields.replaceAll('null', '') + ledgerFields + ' FROM ' + childObject + orderByCreatedDate + ' )';
            return childQuery;
        } catch (Exception ex) {
            cm_ExceptionLog.log(cm_BookingBatchController.class.getName(), 'getChildQuery', ex);
            return '';
        }
    }
    
    public Id getBatchId{
        get{return batchId;}
    }

    private static String dateTimeFormat(date getDate, Time getTime){
        datetime converToDateTime = datetime.newInstance(getDate, getTime);
        String dateTimeFormatted = converToDateTime.formatGmt(cm_Constant.FORMAT_GMT);

        return dateTimeFormatted;        
    }

}