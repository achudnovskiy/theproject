//
//  Featured.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Featured.h"
#import "Business.h"
#import "Statistics.h"
#import "TagSet.h"
#import "Tag.h"
#import "TagConnection.h"
#import "Model.h"

#define CD_TITLE (@"title")
#define CD_DETAILS (@"details")
#define CD_FULLNAME (@"fullName")
#define CD_WELCOMETEXT (@"welcomeText")
#define CD_PERIOD (@"timePeriod")
#define CD_IMAGE (@"image")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_ACIVE (@"active")
#define CD_OPENED (@"opened")

#define P_TITLE (@"name")
#define P_FULLNAME (@"fullName")
#define P_PERIOD (@"timePeriod")
#define P_DETAILS (@"description")
#define P_WELCOMETEXT (@"welcomeText")
#define P_IMAGE (@"picture")
#define P_MINOR (@"minor")
#define P_BUSINESS (@"BusinessID")
#define P_ACTIVE (@"active")

@implementation Featured

@dynamic title;
@dynamic fullName;
@dynamic details;
@dynamic welcomeText;
@dynamic timePeriod;
@dynamic active;
@dynamic opened;
@dynamic image;
@dynamic major;
@dynamic minor;
@dynamic pObjectID;
@dynamic linkedTagSets;
@dynamic linkedBusiness;
@dynamic linkedStats;
@dynamic score;



#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[Featured parseEntityName] objectId:self.pObjectID error:&error];
        //else
          //  NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Featured";}
+(NSString*) parseEntityName {return @"Info";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_TITLE] && object[P_FULLNAME] && object[P_DETAILS] && object[P_BUSINESS])
        return YES;
    else
        return NO;
}

+(Featured*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Featured entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@='%@'", OBJECT_ID, identifier]];

    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
     //   NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}

+ (Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([self checkIfParseObjectRight:object]==NO)
    {
     //   NSLog(@"%@: The object %@ is missing mandatory fields",[Featured entityName],object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    NSError *error;
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:[Featured entityName]
                                                   inManagedObjectContext:context];
    deal.pObjectID=object.objectId;
    
    if(object[P_FULLNAME]!=nil) deal.fullName=object[P_FULLNAME];
    if(object[P_TITLE]!=nil) deal.title=object[P_TITLE];
    if(object[P_DETAILS]!=nil) deal.details=object[P_DETAILS];
    if(object[P_ACTIVE]!=nil)
        deal.active=object[P_ACTIVE];
    if(object[P_MINOR]!=nil) deal.minor=object[P_MINOR];
    
    if(object[P_PERIOD]!=nil) deal.timePeriod=object[P_PERIOD];
    
    
    if(object[P_IMAGE]!=nil)
    {
        PFFile *image=object[P_IMAGE];
        
        NSData *pulledImage=[image getData:&error];
        if(!error)
        {
            if(pulledImage!=nil)
                deal.image = pulledImage;
            else
            {
           //     NSLog(@"Image offer is missing");
            }
        }
        else
        {
        //    NSLog(@"%@",[error localizedDescription]);
            complete=NO;
        }
    }
    
    if(object[P_BUSINESS]!=nil)
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseBusiness=object[P_BUSINESS];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId Context:context];
        if (linkedBusiness!=nil)
        {
            deal.major=linkedBusiness.uid;
            deal.linkedBusiness = linkedBusiness;
            [linkedBusiness addLinkedOffersObject:deal];
        }
        else
        {
       //     NSLog(@"Linked business wasn't found");
            complete=NO;
        }
    }
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
     //   NSLog(@"%@: Couldn't fetch the parse object with id: %@",[Featured entityName],self.pObjectID);
        return NO;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
     //   NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;
    if(self.parseObject[P_FULLNAME]!=nil) self.fullName=self.parseObject[P_FULLNAME];
    if(self.parseObject[P_TITLE]!=nil) self.title=self.parseObject[P_TITLE];
    if(self.parseObject[P_DETAILS]!=nil) self.details=self.parseObject[P_DETAILS];
    if(self.parseObject[P_ACTIVE]!=nil) self.active=self.parseObject[P_ACTIVE];

    if(self.parseObject[P_ACTIVE]!=nil)self.active=self.parseObject[P_ACTIVE];
    if(self.parseObject[P_MINOR]!=nil)self.minor=self.parseObject[P_MINOR];
    if(self.parseObject[P_PERIOD]!=nil) self.timePeriod=self.parseObject[P_PERIOD];

    if(self.parseObject[P_IMAGE]!=nil)
    {
        NSError *error;
        PFFile *image=self.parseObject[P_IMAGE];
        NSData *pulledImage=[image getData:&error];
        if(!error)
        {
            if(pulledImage!=nil)
                self.image = pulledImage;
            else
            {
            //    NSLog(@"Image offer is missing");
            }
        }
        else
        {
         //   NSLog(@"%@",[error localizedDescription]);
            complete=NO;
        }
    }
    
    if(self.parseObject[P_BUSINESS]!=nil)
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseBusiness=self.parseObject[P_BUSINESS];
        if(self.linkedBusiness.pObjectID!=fromParseBusiness.objectId)
        {
            [self.linkedBusiness removeLinkedOffersObject:self];
            Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId Context:context];
            if(linkedBusiness!=nil)
            {
                self.major=linkedBusiness.uid;
                self.linkedBusiness = linkedBusiness;
                [linkedBusiness addLinkedOffersObject:self];
            }
            else
            {
             //   NSLog(@"Linked business wasn't found");
                complete=NO;
            }
        }
    }
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Featured entityName]];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
      //  NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}


+(Featured*) getOfferByMajor:(NSNumber*)major andMinor:(NSNumber*)minor Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Featured entityName]];
    NSPredicate *predicateMajor = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"(%@==%d)", CD_MAJOR, major.intValue]];
    NSPredicate *predicateMinor = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"(%@==%d)", CD_MINOR, minor.intValue]];
    NSPredicate *predicateActive = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"(%@==%d)", CD_ACIVE,YES]];
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor,predicateActive]];
   
    NSError *error;
    NSArray *featured = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
     //   NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    return featured.firstObject;
}


-(Boolean)checkContextTag:(Tag*) lookupTag
{
   for(TagSet* tagset in self.linkedTagSets)
   {
       if (tagset && tagset.linkedTag && [tagset.linkedTag.pObjectID isEqualToString:lookupTag.pObjectID])
           return YES;
   }
    return NO;
}

-(void) processLike:(double)effect
{
    //update likeness scores for tags. alreadyProcessed dictionary holds pObjectID's of tags that we've checked already
    NSMutableSet* alreadyProcessed=[NSMutableSet set];
    for(TagSet* tagset in self.linkedTagSets)
    {
        if( tagset.linkedTag) [tagset.linkedTag processLike:effect*tagset.weight.doubleValue AlreadyProcessed:&alreadyProcessed];
    }

    //update relevancy score
    double score=0.0;
    alreadyProcessed=[NSMutableSet set];
    for(TagSet* tagset in self.linkedTagSets)
        if( tagset.linkedTag) score+=[tagset.linkedTag calculateRelevancyOnLevel:0 AlreadyProcessed:&alreadyProcessed];
    
    [self changeRelevancyByValue:@(score)];
}



-(void)changeRelevancyByValue:(NSNumber*)value
{
    self.score=@(self.score.doubleValue+value.doubleValue);
}

-(NSString*)getLocationAddress;
{
    return [self.linkedBusiness getLocationAddressForDeal:self];
}
-(NSString*)getBusinessName
{
    return self.linkedBusiness.name;
}

-(UIImage*)getCategoryIcon
{
    return [self.linkedBusiness getCategoryIcon];
        
}
-(NSString*)getSpecialTagName
{
    for(TagSet* tagset in self.linkedTagSets)
    {
        if (tagset && tagset.linkedTag && tagset.linkedTag.special.boolValue==YES)
            return tagset.linkedTag.name;
    }
    return nil;
}

@end
