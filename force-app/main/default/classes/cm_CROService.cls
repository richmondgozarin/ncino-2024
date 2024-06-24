public class cm_CROService {
	//private ExternalService.IrelandCRO service = new ExternalService.IrelandCRO();    
    //set request   
    @AuraEnabled
    public static String getCompanyDetails(String CompanyBusInd, String CompanyNum) {
        ExternalService.IrelandCRO service = new ExternalService.IrelandCRO();
        ExternalService.IrelandCRO.GetOneCompany_Request req = new ExternalService.IrelandCRO.GetOneCompany_Request();
        system.debug('CompanyBusInd: '+ CompanyBusInd);
        system.debug('CompanyNum: '+ CompanyNum);
        req.companyx5fbusx5find  = CompanyBusInd;//'C'
        req.companyx5fnum  = CompanyNum;//'83740'
        req.format = 'json';
        // req.htmlEnc = 'Customer';
        String response;
        try{
            //make callout
            ExternalService.IrelandCRO.GetOneCompany_Response res = service.GetOneCompany(req);
            system.debug('responseCode: '+ res);
            //system.debug('200 response id => '+ res.Code201.id);
            //system.debug('200 repsonse: name => '+res.Code201.name);
            //system.debug('200 repsonse: available balance => '+res.Code201.availableBal);
            //system.debug('200 repsonse: type => '+res.Code201.z0type);
            response = JSON.serialize(res);
        }catch(ExternalService.IrelandCRO.GetOneCompany_ResponseException exc){
            system.debug('responseCode: '+ String.valueOf(exc.responseCode) );
            response = String.valueOf(exc.responseCode) ;
        }
        return response;
    }
    
}