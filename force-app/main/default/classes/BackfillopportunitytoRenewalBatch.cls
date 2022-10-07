/* Batchappex created by powerfluence on requirement SAL-84 assinged by Mara at 9/14/2022.  */
/* For backfilling the data from original opportunity to renewal opportunity in Original_opportunity_c column */

public class BackfillopportunitytoRenewalBatch implements Database.Batchable<sObject> {
    public  List<Opportunity> opptyChild= new List<Opportunity>();
    
    public List<Opportunity> start(Database.BatchableContext BC){
        
        
        // find all the renewal opportunity collection which account have onely one renewal opportunity as per the condition 
        
        List<AggregateResult> renewalCollection = [SELECT COUNT(Id), Effective_Date_Cohort__c, AccountId FROM Opportunity WHERE Type= 'renewal v2' and Effective_Date_Cohort__c != null GROUP BY Effective_Date_Cohort__c, AccountId HAVING COUNT(Id) <= 1 LIMIT 2000];
		 
       
        for(AggregateResult a: renewalCollection)
    	{   
         Opportunity newopp = new Opportunity(id=(ID)a.get('Id'), Effective_Date_Cohort__c= (Date)a.get('Effective_Date_Cohort__c'),AccountId=(ID)a.get('AccountId'));

         opptyChild.add(newopp);

   		 }
        
       return opptyChild;
       
    }
    public void execute(Database.BatchableContext BC, List<Opportunity> opptunityChild){
        
            List<Opportunity> updateList = new List<Opportunity>();
            List<Opportunity> opptyPar=new List<Opportunity>();
            Map<String,Id> renewalOpportunityIdMap = new Map<String,Id>();
            List<Opportunity> renewalOpportunities =new List<Opportunity>();
            Integer count=1;
             /* Collect all the renewal opportunities with Effective_Date_Cohort__c not Equals to null */
        
            renewalOpportunities= [SELECT Effective_Date_Cohort__c, AccountId, Id FROM Opportunity WHERE Type= 'renewal v2' and Effective_Date_Cohort__c != null];
            system.debug('renewalOpportunities child'+opptunityChild);
            
                for(Opportunity curOpp : renewalOpportunities){
                    String curOppKey = curOpp.AccountId+''+curOpp.Effective_Date_Cohort__c;
                    renewalOpportunityIdMap.put(curOppKey,curOpp.Id);
                }
            /* collect all the parent Opportunites with Expiration_Cohort__c not equal to null */
        
            opptyPar = [SELECT Id, Expiration_Cohort__c , Effective_Date_Cohort__c,AccountId From Opportunity WHERE StageName='Closed Won' and Expiration_Cohort__c != null];
           
            system.debug('opptyPar'+opptyPar);
           
             /* Mapping the renewal collection (which Account have only one renewal opportunity) and all the renewal opportunities  */
             
            For(Opportunity childOpp: opptunityChild){
                For(Opportunity parentOpp: opptyPar){
                    
                    if((childOpp.Effective_Date_Cohort__c == parentOpp.Expiration_Cohort__c) && (childOpp.AccountId == parentOpp.AccountId))
                        {
                            count++;
                            String key=childOpp.AccountId+''+childOpp.Effective_Date_Cohort__c;
                            Id renewOppId = renewalOpportunityIdMap.get(key);
                            Opportunity oppToUpdate = new Opportunity();
                            oppToUpdate.Id = renewOppId;
                            oppToUpdate.Original_Opportunity__c = parentOpp.Id;
                            updateList.add(oppToUpdate);
                        }
                }
            }
            System.debug('UpdateList'+updateList+count);
            Database.update(updateList);
            
        
        
        }
    public void finish(Database.BatchableContext BC){
        
    }

}