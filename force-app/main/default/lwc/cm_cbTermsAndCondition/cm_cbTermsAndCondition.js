import { LightningElement, api, track } from 'lwc';
import {
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';

export default class Cm_cbTermsAndCondition extends LightningElement {
    @api agreed = 'false';
		@track count = 0;
		
		connectedCallback() {
				console.log('Went here');
        window.addEventListener('resize', this.myFunction);
    }
    
    myFunction = () => {
        this.count = this.count += 1;
    };

    handleAgreeChange(event) {
        this.agreed = event.target.checked;
				console.log(this.agreed);
    }

    handleSubmit() {
        // navigate to the next screen
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}