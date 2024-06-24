public class cm_CreateTestRecordForBookingBatch {
  	
    private static final String TODAY_PREFIX ='TODAY';
    private Date TODAY_DATE = Date.today();
    private Datetime recordDate;
    private Integer recordNumber;
    private String prodLine;
    private String product;
    private String prodType;
    private String marketClassification;
    private String recordType;
    private String type;
    private String creditRating;
    private Integer Exposure;
    private String loanName;
    private String loanPurpose;
    private Integer termInMonths;
    private String loanStatus;
    private String loanTerm;
    private Boolean isPrimary;
    private String legalEntityType;
    private String debitRateCode;
    private Integer interestRateCode;
    private Integer accountNumber; 
    private String sortCodeNumber;
    private Date closeDate;
    private Integer bulletPayAmount;
    private String creditGrade;
    private String prodName;
    private String accountSubType;
    
    // Constructor
    public void runScript(Integer recordCount, 
                          String recordDate, 
                          String prodLine, 
                          String prodType, 
                          String debitRateCode, 
                          Integer interestRateCode,
                          String MClassification, 
                          String recordType,
                          String Type,
                          String creditRating,
                          Integer exposure,
                          String loanPurpose,
                          Integer termInMonths,
                          String loanStatus, 
                          String loanTerm,
                          Boolean isPrimary, 
                          Integer bulletPayAmount, 
                          String creditGrade, 
                          String prodName, 
                          String accountSubType, 
                          String sortCodeNumber)
    {
        this.recordDate = recordDate == CM_Constant.TODAY ? CM_Constant.DATE_TIME_TDY : datetime.valueOf(recordDate);
        this.recordNumber = recordCount;
        this.prodLine = prodline;
        this.prodType = prodType;
        this.marketClassification = MClassification;
        this.recordType = recordType;
        this.creditRating = creditRating;
        this.type = Type;
        this.Exposure = exposure;
        this.loanPurpose = loanPurpose;
        this.termInMonths = termInMonths;
        this.loanStatus = loanStatus;
        this.loanTerm = loanTerm;
        this.isPrimary = isPrimary;
        this.debitRateCode = debitRateCode;
        this.interestRateCode = interestRateCode;
        this.accountNumber = Integer.valueof((Math.random() * 100000000));
        this.sortCodeNumber = sortCodeNumber;
        this.bulletPayAmount = bulletPayAmount;
        this.closeDate = date.valueOf(this.recordDate);
        this.creditGrade = creditGrade;
        this.prodName = prodName;
        this.accountSubType = accountSubType;

        // Check product type
        /* if(prodType == 'Loan Account'){
            this.product = 'Ordinary Loan Account';
        }else{
            this.product = 'Current Loan Account';
        } */

        createBKKTestRecord();
    }
    // Methods to create all records
    private void createBKKTestRecord(){
        LLC_BI__Loan__c loanNominatedId = loanNominatedAccount(recordNumber, prodLine, prodType, product, recordDate, marketClassification, accountNumber, sortCodeNumber);
        Id recordTypeId = getRecordType(recordType);
        String prodLLCName = createProduct(prodType, prodName, accountSubType);
        List<Account> accountId = createAccount(recordNumber, type, creditRating, loanNominatedId.Id, recordType, recordTypeId, Exposure);
        List<Id> productPackageId = createProdPackage(recordNumber, accountId);
        List<Id> createdLoadIds = createLoanRecords(recordNumber, debitRateCode, interestRateCode, prodLine, prodType, 
                                                    prodLLCName, loanPurpose, termInMonths, loanStatus, 
                                                    recordDate, marketClassification, loanTerm, productPackageId, 
                                                    accountId, accountNumber, sortCodeNumber, closeDate, bulletPayAmount, creditGrade, loanNominatedId);
        
        createLegalEntity(createdLoadIds, accountId, type, recordType, isPrimary);
        
	}
    
    // Create record for Nominated Account
    public static LLC_BI__Loan__c loanNominatedAccount(Integer recordNumber, String prodLine, String prodType, String product, Datetime bookingDate, String marketClassification, Integer accountNumber, String sortCodeNumber){
		Integer randomisedAccNumber;
        for(Integer countNumOfRecords = 0; countNumOfRecords < recordNumber; countNumOfRecords++){
            randomisedAccNumber = Integer.valueof((Math.random() * 100000000));
        }
        system.debug('randomisedAccNumber > ' + randomisedAccNumber);
        LLC_BI__Loan__c nominatedLoan = new LLC_BI__Loan__c();
        nominatedLoan.Name = 'Nominated Loan';
        nominatedLoan.LLC_BI__Product_Line__c = prodLine;
        nominatedLoan.LLC_BI__Product_Type__c = prodType;
        nominatedLoan.LLC_BI__Product__c = product;
        nominatedLoan.cm_Loan_Purpose__c = 'Working Capital';
        nominatedLoan.LLC_BI__Term_Months__c = 24;
        nominatedLoan.LLC_BI__Status__c = 'Open';
        nominatedLoan.cm_Account_Number__c = String.valueOf(randomisedAccNumber);
        nominatedLoan.cm_Sort_Code__c = sortCodeNumber;
        nominatedLoan.LLC_BI__Stage__c = 'Booked';
        nominatedLoan.LLC_BI__Amount__c = 10000;
        nominatedLoan.cm_MarketClassification__c = marketClassification;
        
        system.debug('nominatedLoan > ' + nominatedLoan);
        insert nominatedLoan;
        
        return nominatedLoan;
    }
    
    // Create Product LLC
    public static String createProduct(String prodType, String prodName, String accountSubType){
        String productName = prodName + ' ' + prodType;
        String product = '';
        system.debug('productName > ' + productName);
         system.debug('prodType > ' + prodType);
        LLC_BI__Product_Type__c prodTypeId = [SELECT id, Name, 
                                              (SELECT Id, Name, LLC_BI__Product_Type__c FROM LLC_BI__Products__r WHERE Name = :productName) 
                                              FROM LLC_BI__Product_Type__c WHERE Name = :prodType LIMIT 1];
        if (prodTypeId.LLC_BI__Products__r.size() > 0) {
        	product = prodTypeId.LLC_BI__Products__r[0].Name;    
        }
        
        system.debug('product > ' + product);
        return product;
        
    }
    // Create record for Account
    public static List<Account> createAccount(Integer numOfAccount, 
                                         String type, 
                                         String creditRating, 
                                         Id loanNominatedId, 
                                         String recordTypeName, 
                                         Id recordType, 
                                         Integer exposure){
        List<Account> createAccountList = new List<Account>();
        List<Id> accountIds = new List<Id>();
        
        
        for(Integer countAccount = 0; countAccount < numOfAccount; countAccount++){
            Account createdAccount = new Account();
            if(recordTypeName == 'Person Account' || recordTypeName == 'Prospect Individual'){
                createdAccount.FirstName = 'Sample ' + type;
                createdAccount.LastName = '' + countAccount;
                createdAccount.cm_TradingName__c = createdAccount.FirstName + ' ' + createdAccount.LastName;
                createdAccount.PersonBirthdate = Date.valueOf('2010-05-25');
            }else{
                createdAccount.Name = 'Business Account ' + countAccount;
                createdAccount.cm_TradingName__c = createdAccount.Name;
            }
            createdAccount.Type = type;
            createdAccount.LLC_BI__Credit_Rating__c = creditRating;
            createdAccount.cm_NominatedLoanAccount__c = loanNominatedId;
            createdAccount.RecordTypeId = recordType;
            createdAccount.cm_TotalDirectSMEExposure__c = exposure;
            
            createAccountList.add(createdAccount);
        }
        
            
        insert createAccountList;
        return createAccountList;
    }
    
    // Get Record type for Account
    public static Id getRecordType(String recordTypeName){
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for(RecordType recordType : [SELECT Id, Name FROM RecordType]){
             if(recordType.Name == 'Business'){
                recordTypeMap.put( recordType.Name, recordType.Id);
             }
            if(recordType.Name == 'Person Account'){
                recordTypeMap.put(recordType.Name, recordType.Id);
            }
            if(recordType.Name == 'Prospect Individual'){
                recordTypeMap.put(recordType.Name, recordType.Id);
            }
		}
        system.debug(recordTypeMap);
        if(!recordTypeMap.containsKey(recordTypeName)){
           	return null;
        }else {
            return recordTypeMap.get(recordTypeName);
        }
        
    }
    
    // Create product Package
    public static List<Id> createProdPackage(Integer numOfRecords, List<Account> accountRecords){
        List<LLC_BI__Product_Package__c> insertProdPackage = new List<LLC_BI__Product_Package__c>();
        List<Id> prodPackageId = new List<Id>();
        
        for(Integer counter = 0; counter < numOfRecords; counter++){
            LLC_BI__Product_Package__c prodPackage = new LLC_BI__Product_Package__c();
        	prodPackage.Name = accountRecords[counter].Name;
            
            insertProdPackage.add(prodPackage);
        }
        
        
        system.debug('prodPackage > ' + insertProdPackage);
        insert insertProdPackage;
        
        for(LLC_BI__Product_Package__c packageId : insertProdPackage){
            prodPackageId.add(packageId.Id);
        }
        return prodPackageId;
    }
    
    // Create Loan Record
    public static List<Id> createLoanRecords(Integer numOfRecords,
                                             String debitRateCode, 
                                             Integer interestRateCode,
                                             String prodLine, 
                                             String prodType, 
                                             String product, 
                                             String loanPurpose, 
                                             Integer termInMonths, 
                                             String loanStatus,
                                             Datetime bookingDateTime,
                                             String marketClass,
                                             String loanTerm,
                                             List<Id> loanProdPackage,
                                             List<Account> accountId, 
                                             Integer accountNumber, 
                                             String sortCodeNumber,
                                             Date closeDate, 
                                             Integer bulletPayAmount, 
                                             String creditGrade, 
                                             LLC_BI__Loan__c nominatedLoan){
        List<LLC_BI__Loan__c> loanList = new List<LLC_BI__Loan__c>();
		List<LLC_BI__Loan__c> updateLoan = new List<LLC_BI__Loan__c>();
        List<Id> loanIds = new List<Id>();
		
                                                 
		for(Integer iterateLoan = 0; iterateLoan < numOfRecords; iterateLoan++){
            Integer randomAccountNumber = Integer.valueof((Math.random() * 100000000));
            LLC_BI__Loan__c createLoan = new LLC_BI__Loan__c();
            createLoan.Name = 'Sample Loan ' + iterateLoan;
            createLoan.LLC_BI__Product_Line__c = prodLine;
            createLoan.LLC_BI__Product_Type__c = prodType;
            // createLoan.LLC_BI__Product__c = product;
            createLoan.cm_Loan_Purpose__c = loanPurpose;
            createLoan.LLC_BI__Term_Months__c = termInMonths;
            createLoan.LLC_BI__Status__c = loanStatus;
            createLoan.LLC_BI__Amount__c = 10000;
            createLoan.cm_Account_Number__c = String.valueOf(randomAccountNumber);
        	createLoan.cm_Sort_Code__c = sortCodeNumber;
            createLoan.cm_DebitRateCode__c = debitRateCode;
            createLoan.LLC_BI__InterestRate__c = interestRateCode;
            createLoan.LLC_BI__Stage__c = 'Fulfilment';
            createLoan.LLC_BI__CloseDate__c = closeDate;
            createLoan.cm_BulletPayAmount__c = bulletPayAmount;
            createLoan.cm_Ready_for_Booking__c = true;
            createLoan.cm_Ready_for_Booking_Date_Time__c = bookingDateTime;
            createLoan.cm_MarketClassification__c = marketClass;
            createLoan.cm_Term__c = loanTerm;
            createLoan.LLC_BI__Product_Package__c = loanProdPackage[iterateLoan];
            createLoan.LLC_BI__Account__c = accountId[iterateLoan].Id;
            createLoan.cm_SortCode__c = nominatedLoan.cm_Sort_Code__c;
            createLoan.cm_MainCurrentAccount__c = nominatedLoan.cm_Account_Number__c;
			loanList.add(createLoan);                                          
		}
        
		system.debug(loanList);
		insert loanList;
		
		for(LLC_BI__Loan__c loan : loanList){
            loanIds.add(loan.Id);
            loan.cm_CreditGrade__c = creditGrade;
            loan.LLC_BI__Product__c = product;
            updateLoan.add(loan);
        }
		update updateLoan;
        return loanIds;
    }
    
    // Create record for Legal Entity
    public void createLegalEntity(List<id> listLoanId, List<Account> accountId, String accountType, String recordType, boolean isPrimary){
        List<LLC_BI__Legal_Entities__c> createLegal = new List<LLC_BI__Legal_Entities__c>();
        
        for(Id loanId : listLoanId){
            
            // If Sole Trader
            if(accountType == 'Sole Trader'){
                for(Integer countLegal = 0; countLegal < 1; countLegal++){
                    LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                    legalEntity.LLC_BI__Loan__c = loanId;
                    legalEntity.LLC_BI__Account__c = accountId[countLegal].Id;
                    legalEntity.LLC_BI__Borrower_Type__c = 'Borrower';
                    legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                    legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                    legalEntity.cm_PrimaryGuarantorApplicant__c = isPrimary;
                    createLegal.add(legalEntity);
                }
            }
            
            // If Partnership
            if(accountType.contains('Partnership')){
                // Create borrower and Primary Guarantor = True
                for(Integer countLegal = 0; countLegal < 1; countLegal++){
                        LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                        legalEntity.LLC_BI__Loan__c = loanId;
                        legalEntity.LLC_BI__Account__c = accountId[0].Id;
                        legalEntity.LLC_BI__Borrower_Type__c = 'Borrower';
                        legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                        legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                        legalEntity.cm_PrimaryGuarantorApplicant__c = true;
                        createLegal.add(legalEntity);
                    
                }
                // Create borrower type = applicant and primary true
                for(Integer countLegal = 0; countLegal < 1; countLegal++){
                    LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                    legalEntity.LLC_BI__Loan__c = loanId;
                    legalEntity.LLC_BI__Account__c = accountId[1].Id;
                    legalEntity.LLC_BI__Borrower_Type__c = 'Applicant';
                    legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                    legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                    legalEntity.cm_PrimaryGuarantorApplicant__c = true;
                    createLegal.add(legalEntity);
                }
                
                // Create borrower type = applicant and primary false
                Integer countAccount = 2;
                for(Integer countLegal = 0; countLegal < 2; countLegal++){
                    LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                    legalEntity.LLC_BI__Loan__c = loanId;
                    legalEntity.LLC_BI__Account__c = accountId[countAccount].Id;
                    legalEntity.LLC_BI__Borrower_Type__c = 'Applicant';
                    legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                    legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                    legalEntity.cm_PrimaryGuarantorApplicant__c = false;
                    createLegal.add(legalEntity);
                    countAccount++;
                }
            }
            // If Business
            if(accountType.contains('Company')){
                // Create borrower and Primary Guarantor = True
                for(Integer countLegal = 0; countLegal < 1; countLegal++){
                        LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                        legalEntity.LLC_BI__Loan__c = loanId;
                        legalEntity.LLC_BI__Account__c = accountId[0].Id;
                        legalEntity.LLC_BI__Borrower_Type__c = 'Borrower';
                        legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                        legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                        legalEntity.cm_PrimaryGuarantorApplicant__c = true;
                        createLegal.add(legalEntity);
                    
                }
                // Create borrower type = applicant and primary true
                for(Integer countLegal = 0; countLegal < 1; countLegal++){
                    LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                    legalEntity.LLC_BI__Loan__c = loanId;
                    legalEntity.LLC_BI__Account__c = accountId[1].Id;
                    legalEntity.LLC_BI__Borrower_Type__c = 'Applicant';
                    legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                    legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                    legalEntity.cm_PrimaryGuarantorApplicant__c = true;
                    createLegal.add(legalEntity);
                }
                
                // Create borrower type = applicant and primary false
                Integer countAccount = 2;
                for(Integer countLegal = 0; countLegal < 2; countLegal++){
                    LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
                    legalEntity.LLC_BI__Loan__c = loanId;
                    legalEntity.LLC_BI__Account__c = accountId[countAccount].Id;
                    legalEntity.LLC_BI__Borrower_Type__c = 'Applicant';
                    legalEntity.LLC_BI__Contingent_Type__c = 'Joint & Several';
                    legalEntity.LLC_BI__Contingent_Amount__c = Integer.valueof((Math.random() * 1000));
                    legalEntity.cm_PrimaryGuarantorApplicant__c = false;
                    createLegal.add(legalEntity);
                    countAccount++;
                }
            }
        }
        insert createLegal;
        system.debug('Legal Entity > ' + createLegal);
    }
	
    
    public void runSolicitorAccount(Integer numOfRecords) {
        Integer Number_Of_Records = numOfRecords <= 0 ? 5 : numOfRecords; // Number of records to create
        String Date_And_Time = 'TODAY'; // Date of the records where you want to create it's either 'TODAY' or 'YYYY-MM-DD HH-MM-SS-MS';
        String Product_Line = 'SB&A'; // Product line of the Loan
        String Product_Type = 'Loan Account'; // Product Type of the Loan
        String Debit_Rate_Code = 'J-O';
        Integer Interest_Rate_Code = 8;
        String Market_Classification = 'Fishing, Poultry, Fruit Growing - 015'; // Market Class of the Loan
        String Record_Type = 'Business'; // Record type to be used in Account Relationship
        String Type = 'Public Limited Company'; // Type of the Account
        String Credit_Rating = '1M'; // to specify the Credit Rating of the Relationship.
        Integer Total_Direct_SME_Exposure = 800000; //This will populate the Total SME Exposure which reflect the Lending Amount Value in the Lending Office Code
        String Purpose_of_Loan = 'Working Capital'; // Purpose of the Loan
        Integer Term_in_Months = 24; // Term in Months of the Loan
        String Loan_Status = 'Open'; // Status of Loan
        String Loan_Term = '3 months'; // Term of the loan
        Boolean is_Primary = false; // To determine where the borrower type is a primary borrower
        Integer Bullet_Pay_Amount = 1000; // Bullet Pay amount in Loan Object
        String Credit_Grade = '2M'; // Credit grade in the Loan Object
        String Product_Name = 'Solicitor'; // This stands as the name of the Product
        String Account_Sub_Type = '11'; // The field value will populate the Customer type column in the CSV
        String NominatedSortCode  = '902565';
        
        
        runScript(Number_Of_Records, Date_And_Time, Product_Line, Product_Type, Debit_Rate_Code, Interest_Rate_Code, 
                      Market_Classification, Record_Type, Type, Credit_Rating, Total_Direct_SME_Exposure, Purpose_of_Loan, Term_in_Months, 
                      Loan_Status, Loan_Term, is_Primary, Bullet_Pay_Amount, Credit_Grade, Product_Name, Account_Sub_Type, NominatedSortCode);
    }
}