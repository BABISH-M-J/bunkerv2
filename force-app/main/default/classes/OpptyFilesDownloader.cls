//**Code was created For mara's req on 08/30/2022 by powerfluence[babish] Starts */
public with sharing class OpptyFilesDownloader {
    
   
    @AuraEnabled(cacheable=true)
    public static ContentDocument[] getFiles(String recordId) {
        System.debug('recordId'+recordId);
        List<ContentDocument> contentDoc=new List<ContentDocument>();
        List<Id> ContentId=new List<Id>();
        //List<ContentDocumentLink> content=[SELECT ContentDocumentId,LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Opportunity where id =: recordId ) and LinkedEntity.Type='Opportunity'];

    //code modified by powerfluence at 9/16/2022 for mara request starts
        List<ContentDocumentLink> content=[SELECT ContentDocumentId,LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: recordId];
        System.debug('content'+content);
    //code modified by powerfluence at 9/16/2022 for mara request ends
        
        

        for(ContentDocumentLink con :content)
        {
             
            
            ContentId.add(con.ContentDocumentId );
            

        }
        contentDoc.addAll([SELECT Id, Title, FileExtension, LatestPublishedVersionId FROM ContentDocument WHERE Id IN :ContentId]);
        System.debug('contentDoc'+contentDoc);
        return  contentDoc;   }

    // @AuraEnabled(cacheable=true)
    // public static ContentDocument[] getFilesByIds(String[] contentDocumentIds) {
    //     return [
    //         SELECT
    //         Id, Title, FileExtension, LatestPublishedVersionId
    //         FROM ContentDocument
    //         WHERE Id IN :contentDocumentIds
    //     ];
    // }
}
//**Code was created For mara's req on 08/30/2022 by powerfluence[babish] Ends */