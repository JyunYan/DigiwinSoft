//
//  MDataBaseManager.h
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "MUser.h"
#import "MEvent.h"
#import "MGuide.h"
#import "MSituation.h"
#import "MActivity.h"
#import "MTreasure.h"
#import "MPhenomenon.h"

@interface MDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase* db;

+(MDataBaseManager*) sharedInstance;
- (BOOL)loginWithAccount:(NSString*)account Password:(NSString*)pwd CompanyID:(NSString*)compid;

#pragma mark - 事件 相關
- (NSArray*)loadEventsWithUser:(MUser*)user;
- (NSArray*)loadSituationsWithEvent:(MEvent*)event;
- (NSArray*)loadTreasureWithActivity:(MActivity*)act;

- (NSArray*)loadActivitysWithEvent:(MEvent*)event;

#pragma mark - 行業攻略 相關

// get 現象
- (NSArray*)loadPhenArray;

// get 對策Sample
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen;

@end
