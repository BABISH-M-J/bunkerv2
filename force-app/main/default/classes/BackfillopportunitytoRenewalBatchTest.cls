/* Test class created by powerfluence for BackfillopportunitytoRenewalBatch at 15/9/2022 task given by Mara   */
/* for backfilling data old opportunity to renewal opportunity in Original_opportunity_c column */
@isTest
public class BackfillopportunitytoRenewalBatchTest {
    @testSetup
    static void createParentOpportunity()
    {
        //insert the product
        Product2 product= new Product2();
        product.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Insurance Sales').getRecordTypeId();
        product.Name='product_test';
        
        database.insert(product);
        
        system.debug('qwertyuio'+Test.getStandardPricebookId());
        //getting standard pricebook Id
        Id identification= ID.valueOf(Test.getStandardPricebookId());
        //create price book
        Pricebook2 price=new Pricebook2();
        price.Id = identification;
        
        price.IsActive=true;
      
        
        database.update(price);
        
        Pricebook2 standardPricebook= new Pricebook2();
        
        system.debug('standardPricebook'+[SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :identification]);
        
        //create pricebook entry
        PriceBookEntry priceBookList = new PriceBookEntry();
        priceBookList.Product2Id=product.Id;
        priceBookList.IsActive=true;
        priceBookList.Pricebook2Id=price.Id;
        priceBookList.UnitPrice=100;
       
        
        
        
        insert priceBookList;
        
        //create account for opportunity
         Account account= new Account();
        account.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insurance Sales').getRecordTypeId();
            account.Name ='Test_Account';
        database.insert(account);
        
        //create parent opportuity using account id
        Opportunity oldOpportunity = new Opportunity();
        oldOpportunity.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Insurance Sales').getRecordTypeId();
                                                              oldOpportunity.AccountId = account.id;
                                                               oldOpportunity.Name ='Opportunity_test';
                                                                	oldOpportunity.Type= 'New Business';
                                                                oldOpportunity.StageName ='Closed Won';
                                                                oldOpportunity.CloseDate= /*date.addDays(5)*/date.parse('9/19/2022');
        database.insert(oldOpportunity);
        //add the opportunity product to the parrent opportunity
        OpportunityLineItem OpportunityLineItem= new OpportunityLineItem();
        system.debug('product'+product.id);
        
            OpportunityLineItem.OpportunityId=oldOpportunity.id; 
            OpportunityLineItem.PricebookEntryId=priceBookList.Id;
            OpportunityLineItem.Quantity = 1;
            OpportunityLineItem.UnitPrice=100;
        
            OpportunityLineItem.Product2Id=product.id;
        	OpportunityLineItem.Coverage_Limits__c='500k';
            OpportunityLineItem.Effective_Date__c=Date.today();
            
            OpportunityLineItem.Billing_Type__c='Direct';
            //OpportunityLineItem.Expiration_Date__c=Date.addDays(3);
       		OpportunityLineItem.Expiration_Date__c=date.parse('9/17/2022');
            OpportunityLineItem.Carrier_Policy_Number__c='ABCD123';
            OpportunityLineItem.Carrier_Selection__c='Mechanical Turk';
            OpportunityLineItem.Carrier__c='Acuity';
            OpportunityLineItem.Commission_Rate__c=10.00;
            System.runAs( new User( id = UserInfo.getUserId() ) ) {
               database.insert(OpportunityLineItem); 
            }
        
       //create renewal opportunity for using same Account
        Opportunity oldOpportunitychild = new Opportunity();
        oldOpportunitychild.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Insurance Sales').getRecordTypeId();
                                                              oldOpportunitychild.AccountId = account.id;
                                                               oldOpportunitychild.Name ='Opportunity_test_child';
                                                                	oldOpportunitychild.Type= 'renewal v2';
                                                                oldOpportunitychild.StageName ='New Submission';
        oldOpportunitychild.CloseDate=date.parse('9/20/2022');
                                                                oldOpportunitychild.Effective_Date_Cohort__c= /*date.addDays(5)*/date.parse('9/17/2022');
        database.insert(oldOpportunitychild);
        
        
        
    }
    //execute the original class.
     @isTest static void test() {
        Test.startTest();
         
         BackfillopportunitytoRenewalBatch batch= new BackfillopportunitytoRenewalBatch();
         Id batchId = Database.executeBatch(batch);
         
         
         Test.stopTest();
     }

}