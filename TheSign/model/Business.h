//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"



@class Featured,PFObject;

@interface Business : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSNumber * workingHoursEnd;
@property (nonatomic, retain) NSNumber * workingHoursStart;
@property (nonatomic, retain) NSString * businessType;
@property (nonatomic, retain) NSSet *featuredOffers;
@property (nonatomic, retain) NSSet *links;


+(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier;
+(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier;
+(NSArray*) getBusinessesByType:(NSString*)type;
+(NSArray*) getBusinessTypes;

+(NSString*)colName;
+(NSString*)colLogo;
+(NSString*)colUid;
+(NSString*)colWelcomeText;
+(NSString*)colWorkingHoursEnd;
+(NSString*)colWorkingHoursStart;
+(NSString*)colBusinessType;

+(NSString*)pName;
+(NSString*)pLogo;
+(NSString*)pUid;
+(NSString*)pWelcomeText;
+(NSString*)pWorkingHoursEnd;
+(NSString*)pWorkingHoursStart;
+(NSString*)pBusinessType;



@end


@interface Business (CoreDataGeneratedAccessors)

- (void)addFeaturedOffersObject:(Featured *)value;
- (void)removeFeaturedOffersObject:(Featured *)value;
- (void)addFeaturedOffers:(NSSet *)values;
- (void)removeFeaturedOffers:(NSSet *)values;

- (void)addLinksObject:(NSManagedObject *)value;
- (void)removeLinksObject:(NSManagedObject *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

@end
