//
//  TagConnection.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagConnection.h"
#import "Tag.h"
#import "Model.h"
#import "TagSet.h"
#import "Relevancy.h"
#import "Featured.h"

#define P_WEIGHT (@"weight")
#define P_CONTROL_TAG (@"linkedTagFrom")
#define P_RELATED_TAG (@"linkedTagTo")

#define CD_WEIGHT (@"weight")
#define CD_CONTROL_TAG (@"controlTag")
#define CD_RELATED_TAG (@"relatedTag")

@implementation TagConnection

@dynamic pObjectID;
@dynamic weight;
@dynamic linkedTagFrom;
@dynamic linkedTagTo;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TagConnection";}
+(NSString*) parseEntityName {return @"TagConnection";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_WEIGHT] && object[P_CONTROL_TAG] && object[P_RELATED_TAG])
        return YES;
    else
        return NO;
}

+(TagConnection*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (TagConnection*)result.firstObject;
}

+ (void)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    TagConnection *connection = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                              inManagedObjectContext:[Model sharedModel].managedObjectContext];
    connection.parseObject=object;
    connection.pObjectID=object.objectId;
    if(object[P_WEIGHT]!=nil) connection.weight=object[P_WEIGHT];
        
    //careful, incomplete object - only objectId property is there
    PFObject *parseTagFrom=object[P_CONTROL_TAG];
    Tag *linkedTagFrom=[Tag getByID:parseTagFrom.objectId];
    if (linkedTagFrom!=nil)
    {
        connection.linkedTagFrom=linkedTagFrom;
        [linkedTagFrom addLinkedConnectionsFromObject:connection];
    }
    else
        NSLog(@"Linked tag wasn't found");
    
    //careful, incomplete object - only objectId property is there
    PFObject *parseTagTo=object[P_RELATED_TAG];
    Tag *linkedTagTo=[Tag getByID:parseTagTo.objectId];
    if (linkedTagTo!=nil)
    {
        connection.linkedTagTo=linkedTagTo;
        [linkedTagTo addLinkedConnectionsToObject:connection];
    }
    else
        NSLog(@"Linked tag wasn't found");
    
    if(linkedTagTo && linkedTagFrom)
    {
        for(TagSet* tagset in linkedTagFrom.linkedTagSets)
            if(tagset.linkedOffer) [tagset.linkedOffer updateContextTagList];
        for(TagSet* tagset in linkedTagTo.linkedTagSets)
            if(tagset.linkedOffer) [tagset.linkedOffer updateContextTagList];
    }
        
    
}

-(void)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    //rescoring relevancy if we changed the weight
   /* if(self.weight!=self.parseObject[P_WEIGHT])
    {
        for(TagSet* tagset in self.linkedTagFrom.linkedTagSets)
            [tagset.linkedOffer.linkedScore rescore];
        
        for(TagSet* tagset in self.linkedTagTo.linkedTagSets)
            [tagset.linkedOffer.linkedScore rescore];
    }
    */
    self.weight=self.parseObject[P_WEIGHT];
    
    //careful, incomplete object - only objectId property is there
    PFObject *parseTagFrom=self.parseObject[P_CONTROL_TAG];
    Tag *linkedTagFrom=[Tag getByID:parseTagFrom.objectId];
    if (linkedTagFrom!=nil)
    {
        self.linkedTagFrom=linkedTagFrom;
        [linkedTagFrom addLinkedConnectionsFromObject:self];
    }
    else
        NSLog(@"Linked tag wasn't found");
    
    //careful, incomplete object - only objectId property is there
    PFObject *parseTagTo=self.parseObject[P_RELATED_TAG];
    Tag *linkedTagTo=[Tag getByID:parseTagTo.objectId];
    if (linkedTagTo!=nil)
    {
        self.linkedTagTo=linkedTagTo;
        [linkedTagTo addLinkedConnectionsToObject:self];
    }
    else
        NSLog(@"Linked tag wasn't found");

    
}



@end
