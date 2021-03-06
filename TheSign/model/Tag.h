//
//  Tag.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class Like, TagConnection, TagSet, Relevancy, Featured,Context,Template;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * interest;
@property (nonatomic, retain) NSNumber * special;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *linkedConnectionsFrom;
@property (nonatomic, retain) NSNumber * likeness;
@property (nonatomic, retain) Context *linkedContext;

@property (nonatomic, retain) NSSet *linkedTagSets;
@property (nonatomic, retain) NSSet *linkedConnectionsTo;
@property (nonatomic, retain) NSSet *linkedCategoryTemplates;
@property (nonatomic, retain) NSSet *linkedContextTemplates;

/**
 Setting likeness score to tag and releated tags by traversing through the TagConnection graph.
 The minimal likeness to be used = 0.1
 */
-(void)processLike:(double)effect AlreadyProcessed:(NSMutableSet**)processedTags;

/**
 Returns accumulated relevancy score on the current depth level of the Tag's graph
 */
-(double) calculateRelevancyOnLevel:(NSInteger)depth AlreadyProcessed:(NSMutableSet**)processedTags;

/**
 Changing the likeness value for this tag
 */
-(void)changeLikenessByValue:(NSNumber*)value;

/**
 Getting all the Interest Tags
 */
+(NSArray*)getInterestsForContext:(NSManagedObjectContext*)context;

@end


@interface Tag (CoreDataGeneratedAccessors)

- (void)addLinkedConnectionsFromObject:(TagConnection *)value;
- (void)removeLinkedConnectionsFromObject:(TagConnection *)value;
- (void)addLinkedConnectionsFrom:(NSSet *)values;
- (void)removeLinkedConnectionsFrom:(NSSet *)values;

- (void)addLinkedConnectionsToObject:(TagConnection *)value;
- (void)removeLinkedConnectionsToObject:(TagConnection *)value;
- (void)addLinkedConnectionsTo:(NSSet *)values;
- (void)removeLinkedConnectionsTo:(NSSet *)values;

- (void)addLinkedTagSetsObject:(TagSet *)value;
- (void)removeLinkedTagSetsObject:(TagSet *)value;
- (void)addLinkedTagSets:(NSSet *)values;
- (void)removeLinkedTagSets:(NSSet *)values;

- (void)addLinkedCategoryTemplatesObject:(Template *)value;
- (void)removeLinkedCategoryTemplatesObject:(Template *)value;
- (void)addLinkedCategoryTemplates:(NSSet *)values;
- (void)removeLinkedCategoryTemplates:(NSSet *)values;

- (void)addLinkedContextTemplatesObject:(Template *)value;
- (void)removeLinkedContextTemplatesObject:(Template *)value;
- (void)addLinkedContextTemplates:(NSSet *)values;
- (void)removeLinkedContextTemplates:(NSSet *)values;

@end
