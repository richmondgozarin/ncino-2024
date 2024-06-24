public with sharing class InvokeApexFromFlowController
{
  @InvocableMethod(label='Call Sherman')
  public static List<AmortizationData> convertLeads(List<request> requests) {
    List<AmortizationData> results = new List<AmortizationData>();
    for (Request request : requests) {
      results.add(exeCuteCalculations(request));
    }
    return results;
  }

  public static AmortizationData exeCuteCalculations(Request request) {
    String loanAmount= request.loanAmount;
    String loanProjectedCloseDate = request.loanProjectedCloseDate;
    String loanFirstPmtDate = request.loanFirstPmtDate;
    String accrualMethod= request.accrualMethod;
    String rate= request.rate;
    String pmtType= request.pmtType;      
    String pmtFrequency=request.pmtFrequency;      
    String loanTerm = request.loanTerm;
    AmortizationData result; 
	System.debug('Input Parameter');
    System.debug('loanAmount: '+loanAmount);
    System.debug('loanProjectedCloseDate: '+loanProjectedCloseDate);
    System.debug('loanFirstPmtDate: '+loanFirstPmtDate);
    System.debug('accrualMethod: '+accrualMethod);   
    System.debug('rate: '+rate); 
    System.debug('pmtType: '+pmtType); 
    System.debug('pmtFrequency: '+pmtFrequency); 
    System.debug('loanTerm: '+loanTerm); 

    nFORCE.ACrossPackageService service = (nFORCE.ACrossPackageService) nFORCE.BeanFactory.getInstance().getBeanByUniqueName('SCALC.AmortizationCalculationXPkg');

    Map<String, Object> calcData = new Map<String, Object> {
    'aprMethod' => 'Actual_365.25',
    'aprScale' => '3',
    'shouldIncludeFinalPayoff' => 'true',
    'shouldKeepSlush' => 'false',
    'shouldMergePayment' => 'false',
    'shouldShowGrandTotal' => 'true',
    'shouldShowSubtotal' => 'true',
    'shouldShowType' => 'true',
    'shouldSuppressFees' => 'false',
    'shouldTagPayments' => 'true',
    'loanAmount' => loanAmount,
    'loanStartDate' => loanProjectedCloseDate,
    'rateStreams' => new List<Map<String, Object>> {
        new Map<String, Object> {
            'accrualMethod' => '30_360',
            'rate' => rate,
            'startDate' => loanProjectedCloseDate,
            'shouldCapitalize' => 'true',
            'extraDays' => '0',
            'paymentRoundingMethod' => 'up',
            'interestRoundingMethod' => 'nearest',
            'isNewPayment' => 'true'
        }
        },
    'paymentStreams' => new List<Map<String, Object>> {
        new Map<String, Object> {
            //'amount' => '40',
            'type' => pmtType,
            'paymentFrequency' => pmtFrequency,
            'interestPaymentFrequency' => pmtFrequency,
            'termLength' => loanTerm,
            'startDate' => loanFirstPmtDate
        }
        }
    };

    Map<String, Object> calculationSettings = new Map<String, Object>{
        'adjustmentRule' => 'Zero_Balance_Adjust_Payment'
    };

    service.setInputParameter('calculationData', calcData);
    service.executeService();

    Map<String, Object> serializedResult =
    (Map<String, Object>) service.getOutputParameter('amortizationData');

    result = (AmortizationData)JSON.deserialize(
    JSON.serialize(serializedResult),
    AmortizationData.class);
      system.debug('===>result>>>'+result);

    return result;
    
  }

    public class Request {
        @InvocableVariable (label= 'Loan Amount') public String loanAmount;        
        @InvocableVariable (label= 'Close Date') public String loanProjectedCloseDate;    
        @InvocableVariable (label= 'First Payment Date') public String loanFirstPmtDate;   
        @InvocableVariable (label= 'Accrual Method') public String accrualMethod;          
        @InvocableVariable (label= 'Rate') public String rate;
        @InvocableVariable (label= 'Payment Type') public String pmtType;
        @InvocableVariable (label= 'Payment Frequency') public String pmtFrequency;
        @InvocableVariable (label= 'Loan Term') public String loanTerm;        
    }
 
}