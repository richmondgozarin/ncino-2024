import { LightningElement } from 'lwc';
import generateData from './generateData';
import progressCell from './progressCell';

const columns = [
    { label: 'Job Name', fieldName: 'apexName' },
    { label: 'Submitted Date', fieldName: 'dateProcessed', type: 'date' },
    { label: 'Progress', fieldName: 'status', type: 'custom', typeAttributes: {cellAttributes: {class: 'slds-p-horizontal_xx-small'}, componentName: 'c-progress-cell'}},
    { label: 'Record URL', fieldName: 'csvUrl', type: 'url' },
    { label: 'Action', fieldName: 'actionType', type: 'button', typeAttributes: {label: 'Action', variant: 'base', name: 'action'}},
];

export default class Cm_OpenDemandUI extends LightningElement {
    data = [];
    columns = columns;

    connectedCallback() {
        this.data = generateData({ amountOfRecords: 10 });
        this.columns = progressCell;
    }


}