/**************************************************************************************************
* @Author:    Ronce Allyson Balita
* @Date:      05/05/2023
* @Description: This class will format as YYYYMMDD for all date/datetime data type fields.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
public class cm_Utilities {
        
    public static String formatDate(Object fieldValue){
        String dateFormat = CM_Constant.DateFormat;
        String fieldStringValue = '';
        
        if(fieldValue instanceOf Date){
            Date dateValue = (Date) fieldValue; 
            Datetime dateTimeValue = Datetime.newInstance(dateValue, Time.newInstance(0, 0, 0, 0));            
            fieldStringValue = dateTimeValue.format(dateFormat);
        }
        else if(fieldValue instanceOf Datetime){
            Datetime dateTimeValue = (Datetime) fieldValue;
            fieldStringValue = dateTimeValue.format(dateFormat);
        }
        else{
            fieldStringValue = String.valueOf(fieldValue);
        }
        
        return fieldStringValue;
    }
    
    /**********************************************************************************************
* @Author:     Kuldeep  
* @Date:        11/05/2023
* @Description: This method will replace resrved key words from JSON String
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public static String replaceReservedKeywords(String jsonString){
        
        try {
            if(String.isNotBlank(jsonString)){
                CM_JsonKeywords_CMD__mdt[] keywordsList = CM_UtilitiesProvidor.getMetadataRecords();
                
                for(CM_JsonKeywords_CMD__mdt keywordRec : keywordsList){
                    jsonString = jsonString.replace( keywordRec.CM_Keyword__c, keywordRec.CM_Replacement__c );
                }
            }
            
            return jsonString;
            
        } catch(exception exp){
            cm_ExceptionLog.log(cm_Utilities.class.getName(), 'replaceReservedKeywords' ,exp);
            return null;
        } 
        
    }
    
    /**********************************************************************************************
* @Author:     Kuldeep  
* @Date:       11/05/2023
* @Description: This method will retain resrved key words from JSON String
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/
    public static String retainReservedKeywords(String jsonString){
        
        try {
            if(String.isNotBlank(jsonString)){
                CM_JsonKeywords_CMD__mdt[] keywordsList = CM_UtilitiesProvidor.getMetadataRecords();
                for(CM_JsonKeywords_CMD__mdt keywordRec : keywordsList){
                    jsonString = jsonString.replace(keywordRec.CM_Replacement__c,keywordRec.CM_Keyword__c);
                    
                }
            }
            
            return jsonString;
            
        } catch(exception exp){
            cm_ExceptionLog.log(cm_Utilities.class.getName(), 'retainReservedKeywords' ,exp);
            return null;
        }
    }
    /**********************************************************************************************
* @Author:     Kuldeep  
* @Date:       11/05/2023
* @Description: This method will retrieve all the transformation value. Use 'All' to retrive all records 
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***********************************************************************************************/  
    public static Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> getAllTransformationSetting(){
        
        Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> settingMap = new  Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>>();
        try{
            CM_TransformationSetting_CMD__mdt[] settings = CM_UtilitiesProvidor.getSettings();
            
            Map<String , Set<String> > tsMap =  new Map<String , Set<String> >();   
            Set<String> dnSet  = new Set <String>();
            
            for( CM_TransformationSetting_CMD__mdt setting : settings ){
                if(tsMap.containsKey(setting.CM_SourceAPI__c)){
                    dnSet = tsMap.get(setting.CM_SourceAPI__c);
                    dnSet.add(setting.DeveloperName);
                    tsMap.put(setting.CM_SourceAPI__c , dnSet);
                }
                else{
                    Set<String> dnnewSet  = new Set <String>();
                    dnnewSet.add(setting.DeveloperName);
                    tsMap.put(setting.CM_SourceAPI__c, dnnewSet);
                }
            } 
            for( String key : tsMap.keySet()){
                Set<String> dnameSet  = tsMap.get(key);
                Map<String , CM_TransformationSetting_CMD__mdt> sourceMap = new Map<String , CM_TransformationSetting_CMD__mdt>();
                List<Map<String , CM_TransformationSetting_CMD__mdt>> sourceList  = new List<Map<String , CM_TransformationSetting_CMD__mdt>>();
                for(String devName : dnameSet){
                    CM_TransformationSetting_CMD__mdt setRec  = CM_TransformationSetting_CMD__mdt.getInstance(devName);
                    sourceMap.put(setRec.CM_SourceText__c ,setRec);   //setRec.CM_TargetValue__c
                }
                sourceList.add(sourceMap);
                settingMap.put( key , sourceList ); 
            }
            return settingMap;
            
        }catch(exception exp){
            cm_ExceptionLog.log(cm_Utilities.class.getName(), 'getAllTransformationSetting' ,exp);
            return null;
        } 
        
    }
    
    
/**************************************************************************************************
* @Author:    Ronce Allyson Balita
* @Date:      22/05/2023
* @Description: This method will compute the age.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
    public static String calculateAge(Date birthDate){
        try {
        
            Date currentDate = Date.today();
            Integer age = currentDate.year() - birthDate.year();
            
            if(currentDate.month() < birthDate.month() || (currentDate.month() == birthDate.month()
                                                                       && currentDate.day() < birthDate.day())){
                age--;                                                   
            }

            return String.valueOf(age);
        }catch(exception exp){
            cm_ExceptionLog.log(cm_Utilities.class.getName(), 'calculateAge' ,exp);
            return null;
        } 
    }
    
    /**********************************************************************************************
    * @Author:     Rich Gozarin  
    * @Date:       07/07/2023
    * @Description: This method will return the target value based on input
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
    ***********************************************************************************************/
    public static String generateExtraChar(Integer numOfOccurence, String output){
        
        try {
            String value = '';
            if(numOfOccurence == null || numOfOccurence == 0){
                return null;
            }

            for (Integer cnt = 0; cnt < numOfOccurence; cnt++) {
                value += output;
            }
            
            return value;
            
        } catch(exception exp){
            cm_ExceptionLog.log(cm_Utilities.class.getName(), 'generateExtraChar' ,exp);
            return null;
        }
    }
    
    /**********************************************************************************************
    * @Author:     Rolie John Ewican  
    * @Date:       06/22/2024
    * @Description: This method will return the current 
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
    ***********************************************************************************************/
    public static Date addBussinessDays(Date startDate, Integer iMonth){
        Date currentDate = startDate;
        currentDate = currentDate.addMonths(iMonth);
           while (!checkifItisWorkingDay(currentDate) ) {
                // If it's a weekend, add one day to move to the next business day
                currentDate = currentDate.addDays(1);
            }		
        return currentDate;
    }
    // Method to check if a given date is a weekend
     public static Boolean isWeekend(Date dateToCheck) {
            // Get the day of the week 
            Datetime dt = (DateTime)dateToCheck;
            String dayOfWeek = dt.format('EEEE');
            system.debug('dayOfWeek ' + dayOfWeek);
            // Return true if the day is Saturday (7) or Sunday (1)
            return (dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY');
     }
    // Get a list of Holiday
    public static List<Holiday> holidays {
        get {
            if(holidays == null)
                holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
            return holidays;
        }
        private set;
    }
    
    public static boolean checkifItisWorkingDay(Date currentDate){
        Date weekStart  = currentDate.toStartofWeek();
        for(Holiday hDay:holidays){
            if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                return false;
            }
        }
        if(isWeekend(currentDate)){
            return false;
        } else 
            return true;
    }
}