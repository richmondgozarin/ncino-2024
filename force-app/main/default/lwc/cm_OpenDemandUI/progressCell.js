import { LightningElement, api } from 'lwc';

export default class ProgressCell extends LightningElement {
    @api progressValue;
    @api progressVariant;
}