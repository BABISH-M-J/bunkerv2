//**Test class creatd for OpptyFileDownloader.cls by powerfluence[08/30/2022] Starts */
@IsTest
private class OpptyFilesDownloaderTest {
    
    @TestSetup
    static void createData() {
        Opportunity opp=new Opportunity(
            Name='Test12345',StageName='Development', CloseDate=Date.today()
        );
        insert opp;
        System.debug('Id'+opp.Id);
        ContentVersion cv = new ContentVersion(
            Title = 'DemoFile',
            VersionData = Blob.valueOf('Random String Data'),
            PathOnClient = 'DemoFile.png'
            
        );
        insert cv;
        ContentVersion contentVersion= [SELECT Id, Title, ContentDocumentId FROM ContentVersion
             WHERE Id = :cv.Id ].get(0);
             system.debug('contentVersion_2'+contentVersion.Id);
        
        ContentDocumentLink content=new ContentDocumentLink();
        content.LinkedEntityId=opp.Id;
        content.contentdocumentid =contentVersion.contentdocumentid;
        content.ShareType = 'V';
       // content.LinkedEntity.Type='Opportunity';

        insert content;
        ContentDocumentLink contlink=[SELECT ContentDocumentId,LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Opportunity where id =: opp.Id ) and LinkedEntity.Type='Opportunity'];
        System.debug('contlink'+contlink);
    }

    @IsTest
    static void getFilesTest() {
        Opportunity testopp=[SELECT Id FROM Opportunity where Name=:'Test12345'];
        
    System.debug('testopp'+testopp);
        
         String jsonStr = String.valueOf(testopp.Id);
         System.debug('jsonStr'+jsonStr);
        
        
        Test.startTest();
        System.assertEquals(
            1, 
            OpptyFilesDownloader.getFiles(jsonStr).size(),
            'Expected number of files does not match the expected count.'
        );
        Test.stopTest();
    }

    
}
//**Test class creatd for OpptyFileDownloader.cls by powerfluence[08/30/2022] ends*/