//**Created by powerfluence at 30/08/2022 starts */
import { LightningElement, wire,api } from 'lwc';
import getFiles from '@salesforce/apex/OpptyFilesDownloader.getFiles';
import { getRecord } from 'lightning/uiRecordApi';


const COLUMNS = [
    {
        label: 'Title',
        fieldName: 'Id',
        type: 'url',
        typeAttributes: { 
            label: { fieldName: 'Title' },
            target : '_blank'
        }
    },
    {
        label: 'Type',
        fieldName: 'FileExtension',
        type: 'text'
    }
];

const BASE_DOWNLOAD_PATH = '/sfc/servlet.shepherd/version/download';

export default class MassFileDownloader extends LightningElement {
    
    columns = COLUMNS;
    @api recordId;

    @wire(getFiles,{recordId: '$recordId'}) files;

    downloadFiles() {

        let selectedFiles = this.getSelectedRows();

        if(selectedFiles.length === 0) {
            alert('No files selected');
            return;
        }

        this.initDownloading(
            this.getDownloadString(selectedFiles)
        );
    }

    getDownloadString(files) {
        let downloadString = '';
        files.forEach(item => {
            downloadString += '/' + item.LatestPublishedVersionId
        });
        return downloadString;
    }

    initDownloading(downloadString) {
        //alert(BASE_DOWNLOAD_PATH + downloadString);
        window.open(BASE_DOWNLOAD_PATH + downloadString, '_blank');
    }

    getSelectedRows() {
        return this.template.querySelector('lightning-datatable').getSelectedRows(); 
    }
}
//**Created by powerfluence at 30/08/2022 ends */