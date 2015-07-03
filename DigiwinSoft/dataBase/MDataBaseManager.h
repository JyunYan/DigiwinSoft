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
#import "MPhenomenon.h"
#import "MGuide.h"
#import "MActivity.h"
#import "MWorkItem.h"
#import "MIssue.h"
#import "MEvent.h"
#import "MSituation.h"
#import "MTreasure.h"
#import "MSkill.h"

#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"
#import "MCustTarget.h"

#import "MConfig.h"

@interface MDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase* db;

+(MDataBaseManager*) sharedInstance;
- (BOOL)loginWithAccount:(NSString*)account Password:(NSString*)pwd CompanyID:(NSString*)compid;

#pragma mark - 事件 相關
- (NSArray*)loadEventsWithUser:(MUser*)user;
- (NSArray*)loadSituationsWithEvent:(MEvent*)event;
- (NSArray*)loadTreasureWithActivity:(MCustActivity*)act;

- (NSArray*)loadActivitysWithEvent:(MEvent*)event;

#pragma mark - 行業攻略 相關

// get 現象
- (NSArray*)loadPhenArray;

// get 對策Sample
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen;
- (NSArray*)loadActivitySampleArrayWithGuide:(MGuide*)guide;
- (NSArray*)loadWorkItemSampleArrayWithActivity:(MActivity*)act;

// get 議題Sample By 對策
- (NSArray*)loadIssueArrayByGudie:(MGuide*)guide;

// get 所有職能array
- (NSArray*)loadAllSkills;

// get 員工array
- (NSArray*)loadEmployeeArray;

// get 我的規劃/我的攻略
- (NSArray*)loadMyPlanArray;
- (NSArray*)loadMyRaidersArray;

- (NSArray*)loadCustActivityArrayWithGuide:(MCustGuide*)guide;
- (NSArray*)loadCustWorkItemArrayWithActivity:(MCustActivity*)act;

// get 某企業指標實際值的歷史資料(過去一年)
- (NSArray*)loadHistoryTargetArrayWithTarget:(MTarget*)target;

// 加入"我的規劃"清單
- (void)insertGuides:(NSArray*)array from:(NSInteger)from;
- (BOOL)insertGuide:(MGuide*)guide from:(NSInteger)from;

- (void)insertActivitys:(NSArray*)array guideID:(NSString*)guideid;
- (BOOL)insertActivity:(MActivity*)act guideID:(NSString*)guideid;

- (void)insertWorkItems:(NSArray*)array activityID:(NSString*)actid guideID:(NSString*)guideid;
- (BOOL)insertWorkItem:(MWorkItem*)item activityID:(NSString*)actid guideID:(NSString*)guideid;

// 更新對策 release 狀態 Yes:攻略 No:規劃
- (BOOL)updateGuide:(MCustGuide*)guide release:(BOOL)release;

// 判斷此攻略是否都有負責人
- (BOOL)hasEmptyManagerUnderCustGudie:(MCustGuide*)guide;

// 刪除對策
- (BOOL)deleteFromPlanWithCustGude:(MCustGuide*)guide;

@end
