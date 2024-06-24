/**************************************************************************************************
* @Author:      Mark John Amadeo
* @Date:        17/05/2023
* @Description: Test class for cm_Utilities and CM_UtilitiesProvidor
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]   
***************************************************************************************************/
@isTest
private class cm_UtilitiesTest {
    
    static final String CONST_ACCOUNT_ORIGIN = ' "accountOrigination": {\n';
    static final String CONST_PRIMARY_APPLICANT = ' "primaryApplicant": {\n';
    static final String CONST_APPLICATION_DETAILS = ' "applicantAccountDetails": {\n';
    static final String CONST_ACCOUNT = ' "accountOrigination": {\n';
    static final String CONST_NEW_LINE = '": {\n';
    static final String CONST_TIME_SINCE_LIMIT = ' "timeSinceLimitChange": 1.01\n';
    
    @isTest
    static void testFormatDate() {
        // Create Date instance
        Date testDate = date.newInstance(2023, 5, 17);
        // Create DateTime instance
        DateTime testDateTime = DateTime.newInstance(2023, 5, 17);
        // Create date of type String
        String testDateString = '20230517';
        
        String result1 = cm_Utilities.formatDate(testDate);
        String result2 = cm_Utilities.formatDate(testDateTime);
        String result3 = cm_Utilities.formatDate(testDateString);
        
        String expected = '20230517';
        Assert.areEqual(expected, result1);
        Assert.areEqual(expected, result2);
        Assert.areEqual(expected, result3);
    }

    @isTest
    static void testReplaceReservedKeywords() {
        String reservedKeyword = 'limit';
        String replacement = 'x_limit';
        String jsonString = '{\n' +
            CONST_ACCOUNT_ORIGIN + 
            	CONST_PRIMARY_APPLICANT +
            		CONST_APPLICATION_DETAILS +
            			CONST_ACCOUNT +
            				' "' + reservedKeyword + CONST_NEW_LINE +
            					CONST_TIME_SINCE_LIMIT +
            				' }\n' +
            			' }\n' +
            		' }\n' +
            	' }\n' +
            ' }\n' +
           '}';
        String expectedJsonString = '{\n' +
            CONST_ACCOUNT_ORIGIN + 
            	CONST_PRIMARY_APPLICANT +
            		CONST_APPLICATION_DETAILS +
            			CONST_ACCOUNT +
            				' "' + replacement + CONST_NEW_LINE +
            					CONST_TIME_SINCE_LIMIT +
            				' }\n' +
            			' }\n' +
            		' }\n' +
            	' }\n' +
            ' }\n' +
           '}';
        
        String actualJsonString = cm_Utilities.replaceReservedKeywords(jsonString);
        
        // Verify reserved keyword is replaced with the replacement string
        Assert.areEqual(expectedJsonString, actualJsonString);
    }
    
    @isTest
    static void testReplaceReservedKeywordsFail() {
        Integer maxCharLimit = 6000000; // To induce String Exception
        String reservedKeyword = 'limit';
        Integer reservedKeywordSize = reservedKeyword.getChars().size();
        
        String jsonResult = cm_Utilities.replaceReservedKeywords(reservedKeyword.repeat((maxCharLimit - 1) / reservedKeywordSize));
        
        // Verify that the method returns null as it throws a StringException as expected.
        Assert.isNull(jsonResult);
    }
   
    @isTest
    static void testRetainReservedKeywords() {
        String reservedKeyword = 'limit';
        String replacement = 'x_limit';
        String jsonString = '{\n' +
            CONST_ACCOUNT_ORIGIN + 
            	CONST_PRIMARY_APPLICANT +
            		CONST_APPLICATION_DETAILS +
            			CONST_ACCOUNT +
            				' "' + replacement + CONST_NEW_LINE +
            					CONST_TIME_SINCE_LIMIT +
            				' }\n' +
            			' }\n' +
            		' }\n' +
            	' }\n' +
            ' }\n' +
           '}';
        String expectedJsonString ='{\n' +
            CONST_ACCOUNT_ORIGIN + 
            	CONST_PRIMARY_APPLICANT +
            		CONST_APPLICATION_DETAILS +
            			CONST_ACCOUNT +
            				' "' + reservedKeyword + CONST_NEW_LINE +
            					CONST_TIME_SINCE_LIMIT +
            				' }\n' +
            			' }\n' +
            		' }\n' +
            	' }\n' +
            ' }\n' +
           '}';
        String actualJsonString = cm_Utilities.retainReservedKeywords(jsonString);
        
        // Verify replacement string is replaced with reserved keyword.
        Assert.areEqual(expectedJsonString, actualJsonString);
    }
    
    @isTest
    static void testRetainReservedKeywordsFail() {
        Integer maxCharLimit = 6000000; // To induce String Exception
        String replacement = 'usedInTest';
        Integer replacementSize = replacement.getChars().size();
        
        String jsonResult = cm_Utilities.retainReservedKeywords(replacement.repeat((maxCharLimit - 1) / replacementSize));        
        // Verify that the method returns null as it throws a StringException as expected.
        Assert.isNotNull(jsonResult);
    }
    
    @isTest
    static void testGetAllTransformationSetting() {
        // BOI Transformation Setting used in this test: Arrangement Homeowner
        String sourceText = 'Dairy or Breeding Stock Purchase';
        String expectedTransformVal = '37';
        String sourceFieldApi = 'CM_Loan_Purpose__c';
        
        Map<String , List<Map<String, CM_TransformationSetting_CMD__mdt>>> settingMap = cm_Utilities.getAllTransformationSetting();
        
        Assert.isNotNull(settingMap.get(sourceFieldApi));
        List<Map<String, CM_TransformationSetting_CMD__mdt>> transformationList = settingMap.get(sourceFieldApi);
        Map<String, CM_TransformationSetting_CMD__mdt> tMap = transformationList[0];
        
        Assert.isNotNull(tMap.get(sourceText));
        // Verify the source text is transformed accordingly.
        Assert.areEqual(expectedTransformVal, tMap.get(sourceText).get('CM_TargetValue__c'));
    }
    
    @isTest
    static void testCalculateAge() {
        Integer expectedAge = 5;
        Date currentDate = Date.today();
        Date testBDateOrdinary = currentDate.addYears(-expectedAge);
        Date testBDateShortByDays = currentDate.addYears(-6).addDays(1);
        date testBDAteShortByMonths = currentDate.addYears(-6).addMonths(1);
        
        // Case 1: Ordinary birthdate
        String actualAgeOrdinary = cm_Utilities.calculateAge(testBDateOrdinary);
        Assert.areEqual(String.valueOf(expectedAge), actualAgeOrdinary);
        if(testBDateShortByDays.month() == currentDate.month()) {
            // Case 2: Current date month and birthdate month are same but current date day < birthdate date date
            String actualAgeShortByDays = cm_Utilities.calculateAge(testBDateShortByDays);
            Assert.areEqual(String.valueof(expectedAge), actualAgeShortByDays);
        }
        if( testBDAteShortByMonths.year() == currentDate.addYears(-6).year()) {
            // Case 3: Current date month < Birthdate month
            String actualAgeShortByMonths = cm_Utilities.calculateAge(testBDAteShortByMonths);
            Assert.areEqual(String.valueOf(expectedAge), actualAgeShortByMonths);
        }
    }
    
    @isTest
    static void testCalculateAgeFail() {
        Integer expectedAge = 5;
        Date currentDate = Date.today();
        Date testBDateOrdinary = currentDate.addYears(-expectedAge);
        
        // Case 1: Null Age
        try {
            String actualAgeOrdinary = cm_Utilities.calculateAge(null);
            Assert.isNull(actualAgeOrdinary);
        } catch (Exception ex) {
            Assert.fail();
            Assert.areEqual(ex.getMessage().contains('REQUIRED_FIELD_MISSING'), true);
        }
    }
    
    @isTest
    static void testGetMetadataRecords() {
        CM_JsonKeywords_CMD__mdt[] expectedMdKeywordsList = [ SELECT CM_Keyword__c, CM_Replacement__c
                                                             FROM CM_JsonKeywords_CMD__mdt
                                                             LIMIT 1000 ];
        Assert.isTrue(expectedMdKeywordsList.size() > 0);
        CM_JsonKeywords_CMD__mdt[] actualMdKeywordsList = CM_UtilitiesProvidor.getmetadatarecords();
        Assert.isTrue(actualMdKeywordsList.size() > 0);
        
        Assert.areEqual(expectedMdKeywordsList.size(), actualMdKeywordsList.size());
    }
    
    @isTest
    static void testGetSettings() {
        CM_TransformationSetting_CMD__mdt[] expectedMdAllSettingsList = [ SELECT DeveloperName, CM_SourceAPI__c, CM_SourceText__c, CM_TargetType__c, CM_TargetValue__c 
                                                                         FROM CM_TransformationSetting_CMD__mdt
                                                                         LIMIT 1000 ];
        Assert.isTrue(expectedMdAllSettingsList.size() > 0);
        CM_TransformationSetting_CMD__mdt[] actualMdAllSettingsList = CM_UtilitiesProvidor.getSettings();
        Assert.isTrue(actualMdAllSettingsList.size() > 0);
        Assert.areEqual(expectedMdAllSettingsList.size(), actualMdAllSettingsList.size());
        
        CM_TransformationSetting_CMD__mdt[] expectedMdERSSettingsList = [ SELECT DeveloperName, CM_SourceAPI__c,CM_SourceText__c,CM_TargetType__c,CM_TargetValue__c
                                                                         FROM CM_TransformationSetting_CMD__mdt
                                                                         ];
        Assert.isTrue(expectedMdERSSettingsList.size() > 0);
        CM_TransformationSetting_CMD__mdt[] actualMdERSSettingsList = CM_UtilitiesProvidor.getSettings();
        Assert.isTrue(actualMdERSSettingsList.size() > 0);
        Assert.areEqual(expectedMdERSSettingsList.size(), actualMdERSSettingsList.size());
        
        CM_TransformationSetting_CMD__mdt[] expectedMdBookingSettingsList = [ SELECT DeveloperName, CM_SourceAPI__c,CM_SourceText__c,CM_TargetType__c,CM_TargetValue__c
                                                                             FROM CM_TransformationSetting_CMD__mdt
                                                                            ];
        Assert.isTrue(expectedMdBookingSettingsList.size() > 0);
        CM_TransformationSetting_CMD__mdt[] actualMdBookingSettingsList = CM_UtilitiesProvidor.getSettings();
        Assert.isTrue(actualMdBookingSettingsList.size() > 0);
        Assert.areEqual(expectedMdBookingSettingsList.size(), actualMdBookingSettingsList.size());
    }
    
    @isTest
    static void testGenerateExtraChar() {
        Integer maxCharLimit = 6000000; // To induce String Exception
        
        // scenario1: numOfOccurence argument is null or 0. Verify the method will not generate extra characters.
        String result1 = cm_Utilities.generateExtraChar(null, 'test');
        Assert.isNull(result1);
        
        // scenario2: numOfOccurence argument is valid. Verify the method will generate the extra characters.
        String baseText = 'test';
        String expected = 'test' + 'aaaa';
        String result = cm_Utilities.generateExtraChar(4, 'a');
        Assert.areEqual(expected, baseText+result);
    }
    
    @isTest
    static void testGenerateExtraCharFail() {

        String result = cm_Utilities.generateExtraChar(3, 'a'.repeat(3000000));
		// Verify the method will return null as it will hit MathException as expected.
        Assert.isNull(result);
    }

}