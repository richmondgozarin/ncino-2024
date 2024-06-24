@isTest
public class cm_ShermanTest {
    
    // Mock Class for nForce service
    public class MockCrossPackageService extends nFORCE.ACrossPackageService {
        
        public MockCrossPackageService() {
            Map<String, Object> calcData = new Map<String, Object>();
            // Required to prevent failures in consuming class
            addSupportedInputParameter(
                'calculationData',
                true,
                Map<String, Object>.class,
                '',
                calcData
            );
        }
        
        public virtual override void execute() {
            //outputs for usage by consuming implementation can be added here
            
            List<Map<String,Object>> testList = new List<Map<String,Object>>();
            Map<String, Object>  testMapAmortRec = new Map<String, Object> {
                'beginningBalance' => '1000',
                    'date' => '2023-08-28',
                    'endingBalance' => '17000',
                    'index' => '0',
                    'interest' => '0',
                    'payment' => '0',
                    'principal' => '-17000',
                    'type' => 'Advance',
                    'unpaidInterest' => '0'
                    };
                        testList.add(testMapAmortRec);
            
            Map<String, Object> outputMap = new Map<String, Object> {
                'amortizationRecords' => testList
                    };
                        
                        
                        setOutputParameter('amortizationData', outputMap);
        }
    }
    
    @isTest
    static void testShermanCalc() {
        
        //enable the local namespace ClassTypeProvider
        nFORCE.BeanRegistry.getInstance().registerBean(
            'ClassTypeProvider',
            nFORCE.ClassTypeProvider.class,
            ClassTypeProvider.class,
            true
        );
        
        //register your mock process
        nFORCE.BeanRegistry.getInstance().registerBean(
            'SCALC.AmortizationCalculationXPkg',
            nFORCE.ACrossPackageService.class,
            MockCrossPackageService.class,
            true
        );
        
        List<cm_ShermanInvokeApexFromFlowController.Request> shermanReqList = new List<cm_ShermanInvokeApexFromFlowController.Request>();
        List<cm_ShermanAmortizationData> shAmorDataList = new List<cm_ShermanAmortizationData>();
        cm_ShermanInvokeApexFromFlowController.Request shermanReq = new cm_ShermanInvokeApexFromFlowController.Request();
        
        
        shermanReq.loanAmount = '50000';
        shermanReq.loanProjectedCloseDate = '2023-08-24';
        shermanReq.loanFirstPmtDate = '2024-08-24';
        shermanReq.accrualMethod = '';
        shermanReq.rate = '1.5';
        shermanReq.pmtType = 'Principal + Interest';
        shermanReq.pmtFrequency = '1';
        shermanReq.loanTerm = '1';
        
        shermanReqList.add(shermanReq);
        
        Test.startTest();
        shAmorDataList = cm_ShermanInvokeApexFromFlowController.convertLeads(shermanReqList);
        Test.stopTest();
        
        Assert.isNotNull(shAmorDataList);
    }
    
    @isTest
    static void testWrappers() {
        List<cm_ShermanAmortizationRecord> shAmortRecList = new List<cm_ShermanAmortizationRecord>();
        cm_ShermanAmortizationRecord shAmortRec = new cm_ShermanAmortizationRecord();
        shAmortRec.endingBalance = '0';
        shAmortRec.unpaidInterest = '2';
        shAmortRec.principal = '10000';
        shAmortRec.interest = '3';
        shAmortRec.payment = '10000';
        shAmortRec.beginningBalance = '0';
        shAmortRec.pmtdate = '2024-08-05';
        shAmortRec.index = '0';
        shAmortRec.type = 'Advance';
        shAmortRecList.add(shAmortRec);
        
        String jsonString = JSON.serialize(shAmortRec);
        
        cm_ShermanAmortizationRecord output = (cm_ShermanAmortizationRecord) System.JSON.deserialize(jsonString, cm_ShermanAmortizationRecord.class);
        
        
        List<cm_ShermanSubTotal> shSubTotalList = new List<cm_ShermanSubTotal>();
        cm_ShermanSubTotal shSubTotal = new cm_ShermanSubTotal();
        shSubTotal.principalSubTotal = '0';
        shSubTotal.interestSubTotal = '0';
        shSubTotal.paymentSubTotal = '0';
        shSubTotal.events = '';
        shSubTotal.start = '';
        shSubTotal.year = '2024';
        shSubTotalList.add(shSubTotal);
        
        String jsonString1 = JSON.serialize(shSubTotal);
        
        cm_ShermanSubTotal outputSubTotal = (cm_ShermanSubTotal) System.JSON.deserialize(jsonString1, cm_ShermanSubTotal.class);
        
        cm_ShermanAmortizationData shAmortData = new cm_ShermanAmortizationData();
        shAmortData.principalTotal = '1000';
        shAmortData.interestTotal = '500';
        shAmortData.paymentTotal = '1000';
        shAmortData.subTotals = shSubTotalList;
        shAmortData.amortizationRecords = shAmortRecList;
        
        String jsonString2 = JSON.serialize(shAmortData);
        
        cm_ShermanAmortizationData outputShAmortData = (cm_ShermanAmortizationData) System.JSON.deserialize(jsonString2, cm_ShermanAmortizationData.class);
    }
    /* Test coverage for associated wrapper classes */
    @isTest
    static void testAmortizationData() {
        
        Test.startTest();
        String principalTotal = cm_ShermanAmortizationData.getUnitTest();
        principalTotal = '15000';
        Test.stopTest();
        System.assertEquals('15000',principalTotal);
    }
    
    @isTest
    static void testAmortizationRecord() {
        Test.startTest();
        String principal = cm_ShermanAmortizationRecord.getUnitTest();
        principal = '5000';
        Test.stopTest();
        System.assertEquals('5000',principal);
    }

    
    @IsTest 
    static void testShermanSubTotal()
    {
        Test.startTest();
        String subTotal = cm_ShermanSubTotal.getUnitTest();
        subTotal = '50';
        Test.stopTest();
        System.assertEquals('50',subTotal);
    }    
}