/**************************************************************************************************
* @Author:    Kuldeep Parihar 
* @Date:      06/02/2023
* @Description: This class will handle SOQL for utilities.
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
November 9 2023 - Jasper Ramirez - Changed from without to with sharing
***************************************************************************************************/
public with sharing class cm_UtilitiesProvidor {
    
    /**********************************************************************************************
    * @Author:      Kuldeep Parihar  
    * @Date:        06/02/2023
    * @Description: This method will return meta data recored. 
    * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
    ***********************************************************************************************/ 
    public static CM_JsonKeywords_CMD__mdt[] getmetadatarecords() {
        CM_JsonKeywords_CMD__mdt[] keywords = [
            SELECT CM_Keyword__c, 
            CM_Replacement__c 
            FROM CM_JsonKeywords_CMD__mdt
            LIMIT 1000
        ];  
        return keywords;
    }
    
    public Static CM_TransformationSetting_CMD__mdt[] getSettings() {
        CM_TransformationSetting_CMD__mdt[] settings;
            settings = [
                SELECT 
                DeveloperName, CM_SourceAPI__c,CM_SourceText__c,CM_TargetType__c,CM_TargetValue__c 
                FROM CM_TransformationSetting_CMD__mdt 
                LIMIT 1000
            ];
        return settings;
    }
}