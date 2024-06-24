import { LightningElement, api } from "lwc";
export default class CM_LoanProgressIndicator extends LightningElement {
  @api currentStep;
  @api entityType;
  @api accountType;
  steps = [];

  connectedCallback() {
    this.handleSteps();
  }

  handleSteps() {
    // this would be applicable for First Screen since we don't know the Select Product Type
    if (this.accountType === "Comman") {
      if (this.entityType === "Sole Trader") {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" }
        ];
      } else {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" },
          { label: "Define Borrowing Structure", value: "step-4" }
        ];
      }
    }

    if (this.entityType === "Sole Trader") {
      // if entityType == SoleTrder && acountType = Current Account
      if (this.accountType === "Current Account") {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" }
        ];
      }
      // if entityType == SoleTrder && acountType = Loan Account
      if (this.accountType === "Loan Account") {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" },
          { label: "Collect KYC Details", value: "step-3" }
        ];
      }
    }

    if (this.entityType !== "Sole Trader") {
      // if entityType != SoleTrder && acountType = current Account
      if (this.accountType === "Current Account") {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" },
          { label: "Define Borrowing Structure", value: "step-4" }
        ];
      }
      // if entityType != SoleTrder && acountType = Loan Account
      if (this.accountType === "Loan Account") {
        this.steps = [
          { label: "Select Product", value: "step-1" },
          { label: "Collect Application Details", value: "step-2" },
          { label: "Collect KYC Details", value: "step-3" },
          { label: "Define Borrowing Structure", value: "step-4" }
        ];
      }
    }
  }
}