import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import KYC_OBJECT from '@salesforce/schema/BOI_KnowYourCustomer__c';
import COUNTRY_CITIZENSHIP from '@salesforce/schema/BOI_KnowYourCustomer__c.cm_Countryofcitizenship__c';
import getKYCList from '@salesforce/apex/CM_AdditionalDetailsHelper.getKYCList';
import updateFlagField from '@salesforce/apex/CM_AdditionalDetailsHelper.updateFlag';
import getBaseUrl from '@salesforce/apex/CM_AdditionalDetailsHelper.returnBaseUrl'; // Apex Controller
import boiLogo from '@salesforce/resourceUrl/BoiCommonImages'; // Import BOI Logo
import customStyles from './cm_AdditionalDetailCustomStyle.css';

// KYC Table Settings
const columns = [
    { label: 'Loan', fieldName: 'Loan_Name' },
    {
        label: 'Country of Citizenship', fieldName: 'cm_Countryofcitizenship__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Type', 
            options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'cm_Countryofcitizenship__c' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },
    {
        label: 'Country of Birth', fieldName: 'cm_Sameascitizenship__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Type', 
            options: { fieldName: 'pickListOptions2' }, 
            value: { fieldName: 'cm_Sameascitizenship__c' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    }
];

export default class CM_AdditionalDetails extends LightningElement {
		
    // Custom Stylesheet
    static stylesheets = [
        customStyles
    ];

// BOI LOGO
BOI_Logo = boiLogo + '/BoiCommonImages/logo.png'

// Account Record Id
@track recId;

@track setFlagtoFalse = false; // To update the flag field in the relationship record
@track successMsg; // to set a success message after record is updated.
@track selectedType = "Tenant";
isMonthlyRentVisible = true;
isIncorrectPD = true; // Checkbox, show if true, otherwise false.
showToast = false; // Success Message
isBtnFreeze; // to freeze/disable button
showSpinner = false; // Display spinner after ticking save/submit
showTableSpinner = false;

// KYC Table with picklist feature
@track kycRec = [];
@track data = [];
@track draftValues = [];
@track pickListOptions;
lastSavedData = [];
columns = columns;

// Picklist options for Country of Birth
sameAsCitizenship = [
    { label: 'Yes', value: 'Yes' },
    { label: 'No', value: 'No' }
];

// Redirection to Portal
@track baseUrl;
@track backToPortal = "/nPortal__Portal";
            
// Get Object Info (KYC Object)
@wire(getObjectInfo, { objectApiName: KYC_OBJECT })
objectInfo;
            
//fetch picklist options for COUNTRY_CITIZENSHIP
@wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: COUNTRY_CITIZENSHIP
})
            
wirePickList({ error, data }) {
    if (data) {
        this.pickListOptions = data.values;
    } else if (error) {
        console.log("picklist error >" + error);
    }
}
            
//here I pass picklist option so that this wire method call after above method
@wire(getKYCList, {accountId: '$recId', pickList: '$pickListOptions' })
kycRec(result) {
    this.kycRec = result;
    if (result.data) {

        this.data = JSON.parse(JSON.stringify(result.data));

        this.data.forEach(ele => {
            ele.pickListOptions = this.pickListOptions;
            ele.pickListOptions2 = this.sameAsCitizenship;
            if(ele.cm_Loan__c){
                ele.Loan_Name = ele.cm_Loan__r.Name
            }
        })

        this.lastSavedData = JSON.parse(JSON.stringify(this.data));

    } else if (result.error) {
        this.data = undefined;
                    console.log("Error from Picklist!");
    }
};
            
    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });

        //write changes back to original data
        this.data = [...copyData];
    }
            
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
            
            //handler to handle cell changes & update values in draft values
    handleCellChange(event) {
        //this.updateDraftValues(event.detail.draftValues[0]);
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }
            
    handleSave(event) {
        this.showTableSpinner = true;
        this.saveDraftValues = this.draftValues;

        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.successMsg = "KYC record updated successfully!";

            this.showToast = true;
            setTimeout(() => {
                this.showToast = false;
            }, 2000)
                        
            this.draftValues = [];
            return this.refresh();
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.draftValues = [];
            this.showTableSpinner = false;
        });
    }
            
    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
            
    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.kycRec);
    }
            
    // Method for the updating the relationship record.
    handleSuccess() {
				
        // Report success with a toast
        this.successMsg = "Relationship record updated!";
        this.showSpinner = false;
        this.showToast = true;

        setTimeout(() => {
        this.showToast = false;
        this.navigateToDashboard();
        }, 2000)
    }

        // Method to update the checkbox field/flag field
    updateFlag(){
		this.showSpinner = true;
        console.log("record Id > " + this.recId);
        updateFlagField({recordId: this.recId})
        .then(result=>{
            console.log("Result > " + result.data);
        }).catch(error =>{
            console.log("error > " + error);
        });
    }
                 
    handleTypeChange(event) {
        this.selectedType = event.target.value;
        // Living Arrangement
        if (this.selectedType == 'Tenant') {
            this.isMonthlyRentVisible = true;
        } else {
            this.isMonthlyRentVisible = false;
        }
    }

    handleBooleanField() {
        this.personalDetails = this.template.querySelector(".incorrectPerDetails").value;

        // Incorrect Personal Details
        if(this.personalDetails == true){
            this.isIncorrectPD = true;
        }else{
            this.isIncorrectPD = false;
        }
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        console.log(this.parameters.recId);
        this.recId = this.parameters.recId;
        // Get base Url
        getBaseUrl().then(result=>{
            this.baseUrl = result;
            console.log(this.baseUrl);
        }).catch(error =>{
            this.baseUrlError = error;
        });
    }
    
    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);
        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }
        return params;
    }

    navigateToDashboard() {
        window.location.replace(this.baseUrl + this.backToPortal);
    }
}