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
#import "MReport.h"
#import "MEfficacy.h"

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
- (NSArray*)loadEventsWithCustActivity:(MCustActivity*)activity;

- (NSInteger)loadEventsCountWithUser:(MUser*)user;
- (NSInteger)loadEventsCountWithCustActivity:(MCustActivity*)activity;

- (NSArray*)loadSituationsWithEvent:(MEvent*)event;
- (NSArray*)loadTreasureWithActivity:(MCustActivity*)act;

- (NSArray*)loadActivitysWithEvent:(MEvent*)event;

#pragma mark - 行業攻略 相關

// get 現象
- (NSArray*)loadPhenArray;

// get 對策Sample
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen;
- (NSArray*)loadGuideSampleArrayWithIssue:(MIssue*)issue;

- (NSArray*)loadActivitySampleArrayWithGuide:(MGuide*)guide;
- (NSArray*)loadWorkItemSampleArrayWithActivity:(MActivity*)act;
- (NSArray*)loadTargetSampleArray;

// get 議題Sample By 對策
- (NSArray*)loadIssueArrayByGudieID:(NSString*)guideid;

// get 所有職能array
- (NSArray*)loadAllSkills;

// get 員工array
- (NSArray*)loadEmployeeArray;

#pragma mark - 我的任務
// get 我的任務 list
- (NSArray*)loadMyMissionsWithIndex:(NSInteger)index;
- (NSArray*)loadMyGuideMissionsWithRelese:(BOOL)brelease status:(NSString*)status;
- (NSArray*)loadMyActivityMissionWithRelese:(BOOL)brelease status:(NSString*)status;
- (NSArray*)loadMyWorkItemMissionWithRelese:(BOOL)brelease status:(NSString*)status accepted:(NSString*)accepted;
- (NSArray*)loadReports;

- (BOOL)insertReport:(MReport*)report;

#pragma mark - 監控地圖
- (NSArray*)loadMonitorGuideData;
- (NSArray*)loadMonitorIssueWithGudieID:(NSString*)guideid;
- (NSArray*)loadIssueTypeArrayWithIssUUid:(NSString*)uuid;

#pragma mark - 找對策
- (NSArray*)loadQuestionArrayWithKeyword:(NSString*)keyword;
- (NSArray*)loadIssueArrayWithQuestionID:(NSString*)uuid;

#pragma mark - 看現況(經營效能)
- (NSArray*)loadCompanyEfficacyArray;
- (NSArray*)loadCompEffTargetArrayWithEffID:(NSString*)uuid;

#pragma mark - 看現況(管理表現)
- (NSArray*)loadCompManageItemArray;
- (NSArray*)loadCompMaItemIssueArrayWithMaItemID:(NSString*)uuid date:(NSString*)date;

#pragma mark - 看現況(行業情報)
- (NSArray*)loadIndustryInfoKindArray;
- (NSArray*)loadIndustryInfoArrayWithKindID:(NSString*)kindid;

- (MTarget*)loadTargetInfoWithID:(NSString*)uuid;

#pragma mark - 我的規劃/我的攻略
// get 我的規劃/我的攻略
- (NSArray*)loadMyPlanArray;
- (NSArray*)loadMyRaidersArray;

- (NSArray*)loadCustActivityArrayWithGuide:(MCustGuide*)guide;
- (NSArray*)loadCustWorkItemArrayWithActivity:(MCustActivity*)act;

// get 某企業指標實際值的歷史資料(過去一年)
- (NSArray*)loadHistoryTargetArrayWithTarget:(MTarget*)target limit:(NSInteger)limit;

// 加入"我的規劃"清單
- (void)insertGuides:(NSArray*)array from:(NSInteger)from;
- (BOOL)insertGuide:(MGuide*)guide from:(NSInteger)from;

- (void)insertActivitys:(NSArray*)array guideID:(NSString*)guideid;
- (BOOL)insertActivity:(MActivity*)act guideID:(NSString*)guideid;

- (void)insertWorkItems:(NSArray*)array activityID:(NSString*)actid guideID:(NSString*)guideid;
- (BOOL)insertWorkItem:(MWorkItem*)item activityID:(NSString*)actid guideID:(NSString*)guideid;

- (void)insertCustActivitys:(NSArray*)array;
- (BOOL)insertCustActivity:(MCustActivity*)act;
- (void)insertCustWorkItems:(NSArray*)array;
- (BOOL)insertCustWorkItem:(MCustWorkItem*)item;

// 更新對策 release 狀態 Yes:攻略 No:規劃
- (BOOL)updateGuide:(MCustGuide*)guide release:(BOOL)release;

// 判斷此攻略是否都有負責人
- (BOOL)hasEmptyManagerUnderCustGudie:(MCustGuide*)guide;

// 刪除對策
- (BOOL)deleteFromPlanWithCustGude:(MCustGuide*)guide;

@end
