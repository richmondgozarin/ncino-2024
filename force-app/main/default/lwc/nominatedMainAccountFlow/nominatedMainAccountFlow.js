import { LightningElement, api } from 'lwc';

export default class NominatedMainAccountFlow extends LightningElement {
    @api id;
    @api label;

    toggleSection() {
        const div = this.template.querySelector('.slds-section.slds-is-open');
        if (div.className.search('slds-section slds-is-open') == -1) {
            div.className = 'slds-section slds-is-close';
            console.log('Open');
        }
        else {
            div.className = 'slds-section slds-is-open';
            console.log('close');
        }

    }
}