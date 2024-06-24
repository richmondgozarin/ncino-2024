import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCurrentBatchId from '@salesforce/apex/cm_BookingBatchSchedulerController.getBatchIdController';
import getBatchProgressStatus from '@salesforce/apex/cm_BookingBatchSchedulerController.getBatchProgressStatus';

export default class ProgressCell extends LightningElement {
    @track progressValue = 0;
    @track timer;
    mapValue = [];
    @track bkkId;
    
    /** @wire(getBatchProgressStatus, {jobId : '$bkkId'})
    progressStatus({error, data}){
        if(data){
            this.mapValue = JSON.parse(data);
            this.progStatus = this.mapValue.Status;
            this.batchName = this.mapValue.AppexClass.Name;
            this.batchId = this.mapValue.Id;
            console.log('Status: ' + this.progStatus);
            console.log('Name ' + this.batchName);
            console.log('Id ' + this.batchId);
        } else if(error){
            console.log('error ', error);
        }
    };
    
    getProgressStatus(){
        progressStatus.then(result => {
            if(this.progStatus == 'Processing'){
                progressValue + 10;
            }
            else if(this.progStatus == 'Completed'){
                progressValue = 100;
            }
        });
    }

    getProgressStatus(){
        progressStatus.then(result => {
            if(this.progStatus == 'Processing'){
                this.progInterval = setInterval(() => {
                this.progressValue = this.progressValue === 100 ? 0 : this.progressValue + 1;
                }, 10000);
            }
            else if(this.progStatus == 'Completed'){
                progressValue = 100;
            }
        });
    }
    
    progressStatus(){
        getBatchProgressStatus().then(result => {
            this.mapValue = JSON.parse(result);
            this.progStatus = this.mapValue.Status;
            this.batchName = this.mapValue.AppexClass.Name;
            this.batchId = this.mapValue.Id;
            console.log('Status: ' + this.progStatus);
            console.log('Name ' + this.batchName);
            console.log('Id ' + this.batchId);
        });
    }
    */
   /* @wire(getBatchProgressStatus)
    progressStatus({error, data}){
        if(data){
            this.mapValue = JSON.parse(data);
            this.progStatus = this.mapValue.Status;
            this.batchName = this.mapValue.AppexClass.Name;
            this.batchId = this.mapValue.Id;
            console.log('Status: ' + this.progStatus);
            console.log('Name ' + this.batchName);
            console.log('Id ' + this.batchId);
        } else if(error){
            console.log('error ', error);
        }
    };*/

    progressBar(){
            getBatchProgressStatus().then(result => {
                console.log('Res: ' + result);
                this.mapValue = JSON.stringify(result);
                this.progStatus = this.mapValue.Status;
                //this.batchName = this.mapValue.AppexClass.Name;
                this.batchId = this.mapValue.Id;
                console.log('Status: ' + this.progStatus);
                //console.log('Name ' + this.batchName);
                console.log('Id ' + this.batchId);
            });
        //progressStatus();
        console.log('Running');
        console.log('Status: ' + this.progStatus);
       // console.log('Name ' + this.batchName);
        console.log('Id ' + this.batchId);
    }

    /*connectedCallback(){
        this.startProgress();
    }

    disconnectedCallback(){
        clearInterval(this.timer);
    }

    startProgress(){
        this.timer = setInterval(() => {
            console.log('ID: '+ this.bkkId);
            refreshApex(this.bkkId)        
                .then(() => {
                    if(!this.isBatchRunning){
                        clearInterval(this.timer);
                    }
                })
                .catch((error) => {
                    console.log('Error for progress bar: ', error);
                });
        }, 10000); //Refresh the batcch id every 10 seconds
    }

    get isBatchRunning(){
        return this.bkkId && this.bkkId.data &&
            this.bkkId.data.length > 0;
    }

    get progressLabel(){
        return this.isBatchRunning ? 'Running' : 'Completed';
    }

    get progressValue(){
        return this.isBatchRunning ? this.progressValue + 10 : 100;
    }*/
}