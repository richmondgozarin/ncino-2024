@isTest
public class cm_PortalLoginScreenControllerTest {
	
    static final String TEST_USER = 'Test User';
    static final String TEST_USER_EMAIL = 'testuser@example.com';
    static final String USER = 'User';
    static final String TESTUSER = 'testuser';
    static final String UTF_8 = 'UTF-8';
    static final String EN_US = 'en_US';
    static final String NCINO_COMMUNITY_USER = 'nCino Community User';
    static final String FIRST_NAME = 'Test';
    static final String TIME_ZONE = 'America/Los_Angeles';
        
    @isTest
    static void testCaptureURLOnLoad() {
        // Create an instance of the controller
        cm_PortalLoginScreenController controller = new cm_PortalLoginScreenController();

        // Set up a test PageReference
		PageReference testPageRef = Page.nPortal__PortalLogin; 
        Test.setCurrentPage(testPageRef);

        // Test the captureURLOnLoad method
        PageReference pageRef = controller.captureURLOnLoad();
        String capturedURL = controller.capturedURL;

        // Add your assertions based on what you expect to happen when captureURLOnLoad is called
        System.assertNotEquals(null, capturedURL);
    }

    @isTest
    static void testUpdateUser() {
        Account acc = new Account();
        acc.Name = TEST_USER;
        insert acc;

        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = USER;
        insert con;

        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = :NCINO_COMMUNITY_USER];
        User testUser = new User(
            ContactId = con.Id,
            FirstName = 'Test1',
            LastName = USER,
            Email = TEST_USER_EMAIL,
            Username = TEST_USER_EMAIL,
            Alias = TESTUSER,
            CommunityNickname = 'testuserexample',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'Europe/Dublin',
            LocaleSidKey = 'en_IE',
            EmailEncodingKey = UTF_8,
            LanguageLocaleKey = EN_US
        );
        insert testUser;

        // Set up the test data
        System.runAs(testUser) {
            cm_PortalLoginScreenController controller = new cm_PortalLoginScreenController();

            // Update the user's custom field
            controller.updateUser();

            // Verify that the custom field value has been updated
            User updatedUser = [SELECT Id, cm_TermsofService__c FROM User WHERE Id = :testUser.Id];
            System.assertEquals(true, updatedUser.cm_TermsofService__c);
        }
    }

    @isTest
    static void testFinishLoginFlowHome() {
        Account acc = new Account();
        acc.Name= TEST_USER;
        insert acc;   
        
        Contact con= new Contact();
        con.AccountId=acc.id;
        con.LastName=USER;
        insert con; 
        
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = :NCINO_COMMUNITY_USER];
        User testUser = new User(
            ContactId = con.id,
            FirstName = FIRST_NAME,
            LastName = USER,
            Email = TEST_USER_EMAIL,
            Username = TEST_USER_EMAIL,
            Alias = TESTUSER,
            ProfileId = profile.Id,
            TimeZoneSidKey = TIME_ZONE,
            LocaleSidKey = EN_US,
            EmailEncodingKey = UTF_8,
            LanguageLocaleKey = EN_US,
            cm_TermsofService__c = true
        );
        insert testUser;

        System.runAs(testUser) {
            cm_PortalLoginScreenController controller = new cm_PortalLoginScreenController();
            
            /* Defect NCINO-6275
            controller.currentUser = [SELECT Id, cm_TermsofService__c, Account.Id, Account.cm_AdditionalInfoReqd__c FROM User WHERE Id = :UserInfo.getUserId()];
            */

            controller.currentUser = [SELECT Id, cm_TermsofService__c, Account.Id FROM User WHERE Id = :UserInfo.getUserId()];
          
		/* Defect NCINO-6275
            // Test when curUserInfo's Id and cm_TermsofService__c and Account.cm_AdditionalInfoReqd__c are as expected
            
            controller.currentUser.Account.cm_AdditionalInfoReqd__c = true;
           
            PageReference resultTrue = controller.FinishLoginFlowHome();
            // Verify the result of the method
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow + 'Portal_AdditionalDetails?recId=' + acc.Id, resultTrue.getUrl());     
       
                
            // Test when curUserInfo's Id and cm_TermsofService__c and Account.cm_AdditionalInfoReqd__c = false are as expected
         
            controller.currentUser.Account.cm_AdditionalInfoReqd__c = false;
            
            PageReference resultFalse = controller.FinishLoginFlowHome();

            // Verify the result of the method
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow, resultFalse.getUrl());   
		*/
            
            // Test when curUserInfo's Id and cm_TermsofService__c
            PageReference result = controller.FinishLoginFlowHome();
            // Verify the result of the method
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow, result.getUrl()); 
            
        }
    }

    @isTest
    static void testWindowsloadFinishLoginFlowHome() {
        Account testAccount = new Account();
        testAccount.Name = TEST_USER;
        insert testAccount;

        Contact con = new Contact();
        con.AccountId = testAccount.Id;
        con.LastName = USER;
        insert con;

        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = :NCINO_COMMUNITY_USER];
        User testUser = new User(
            ContactId = con.Id,
            FirstName = FIRST_NAME,
            LastName = USER,
            Email = TEST_USER_EMAIL,
            Username = TEST_USER_EMAIL,
            Alias = TESTUSER,
            ProfileId = profile.Id,
            TimeZoneSidKey = TIME_ZONE,
            LocaleSidKey = EN_US,
            EmailEncodingKey = UTF_8,
            LanguageLocaleKey = EN_US,
            cm_TermsofService__c = true
        );
        insert testUser;

        System.runAs(testUser) {
            
            
            cm_PortalLoginScreenController controller = new cm_PortalLoginScreenController();
            controller.currentUser = [SELECT Id, cm_TermsofService__c, Account.Id, Account.cm_AdditionalInfoReqd__c FROM User WHERE Id = :UserInfo.getUserId()];
            
		/* Defect NCINO-6275            
            // Test when curUserInfo's Id and cm_TermsofService__c and Account.cm_AdditionalInfoReqd__c are as expected
			controller.currentUser.Account.cm_AdditionalInfoReqd__c = true;
            PageReference resultTrueTrue = controller.windowsloadFinishLoginFlowHome();
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow + 'Portal_AdditionalDetails?recId=' + testAccount.Id, resultTrueTrue.getUrl());       
            
            // Test when curUserInfo's Id and cm_TermsofService__c = true and Account.cm_AdditionalInfoReqd__c = falase are as expected
            controller.currentUser.Account.cm_AdditionalInfoReqd__c = false;
            PageReference resultTrueFalse = controller.windowsloadFinishLoginFlowHome();
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow, resultTrueFalse.getUrl());   			
            
            // Test when cm_TermsofService__c is false
            controller.currentUser.cm_TermsofService__c = false;
            PageReference resultFalse = controller.windowsloadFinishLoginFlowHome();
            System.assertEquals(null, resultFalse);
		*/
            
            // Test when curUserInfo's Id and cm_TermsofService__c Is expected
            controller.currentUser.cm_TermsofService__c = true;
            PageReference resultTrue = controller.windowsloadFinishLoginFlowHome();
            System.assertEquals(System.Label.BOI_CP_finishLoginFlow, resultTrue.getUrl());   	
            
            // Test when cm_TermsofService__c is false
            controller.currentUser.cm_TermsofService__c = false;
            PageReference resultFalse = controller.windowsloadFinishLoginFlowHome();
            System.assertEquals(null, resultFalse);            

        }
        
    }

    // Add more test methods as needed for other parts of the class

}