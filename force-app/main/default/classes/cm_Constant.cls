/**************************************************************************************************
* @Author:      Jan Reimil Cabantog
* @Date:        26/04/2023https://bankofireland--r1dev.sandbox.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
* @Description: This class will be use to store constant values
* @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]  
***************************************************************************************************/
public class cm_Constant {

    //use to validate if loan.cm_Loan_Purpose__c has a value of Dairy or Breeding Stock Purchase or Short-term Livestock purchase
    public static final string purposefieldStockLoanIndicator = 'Dairy or Breeding Stock Purchase,Short-Term Livestock Purchase,Tillage Inputs'; //updated from Breeding or Dairy Stock Purchase to Dairy or Breeding Stock Purchase base on the picklist values
    //use to validate to validate rel.type
    public static final string validateschoolChurchCharitiesClubsIndicator = 'School,Church,Charity,Club';
    
    public static final string stringY = 'Y';
    
    public static final string stringN = 'N';
    
    public static final string stringA = 'A';
    
    public static final string stringB = 'B';
    
    public static final string stringC = 'C';
    
    public static final string stringD = 'D';
    
    public static final string stringO = 'O';
    
    public static final string stringL = 'L';
    
    public static final string stringE = 'E';
    
    public static final string string01 = '01';
    
    public static final string string04 = '04';
  
    public static final string string05 = '05';
    
    public static final string bridgingLoans = 'Bridging Loans';
    
    public static final string SOLE_TRADER = 'Sole Trader';
    
    public static final string allPartnership = 'Limited Partnership,Registered Partnership,Unregistered Partnership';
    
    public static final string Homeowner = 'Homeowner';
    
    public static final string livingWithParents = 'Living with parents';
    
    public static final string Tenant = 'Tenant';
    
    public static final string Other = 'Other';
    
    public static final string Single = 'Single';
    
    public static final string Married = 'Married';
    
    public static final string Divorced = 'Divorced';
    
    public static final string LegallySeparated = 'Legally Separated';
    
    public static final string Widowed = 'Widowed';
    
    public static final string NUM_ZERO = '0';
    
    public static final string NUM_ONE = '1';
    
    public static final string NUM_TWO = '2';
    
    public static final string NUM_THREE = '3';
    
    public static final string NUM_FOUR = '4';
    
    public static final string NUM_FIVE = '5';

    public static final string NUM_SIX = '6';

    public static final string NUM_ELVN = '11';

    public static final string ZERO_TWO = '02';

    public static final string DBL_ZERO = '00';
    
    public static final string Prospect = 'Prospect';
    
    public static final string Customer = 'Customer';
    
    public static final string BORROWER = 'Borrower';
    
    public static final string APPLICANT = 'Applicant';
    
    public static final string Guarantor = 'Guarantor';
    
    public static final integer Ninetynine = 99;
    
    //@Revision(s): 05/05/2023 - use to format the fields in generated CSV file which have a DATE/DATETIME data type
    public static final string DateFormat = Label.cm_DateFormat;
    
    public static final String ACCOUNT_TYPE = 'Type';
    
    public static final String LOAN_PURPOSE = 'CM_Loan_Purpose__c';
    
    public static final String REASON_CODE_NARRATIVE = 'cm_ReasonCodeNarrative__c';
    
/**************************************************************************************************
* @Revision(s):
* Date: 13/07/2023
* Change Reference: transferred all constant values
* Changed By: Rolie John Ewican
* Description: These are new constant values that are being used in all different apex classes
**************************************************************************************************/
    
    public static final String ADHOC_JOB_NAME_PREFIX = Label.cm_BKK_On_Demand_Schedule_Name;
    
    public static final String DELIMITER = Label.cm_Booking_Delimiter;
    
    public static final String AGRI_INDICATOR = Label.cm_Booking_AgriIndicator;
    
    public static final String TODAY = 'TODAY'; 
    
    @TestVisible
    public static Integer ADD_SEC = 10;
    
    @TestVisible
    public static String BATCH_NAME = 'cm_BookingBatch';
    
    @TestVisible
    public static Date DATE_TODAY = Date.today();
    
    public static final String BOOKING = 'Booking';
    
    public static final String BOOKING_DATE_TYPE = 'Booking_Date_Type';

    public static final List<String> BOOKING_TARGET_FILES = new List<String>{'Loan Account', 'Current Account', 'Control'};

    public static final Map<String, String> BOOKING_FILES_MAP = new Map<String, String>{'Current' => 'Overdraft', 'Loan' => 'Loan', 'Control' => 'Control'};        

    public static final List<String> S_OBJECTS = new List<String>{'LLC_BI__Account__r', 'LLC_BI__Legal_Entities__r', 'cm_PrimaryGuarantorApplicant__c'};

    public static final List<String> FIELD_NAME = new List<String>{'Type', 'Name', 'cm_SortCode__c', 'cm_MainAccountNumber__c', 'LLC_BI__Borrower_Type__c', 'LLC_BI__Index__c', 'cm_TotalSMEExposure__c', 'Calculate Age'};

	public static final List<String> BORROWER_TYPES = new List<String>{'Co-Borrower'};
        
    public static final Integer LENDG_VALUE_120K = 120000;
    
    public static final Integer LENDG_VALUE_500K = 500000;
    
    public static final Integer LENDG_VALUE_1M = 1000000;
    
    public static final Integer FIVE = 5;
    
    public static final Integer FOUR = 4;

    public static final String MONDAY = 'Monday';

    public static final String DAY_FORMAT = 'EEEE';

    public static final String LEDGER = 'Ledger';

    public static final String DBT_INT_RATE = 'Debit_Interest_Rate';

    public static final String DBT_RATE_CDE = 'Debit_Rate_Code'; 
    
    public static final String BKK_CSV_FILE_NAME = 'BKK Loan Files';

    public static final String CSV_FILE_EXTENSION = '.csv';

    public static final String CSV_FILE_NAME_INTRO = 'nCino_';

    public static final String CSV_FILE_NAME_MID = '_BKK_';

    public static final String PRD_TYPE_LOAN = 'Loan';

    public static final String PRD_TYPE_OVERDRAFT = 'Overdraft';

    public static final String PRD_TYPE_CONTROL = 'Control';
    
    public static final String EMPTY_STRING = '';

    public static final String B365 = 'Banking_365';

    public static final String CONTENT_TYPE = 'text/csv';

    public static final String BOI_NSC = 'BOI_NSC';

    public static final String EX_ACC_REC = 'Existing_Account_Record';

    public static final String TRM_MTH = 'cm_Term__c';

    public static final String MARKET_CLASS = 'Market_Class';

    public static final String FARM_LOAN = 'Farm_Loan';
    
    public static final String DEBIT_RATE_CODE = 'Debit_Rate_Code';
        
    public static final String DEBIT_INTEREST_RATE = 'Debit_Interest_Rate';

    public static final String LOC = 'Lending_Officer_Code';
    
    public static final String SHRT_NAME_SFX = '/LN';

    public static final String CUST_TYPE = 'Customer_Type';
    
    public static final String SOLE_TRDR = 'Sole Trader';
    
    public static final String PRIV_BNKNG_INDCTR = 'Private_Banking_Indicator';
        
    public static final String PRIV_BNKNG_INDCTR_VALUE = Label.cm_Private_Banking_Indicator;
	
    public static List<String> BKK_BATCH_TIMING = Label.cm_BKK_batch_timing.trim().split(',');
    
    public static final Time TIME_SET = time.newInstance(Integer.valueOf(BKK_BATCH_TIMING[0]),
                                                         Integer.valueOf(BKK_BATCH_TIMING[1]),
                                                         Integer.valueOf(BKK_BATCH_TIMING[2]),
                                                         Integer.valueOf(BKK_BATCH_TIMING[3]));
    
    public static datetime DATE_TIME_TDY = datetime.now();
    
    public static final String FORMAT_GMT = 'yyyy-MM-dd\'T\'HH:mm:ss.SSSZ';
    
    public static final String BKK_STATUS_IN_PROGRESS = 'IN PROGRESS';
    
    public static final String BKK_STATUS_REJECT = 'REJECTED';
    
    public static List<String> BKK_STATUS_ADHOC = Label.cm_bkk_status_adhoc.trim().replace('null', '').split(',');

    public static List<String> BKK_STATUS_STANDARD = Label.cm_bkk_status_standard.trim().replace('null', '').split(',');
	
    public static final String FROM_DATE = ' FROM ';
    
    public static final String TO_DATE = ' TO ';
    
    public static List<String> AUDIT_LOG_USER_PROFILE = Label.cm_Include_Login_User_by_Profile.split(',');
	
    public static Set<String> AUDIT_EXCLUDE_SECTION = new Set<String>(Label.cm_Audit_Trail_Exclude_Sections.replace(' ', '').split(','));

    public static List<String> AUDIT_LOG_RECIPIENTS = Label.cm_Audit_Trail_Email_Recipients.trim().split(',');

    public static List<String> AUDIT_CSV_HEADER = new List<String>{Label.cm_Login_History_Report_CSV_Header, Label.cm_Audit_Trail_Report_CSV_Header};
    
    public static List<String> AUDIT_FILE_NAMES = new List<String>{Label.cm_Login_History_FileName, Label.cm_Audit_Trail_FileName};
    
    public static final String USER_ACTION = Label.cm_Login_History_User_Action.trim();

    public static final String NEW_LINE_BREAK = '\n';
    
    public static final String DD_MM_YYYY_TIME_FORMAT = 'dd/MM/yyyy kk:mm:ss';
    
    public static final String DD_MM_YYYY_FORMAT = 'dd/MM/yyyy';
    
    public static final Integer AUDIT_DAY_PERIOD = Integer.valueOf(Label.cm_Audit_Trail_Period_of_Day);
    
    public static final Time SET_TIME = Time.newInstance(01, 00, 00, 00);
    
    public static final Datetime SET_DATE_TIME = Datetime.newInstance(Date.Today(), SET_TIME);
    
    public static final String AUDIT_EMAIL_SUBJECT = Label.cm_Audit_Trail_Email_Subject + ' (' + String.valueof(DATE_TIME_TDY.addDays(- + AUDIT_DAY_PERIOD).formatGmt(DD_MM_YYYY_FORMAT)) + ')';

    public static final String AUDIT_MESSAGE_BODY = Label.cm_Audit_Trail_Report_Email_Body + FROM_DATE + SET_DATE_TIME.addDays(- + AUDIT_DAY_PERIOD).addHours(1).formatGmt(DD_MM_YYYY_TIME_FORMAT) + TO_DATE + SET_DATE_TIME.addHours(1).formatGmt(DD_MM_YYYY_TIME_FORMAT);
    
    public static final String AUDIT_LOGIN_ACTION = 'Login';
    
    public static Integer COUNTER = 0;
    
    public static final Integer LDGR_MAX_CHAR = 30;

    public static final String THIRTEEN = '13';
    
    public static final String TWENTY_THREE = '23';
    
    public static final String SO_START_DATE = 'SO_Start_Date';
    
    public static final String DRAWDOWN_AMOUNT = 'Drawdown_Amount';
    
    public static final String DD_NSC = 'DD_NSC';
    
    public static final String PAYOFF_YES = 'Yes';
    
    public static final String PAYOFF_NO = 'No';
    
    public static final String DD_ACCOUNT = 'DD_ACCOUNT';
    
    public static final String SO_START_AMOUNT = 'SO_Start_Amount';
    
    public static final String SO_FREQ_SPAN = 'SO_Frequency_Span';
    
    public static final String SO_CATEGORY = 'So_Category';
    
    public static final String RETRY_INDICATOR = 'Retry_Indicator';
    
    public static final String SO_Retry_Indicator = 'SO_Retry_Indicator';
    
    public static final String Account_Re_Opening_Indicator = 'Account_Re_Opening_Indicator';
    
    public static final String Payments_Retry_Indicator = 'Payments_Retry_Indicator';
    
    public static final String Overdraft_Retry_Indicator = 'Overdraft_Retry_Indicator';

    public static final String Permission_Amend_Retry_Indicator = 'Permission_Amend_Retry_Indicator';
    
    public static final String N_VALUE = 'N';
    
    public static final String Y_VALUE = 'Y';
    
    public static final Map<String, String> BKK_DROP_COUNTER = new Map<String, String>{'09' => '1', '10' => '1', '11' => '2', '12' => '2', '13' => '2', '14' => '3'};
        
    public static final String DROP_NO4 = '4';
    
	public static final String PRE_FULFILMENT = Label.cm_Pre_Fulfilment_Loan_Stage;
    
    public static string BKK_SCHEDULER_TEST_CASE = 'For_Test_Cases';
    
    public static final String READY_FOR_BOOKING_DATE_TIME = 'cm_Ready_for_Booking_Date_Time__c';
    
    public static final String BENF_NAME = 'BENF_NAME';
    
    public static final String PAYER_NAME = 'PAYER_NAME';
    
    public static final String YES_VALUE = 'Yes';
    
    public static final String NO_VALUE = 'No';
    
/**************************************************************************************************
* @Revision(s):
* Date: 13/07/2023
* Change Reference: constant values used in regex
* Changed By: John Gamboa
* Description: Constant values will be used in fields that requires regex validation.
**************************************************************************************************/
    public static final String string_to_number = '[a-zA-Z]{1,}|\\-';
    public static final String alphanumeric = '^[a-zA-Z0-9-\\w\\s]+$';
    public static final String numbers_value_regex = '([0-9]+)';
    public static final String numbers_with_decimal_regex = '([0-9]+.[0-9]+$)';
    public static final String SPCL_CHAR = '[,\'*.()!&-]';
}