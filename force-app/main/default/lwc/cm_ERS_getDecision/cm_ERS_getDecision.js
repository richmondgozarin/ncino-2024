import { LightningElement, wire, api, track } from "lwc";
import { CloseActionScreenEvent } from "lightning/actions";
import { CurrentPageReference } from "lightning/navigation";
import getERSDecision from "@salesforce/apex/cm_ERS_GetDecisionController.getERSDecision";
import validateLoan from "@salesforce/apex/cm_ERS_GetDecisionController.validateLoan";
/**************************************************************************************************
 * @Author:    Kuldeep Parihar
 * @Date:      06/02/2023
 * @Description: This method will handle Call out to ERS.
 * @Revision(s): [Date] - [Change Reference] - [Changed By] - [Description]
 ***************************************************************************************************/
export default class Cm_ERS_getDecision extends LightningElement {
  recordId;
  @track isApprove = false;
  @track isRefer = false;
  @track isDecline = false;
  showSpinner = false;
  @track haserror = false;
  resultObj = {};
  hasRendered = false;
  isLoanValidated = false;

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.recordId = currentPageReference.state.recordId;
    }
  }

  closeModal() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }

  updateRecordView() {
    //
    setTimeout(() => {
      eval("$A.get('e.force:refreshView').fire();");
    }, 1000);
  }

  connectedCallback() {
    this.showSpinner = true;
    console.log(this.recordId + " from connectedCallback");
  }
  renderedCallback() {
    if (this.hasRendered) {
      return;
    }
    // Method action implementation.
    this.hasRendered = true;
    console.log(this.recordId + " from renderedCallback");
    this.validateLoanInformation();
  }

  validateLoanInformation() {
    var parameterObject = {
      recordId: this.recordId
    };
    validateLoan({ recordStr: parameterObject })
      .then((result) => {
        this.resultObj = JSON.parse(result);
        console.log("Validate Data:" + JSON.stringify(this.resultObj));

        if (this.resultObj.hasInfo && this.resultObj.errorList === undefined) {
          this.submitRequest();
        }
        if (this.resultObj.hasError && this.resultObj.errorList.length > 0) {
          this.isLoanValidated = false;
          this.showSpinner = false;
        }
      })
      .catch((error) => {
        this.showSpinner = false;
        this.haserror = true;
        console.log("ERROR:" + JSON.stringify(error));
        this.error = error;
      });
  }

  submitRequest() {
    var parameterObject = {
      recordId: this.recordId
    };
    getERSDecision({ recordStr: parameterObject })
      .then((result) => {
        this.showSpinner = false;
        this.isLoanValidated = true;
        this.resultObj = JSON.parse(result);
        console.log("ERS Data:" + JSON.stringify(this.resultObj));
        if (this.resultObj.ersStatus === "Approve") {
          this.isApprove = true;
          this.updateRecordView();
        } else if (this.resultObj.ersStatus === "Refer") {
          this.isRefer = true;
        } else if (this.resultObj.ersStatus === "Decline") {
          this.isDecline = true;
        }
      })
      .catch((error) => {
        this.showSpinner = false;
        this.haserror = true;
        console.log("ERROR:" + JSON.stringify(error));
        this.error = error;
      });
  }
}