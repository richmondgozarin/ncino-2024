<script type="text/javascript">
   
        function openModal() {
            document.getElementById("modal").classList.add("slds-fade-in-open");
            document.querySelector(".slds-backdrop").classList.add("slds-backdrop_open");
            
            let checkboxTermsCondition = document.getElementById("termsCheckbox");    
            
            if (checkboxTermsCondition.checked == false) {

                const labelError = document.querySelector('.labelError');
                const labelSuccess = document.querySelector('.labelSuccess');
                const labelRedirecting = document.querySelector('.labelRedirecting');
                labelError.removeAttribute('style');  
                labelSuccess.style.display = 'none';   
                labelRedirecting.style.display = 'none';   

            } else {             
                const labelError = document.querySelector('.labelError');
                const labelSuccess = document.querySelector('.labelSuccess');
                const labelRedirecting = document.querySelector('.labelRedirecting');
                labelError.style.display = 'none';   
                labelSuccess.removeAttribute('style'); 
                labelRedirecting.removeAttribute('style'); 
                
            }
     			buttonAtrib();            
            
        }
    
        function closeModal() {
            document.getElementById("modal").classList.remove("slds-fade-in-open");
            document.querySelector(".slds-backdrop").classList.remove("slds-backdrop_open");
        }
    
        function buttonAtrib() {
            let checkbox = document.getElementById("termsCheckbox");  
            if (checkbox.checked === true) {
                showButtonDone();  
                hideButtonCancel();  	
            } else {
                showButtonCancel(); 
                hideButtonDone();    
            }
        }
        
        function hideButtonDone() {
            let button = document.getElementById('{!$Component.frmTermsCondition.bntModalDone}');
            if (button) {
                button.style.display = 'none';
            }
        }
        
        function hideButtonCancel() {
            let button = document.getElementById('{!$Component.frmTermsCondition.bntModalCancel}');
            if (button) {
                button.style.display = 'none';
            }
        } 
        function showButtonDone() {
            let button = document.getElementById('{!$Component.frmTermsCondition.bntModalDone}');
            if (button) {
                button.style.display = ''; // Empty string or 'block'
            }
        }
        
        function showButtonCancel() {
            let button = document.getElementById('{!$Component.frmTermsCondition.bntModalCancel}');
            if (button) {
                button.style.display = ''; // Empty string or 'block'
            }
        }       
        
</script>     