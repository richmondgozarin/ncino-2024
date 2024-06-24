@isTest
public class cm_ShermanTestClone {

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
            cm_ShermanSubTotal shSubTotal = new cm_ShermanSubTotal();
            List<cm_ShermanSubTotal> shSubTotalList = new List<cm_ShermanSubTotal>();
            cm_ShermanAmortizationRecord shAmortRec = new cm_ShermanAmortizationRecord();
            cm_ShermanAmortizationData shAmortData = new cm_ShermanAmortizationData();
            List<cm_ShermanAmortizationRecord> shAmortRecList = new List<cm_ShermanAmortizationRecord>();
            
            shSubTotal.principalSubTotal = '123';
            shSubTotal.interestSubTotal = '10';
            shSubTotal.paymentSubTotal = '1000';
            shSubTotal.events = '';
            shSubTotal.start = '10';
            shSubTotal.year = '20';
            shSubTotalList.add(shSubTotal);
            
            shAmortRec.endingBalance = '1000';
            shAmortRec.unpaidInterest ='0';
            shAmortRec.principal = '1000';
            shAmortRec.interest = '1.5';
            shAmortRec.payment = '1000';
            shAmortRec.beginningBalance = '1000';
            shAmortRec.pmtdate = '2024-08-24';
            shAmortRec.index = '2J';
            shAmortRec.type = 'test';
            shAmortRecList.add(shAmortRec);
            
            shAmortData.principalTotal = '1000';
            shAmortData.interestTotal = '1.5';
            shAmortData.paymentTotal = '1000';
            shAmortData.subTotals = shSubTotalList;
            shAmortData.amortizationRecords = shAmortRecList;
            
            Map<String, Object> output = new Map<String, Object>();
            
            
            setOutputParameter('amortizationData', output);
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
        
        //List<cm_ShermanInvokeApexFromFlowController.Request> shermanReqList = new List<cm_ShermanInvokeApexFromFlowController.Request>();
        List<cm_ShermanInvokeApexFromFlowController.Request> shermanReqList = new List<cm_ShermanInvokeApexFromFlowController.Request>();
        List<cm_ShermanAmortizationData> shAmorDataList = new List<cm_ShermanAmortizationData>();
        //cm_ShermanInvokeApexFromFlowController.Request shermanReq = new cm_ShermanInvokeApexFromFlowController.Request();
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
        //shAmorDataList = cm_ShermanInvokeApexFromFlowController.convertLeads(shermanReqList);
        shAmorDataList = cm_ShermanInvokeApexFromFlowController.convertLeads(shermanReqList);
        Test.stopTest();
        
        Assert.isNotNull(shAmorDataList);
    }
    
    @isTest
    static void wrapperClass(){
        cm_ShermanSubTotal shermanST = new cm_ShermanSubTotal();
        shermanST.principalSubTotal = '10';
        shermanST.interestSubTotal = '10';
        shermanST.paymentSubTotal = '10';
        shermanST.events = '10';
        shermanST.start = '10';
        shermanST.year = '10';
    }
    
}