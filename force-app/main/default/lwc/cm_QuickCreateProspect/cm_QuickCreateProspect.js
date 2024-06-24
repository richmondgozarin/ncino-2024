import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Cm_QuickCreateProspect extends NavigationMixin(LightningElement) {

    navigateToObjectHome(){
        // Navigate to the Account home page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'PersonAccount',
                actionName: 'home',
            },
        });
    }

    recordPageUrl;

    connectedCallback(){
        // Generate a URL to a User record page
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '005B0000001ptf1IAE',
                actionName: 'view',
            },
        }).then((url) => {
            this.recordPageUrl = url;
        });
    }
}