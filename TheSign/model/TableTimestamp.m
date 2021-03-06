//
//  TableTimestamp.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TableTimestamp.h"
#import "Model.h"

#define CD_TABLE (@"tableName")
#define CD_TIMESTAMP (@"timeStamp")
#define CD_ORDER (@"order")

#define P_TABLE (@"TableName")
#define P_TIMESTAMP (@"TimeStamp")
#define P_ORDER (@"order")

@implementation TableTimestamp

@dynamic pObjectID;
@dynamic tableName;
@dynamic timeStamp;
@dynamic order;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;
-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[TableTimestamp parseEntityName] objectId:self.pObjectID error:&error];
      //  else
       //     NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"TableTimestamp";}
+(NSString*) parseEntityName {return @"UpdateTimestamps";}

+(NSString*)pTableName {return P_TABLE;}
+(NSString*)pTimeStamp {return P_TIMESTAMP;}
+(NSString*)pOrder {return P_ORDER;}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_TABLE] && object[P_ORDER])
        return YES;
    else
        return NO;
}


+(TableTimestamp*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TableTimestamp entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
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
       // NSLog(@"%@: The object %@ is missing mandatory fields",[TableTimestamp parseEntityName],object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    TableTimestamp *timeStamp = [NSEntityDescription insertNewObjectForEntityForName:[TableTimestamp entityName]
                                                          inManagedObjectContext:context];
    timeStamp.pObjectID=object.objectId;
    timeStamp.timeStamp=object[TableTimestamp.pTimeStamp];
    timeStamp.tableName=object[TableTimestamp.pTableName];
    timeStamp.order=object[TableTimestamp.pOrder];
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
      //  NSLog(@"%@: Couldn't fetch the parse object with id: %@",[TableTimestamp parseEntityName],self.pObjectID);
        return NO;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
    //    NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.timeStamp=self.parseObject[TableTimestamp.pTimeStamp];
    self.tableName=self.parseObject[TableTimestamp.pTableName];
    self.order=self.parseObject[TableTimestamp.pOrder];
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TableTimestamp entityName]];
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


+ (NSArray*)getTableNamesForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TableTimestamp entityName]];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:CD_ORDER ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSArray *timestamps = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
    {
        return [timestamps valueForKey:CD_TABLE];
    }
}

+(NSDate*) getUpdateTimestampForTable:(NSString*)tName Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TableTimestamp entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", CD_TABLE,tName]];
    NSError *error;
    NSArray *timestamp = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
    //    NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    if(timestamp.count==0)
        return nil;
    else
        return ((TableTimestamp*)timestamp[0]).timeStamp;
}

@end
