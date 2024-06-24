@isTest
public class cm_TestDataFactory {
    
    static final String CONST_DATETIME = '2023-05-25 15:31:00';
    
    public class LoanWrapper {
        public Integer numOfLoans;
        public String loanName;
        public String productType;
        public Id productPackage;
        public String product;
        public Id productReference;
        public String loanPurpose;
        public String sortCode;
        public Id account;
    }
    
    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
        return accts;
    }
    
    // Create test record for Holiday
    public static Holiday createHolidayRecord(date holidayDate){
        Holiday holidayRecord = new Holiday();
        holidayRecord.Name = 'Test Holiday';
        holidayRecord.ActivityDate = holidayDate;
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
         	insert holidayRecord;
        }

        return holidayRecord;
    }
    
    /*BKK*/
    //Create record for LLC_BI__Product_Package__c
    public static LLC_BI__Product_Package__c createProductPackage(){
        LLC_BI__Product_Package__c pp = new LLC_BI__Product_Package__c();
        pp.Name = 'Test Package';

        insert pp;
        return pp;
    }

    //create record for LLC_BI__Loan__c
    public static List<LLC_BI__Loan__c> createLoan(LoanWrapper loanInfo){
        List<LLC_BI__Loan__c> loanList = new List<LLC_BI__Loan__c>();

        for(Integer i=0; i<loanInfo.numOfLoans; i++) {
            LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
            loan.Name = loanInfo.loanName + i;
            loan.LLC_BI__Product_Line__c = 'SB&A';
            loan.LLC_BI__Product_Type__c = loanInfo.productType;
            loan.LLC_BI__Product__c = loanInfo.product;
            loan.cm_Loan_Purpose__c = loanInfo.loanPurpose;
            loan.LLC_BI__Term_Months__c = 24;
            loan.LLC_BI__Status__c = 'Open';
            loan.LLC_BI__Amount__c = 10000;
            loan.cm_Ready_for_Booking_Date_Time__c = Datetime.valueOf(CONST_DATETIME);
            loan.cm_Account_Number__c = '12345678';
            loan.cm_MarketClassification__c = '011';
            loan.cm_Sort_Code__c = loanInfo.sortCode;

            loan.cm_Term__c = '9 months';

            loan.LLC_BI__Product_Package__c = loanInfo.productPackage;
            loan.LLC_BI__Product_Reference__c = loanInfo.productReference;
            loan.LLC_BI__Account__c = loanInfo.account;
            
            loan.cm_DebitRateCode__c = '2-O';
            loan.LLC_BI__InterestRate__c = 5.51129911;

            loanList.add(loan);
        }
        insert loanList;
        return loanList;
    }
    
    // create single loan record
    public static LLC_BI__Loan__c createSingleLoan(String productType, 
                                                   Id productPackage, 
                                                   String product, 
                                                   Id productReference, 
                                                   String loanPurpose, 
                                                   String sortCode, 
                                                   Id account){
	LLC_BI__Loan__c createLoan = new LLC_BI__Loan__c();
            createLoan.Name = 'Test Loan';
            createLoan.LLC_BI__Product_Line__c = 'SB&A';
            createLoan.LLC_BI__Product_Type__c = productType;
            createLoan.LLC_BI__Product__c = product;
            createLoan.cm_Loan_Purpose__c = loanPurpose;
            createLoan.LLC_BI__Term_Months__c = 24;
            createLoan.LLC_BI__Status__c = 'Open';
            createLoan.LLC_BI__Amount__c = 10000;
            createLoan.cm_Ready_for_Booking_Date_Time__c = Datetime.valueOf(CONST_DATETIME);
            createLoan.cm_Account_Number__c = '12345678';
            createLoan.cm_MarketClassification__c = '011';
            createLoan.cm_Sort_Code__c = sortCode;
            createLoan.cm_Term__c = '3 months';
            createLoan.LLC_BI__Product_Package__c = productPackage;
            createLoan.LLC_BI__Product_Reference__c = productReference;
            createLoan.LLC_BI__Account__c = account;
                                                       
		insert createLoan;
        return createLoan;
    }
    
    // Create single Account
    public static Account createSingleAccount(Id loan, String type, String creditRating, Integer exposure){
        	Account createAccount = new Account();
            createAccount.FirstName = 'Test';
            createAccount.LastName = 'Account';
            createAccount.cm_TradingName__c = 'test';
            createAccount.Type = type;
            createAccount.LLC_BI__Credit_Rating__c = creditRating;
            createAccount.AccountNumber = '12345678';
            createAccount.cm_NominatedLoanAccount__c = loan;

            createAccount.RecordTypeId = '0127S000000x4doQAA';
            createAccount.PersonBirthdate = Date.valueOf('2023-05-25');
            createAccount.cm_TotalDirectSMEExposure__c = exposure;
        
        insert createAccount;
        return createAccount;
    }
    
    //create record for nominated account
    public static LLC_BI__Loan__c createNominated(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Name = 'Nominated Loan Account';
        loan.LLC_BI__Product_Line__c = 'SB&A';
        loan.LLC_BI__Product_Type__c = 'Loan Account';
        loan.LLC_BI__Product__c = 'Ordinary Loan Account';
        loan.cm_Loan_Purpose__c = 'Working Capital';
        loan.LLC_BI__Term_Months__c = 24;
        loan.LLC_BI__Status__c = 'Open';
        loan.LLC_BI__Amount__c = 10000;
        loan.cm_Ready_for_Booking_Date_Time__c = Datetime.valueOf(CONST_DATETIME);
        loan.cm_Account_Number__c = '12345678';
        loan.cm_MarketClassification__c = '011';

        insert loan;
        return loan;
    }
    
    //create record for Account
    public static List<Account> createAcc(Integer numOfAcc, Id loan, String type, String creditRating, Integer exposure){
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<numOfAcc; i++){
            Account acc = new Account();
            acc.FirstName = 'Test' + i;
            acc.LastName = 'Account!s';
            acc.cm_TradingName__c = 'test';
            acc.Type = type;
            acc.LLC_BI__Credit_Rating__c = creditRating;
            acc.AccountNumber = '12345678';
            acc.cm_NominatedLoanAccount__c = loan;

            acc.PersonBirthdate = Date.valueOf('2023-05-25');
            acc.cm_TotalDirectSMEExposure__c = exposure;

            accList.add(acc);
        }
        insert accList;
        return accList;
    }

    //create record for product line
    public static LLC_BI__Product_Line__c createProductLine(){
        LLC_BI__Product_Line__c pl = new LLC_BI__Product_Line__c();
        pl.Name = 'SB&A';

        insert pl;
        return pl;
    }

    //create record for product type
    public static LLC_BI__Product_Type__c createProductType(String accType, Id productLine){
        LLC_BI__Product_Type__c pt = new LLC_BI__Product_Type__c();
        pt.cm_AccountType__c = accType;
        pt.LLC_BI__Product_Line__c = productLine;

        insert pt;
        return pt;
    }

    //create record for product reference
    public static LLC_BI__Product__c createProductReference(String accType, Id productType, String prodName){
        LLC_BI__Product__c prod = new LLC_BI__Product__c();
        prod.cm_AccountType__c = accType;
        prod.Name = prodName;
        prod.LLC_BI__Product_Type__c = productType;

        insert prod;
        return prod;
    }

    //create record for legal entities
    public static List<LLC_BI__Legal_Entities__c> createLegalEntity(Integer numOfLegal, Id loan, Id account, Boolean primary, String borrowerType){
        List<LLC_BI__Legal_Entities__c> legalList = new List<LLC_BI__Legal_Entities__c>();

        for(integer i=0; i<numOfLegal; i++){
            LLC_BI__Legal_Entities__c legal = new LLC_BI__Legal_Entities__c();
            legal.LLC_BI__Loan__c = loan;
            legal.LLC_BI__Account__c = account;
            legal.LLC_BI__Borrower_Type__c = borrowerType;
            legal.LLC_BI__Contingent_Type__c = 'Joint & Several';
            legal.LLC_BI__Contingent_Amount__c = 1500;
            legal.cm_PrimaryGuarantorApplicant__c = primary;

            legalList.add(legal);
        }
        insert legalList;
        return legalList;
    }

    //create record for pricing stream
    public static LLC_BI__Pricing_Stream__c createPricingStream(Id loan){
        LLC_BI__Pricing_Stream__c pricingStream = new LLC_BI__Pricing_Stream__c();
        pricingStream.LLC_BI__Loan__c = loan;
        pricingStream.LLC_BI__Is_Rate_Stream__c = true;
        insert pricingStream;
        return pricingStream;
    }

    //create record for pricing rate
    public static LLC_BI__Pricing_Rate_Component__c createPricingRate(Id loan, Id pricingStream){
        LLC_BI__Pricing_Rate_Component__c pricingRate = new LLC_BI__Pricing_Rate_Component__c();
        pricingRate.cm_Loan__c = loan;
        pricingRate.LLC_BI__Index__c = 'BOI_2J';
        pricingRate.LLC_BI__Rate__c = 5;
        pricingRate.LLC_BI__Pricing_Stream__c = pricingStream;
        pricingRate.LLC_BI__Next_Interest_Rate_Change_Date__c = date.today();
        insert pricingRate;
        return pricingRate;
    }
    
    public static String returnLoanQuery(String startDateParam, String endDateParam){
        String sd = startDateParam;
        String ed = endDateParam;
        Time setTime = Time.newInstance(15, 30, 00, 00);
        Date startDate = date.valueOf(sd);
        Date endDate = date.valueOf(ed);
        Datetime startDatetime = datetime.newInstance(startDate, setTime.addMinutes(1));
        Datetime endDatetime = datetime.newInstance(endDate, setTime);
        String SDFormatted = startDatetime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        String EDFormatted = endDatetime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

        String query = 'Select Name,LLC_BI__Product_Type__c,cm_ApplicationNumber__c,cm_SortCode__c, cm_Sort_Code__c, cm_DebitRateCode__c, LLC_BI__InterestRate__c, cm_Term__c, ';
        query += 'cm_MainCurrentAccount__c,cm_MarketClassification__c,cm_Ready_for_Booking_Date_Time__c,LLC_BI__Amount__c, ';
        query += 'cm_Loan_Purpose__c,LLC_BI__Term_Months__c, LLC_BI__Account__r.Name, LLC_BI__Account__r.PersonBirthdate, LLC_BI__Account__r.Type, LLC_BI__Account__r.cm_SortCode__c, ';
        query += 'LLC_BI__Account__r.LLC_BI__Credit_Rating__c,LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.cm_AccountType__c, LLC_BI__Account__r.cm_TotalSMEExposure__c, ';
        query += '(Select LLC_BI__Account__r.Name, LLC_BI__Borrower_Type__c, LLC_BI__Account__r.Type, cm_PrimaryGuarantorApplicant__c from LLC_BI__Legal_Entities__r order by CreatedDate), ';
		query += '(Select LLC_BI__Index__c, LLC_BI__Rate__c from Pricing_Rate_Components__r where LLC_BI__Pricing_Stream__r.LLC_BI__Is_Rate_Stream__c = true), ';
        query += 'LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.CreatedDate, LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Category__c, LLC_BI__Product_Reference__r.cm_AccountType__c  ';
        query += 'from LLC_BI__Loan__c where cm_Ready_for_Booking_Date_Time__c >=' + SDFormatted + ' and cm_Ready_for_Booking_Date_Time__c <=' + EDFormatted +'';
        
        return query;
    }
    public static Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> returnBookingSettings(){
        Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings = cm_Utilities.getAllTransformationSetting();
        return bookingSettings;
    }
    
    public static String returnParams(){
        String params = '[';
        params += '{"DeveloperName":"TestDevName", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"TestColumn", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"LLC_BI__Product_Type__c"},';  
        params += '{"DeveloperName":"Private_Banking_Indicator", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Private Banking", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"cm_SortCode__c"},';
        params += '{"DeveloperName":"BOI_NSC", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"BoiNSC", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"cm_SortCode__c"},';
        params += '{"DeveloperName":"RecordType", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Record Type", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"LLC_BI__Product_Type__c"},';
        params += '{"DeveloperName":"RecordType", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Record Type", "cm_Target_Csv_File__c":"Current Account", "cm_Source_Field__c":"LLC_BI__Product_Type__c"},';
        params += '{"DeveloperName":"Statement_Day_of_Month", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Statement day of month", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"cm_Ready_for_Booking_Date__c"},';
        params += '{"DeveloperName":"Statement_Next_Due_Date", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Statement next due", "cm_Target_Csv_File__c":"Loan Account", "cm_Source_Field__c":"cm_Ready_for_Booking_Date__c"},';
        params += '{"DeveloperName":"Date_of_Review", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Date of review", "cm_Target_Csv_File__c":"Loan_Account.Current_Account", "cm_Source_Field__c":"cm_Ready_for_Booking_Date__c"},';
        
        // Parent fields & Objects
        params += '{"DeveloperName":"dob", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"testdob", "cm_Target_Csv_File__c":"Loan_Account.Current_Account", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"PersonBirthdate"},';
        params += '{"DeveloperName":"testName", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Name", "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"Name"},';
        params += '{"DeveloperName":"testCredit", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"TestCredit", "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"LLC_BI__Credit_Rating__c"},';
        params += '{"DeveloperName":"Lending_Officer_Code", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"Lending", "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Account__r", "cm_Parent_Field__c":"cm_TotalSMEExposure__c"},';
       
        //multi-level
        params += '{"DeveloperName":"aType","cm_Target_Column__c":"aType", "cm_Source_Object__c":"LLC_BI__Loan__c",  "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r", "cm_Parent_Field__c":"cm_AccountType__c"},';
        params += '{"DeveloperName":"aDate","cm_Target_Column__c":"aDate", "cm_Source_Object__c":"LLC_BI__Loan__c",  "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r", "cm_Parent_Field__c":"CreatedDate"},';
        params += '{"DeveloperName":"aCat","cm_Target_Column__c":"aCat", "cm_Source_Object__c":"LLC_BI__Loan__c",  "cm_Target_Csv_File__c":"Loan Account", "cm_Parent_Object__c":"LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r", "cm_Parent_Field__c":"LLC_BI__Category__c"},'; 

        params += '{"DeveloperName":"testNull", "cm_Target_Column__c":"tn",  "cm_Target_Csv_File__c":"Loan_Account.Current_Account", "cm_Default_Value__c":"null"},';
        params += '{"DeveloperName":"ledgerChild", "cm_Source_Object__c":"LLC_BI__Loan__c", "cm_Target_Column__c":"ledgerFields", "cm_Target_Csv_File__c":"Loan Account", "cm_Child_Object__c":"LLC_BI__Legal_Entities__r", "cm_Child_Field__c":"LLC_BI__Account__r.Name"},';
        params += '{"DeveloperName":"testDefault", "cm_Target_Column__c":"td",  "cm_Target_Csv_File__c":"Current Account", "cm_Default_Value__c":"N"}';
        params += ']';
        
        return params;
    }
    
    public static String transParams(){
        string transParams = '[';
        transParams += '{"CM_SourceAPI__c":"LLC_BI__Product_Type__c", "CM_SourceText__c":"Current Account","CM_TargetType__c":"String","CM_TargetValue__c":"143"},';
        transParams += '{"CM_SourceAPI__c":"LLC_BI__Product_Type__c", "CM_SourceText__c":"Loan Account","CM_TargetType__c":"String","CM_TargetValue__c":"117"},';
        transParams += '{"CM_SourceAPI__c":"cm_SortCode__c", "CM_SourceText__c":"902565","CM_TargetType__c":"String","CM_TargetValue__c":"1"},';
        transParams += '{"CM_SourceAPI__c":"cm_AccountType__c", "CM_SourceText__c":"00","CM_TargetType__c":"String","CM_TargetValue__c":"1"}';
        transParams += ']';
        
        return transParams;
    }
    
    public static Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> bookingSettings(){
        List<CM_TransformationSetting_CMD__mdt> transformationMetadata = [SELECT DeveloperName, CM_SourceAPI__c, CM_SourceText__c, CM_TargetType__c, CM_TargetValue__c, cm_Target_Value02__c, cm_Target_Value03__c, cm_Target_Value04__c, cm_Target_Value05__c FROM CM_TransformationSetting_CMD__mdt]; 
        transformationMetadata = (List<CM_TransformationSetting_CMD__mdt>) JSON.deserialize(transParams(), List<CM_TransformationSetting_CMD__mdt>.class);
        
        Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>> settingMap = new  Map<String , List<Map<String , CM_TransformationSetting_CMD__mdt>>>();
        Map<String , CM_TransformationSetting_CMD__mdt> atypeMap = new Map<String , CM_TransformationSetting_CMD__mdt>();
        List<Map<String , CM_TransformationSetting_CMD__mdt>> atypeList  = new List<Map<String, CM_TransformationSetting_CMD__mdt>>();
        
        for (CM_TransformationSetting_CMD__mdt transValues: transformationMetadata) {
            atypeMap.put(transValues.CM_TargetValue__c , transValues);
            atypeList.add(atypeMap);
            settingMap.put(transValues.CM_SourceAPI__c , atypeList);
        }
        
        return settingMap;
    }
    
    // Method that creates Relationship that accepts parameter to determine if it is a person account
    public static List<Account> createAccountWithRecordtype(Integer numOfAcc, Id recordTypeId){
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<numOfAcc; i++){
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            acc.cm_TradingName__c = 'test';
            acc.RecordTypeId = recordTypeId;
            
            accList.add(acc);
        }
        insert accList;
        return accList;
    }
    
    // Method that creates 12 Monthly Statements
    public static List<MonthlyStatement__c> createMonthlyStatements(String loanId, Decimal AvgCreditBalance, Decimal WorstBalance, Decimal Turnover) {
        
        List<MonthlyStatement__c> monthlyStatementsList = new List<MonthlyStatement__c>();
        MonthlyStatement__c m1 = new MonthlyStatement__c(Loan__c = loanId,
                                                         cm_AverageCreditBalance__c = AvgCreditBalance,
                                                         cm_WorstBalance__c = WorstBalance,
                                                         cm_Turnover__c = Turnover,
                                                         cm_MonthEndDate__c = Date.Today().toStartOfMonth().addDays(-1));
        monthlyStatementsList.add(m1);
        for(Integer ctr = 1; ctr < 12; ctr++) {
            MonthlyStatement__c mnthlyStmnt = new MonthlyStatement__c(Loan__c = loanId,
                                                                      cm_AverageCreditBalance__c = AvgCreditBalance,
                                                                      cm_WorstBalance__c = WorstBalance,
                                                                      cm_Turnover__c = Turnover,
                                                                      cm_MonthEndDate__c =  Date.Today().addMonths(-ctr).toStartOfMonth().addDays(-1));
            monthlyStatementsList.add(mnthlyStmnt);
        }
        
        insert monthlyStatementsList;
        return monthlyStatementsList;
    }
    
    // Create Sample User for cm_AuditLogReportTest class
    public static List<User> createTestUser(List<String> getProfileParam){
        
        List<Profile> selectUserProfile = new List<Profile>([SELECT Id FROM Profile WHERE Name IN:getProfileParam]);
        List<User> userListToCreate = new List<User>();
        Integer nameCount = 0;
        for(Profile iterateProfile : selectUserProfile){
            User newUser = new User(
                Username = 'test_' + math.random() + '@test.com',
                FirstName = 'Test-First' + nameCount,
                LastName = 'Test-Last' + nameCount,
                Alias = 'test',
                Email = 'test' + math.random() + '@test.com',
                ProfileId = iterateProfile.Id,
                EmailEncodingKey = 'UTF-8',
                TimeZoneSidKey = 'Europe/Dublin',
                LocaleSidKey = 'en_IE',
                LanguageLocaleKey = 'en_US'
        	);
            userListToCreate.add(newUser);
            nameCount++;
        }
        
        insert userListToCreate;
        
        return userListToCreate;
        
    }
}