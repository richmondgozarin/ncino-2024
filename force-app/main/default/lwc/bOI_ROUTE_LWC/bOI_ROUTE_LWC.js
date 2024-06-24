import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from "lightning/actions";
import { CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCompanyDetails from "@salesforce/apex/cm_CROService.getCompanyDetails";
export default class BOI_ROUTE_LWC extends LightningElement {
   @track visible = false;
   @track isError = false;
   
    showModal = false;
    receivedMessage;
    @api inputCompany;
    @api inputCoIndicator;
    @api inputCoBusNum;

    hasRendered = false;

    recordId;
    @track isApprove = false;
    @track isRefer = false;
    @track isDecline = false;
    showSpinner = false;
    haserror = false;
    resultObj = {};
    @track isSuccess= false;
    @track companyName;
    @track companyNumber;
    @track status;
    @track address;

    
    connectedCallback() {
        this.visible = false;
        this.showSpinner = true;
        console.log(this.recordId + " from connectedCallback");
    }
    
    handleInputChange(event) {
        this.inputCompany = event.detail.value;
    }

    handleCoInd(event) {
        this.inputCoIndicator = event.detail.value;
    }
    handleCoBusNum(event) {
        this.inputCoBusNum = event.detail.value;
    }

    SearchCompany() {
        console.log(this.inputCoIndicator + this.inputCoBusNum)
        getCompanyDetails({ CompanyBusInd: this.inputCoIndicator, CompanyNum: this.inputCoBusNum })
      .then((result) => {
        this.showSpinner = false;
        this.resultObj = JSON.parse(result);
        console.log("Data:" + JSON.stringify(this.resultObj));
        console.log("companyName >>" + this.resultObj.Code200.companyx5fname);
        
        this.visible = true;
                let delay = 2000
            setTimeout(() => {
                this.visible = false;
            this.showModal = true;
            this.companyName = this.resultObj.Code200.companyx5fname;
            this.companyNumber = this.resultObj.Code200.companyx5fnum;
            this.status = this.resultObj.Code200.companyx5fstatusx5fdesc;
            this.address = this.resultObj.Code200.companyx5faddrx5f4;

            }, delay );


      })
      .catch((error) => {
        this.showSpinner = false;
        this.haserror = true;
        console.log("ERROR:" + JSON.stringify(error));
        this.error = error;
        this.isError = true;
                let delay = 2000
            setTimeout(() => {
                this.isError = false;
            }, delay );

      }); 
  }
    

    getTheJoke(){
        const calloutURI = 'https://icanhazdadjoke.com';
        // requires whitelisting of calloutURI in CSP Trusted Sites
        fetch(calloutURI, {
            method: "GET",
            headers: {
                "Accept": "application/json"
              }
        }).then(
            (response) => {
                if (response.ok) {
                    return response.json();
                } 
            }
        ).then(responseJSON => {
            this.receivedMessage = responseJSON.joke;
            /*const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Get the Joke sucessfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);*/
           this.visible = true;
                let delay = 2000
            setTimeout(() => {
                this.visible = false;
            }, delay );

        console.log(this.receivedMessage + 'TESTTT');
        });
    }


    renderedCallback() {
        if(this.hasRendered == false) {
            //this.getTheJoke();
            this.hasRendered = true;
        }
    

        /*if (this.hasRendered) {
            return;
        }
        Method action implementation.
        this.hasRendered = true;
        console.log(this.recordId + " from renderedCallback");
        this.submitRequest();*/
    }

    clickShowModal(){
        this.showModal=true;
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
        this.showModal = false;
    }

}