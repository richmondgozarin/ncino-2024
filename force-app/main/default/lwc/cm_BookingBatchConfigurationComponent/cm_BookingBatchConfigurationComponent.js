import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getcronSchedule from '@salesforce/apex/cm_BookingBatchSchedulerController.getcronSchedule';
import {refreshApex} from '@salesforce/apex';
import getBookingSchedule from '@salesforce/apex/cm_BookingBatchSchedulerController.getBookingSchedule';
import runFrequencyScheduler from '@salesforce/apex/cm_BookingBatchSchedulerController.runFrequencyScheduler';
import {NavigationMixin} from 'lightning/navigation';
import runScheduler from '@salesforce/apex/cm_BookingBatchSchedulerController.runScheduler';
import getBatchId from '@salesforce/apex/cm_BookingBatchSchedulerController.getBatchId';
import getCSVFileLocation from '@salesforce/apex/cm_BookingBatchSchedulerController.csvFilesLocation';
import HOLIDAY_OBJECT from '@salesforce/schema/Holiday';
import getListOfHolidays from '@salesforce/apex/cm_BookingBatchSchedulerController.getListOfHolidays';
import checkScheduler from '@salesforce/apex/cm_BookingBatchSchedulerController.checkScheduler';
import returnHolidayURL from '@salesforce/apex/cm_BookingBatchSchedulerController.returnHolidayURL';

// Import custom labels
import bkkDailyJobSettingsLabel from '@salesforce/label/c.cm_BKK_Daily_Job_Settings_Note';
import bkkOnDemandSettingsLabel from '@salesforce/label/c.cm_BKK_On_Demand_Settings_Note';
import holidayPanelHeaderTitle from '@salesforce/label/c.Holiday_Panel_Header_Title';
import holidayPanelGenericText from '@salesforce/label/c.cm_Holiday_Panel_Generic_Text';
import holidayPanelHyperLinkLabel from '@salesforce/label/c.cm_Holiday_Panel_hyperlink_label';
import BKKPanelHeaderTitle from '@salesforce/label/c.cm_BKK_Panel_Header_Title';
import standardSchedulerTitle from '@salesforce/label/c.cm_Standard_Scheduler_Header_Title';
import standardSchedulerIntervalText from '@salesforce/label/c.cm_Standard_Scheduler_Interval_Text';
import standardSchedulerBtnLabel from '@salesforce/label/c.cm_Standard_Scheduler_button_label';
import standardSchedQueuedLabel from '@salesforce/label/c.Standard_Scheduler_queued_label';
import onDemandBatchJobTitle from '@salesforce/label/c.cm_On_Demand_Batch_Job_TItle';
import startDateInputLabel from '@salesforce/label/c.cm_Start_Date_Input_Label';
import endDateInputLabel from '@salesforce/label/c.cm_End_Date_Input_Label';
import onDemandBtnLabel from '@salesforce/label/c.cm_On_Demand_Button_Label';
import errMsgStartDateBlank from '@salesforce/label/c.cm_Err_Message_Start_Date_Blank';
import errMsgEndDateBlank from '@salesforce/label/c.cm_Err_Message_End_Date_Blank';
import errMsgStartDateEqEndDate from '@salesforce/label/c.Err_Message_Start_Date_End_Date';
import errMsgEndDatePastStartDate from '@salesforce/label/c.cm_Err_Message_End_Date_past_Start_Date';
import errMsgTodayFutureDateSelected from '@salesforce/label/c.cm_Err_Message_Today_or_Future_Date_Selected';
import onDemandPopUpMsg from '@salesforce/label/c.cm_On_Demand_Msg_Confirmation';

export default class Cm_BookingBatch_ParentContainerComponent extends NavigationMixin(LightningElement) {
    // Expose the labels to use in the template.
  
    customLabel = {
        bkkDailyJobSettingsLabel,
        bkkOnDemandSettingsLabel,
        holidayPanelHeaderTitle,
        holidayPanelGenericText,
        holidayPanelHyperLinkLabel,
        BKKPanelHeaderTitle,
        standardSchedulerTitle,
        standardSchedulerIntervalText,
        standardSchedulerBtnLabel,
        onDemandBatchJobTitle,
        startDateInputLabel,
        endDateInputLabel,
        onDemandBtnLabel,
        errMsgStartDateBlank,
        errMsgEndDateBlank,
        errMsgStartDateEqEndDate,
        errMsgEndDatePastStartDate,
        errMsgTodayFutureDateSelected,
        onDemandPopUpMsg,
				standardSchedQueuedLabel,
    };

    // Daily Schedule Job Settings
        @track label = [];
        @track batchNames = [];
        @track scheduleMdt = {};
        @track updatedSchedMdt = {};
        @track runningScheduler = false;
        @track _wiredScheduler;
        @track checkboxes = [];
        
        
    // End Daily Schedule Job Settings
    
    // On-Demand Batch Job Settings
        // Date form decorators
        @api inputStartDate;
        @api inputEndDate;
        @track disableRunBtn = true;
        @track minDate;
        @track maxDate;
        @track disabledDateFields = false;
        @track dateToday;
        // Display decorators
        @track isLoading = false;
        @track progressBar = 0;
        @track hasError = false;
        @track errorMessage;
        // End Display decorators

        // Csv Record decorators
        @track csvId;
        @track _wiredCsvData;
        @track csvFilesReady = false;
        // End Csv Record decorators

        // Batch Process decorators
        @track _wiredRunningBatch;
        @track batchResult;
        @track refreshEvent;
        @track batchStatus;
    // End On-Demand Batch Job Settings

    // BOI Holiday Calendar
        @api objectApiName = HOLIDAY_OBJECT;
        @track holidayData = false;
        @track _wiredHolidays;
        @track _interval;
        @track holidayURL;
        @track holidayURLError;
    // END BOI Holiday Calendar


// // <<<<<<<<<<<<<<<<<<<<<<< Daily Schedule Job Settings >>>>>>>>>a>>>>>>>>>>>>>>>>>>>>>

    @wire(getcronSchedule)
    wiredBookingSchedule({ error, data }) {
        var counter = 1;
        if (data) {
            this.scheduleMdt = JSON.parse(JSON.stringify(data));

            this.scheduleMdt.forEach(ele => {
            JSON.stringify(this.label.push({values:[counter] + ". " + ele.MasterLabel, key:ele.Id}));
            this.batchNames.push(ele.CM_Batch_Name__c);

            counter++;
            });            

        } else if (error) {
            this.error = error;
        }
    }

    FrequencyScheduler(){
    runFrequencyScheduler().then(result => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Scheduler is now Running!',
                message: 'You may check the status on the Schedule Jobs',
                variant: 'success'
            })
        );
    });
    }

    editJob(event){
            var recId = event.target.dataset.key;
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                recordId: recId,
                actionName: 'view'
                }
            }).then(url => {
                window.open(url, '_blank');
            });
    }

    disableEdit(){
        this.allowEdit = false;
        this.isDisabled = false;
    }

    refreshScheduleJobs(){
        // BKK Scheduler
        getBookingSchedule().then(result => {
            this.updatedSchedMdt = JSON.parse(JSON.stringify(result));
            var counter = 0;
            var numLabel = 1;
            this.updatedSchedMdt.forEach(ele => {
                    if(this.label[counter].key.includes(ele.Id)){
                        this.label[counter].values = [numLabel] + ". " + ele.MasterLabel;
                    }
								 this.batchNames[counter] = ele.CM_Batch_Name__c;
                counter++;
                numLabel++;
            });
            
            
            
        });

        checkScheduler({batchNames : JSON.stringify(this.batchNames)}).then(result =>{
            this._wiredScheduler = result;
        }).catch(error =>{
            this.error = error;
        });

    }

// <<<<<<<<<<<<<<<<<<<<<<< On-Demand Batch Job Settings >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


    // Handles the changes of input value
    handleChange(event){
        this.inputStartDate = this.template.querySelector(".startDate").value;
        this.inputEndDate = this.template.querySelector(".endDate").value;

    }

    // Fetch the value of the input field and used as parameter in the controller - button
    getInputValue() {
        this.batchStatus = "";
        this.handleIsLoading(false);
        this.progressBar = 0;
        this.csvFilesReady = false;

        
        if(this.inputStartDate == ""){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgStartDateBlank;
        }else if(this.inputStartDate >= this.dateToday || this.inputEndDate >= this.dateToday){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgTodayFutureDateSelected;
        }else if(this.inputEndDate == ""){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgEndDateBlank;
        }else if(this.inputStartDate == "" && this.inputEndDate == "" || this.inputStartDate == undefined && this.inputEndDate == undefined){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgStartDateBlank;
        }else if(this.inputStartDate == this.inputEndDate){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgStartDateEqEndDate;
        }else if(this.inputStartDate > this.inputEndDate){
            this.handleIsLoading(false);
            this.hasError = true;
            this.errorMessage = this.customLabel.errMsgEndDatePastStartDate;
        }else{
            this.hasError = false;
            this.handleIsLoading(true);
            runScheduler({startDate : this.inputStartDate, endDate : this.inputEndDate})
            .then(result=>{
            this.batchResult = result;
            this.disabledDateFields = true;
            this.disableRunBtn = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.customLabel.onDemandPopUpMsg,
                    message: 'Loan Records FROM: ' + this.inputStartDate + " TO: " + this.inputEndDate,
                    variant: 'success'
                })
            );
            this.getRunningBatchId();
            setTimeout(()=>{
                this.handledBatchProgress();
            },1000)

        }).catch(error =>{
            this.error = error;
        });
        }
    }

    // Get current running Batch status.
    getBatchCsvStatus(){

        getCSVFileLocation().then(result=>{
            this._wiredCsvData = result;
            this.csvId = this._wiredCsvData.Id;
            this._wiredCsvData.forEach(csvId => {
                this.csvId = csvId.Id;
            });
        });

    }
    getRunningBatchId(){
        getBatchId({batchId:this.batchResult}).then(result => {
            this._wiredRunningBatch = result;
            });  
    }

    handledBatchProgress(){
        
        this.refreshEvent = setInterval(()=>{
            this.getRunningBatchId();
            this.getBatchCsvStatus();
            if(this._wiredRunningBatch.Status == "Queued"){
                this.disableRunBtn = true;
                this.batchStatus = "25%";
                this.template.querySelector('.progress_bar_percentage').classList.add('left_25');
                this.progressBar = 25;
            }else if(this._wiredRunningBatch.Status == "Preparing"){
                this.disableRunBtn = true;
                this.batchStatus = "50%";
                this.template.querySelector('.progress_bar_percentage').classList.add('left_50');
                this.progressBar = 50;
            }else if(this._wiredRunningBatch.Status == "Processing"){
                this.disableRunBtn = true;
                this.batchStatus = "75%";
                this.template.querySelector('.progress_bar_percentage').classList.add('left_75');
                this.progressBar = 75;
            }else if(this._wiredRunningBatch.Status == "Completed"){
                this.template.querySelector('.progress_bar_percentage').classList.add('left_100');
                this.batchStatus = "100%";
                this.progressBar = 100;
                setTimeout(() => {
                    this.csvFilesReady = true;
                    this.progressBar = 0;
                    this.batchStatus = "";
                    if(this.csvFilesReady = true){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'CSV Files Ready!',
                                message: 'Click the "Check CSV File Records" to check!',
                                variant: 'Success'
                            })
                        );

                        this.template.querySelector('.progress_bar_percentage').classList.add('left_0');
                    }
                }, 5000);
                clearInterval(this.refreshEvent);
                this.disabledDateFields = false;
                this.disableRunBtn = false;

            }else if(this._wiredRunningBatch.Status == "Aborted"){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Job Aborted!',
                        message: 'The Batch Job is Aborted!',
                        variant: 'Error'
                    })
                );
                clearInterval(this.refreshEvent);
                this.disabledDateFields = false;
                this.disableRunBtn = false;
            }else if(this._wiredRunningBatch.Status == "Failed"){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Failed!',
                        message: 'The Batch Job is Failed!',
                        variant: 'Error'
                    })
                );
                clearInterval(this.refreshEvent);
                this.disabledDateFields = false;
                this.disableRunBtn = false;
            }
                
        }, 1000);
        
    }

    // Redirection to the newly created record
    redirectToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.csvId,
                objectApiName: 'cm_LoanBooking__c',
                actionName: 'view'
            }
        });
    }

    handleIsLoading(isLoading){
        this.isLoading = isLoading;
    }

    // <<<<<<<<<<<<<<<<<<<<<<< BOI HOLIDAY CALENDAR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    getHolidays(){
        getListOfHolidays().then(result=>{ 
            this._wiredHolidays = result;
            this.holidayData = true;
        }).catch(error =>{
            this.holidayData = false;
        });
        
    }

    redirectToHoliday(){
        returnHolidayURL().then(result=>{
            this.holidayURL = result;
        }).catch(error =>{
            this.holidayURLError = error;
        });
    }

    async renderedCallback(){
        this.disableRunBtn = false;
    }

    connectedCallback(){
        setInterval(() => {
            this.refreshScheduleJobs();
        }, 4000);

        setTimeout(()=>{
            this.redirectToHoliday();
        },2000)
    
        // Handles Date Range
        const today = new Date();
        const thirtyDaysLater = new Date();
        thirtyDaysLater.setDate(today.getDate()-30);
        today.setDate(today.getDate()-1);
        this.maxDate = today.toISOString().split('T')[0];
        this.minDate = thirtyDaysLater.toISOString().split('T')[0];
    
        this.getHolidays();

        setInterval(() => {
            this.getHolidays();
        }, 2000);

        // Get Today's Date
        const getDateToday = new Date();
        getDateToday.setDate(today.getDate()+1);
        this.dateToday = getDateToday.toISOString().split('T')[0];
        console.log("Connected call back dateToday" + this.dateToday);
    }

    disconnectedCallback(){
        clearInterval(this._interval);
    }
}