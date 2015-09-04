//
//  MDataBaseManager.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDataBaseManager.h"
#import "MDirector.h"
#import "MMonitorData.h"
#import "MIssType.h"
#import "MManageItem.h"
#import "MQuestion.h"
#import "MIndustryInfo.h"
#import "MIndustryInfoKind.h"

@implementation MDataBaseManager

static MDataBaseManager* _director = nil;

+(MDataBaseManager*) sharedInstance
{
    @synchronized([MDataBaseManager class])
    {
        if( !_director)
        {
            _director=[[MDataBaseManager alloc] init];
        }
        return _director;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self createDataBase];
        [self connectDataBase];
    }
    
    return self;
}

- (void)createDataBase
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"dataStore.sqlite"];
    if(![fileManager fileExistsAtPath:path]){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dataStore.sqlite"];
        [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
        
        if(error)
            NSLog(@"Failed to create db file : %@", [error localizedDescription]);
    }
}

- (void)connectDataBase
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* path;
    path = [documentsDirectory stringByAppendingPathComponent:@"dataStore.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    self.db = db;
}

#pragma mark - login 相關

- (BOOL) loginWithAccount:(NSString*)account Password:(NSString*)pwd CompanyID:(NSString*)compid
{
    NSString* sql = @"select b.NAME, c.NAME, e.* from R_IND_COMP as a inner join M_INDUSTRY as b on a.IND_ID = b.ID inner join M_COMPANY as c on a.COMP_ID = c.ID inner join M_USER as d on d.COMP_ID = c.ID inner join M_EMPLOYEE as e on e.ID = d.EMP_ID where d.ACCOUNT = ? and d.PASSWORD = ? and d.COMP_ID = ?";
    //select b.NAME, c.NAME, e.*
    //from R_IND_COMP as a
    //inner join M_INDUSTRY as b on a.IND_ID = b.ID
    //inner join M_COMPANY as c on a.COMP_ID = c.ID
    //inner join M_USER as d on d.COMP_ID = c.ID
    //inner join M_EMPLOYEE as e on e.ID = d.EMP_ID
    //where d.ACCOUNT = 'amigo2' and d.PASSWORD = 'amigo2' and d.COMP_ID = 'cmp-001'
    
    FMResultSet* rs = [self.db executeQuery:sql, account, pwd, compid];
    if([rs next]){
        
        MUser* user = [MUser new];
        user.industryName = [rs stringForColumnIndex:0];    // industry name
        user.companyName = [rs stringForColumnIndex:1];     // company name
        user.uuid = [rs stringForColumn:@"ID"];
        user.industryId = [rs stringForColumn:@"IND_ID"];
        user.companyId = [rs stringForColumn:@"COMP_ID"];
        user.name = [rs stringForColumnIndex:5];            // user name
        user.phone = [rs stringForColumn:@"PHONE"];
        user.email = [rs stringForColumn:@"EMAIL"];
        user.arrive_date = [rs stringForColumn:@"ARRIVE_DATE"];
        user.thumbnail = [rs stringForColumn:@"THUMBNAIL"];
        
        user.skillArray = [self loadSkillsWithEmpID:user.uuid];
        
        [MDirector sharedInstance].currentUser = user;
        
        return YES;
    }else{
        return NO;
    }
}

- (NSArray*)loadAllSkills
{
    NSString* sql = @"select * from M_SKILL";
    
    NSMutableArray* array = [NSMutableArray new];
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        MSkill* skill = [MSkill new];
        skill.uuid = [rs stringForColumn:@"ID"];
        skill.name = [rs stringForColumn:@"NAME"];
        
        [array addObject:skill];
    }
    return array;
}

- (MSkill*)loadSuggestSkillWithID:(NSString*)uuid type:(NSInteger)type
{
    MSkill* skill = [MSkill new];
    
    NSString* sql = @"select * from M_SUGGEST as sug inner join M_SKILL as sk on sk.ID = sug.SKILL_ID ";
    if(type == 0)
        sql = [sql stringByAppendingString:@"where sug.GUI_ID = ?"];
    else if(type == 1)
        sql = [sql stringByAppendingString:@"where sug.ACT_ID = ?"];
    else if(type == 2)
        sql = [sql stringByAppendingString:@"where sug.WI_ID = ?"];
    else
        return skill;
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    if([rs next]){
        
        skill.uuid = [rs stringForColumn:@"ID"];
        skill.name = [rs stringForColumn:@"NAME"];
        skill.level = [rs stringForColumn:@"LEVEL"];
    }
    
    return skill;
}

#pragma mark - 事件相關

- (NSArray*)loadEventsWithCustActivity:(MCustActivity*)activity
{
    NSString* sql = @"select * from U_EVENT where ACT_ID = ?";
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, activity.uuid];
    while([rs next]){
        
        MEvent* event = [MEvent new];
        event.uuid = [rs stringForColumn:@"ID"];
        event.evtId = [rs stringForColumn:@"EVT_ID"];
        event.actId = [rs stringForColumn:@"ACT_ID"];
        event.name = [rs stringForColumn:@"NAME"];
        event.status = [rs stringForColumn:@"STATUS"];
        event.start = [rs stringForColumn:@"START_DATE"];
        
        [array addObject:event];
    }
    
    return array;
}

- (NSInteger)loadEventsCountWithCustActivity:(MCustActivity*)activity
{
    NSString* sql = @"select count(*) as count from U_EVENT where STATUS = '0' and ACT_ID = ?";
    FMResultSet* rs = [self.db executeQuery:sql, activity.uuid];
    if([rs next]){
        NSInteger count = [rs intForColumn:@"count"];
        return count;
    }
    return 0;
}

// p16
- (NSArray*)loadEventsWithUser:(MUser*)user
{
    NSString* sql = @"select e.* from U_ACTIVITY as a inner join U_EVENT as e on a.ID = e.ACT_ID where a.EMP_ID = ?";
    // select e.* from U_ACTIVITY as a
    // inner join U_EVENT as e on a.ID = e.ACT_ID
    // where a.EMP_ID = 'emp-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, user.uuid];
    while([rs next]){
        
        MEvent* event = [MEvent new];
        event.uuid = [rs stringForColumn:@"ID"];
        event.evtId = [rs stringForColumn:@"EVT_ID"];
        event.actId = [rs stringForColumn:@"ACT_ID"];
        event.name = [rs stringForColumn:@"NAME"];
        event.status = [rs stringForColumn:@"STATUS"];
        event.start = [rs stringForColumn:@"START_DATE"];
        
        [array addObject:event];
    }
    return array;
}

- (NSInteger)loadEventsCountWithUser:(MUser*)user
{
    NSString* sql = @"select count(*) as count from U_ACTIVITY as a inner join U_EVENT as e on a.ID = e.ACT_ID where e.STATUS = '0' and a.EMP_ID = ?";
    
    FMResultSet* rs = [self.db executeQuery:sql, user.uuid];
    if([rs next]){
        NSInteger count = [rs intForColumn:@"count"];
        return count;
    }
    return 0;
}

// p18
- (NSArray*)loadSituationsWithEvent:(MEvent*)event
{
    NSString* sql = @"select s.*, r.NAME from M_EVENT as e inner join R_EVT_SITU as res on e.ID = res.EVT_ID inner join M_SITUATION as s on s.ID = res.SITU_ID inner join R_SITU_REA as rsr on s.ID = rsr.SITU_ID inner join M_REASON as r on r.ID = rsr.REA_ID where e.ID = ?";
    // select s.*
    // from M_EVENT as e
    // inner join R_EVT_SITU as res on e.ID = res.EVT_ID
    // inner join M_SITUATION as s on s.ID = res.SITU_ID
    // inner join R_SITU_REA as rsr on s.ID = rsr.SITU_ID
    // inner join M_REASON as r on r.ID = rsr.REA_ID
    // where e.ID = 'evt-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, event.evtId];
    while([rs next]){
        MSituation* situ = [MSituation new];
        situ.uuid = [rs stringForColumn:@"ID"];
        situ.name = [rs stringForColumnIndex:1];    // situ name
        situ.reason = [rs stringForColumnIndex:2];  // reason name
        
        [array addObject:situ];
    }
    
    return array;
}

- (NSArray*)loadActivitysWithEvent:(MEvent*)event
{
    NSString* sql = @"select * from U_ACTIVITY as ua inner join U_TARGET as ut on ut.ID = ua.TAR_ID where ua.ID = ?";
    // select e.* from U_ACTIVITY as a
    // where a.ID = 'a-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, event.actId];
    while([rs next]){
        
        MCustActivity* act = [MCustActivity new];
        act.uuid = [rs stringForColumnIndex:0];
        act.name = [rs stringForColumnIndex:4];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.index = [rs stringForColumn:@"INDEX"];
        act.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        act.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        act.status = [rs stringForColumn:@"STATUS"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        act.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        
        // 指標
        MCustTarget* target = act.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:14];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = [rs stringForColumn:@"TYPE"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        act.manager = [self loadEmployeeWithID:empid];
        
        act.suggestSkill = [self loadSuggestSkillWithID:act.act_m_id type:1];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadCustWorkItemArrayWithActivity:act]];
        
        [array addObject:act];
    }
    
    [self adjustPreviosWithCustActivitys:array];
    
    return array;
}

- (NSString*)loadCustGuideIDWithCustomActID:(NSString*)actid
{
    NSString* sql = @"select GUIDE_ID from U_ACTIVITY where ID = ?";
    FMResultSet* rs = [self.db executeQuery:sql, actid];
    if([rs next])
        return [rs stringForColumn:@"GUIDE_ID"];
    return @"";
}

// p19
- (NSArray*)loadTreasureWithActivity:(MCustActivity*)act
{
    NSString* sql = @"select t.* from M_WORK_ITEM as wi inner join R_SOR_TRE as rst on wi.ID = rst.SOR_ID inner join M_TREASURE as t on t.ID = rst.TRE_ID where wi.ACT_ID = ? group by t.ID";
    // select t.*
    // from M_WORK_ITEM as wi
    // inner join R_SOR_TRE as rst on wi.ID = rst.SOR_ID
    // inner join M_TREASURE as t on t.ID = rst.TRE_ID
    // where wi.ACT_ID = 'act-001'
    // group by t.ID
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.act_m_id];
    while([rs next]){
        
        MTreasure* treasure = [MTreasure new];
        treasure.uuid = [rs stringForColumn:@"ID"];
        treasure.name = [rs stringForColumn:@"NAME"];
        treasure.phone = [rs stringForColumn:@"PHONE"];
        treasure.url = [rs stringForColumn:@"URL"];
        treasure.desc = [rs stringForColumn:@"DESCRIPTION"];
        
        [array addObject:treasure];
    }
    return array;
}

#pragma mark - 行業攻略相關

// p1, p2, p3
- (NSArray*)loadPhenArray
{
    NSString* uuid = [MDirector sharedInstance].currentUser.industryId;
    NSString* sql = @"select p.*, t.NAME, t.UNIT, t.TREND from R_IND_PHEN as rip inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID inner join M_TARGET as t on t.ID = p.TAR_ID where rip.IND_ID = ?";
    // select p.*, t.NAME, t.UNIT, t.TREND
    // from R_IND_PHEN as rip
    // inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID
    // inner join M_TARGET as t on t.ID = p.TAR_ID
    // where rip.IND_ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while([rs next]){
        
        MPhenomenon* phen = [MPhenomenon new];
        phen.uuid = [rs stringForColumn:@"ID"];
        phen.subject = [rs stringForColumn:@"SUBJECT"];
        phen.desc = [rs stringForColumn:@"DESCRIPTION"];
        
        MTarget* target = phen.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        [self loadTargetDetailWithTarget:target];
        
        [array addObject:phen];
    }
    return array;
}

// p5, p25
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen
{
    NSString* sql = @"select g.*, t.NAME, t.UNIT, t.TREND from R_PHEN_GUIDE as rpg inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rpg.PHEN_ID = ?";
    // select g.*, t.NAME, t.UNIT, t.TREND
    // from R_PHEN_GUIDE as rpg
    // inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID
    // inner join M_TARGET as t on t.ID = g.TAR_ID
    // where rpg.PHEN_ID = 'phe-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, phen.uuid];
    while([rs next]){
        MGuide* guide = [MGuide new];
        
        guide.uuid = [rs stringForColumn:@"ID"];
        guide.name = [rs stringForColumnIndex:2];   // 對策name
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.review = [rs stringForColumn:@"REVIEW"];
        guide.url = [rs stringForColumn:@"URL"];
        
        // 指標
        MTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];  // 指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        [self loadTargetDetailWithTarget:target];
        
        // 推薦職能
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.uuid type:0];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadActivitySampleArrayWithGuideID:guide.uuid]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadGuideSampleArrayWithPhen2:(MPhenomenon*)phen
{
    NSString* sql = @"select g.*, t.NAME, t.UNIT, t.TREND from R_PHEN_GUIDE as rpg inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rpg.PHEN_ID = ?";
    // select g.*, t.NAME, t.UNIT, t.TREND
    // from R_PHEN_GUIDE as rpg
    // inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID
    // inner join M_TARGET as t on t.ID = g.TAR_ID
    // where rpg.PHEN_ID = 'phe-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, phen.uuid];
    while([rs next]){
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_GUIDE_UUID_PREV];
        guide.companyID = [MDirector sharedInstance].currentUser.companyId;
        guide.gui_uuid = [rs stringForColumn:@"ID"];
        guide.name = [rs stringForColumnIndex:2];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.review = [rs stringForColumn:@"REVIEW"];
        guide.url = [rs stringForColumn:@"URL"];
        guide.bRelease = NO;
        guide.status = @"0";
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
        target.tar_uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = @"1";
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 推薦職能
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.gui_uuid type:0];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadActivitySampleArrayWithGuide2:guide]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadGuideSampleArrayWithIssue:(MIssue*)issue
{
    NSString* sql = @"select g.*, t.NAME, t.UNIT, t.TREND from R_GUIDE_ISSUE as rgi inner join M_GUIDE as g on g.ID = rgi.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rgi.ISSUE_ID = ?";
    // select g.*, t.NAME, t.UNIT, t.TREND
    // from R_GUIDE_ISSUE as rgi
    // inner join M_GUIDE as g on g.ID = rgi.GUIDE_ID
    // inner join M_TARGET as t on t.ID = g.TAR_ID
    // where rgi.ISSUE_ID = 'iss-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, issue.uuid];
    while([rs next]){
        
        MGuide* guide = [MGuide new];
        
        guide.uuid = [rs stringForColumn:@"ID"];
        guide.name = [rs stringForColumnIndex:2];   // 對策name
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.review = [rs stringForColumn:@"REVIEW"];
        guide.url = [rs stringForColumn:@"URL"];
        
        // 指標
        MTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];  // 指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        [self loadTargetDetailWithTarget:target];
        
        // 推薦職能
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.uuid type:0];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadActivitySampleArrayWithGuideID:guide.uuid]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadGuideSampleArrayWithIssue2:(MIssue*)issue
{
    NSString* sql = @"select g.*, t.NAME, t.UNIT, t.TREND from R_GUIDE_ISSUE as rgi inner join M_GUIDE as g on g.ID = rgi.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rgi.ISSUE_ID = ?";
    // select g.*, t.NAME, t.UNIT, t.TREND
    // from R_GUIDE_ISSUE as rgi
    // inner join M_GUIDE as g on g.ID = rgi.GUIDE_ID
    // inner join M_TARGET as t on t.ID = g.TAR_ID
    // where rgi.ISSUE_ID = 'iss-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, issue.uuid];
    while([rs next]){
        
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_GUIDE_UUID_PREV];
        guide.companyID = [MDirector sharedInstance].currentUser.companyId;
        guide.gui_uuid = [rs stringForColumn:@"ID"];
        guide.name = [rs stringForColumnIndex:2];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.review = [rs stringForColumn:@"REVIEW"];
        guide.url = [rs stringForColumn:@"URL"];
        guide.bRelease = NO;
        guide.status = @"0";
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
        target.tar_uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = @"1";
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 推薦職能
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.gui_uuid type:0];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadActivitySampleArrayWithGuide2:guide]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadActivitySampleArrayWithGuideID:(NSString*)uuid
{
    NSString* sql = @"select ma.*, mt.NAME, mt.UNIT, mt.TREND from R_GUIDE_ACT as rga inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID inner join M_TARGET as mt on ma.TAR_ID = mt.ID where rga.GUIDE_ID = ?";
    // select ma.*, mt.NAME, mt.UNIT, mt.TREND
    // from R_GUIDE_ACT as rga
    // inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID
    // inner join M_TARGET as mt on ma.TAR_ID = mt.ID
    // where rga.GUIDE_ID = 'gui-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while ([rs next]) {
        MActivity* act = [MActivity new];
        act.uuid = [rs stringForColumn:@"ID"];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.index = [rs stringForColumn:@"INDEX"];
        act.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        act.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        act.name = [rs stringForColumnIndex:1];
        
        act.guide_id = uuid;
        
        // 指標
        MTarget* target = act.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.name = [rs stringForColumnIndex:6];
        
        [self loadTargetDetailWithTarget:target];
        
        // 推薦職能
        act.suggestSkill = [self loadSuggestSkillWithID:act.uuid type:1];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadWorkItemSampleArrayWithActivity:act]];
        
        [array addObject:act];
    }
    return array;
}

- (NSArray*)loadActivitySampleArrayWithGuide2:(MCustGuide*)guide
{
    NSString* sql = @"select ma.*, mt.NAME, mt.UNIT, mt.TREND from R_GUIDE_ACT as rga inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID inner join M_TARGET as mt on ma.TAR_ID = mt.ID where rga.GUIDE_ID = ?";
    // select ma.*, mt.NAME, mt.UNIT, mt.TREND
    // from R_GUIDE_ACT as rga
    // inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID
    // inner join M_TARGET as mt on ma.TAR_ID = mt.ID
    // where rga.GUIDE_ID = 'gui-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.gui_uuid];
    while ([rs next]) {
        
        MCustActivity* act = [MCustActivity new];
        act.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_ACT_UUID_PREV];
        act.act_m_id = [rs stringForColumn:@"ID"];
        act.name = [rs stringForColumnIndex:1];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.index = [rs stringForColumn:@"INDEX"];
        act.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        act.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        act.status = @"0";
        act.comp_id = [MDirector sharedInstance].currentUser.companyId;
        act.guide_id = guide.uuid;
        
        // 指標
        MCustTarget* target = act.custTarget;
        target.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
        target.tar_uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = @"1";
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 推薦職能
        act.suggestSkill = [self loadSuggestSkillWithID:act.act_m_id type:1];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadWorkItemSampleArrayWithActivity2:act]];
        
        [array addObject:act];
    }
    
    [self adjustPreviosWithCustActivitys:array];
    
    return array;
}

- (NSArray*)loadWorkItemSampleArrayWithActivity:(MActivity*)act
{
    NSString* sql = @"select mw.*, mt.NAME, mt.UNIT, mt.TREND from M_WORK_ITEM as mw inner join M_TARGET as mt on mw.TAR_ID = mt.ID where mw.ACT_ID = ?";
    // select mw.*, mt.NAME, mt.UNIT, mt.TREND
    // from M_WORK_ITEM as mw
    // inner join M_TARGET as mt on mw.TAR_ID = mt.ID
    // where mw.ACT_ID = 'act-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.uuid];
    while ([rs next]) {
        
        MWorkItem* item = [MWorkItem new];
        item.uuid = [rs stringForColumn:@"ID"];
        item.desc = [rs stringForColumn:@"DESCRIPTION"];
        item.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        item.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        item.name = [rs stringForColumnIndex:2];
        
        item.act_id = act.uuid;
        item.guide_id = act.guide_id;
        
        MTarget* target = item.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.name = [rs stringForColumnIndex:7];
        
        [self loadTargetDetailWithTarget:target];
        
        // 推薦職能
        item.suggestSkill = [self loadSuggestSkillWithID:item.uuid type:2];
        
        [array addObject:item];
        
    }
    return array;
}

- (NSArray*)loadWorkItemSampleArrayWithActivity2:(MCustActivity*)act
{
    NSString* sql = @"select mw.*, mt.NAME, mt.UNIT, mt.TREND from M_WORK_ITEM as mw inner join M_TARGET as mt on mw.TAR_ID = mt.ID where mw.ACT_ID = ?";
    // select mw.*, mt.NAME, mt.UNIT, mt.TREND
    // from M_WORK_ITEM as mw
    // inner join M_TARGET as mt on mw.TAR_ID = mt.ID
    // where mw.ACT_ID = 'act-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.act_m_id];
    while ([rs next]) {
        
        MCustWorkItem* item = [MCustWorkItem new];
        item.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_WORK_ITEM_UUID_PREV];
        item.wi_m_id = [rs stringForColumn:@"ID"];
        item.name = [rs stringForColumnIndex:2];
        item.desc = [rs stringForColumn:@"DESCRIPTION"];
        item.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        item.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        item.status = @"0";
        item.comp_id = [MDirector sharedInstance].currentUser.companyId;
        item.guide_id = act.guide_id;
        item.act_id = act.uuid;
        
        item.accepted = @"0";
        
        // 指標
        MCustTarget* target = item.custTarget;
        target.uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
        target.tar_uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:7];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = @"1";
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 推薦職能
        item.suggestSkill = [self loadSuggestSkillWithID:item.wi_m_id type:2];
        
        [array addObject:item];
        
    }
    
    [self adjustPreviosWithCustWorkItems:array];
    return array;
}

- (NSArray*)loadTargetSampleArray
{
    NSMutableArray* array = [NSMutableArray new];
    NSString* sql = @"select * from M_TARGET";
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        MTarget* target = [MTarget new];
        target.uuid = [rs stringForColumn:@"ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        [array addObject:target];
    }
    return array;
}

// p30
- (NSArray*)loadEmployeeArray
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select ind.NAME, comp.NAME, emp.* from M_EMPLOYEE as emp inner join M_INDUSTRY as ind on ind.ID = emp.IND_ID inner join M_COMPANY as comp on comp.ID = emp.COMP_ID where COMP_ID = ?";
    // select ind.NAME, comp.NAME, emp.*
    // from M_EMPLOYEE as emp
    // inner join M_INDUSTRY as ind on ind.ID = emp.IND_ID
    // inner join M_COMPANY as comp on comp.ID = emp.COMP_ID
    // where COMP_ID = ?
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid];
    while ([rs next]) {
        MUser* user = [MUser new];
        user.industryName = [rs stringForColumnIndex:0];    // industry name
        user.companyName = [rs stringForColumnIndex:1];     // company name
        user.uuid = [rs stringForColumn:@"ID"];
        user.industryId = [rs stringForColumn:@"IND_ID"];
        user.companyId = [rs stringForColumn:@"COMP_ID"];
        user.name = [rs stringForColumnIndex:5];            // user name
        user.phone = [rs stringForColumn:@"PHONE"];
        user.email = [rs stringForColumn:@"EMAIL"];
        user.arrive_date = [rs stringForColumn:@"ARRIVE_DATE"];
        user.thumbnail = [rs stringForColumn:@"THUMBNAIL"];
        
        user.skillArray = [self loadSkillsWithEmpID:user.uuid];
        
        [array addObject:user];
    }
    return array;
}

// p25
- (NSArray*)loadIssueArrayByGudieID:(NSString*)guideid
{
    NSString* industryId = [MDirector sharedInstance].currentUser.industryId;
    NSString* sql = @"select tar.NAME, tar.UNIT, tar.TREND, iss.*, rit.* from R_GUIDE_ISSUE as rgi inner join M_ISSUE as iss on iss.ID = rgi.ISSUE_ID inner join M_TARGET as tar on iss.TAR_ID = tar.ID inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID where rgi.GUIDE_ID = ? AND rit.IND_ID = ?";
    // select tar.NAME, tar.UNIT, tar.TREND, iss.*, rit.*
    // from R_GUIDE_ISSUE as rgi
    // inner join M_ISSUE as iss on iss.ID = rgi.ISSUE_ID
    // inner join M_TARGET as tar on iss.TAR_ID = tar.ID
    // inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID
    // where rgi.GUIDE_ID = 'gui-001' AND rit.IND_ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guideid, industryId];
    while([rs next]){
        
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumnIndex:5];   // 議題name
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        
        MTarget* target = issue.target;
        target.uuid = [rs stringForColumnIndex:4];  //指標id
        target.name = [rs stringForColumnIndex:0];   //指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        target.top = [rs stringForColumn:@"TOP"];
        target.avg = [rs stringForColumn:@"AVG"];
        target.bottom = [rs stringForColumn:@"BOTTOM"];
        target.upMin = [rs stringForColumn:@"UP_MIN"];
        target.upMax = [rs stringForColumn:@"UP_MAX"];
        
        [self loadTargetDetailWithTarget:target];
        
        [array addObject:issue];
    }
    return array;
}

- (NSArray*)loadAllHistoryTargetArrayWithTargetID:(NSString*)tarid
{
    NSString* indid = [MDirector sharedInstance].currentUser.industryId;
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_IND_TAR as rit inner join M_TARGET as tar on tar.ID = rit.TAR_ID inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID where rit.IND_ID = ? and tar.ID = ? and rct.COMP_ID = ? order by rct.DATETIME desc";
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, indid, tarid, compid];
    while([rs next]){
        MTarget* target = [MTarget new];
        target.uuid = [rs stringForColumn:@"ID"];
        target.name = [rs stringForColumn:@"NAME"];
        
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        target.datetime = [rs stringForColumn:@"DATETIME"];
        
        target.top = [rs stringForColumn:@"TOP"];
        target.avg = [rs stringForColumn:@"AVG"];
        target.bottom = [rs stringForColumn:@"BOTTOM"];
        target.upMin = [rs stringForColumn:@"UP_MIN"];
        target.upMax = [rs stringForColumn:@"UP_MAX"];
        
        [array insertObject:target atIndex:0];
    }
    return array;
    
    /*
    //test
    NSArray* array = [self loadHistoryTargetArrayWithTargetID:tarid limit:12];
    
    NSMutableArray* array2 = [NSMutableArray new];
    NSMutableArray* last = [NSMutableArray new];
    for (MTarget* target in array) {
        if([target.datetime hasPrefix:@"2015"])
            [last addObject:target];
        if([target.datetime hasPrefix:@"2014"]){
            NSString* datetime = [target.datetime stringByReplacingOccurrencesOfString:@"2014" withString:@"2005"];
            target.datetime = datetime;
            [array2 addObject:target];
        }
    }
    
    for (int i=2006; i<2015; i++) {
        array = [self loadHistoryTargetArrayWithTargetID:tarid limit:12];
        int index = 1;
        for (MTarget* target in array) {
            NSString* datetime = [NSString stringWithFormat:@"%d-%02d-01", i, index];
            //NSLog(@"%02d : %@", index, datetime);
            target.datetime = datetime;
            [array2 addObject:target];
            index ++;
        }
    }
    
    [array2 addObjectsFromArray:last];
    
    int index = 0;
    for (MTarget* target in array2) {
        NSLog(@"%@ : %@", target.datetime, target.valueR);
        index++;
    }
    return array2;
    */
    
}

// p29
- (NSArray*)loadHistoryTargetArrayWithTargetID:(NSString*)tarid limit:(NSInteger)limit
{
    NSString* indid = [MDirector sharedInstance].currentUser.industryId;
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_IND_TAR as rit inner join M_TARGET as tar on tar.ID = rit.TAR_ID inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID where rit.IND_ID = ? and tar.ID = ? and rct.COMP_ID = ? order by rct.DATETIME desc";
    // select *
    // from R_IND_TAR as rit
    // inner join M_TARGET as tar on tar.ID = rit.TAR_ID
    // inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID
    // where rit.IND_ID = 'ind-001' and tar.ID = 'tar-001' and rct.COMP_ID = 'cmp-001'
    // order by rct.DATETIME desc
    
    if(limit > 0)
        sql = [NSString stringWithFormat:@"%@ limit %d", sql, (int)limit];
    
    NSMutableArray* array = [NSMutableArray new];

    NSString* unit = @"";
    NSString* datetime = @"";

    FMResultSet* rs = [self.db executeQuery:sql, indid, tarid, compid];
    while([rs next]){
        MTarget* target = [MTarget new];
        target.uuid = [rs stringForColumn:@"ID"];
        target.name = [rs stringForColumn:@"NAME"];
        
        target.unit = [rs stringForColumn:@"UNIT"];
        unit = target.unit;
        
        target.trend = [rs stringForColumn:@"TREND"];
        
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        target.datetime = [rs stringForColumn:@"DATETIME"];
        datetime = target.datetime;
        
        target.top = [rs stringForColumn:@"TOP"];
        target.avg = [rs stringForColumn:@"AVG"];
        target.bottom = [rs stringForColumn:@"BOTTOM"];
        target.upMin = [rs stringForColumn:@"UP_MIN"];
        target.upMax = [rs stringForColumn:@"UP_MAX"];
        
        [array insertObject:target atIndex:0];
    }
    
    // 補到跟limit一樣數量
    NSInteger count = limit - array.count;
    
    NSString* yearStr = [datetime substringToIndex:4];
    NSString* monthStr = [datetime substringWithRange:NSMakeRange(5, 2)];
    NSInteger year = [yearStr integerValue];
    NSInteger month = [monthStr integerValue];
    
    for (int i = 0; i<count; i++) {
        MTarget* target = [MTarget new];
        target.unit = unit;
        
        if (month == 1) {
            month = 12;
            year--;
        } else {
            month--;
        }
        NSString* newMonthStr = [NSString stringWithFormat:@"%02d", (int)month];
        target.datetime = [NSString stringWithFormat:@"%04d-%@-01", (int)year, newMonthStr];
        
        [array insertObject:target atIndex:0];
    }
    
    return array;
}

#pragma mark - 我的任務

- (NSArray*)loadMyMissionsWithIndex:(NSInteger)index
{
    NSMutableArray* missions = [NSMutableArray new];
    
    if(index == 0){         //待佈屬任務
        NSArray* array2 = [self loadMyActivityMissionWithRelese:NO status:@"0"];                //規劃的關鍵活動
        [missions addObjectsFromArray:array2];
        NSArray* array3 = [self loadMyWorkItemMissionWithRelese:YES status:@"0" accepted:@"0"]; //攻略&未接受的工作項目
        [missions addObjectsFromArray:array3];
    }else if(index == 1){   //進度回報
        NSArray* array2 = [self loadMyActivityMissionWithRelese:YES status:@"0"];               //攻略的關鍵活動
        [missions addObjectsFromArray:array2];
        NSArray* array3 = [self loadMyWorkItemMissionWithRelese:YES status:@"0" accepted:@"1"]; //攻略&已接受的工作項目
        [missions addObjectsFromArray:array3];
    }else if(index == 2){   //已完成任務
        NSArray* array2 = [self loadMyActivityMissionWithRelese:YES status:@"2"];               //攻略&已完成的關鍵活動
        [missions addObjectsFromArray:array2];
        NSArray* array3 = [self loadMyWorkItemMissionWithRelese:YES status:@"2" accepted:@"1"]; //攻略&已完成的工作項目
        [missions addObjectsFromArray:array3];
    }else{
        return missions;
    }
    
    
    // sort by created date
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"cre_dte" ascending:YES];  // YES:升冪 NO:降冪
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [missions sortUsingDescriptors:descriptors];
    
    return missions;
}

- (NSArray*)loadMyGuideMissionsWithRelese:(BOOL)brelease status:(NSString*)status
{
    NSMutableArray* array = [NSMutableArray new];

    NSString* rel = brelease ? @"1" : @"0";
    NSString* empid = [MDirector sharedInstance].currentUser.uuid;
    NSString* sql = @"select * from U_GUIDE as ug inner join U_TARGET as ut on ug.TAR_ID = ut.ID where ug.EMP_ID = ? and ug.RELEASE = ? ";
    if(!status)
        return array;
    else if([status isEqualToString:@"2"])
        sql = [sql stringByAppendingString:@"and ug.STATUS = 2"];   //已完成
    else
        sql = [sql stringByAppendingString:@"and ug.STATUS <> 2"];  //未開始or進行中
    
    FMResultSet* rs = [self.db executeQuery:sql, empid, rel];
    while ([rs next]) {
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [rs stringForColumnIndex:0];
        guide.companyID = [rs stringForColumn:@"COMP_ID"];
        guide.gui_uuid = [rs stringForColumn:@"GUI_M_ID"];
        guide.name = [rs stringForColumnIndex:5];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.bRelease = [rs boolForColumn:@"RELEASE"];
        guide.status = [rs stringForColumn:@"STATUS"];
        guide.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:15];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        target.type = [rs stringForColumn:@"TYPE"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        
        // 緣起1
        NSString* phenId = [rs stringForColumn:@"FROM_PHEN_ID"];
        guide.fromPhen = [self loadPhenWithID:phenId];
        
        // 緣起2
        NSString* issueId = [rs stringForColumn:@"FROM_ISS_ID"];
        guide.fromIssue = [self loadIssueWithID:issueId];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        guide.manager = [self loadEmployeeWithID:empid];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadCustActivityArrayWithCustGuideID:guide.uuid]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadMyActivityMissionWithRelese:(BOOL)brelease status:(NSString*)status
{
    NSMutableArray* array = [NSMutableArray new];
    
    NSString* rel = brelease ? @"1" : @"0";
    NSString* empid = [MDirector sharedInstance].currentUser.uuid;
    NSString* sql = @"select ua.*, ut.* from U_GUIDE as ug inner join U_ACTIVITY as ua on ug.ID = ua.GUIDE_ID inner join U_TARGET as ut on ua.TAR_ID = ut.ID where ug.RELEASE = ? and ua.EMP_ID = ? ";
    if(!status)
        return array;
    else if([status isEqualToString:@"2"])
        sql = [sql stringByAppendingString:@"and ua.STATUS = 2"];   //已完成
    else
        sql = [sql stringByAppendingString:@"and ua.STATUS <> 2"];  //未開始or進行中
    
    FMResultSet* rs = [self.db executeQuery:sql, rel, empid];
    while ([rs next]) {
        
        MCustActivity* act = [MCustActivity new];
        act.uuid = [rs stringForColumnIndex:0];
        act.name = [rs stringForColumnIndex:4];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.index = [rs stringForColumn:@"INDEX"];
        act.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        act.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        act.status = [rs stringForColumn:@"STATUS"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        act.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        
        // 指標
        MCustTarget* target = act.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:14];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        target.type = [rs stringForColumn:@"TYPE"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        act.manager = [self loadEmployeeWithID:empid];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadCustWorkItemArrayWithActivity:act]];
        
        [array addObject:act];
    }
    return array;
}

- (NSArray*)loadMyWorkItemMissionWithRelese:(BOOL)brelease status:(NSString*)status accepted:(NSString*)accepted
{
    NSMutableArray* array = [NSMutableArray new];
    
    NSString* rel = brelease ? @"1" : @"0";
    NSString* empid = [MDirector sharedInstance].currentUser.uuid;
    NSString* sql = @"select uw.*, ut.* from U_GUIDE as ug inner join U_WORK_ITEM as uw on ug.ID = uw.GUIDE_ID inner join U_TARGET as ut on uw.TAR_ID = ut.ID where ug.RELEASE = ? and uw.EMP_ID = ? and uw.ACCEPTED = ? ";
    if(!status)
        return array;
    else if([status isEqualToString:@"2"])
        sql = [sql stringByAppendingString:@"and uw.STATUS = 2"];   //已完成
    else
        sql = [sql stringByAppendingString:@"and uw.STATUS <> 2"];  //未開始or進行中
    
//    if(!status)
//        return array;
//    else
//        sql = [sql stringByAppendingFormat:@"and uw.STATUS = '%@'", status];  //未開始or進行中or已完成
    
    FMResultSet* rs = [self.db executeQuery:sql, rel, empid, accepted];
    while ([rs next]) {
        
        MCustWorkItem* item = [MCustWorkItem new];
        item.uuid = [rs stringForColumnIndex:0];
        item.name = [rs stringForColumnIndex:5];
        item.desc = [rs stringForColumn:@"DESCRIPTION"];
        item.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        item.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        item.status = [rs stringForColumn:@"STATUS"];
        item.comp_id = [rs stringForColumn:@"COMP_ID"];
        item.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        item.act_id = [rs stringForColumn:@"ACT_ID"];
        item.wi_m_id = [rs stringForColumn:@"WI_M_ID"];
        item.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        item.accepted = [rs stringForColumn:@"ACCEPTED"];
        
        // 指標
        MCustTarget* target = item.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:16];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        target.type = [rs stringForColumn:@"TYPE"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        item.manager = [self loadEmployeeWithID:empid];
        
        [array addObject:item];
    }
    
    return array;
}

// p35
- (NSArray*)loadReports
{
    NSString* sql = @"select * from U_REPORT";
    // select *
    // from U_REPORT
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        MReport* report = [MReport new];
        report.uuid = [rs stringForColumn:@"ID"];
        report.gui_id = [rs stringForColumn:@"GUI_ID"];
        report.act_id = [rs stringForColumn:@"ACT_ID"];
        report.wi_id = [rs stringForColumn:@"WI_ID"];

        report.status = [rs stringForColumn:@"STATUS"];
        report.value = [rs stringForColumn:@"VALUE"];
        report.desc = [rs stringForColumn:@"DESCRIPTION"];
        report.completed = [rs stringForColumn:@"COMPLETED"];
        report.create_date = [rs stringForColumn:@"CREATE_DATE"];

        [array addObject:report];
    }
    return array;
}

- (BOOL)insertReport:(MReport*)report
{
    NSString* uuid = report.uuid;
    NSString* gui_id = report.gui_id;
    NSString* act_id = report.act_id;
    NSString* wi_id = report.wi_id;

    if (uuid == nil || [uuid isEqualToString:@""]) {
        uuid = [[MDirector sharedInstance] getCustUuidWithPrev:REPORT_UUID_PREV];
    }

    NSString* status = report.status;
    NSString* value = report.value;
    NSString* desc = report.desc;
    NSString* completed = report.completed;
    NSString* create_date = report.create_date;
    
    if (create_date == nil || [create_date isEqualToString:@""]) {
        NSDateFormatter* dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate* date = [NSDate date];
        create_date = [dateFormatter stringFromDate:date];
    }

    NSString* sql = @"insert into U_REPORT ('ID','GUI_ID','ACT_ID','WI_ID','STATUS','VALUE','DESCRIPTION','COMPLETED','CREATE_DATE') VALUES(?,?,?,?,?,?,?,?,?)";
    // insert into U_REPORT
    // ('ID','GUI_ID','ACT_ID','WI_ID','STATUS','VALUE','DESCRIPTION','COMPLETED','CREATE_DATE')
    // VALUES(%@,%@,%@,%@,%@,%@,%@,%@,%@)
    
    
    BOOL b = [self.db executeUpdate:sql, uuid, gui_id, act_id, wi_id, status, value, desc, completed, create_date];
    if(!b){
        NSLog(@"add report failed : %@", [self.db lastErrorMessage]);
    }
    
    return b;
}

#pragma mark - 我的規劃 相關

// p15-1, load 我的規劃
- (NSArray*)loadMyPlanArray
{
    NSString* empid = [MDirector sharedInstance].currentUser.uuid;
    
    NSString* sql = @"select * from U_GUIDE as ug inner join U_TARGET as ut on ug.TAR_ID = ut.ID  where (ug.OWNER = ? or ug.EMP_ID = ?) and ug.RELEASE = ? order by ug.CREATE_DATE";
    // select mt.NAME, gu.*, ut.*
    // from U_GUIDE as ug
    // inner join U_TARGET as ut on g.TAR_ID = ut.ID
    // where (ug.OWNER = 'emp-001' or ug.EMP_ID ='emp-001') and ug.RELEASE = 0
    // order by ug.CREATE_DATE
    
    NSMutableArray* all = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, empid, empid, @"0"];
    while([rs next]){
        
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [rs stringForColumnIndex:0];
        guide.companyID = [rs stringForColumn:@"COMP_ID"];
        guide.gui_uuid = [rs stringForColumn:@"GUI_M_ID"];
        guide.name = [rs stringForColumnIndex:5];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.bRelease = [rs boolForColumn:@"RELEASE"];
        guide.status = [rs stringForColumn:@"STATUS"];
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:15];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = [rs stringForColumn:@"TYPE"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        NSString* phenId = [rs stringForColumn:@"FROM_PHEN_ID"];
        guide.fromPhen = [self loadPhenWithID:phenId];
        
        NSString* issueId = [rs stringForColumn:@"FROM_ISS_ID"];
        guide.fromIssue = [self loadIssueWithID:issueId];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        guide.manager = [self loadEmployeeWithID:empid];
        
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.gui_uuid type:0];
        
        // 關鍵活動
        
        [guide.activityArray addObjectsFromArray:[self loadCustActivityArrayWithCustGuideID:guide.uuid]];
        
        //[all addObject:guide];
        
        // filter for section
        BOOL isExist = NO;
        NSInteger index = 0;
        for (NSMutableArray* array in all) {
            
            MCustGuide* cg = [array objectAtIndex:0];
            if([phenId isEqualToString:cg.fromPhen.uuid]){
                isExist = YES;
                break;
            }
            if([issueId isEqualToString:cg.fromIssue.uuid]){
                isExist = YES;
                break;
            }
            index++;
        }
        
        if(isExist){
            NSMutableArray* array = [all objectAtIndex:index];
            [array addObject:guide];
        }else{
            NSMutableArray* array = [NSMutableArray new];
            [array addObject:guide];
            [all addObject:array];
        }
    }

    return all;
}

#pragma mark - 我的攻略

// p15-2, load 我的攻略
- (NSArray*)loadMyRaidersArray
{
    NSString* empid = [MDirector sharedInstance].currentUser.uuid;
    NSString* sql = @"select ug.*, ut.* from U_GUIDE as ug inner join U_TARGET as ut on ug.TAR_ID = ut.ID inner join U_ACTIVITY as ua on ug.ID = ua.GUIDE_ID inner join U_WORK_ITEM as uw on ua.ID = uw.ACT_ID where (ug.EMP_ID = ? or ua.EMP_ID = ? or uw.EMP_ID = ?) and ug.RELEASE = ? group by ug.ID order by ug.CREATE_DATE";
    // select ug.*, ut.*
    // from U_GUIDE as ug
    // inner join U_TARGET as ut on ug.TAR_ID = ut.ID
    // inner join U_ACTIVITY as ua on ug.ID = ua.GUIDE_ID
    // inner join U_WORK_ITEM as uw on ua.ID = uw.ACT_ID
    // where (ug.EMP_ID = 'emp-001' or ua.EMP_ID = 'emp-001' or uw.EMP_ID = 'emp-001') and ug.RELEASE = 1
    // group by ug.ID
    // order by ug.CREATE_DATE
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, empid, empid, empid, @"1"];
    while ([rs next]) {
        
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [rs stringForColumnIndex:0];
        guide.companyID = [rs stringForColumn:@"COMP_ID"];
        guide.gui_uuid = [rs stringForColumn:@"GUI_M_ID"];
        guide.name = [rs stringForColumnIndex:5];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.bRelease = [rs boolForColumn:@"RELEASE"];
        guide.status = [rs stringForColumn:@"STATUS"];
        guide.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:15];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = [rs stringForColumn:@"TYPE"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        NSString* phenId = [rs stringForColumn:@"FROM_PHEN_ID"];
        guide.fromPhen = [self loadPhenWithID:phenId];
        
        NSString* issueId = [rs stringForColumn:@"FROM_ISS_ID"];
        guide.fromIssue = [self loadIssueWithID:issueId];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        guide.manager = [self loadEmployeeWithID:empid];
        
        guide.suggestSkill = [self loadSuggestSkillWithID:guide.gui_uuid type:0];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadCustActivityArrayWithCustGuideID:guide.uuid]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadCustActivityArrayWithCustGuideID:(NSString*)guiid
{
    NSString* sql = @"select * from U_ACTIVITY as ua inner join U_TARGET as ut on ut.ID = ua.TAR_ID where ua.GUIDE_ID = ?";
    // select *
    // from U_ACTIVITY as ua
    // inner join U_TARGET as ut on ut.ID = ua.TAR_ID
    // where ua.GUIDE_ID = 'g001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guiid];
    while ([rs next]) {
        MCustActivity* act = [MCustActivity new];
        act.uuid = [rs stringForColumnIndex:0];
        act.name = [rs stringForColumnIndex:4];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.index = [rs stringForColumn:@"INDEX"];
        act.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        act.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        act.status = [rs stringForColumn:@"STATUS"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        act.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        
        // 指標
        MCustTarget* target = act.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:14];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = [rs stringForColumn:@"TYPE"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        act.manager = [self loadEmployeeWithID:empid];
        
        act.suggestSkill = [self loadSuggestSkillWithID:act.act_m_id type:1];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadCustWorkItemArrayWithActivity:act]];
        
        [array addObject:act];
    }
    [self adjustPreviosWithCustActivitys:array];
    return array;
}

- (NSArray*)loadCustWorkItemArrayWithActivity:(MCustActivity*)act
{
    NSString* sql = @"select * from U_WORK_ITEM as uw inner join U_TARGET as ut on ut.ID = uw.TAR_ID where uw.ACT_ID = ? and uw.GUIDE_ID = ?";
    // select *
    // from U_WORK_ITEM as uw
    // inner join U_TARGET as ut on ut.ID = uw.TAR_ID
    // where uw.ACT_ID = ? and uw.GUIDE_ID = ?
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.uuid, act.guide_id];
    while ([rs next]) {
        MCustWorkItem* item = [MCustWorkItem new];
        item.uuid = [rs stringForColumnIndex:0];
        item.name = [rs stringForColumnIndex:5];
        item.desc = [rs stringForColumn:@"DESCRIPTION"];
        item.previos1 = [rs stringForColumn:@"PREVIOS_1"];
        item.previos2 = [rs stringForColumn:@"PREVIOS_2"];
        item.status = [rs stringForColumn:@"STATUS"];
        item.comp_id = [rs stringForColumn:@"COMP_ID"];
        item.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        item.act_id = [rs stringForColumn:@"ACT_ID"];
        item.wi_m_id = [rs stringForColumn:@"WI_M_ID"];
        item.cre_dte = [rs stringForColumn:@"CREATE_DATE"];
        item.accepted = [rs stringForColumn:@"ACCEPTED"];
        
        // 指標
        MCustTarget* target = item.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:16];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.type = [rs stringForColumn:@"TYPE"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        item.manager = [self loadEmployeeWithID:empid];
        
        item.suggestSkill = [self loadSuggestSkillWithID:item.wi_m_id type:2];
        
        [array addObject:item];
    }
    [self adjustPreviosWithCustWorkItems:array];
    return array;
}

#pragma mark - 監控地圖

- (NSArray*)loadMonitorGuideData
{
    NSMutableArray* array = [NSMutableArray new];
    
    NSArray* guides = [self loadMyRaidersArray];
    for (MCustGuide* guide in guides) {
        NSArray* issues = [self loadMonitorIssueWithGudieID:guide.gui_uuid];
        
        MMonitorData* data = [MMonitorData new];
        data.guide = guide;
        data.issueArray = issues;
        
        [array addObject:data];
    }
    
    return array;
}

- (NSArray*)loadMonitorIssueWithGudieID:(NSString*)guideid
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_GUIDE_ISSUE as rgi inner join M_ISSUE as mi on mi.ID = rgi.ISSUE_ID inner join R_COMP_ISSUE as rci on rci.ISSUE_ID = mi.ID where rgi.GUIDE_ID = ? and rci.COMP_ID = ?";
    //select *
    //from R_GUIDE_ISSUE as rgi
    //inner join M_ISSUE as mi on mi.ID = rgi.ISSUE_ID
    //inner join R_COMP_ISSUE as rci on rci.ISSUE_ID = mi.ID
    //where rgi.GUIDE_ID = 'gui-002' and rci.COMP_ID = 'cmp-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guideid, compid];
    while ([rs next]) {
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumn:@"NAME"];   // 議題name
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        issue.gainR = [rs stringForColumn:@"R_GAIN"];
        issue.gainP = [rs stringForColumn:@"P_GAIN"];
        
        NSArray* types = [self loadIssueTypeArrayWithIssUUid:issue.uuid];
        issue.issTypeArray = types;
        
        [array addObject:issue];
    }
    
    return array;
}

- (NSArray*)loadIssueTypeArrayWithIssUUid:(NSString*)uuid
{
    NSString* sql = @"select * from R_ISS_TYPE as rit inner join M_ISS_TYPE as mit on mit.ID = rit.TYPE_ID where rit.ISS_ID = ?";
    //select *
    //from R_ISS_TYPE as rit
    //inner join M_ISS_TYPE as mit on mit.ID = rit.TYPE_ID
    //where rit.ISS_ID = 'iss-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while ([rs next]) {
        
        MIssType* isstype = [MIssType new];
        isstype.uuid = [rs stringForColumn:@"ID"];
        isstype.name = [rs stringForColumn:@"NAME"];
        isstype.gainR = [rs stringForColumn:@"R_GAIN"];
        isstype.gainP = [rs stringForColumn:@"P_GAIN"];
        
        [array addObject:isstype];
    }
    return array;
}

#pragma mark - 找對策

- (NSArray*)loadQuestionArrayWithKeyword:(NSString*)keyword
{
    NSString* sql = @"select * from M_QUESTION as q";
    
    // 模糊搜尋
    if(keyword && ![keyword isEqualToString:@""]){
        for (int index = 0; index < keyword.length; index++) {
            NSString* keychar = [keyword substringWithRange:NSMakeRange(index, 1)];
            if(index == 0)
                sql = [sql stringByAppendingFormat:@" where q.SUBJECT like '%%%@%%'", keychar];
            else
                sql = [sql stringByAppendingFormat:@" or q.SUBJECT like '%%%@%%'", keychar];
        }
    }
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        MQuestion* qu = [MQuestion new];
        qu.uuid = [rs stringForColumn:@"ID"];
        qu.subject = [rs stringForColumn:@"SUBJECT"];
        qu.reads = [rs stringForColumn:@"READS"];
        
        NSArray* issArray = [self loadIssueArrayWithQuestionID:qu.uuid];
        qu.issueArray = issArray;
        
        [array addObject:qu];
    }
    return array;
}

- (NSArray*)loadIssueArrayWithQuestionID:(NSString*)uuid
{
    NSString* sql = @"select * from R_QU_ISS as rqi inner join M_ISSUE as mi on mi.ID = rqi.ISS_ID where rqi.QU_ID = ?";
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while ([rs next]) {
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumn:@"NAMe"];
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        
        NSString* tarid = [rs stringForColumn:@"TAR_ID"];
        MTarget* target = [self loadTargetInfoWithID:tarid];
        issue.target = target;
        
        [array addObject:issue];
    }
    return array;
}

#pragma mark - 看現況(經營效能)

- (NSArray*)loadCompanyEfficacyArray
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from M_EFFICACY_ITEM as eff inner join R_COMP_EFF as rce on rce.EFF_ID = eff.ID where rce.COMP_ID = ?";
    //select *
    //from M_EFFICACY_ITEM as eff
    //inner join R_COMP_EFF as rce on rce.EFF_ID = eff.ID
    //where rce.COMP_ID = 'cmp-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid];
    while ([rs next]) {
        
        MEfficacy* eff = [MEfficacy new];
        eff.uuid = [rs stringForColumn:@"ID"];
        eff.name = [rs stringForColumn:@"NAME"];
        eff.pr = [rs stringForColumn:@"EFF_PR"];
        
        NSArray* tarArray = [self loadCompEffTargetArrayWithEffID:eff.uuid];
        eff.effTargetArray = tarArray;
        
        [array addObject:eff];
    }
    
    return array;
}

- (NSArray*)loadCompEffTargetArrayWithEffID:(NSString*)uuid
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_COMP_EFF_TAR as rcet inner join M_TARGET as tar on rcet.TAR_ID = tar.ID where rcet.COMP_ID = ? and rcet.EFF_ID = ?";
    //select *
    //from R_COMP_EFF_TAR as rcet
    //inner join M_TARGET as tar on rcet.TAR_ID = tar.ID
    //where rcet.COMP_ID = 'cmp-001' and rcet.EFF_ID = 'eff-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid, uuid];
    while ([rs next]) {
        
        MEfficacyTarget* target = [MEfficacyTarget new];
        target.uuid = [rs stringForColumn:@"ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.pr = [rs stringForColumn:@"TAR_PR"];
        
        [array addObject:target];
    }
    return array;
}

#pragma mark - 看現況(管理表現)

// 取得資料日期(降冪)
- (NSArray*)loadCompManageDateArrayWithLimit:(NSInteger)limit
{
    NSMutableArray* array = [NSMutableArray new];
    if(limit < 1)
        return array;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select DATE from R_COMP_MA_ISSUE where COMP_ID = ? group by DATE order by DATE desc";
    sql = [NSString stringWithFormat:@"%@ limit %d", sql, (int)limit];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid];
    while ([rs next]) {
        NSString* dateString = [rs stringForColumn:@"DATE"];
        [array addObject:dateString];
    }
    return array;
}

//取得管理表現的項目, bComplex : 是否包含"綜合表現"
- (NSArray*)loadCompManageItemArrayWithComplex:(BOOL)bComplex
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from M_MANAGE_ITEM as mmi inner join R_COMP_MANAGE as rci on rci.MA_ID = mmi.ID where rci.COMP_ID = ?";
    //select *
    //from M_MANAGE_ITEM as mmi
    //inner join R_COMP_MANAGE as rci on rci.MA_ID = mmi.ID
    
    if(!bComplex)
        sql = [sql stringByAppendingString:@" and mmi.TYPE = '0'"];
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid];
    while ([rs next]) {
        MManageItem* manageItem = [MManageItem new];
        manageItem.uuid = [rs stringForColumn:@"ID"];
        manageItem.name = [rs stringForColumn:@"NAME"];
        manageItem.s_name = [rs stringForColumn:@"S_NAME"];
        manageItem.type = [rs stringForColumn:@"TYPE"];
        manageItem.review = [rs stringForColumn:@"REVIEW"];
        
        [array addObject:manageItem];
    }
    return array;
}

//某管理表現項目在某日期的歷史資料
- (NSArray*)loadCompMaItemIssueArrayWithMaItemID:(NSString*)uuid date:(NSString*)date
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_COMP_MA_ISSUE as rcmi inner join M_ISSUE as mi on mi.ID = rcmi.ISSUE_ID where rcmi.COMP_ID = ? and rcmi.MA_ID = ? and rcmi.DATE = ? order by rcmi.DATE desc";
    //select *
    //from R_COMP_MA_ISSUE as rcmi
    //inner join M_ISSUE as mi on mi.ID = rcmi.ISSUE_ID
    //where rcmi.COMP_ID = 'cmp-001' and rcmi.MA_ID = 'mana-002'
    //order by rcmi.DATE desc
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid, uuid, date];
    while ([rs next]) {
        
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumn:@"NAMe"];
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        issue.pr = [rs stringForColumn:@"ISSUE_PR"];
        issue.mgUuid = uuid;
        
        NSString* tarid = [rs stringForColumn:@"TAR_ID"];
        MTarget* target = [self loadTargetInfoWithID:tarid];
        issue.target = target;
        
        [array addObject:issue];
    }
    return array;
}

//最近的歷史資料
- (NSArray*)loadRecentCompManageHistoryData
{
    NSArray* dateArray = [self loadCompManageDateArrayWithLimit:1];
    NSString* dateString = (dateArray.count == 0) ? @"" : [dateArray firstObject];
    
    NSArray* items = [self loadCompManageItemArrayWithComplex:YES];
    
    for (MManageItem* item in items) {
        if([item.type isEqualToString:@"1"])
            continue;
        
        NSArray* issues = [self loadCompMaItemIssueArrayWithMaItemID:item.uuid date:dateString];
        item.issueArray = issues;
    }
    
    return items;
}

//最近的歷史資料(降冪,最多limit筆)
- (NSDictionary*)loadCompManageHistoryDataWithLimit:(NSInteger)limit
{
    NSArray* dateArray = [self loadCompManageDateArrayWithLimit:limit];

    NSMutableDictionary* dict = [NSMutableDictionary new];
    for(NSString* date in dateArray){
        NSArray* items = [self loadCompManageItemArrayWithComplex:NO];
        for (MManageItem* item in items) {
            NSArray* issues = [self loadCompMaItemIssueArrayWithMaItemID:item.uuid date:date];
            item.issueArray = issues;
        }
        [dict setObject:items forKey:date];
    }
    
    return dict;
}

- (NSArray*)loadCompManageItemArrayWithDate:(NSString*)date withComplex:(BOOL)bComplex
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from M_MANAGE_ITEM as mmi inner join R_COMP_MANAGE as rci on rci.MA_ID = mmi.ID where rci.COMP_ID = ?";
    //select *
    //from M_MANAGE_ITEM as mmi
    //inner join R_COMP_MANAGE as rci on rci.MA_ID = mmi.ID
    
    if(bComplex)
        sql = [sql stringByAppendingString:@" and mmi.TYPE = '0'"];
    
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, compid];
    while ([rs next]) {
        MManageItem* manageItem = [MManageItem new];
        manageItem.uuid = [rs stringForColumn:@"ID"];
        manageItem.name = [rs stringForColumn:@"NAME"];
        manageItem.s_name = [rs stringForColumn:@"S_NAME"];
        manageItem.type = [rs stringForColumn:@"TYPE"];
        manageItem.review = [rs stringForColumn:@"REVIEW"];
        
        NSArray* issArray = [self loadCompMaItemIssueArrayWithMaItemID:manageItem.uuid date:date];
        manageItem.issueArray = issArray;
 
        [array addObject:manageItem];
    }
    return array;
}

#pragma mark - 看現況(行業情報)

- (NSArray*)loadIndustryInfoKindArray
{
    NSString* sql = @"select * from M_INFO_KIND";
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        MIndustryInfoKind* kind = [MIndustryInfoKind new];
        kind.uuid = [rs stringForColumn:@"ID"];
        kind.name = [rs stringForColumn:@"NAME"];
        
        [array addObject:kind];
    }
    return array;
}

- (NSArray*)loadIndustryInfoArrayWithKindID:(NSString*)kindid
{
    NSString* indid = [MDirector sharedInstance].currentUser.industryId;
    NSString* sql = @"select info.*, kind.NAME from R_IND_INFO as rii inner join M_INFORMATION as info on info.ID = rii.INFO_ID inner join M_INFO_KIND as kind on kind.ID = info.KIND_ID where kind.ID = ? and rii.IND_ID = ?";
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, kindid, indid];
    while ([rs next]) {
        
        MIndustryInfo* info = [MIndustryInfo new];
        info.uuid = [rs stringForColumn:@"ID"];
        info.subject = [rs stringForColumn:@"SUBJECT"];
        info.desc = [rs stringForColumn:@"DESCRIPTION"];
        info.url = [rs stringForColumn:@"URL"];
        info.isRead=[rs boolForColumn:@"READ"];
        
        MIndustryInfoKind* kind = [MIndustryInfoKind new];
        kind.uuid = [rs stringForColumn:@"KIND_ID"];
        kind.name = [rs stringForColumn:@"NAME"];
        info.kind = kind;
        
        [array addObject:info];
    }
    return array;
}

#pragma mark - 通用

- (MTarget*)loadTargetInfoWithID:(NSString*)uuid
{
    NSString* sql = @"select * from M_TARGET as mt inner join R_IND_TAR as rit on rit.TAR_ID = mt.ID inner join R_COMP_TAR as rct on rct.TAR_ID = rit.TAR_ID where rit.TAR_ID = ? order by rct.DATETIME desc limit 1";
    
    MTarget* target = [MTarget new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    if ([rs next]) {
        target.uuid = uuid;
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.top = [rs stringForColumn:@"TOP"];
        target.avg = [rs stringForColumn:@"AVG"];
        target.bottom = [rs stringForColumn:@"BOTTOM"];
        target.upMin = [rs stringForColumn:@"UP_MIN"];
        target.upMax = [rs stringForColumn:@"UP_MAX"];
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
    }
    return target;
}

- (MPhenomenon*)loadPhenWithID:(NSString*)phenid
{
    if(!phenid)
        return nil;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from M_PHENOMENON as p inner join M_TARGET as t on p.TAR_ID = t.ID inner join R_COMP_TAR as rct on rct.TAR_ID = t.ID where rct.COMP_ID = ? and p.ID = ? order by DATETIME desc limit 1";
    // select *
    // from M_PHENOMENON as p
    // inner join M_TARGET as t on p.TAR_ID = t.ID
    // inner join R_COMP_TAR as rct on rct.TAR_ID = t.ID
    // where rct.COMP_ID = 'cmp-001' and p.ID = 'phe-001'
    // order by DATETIME desc
    // limit 1
    
    FMResultSet* rs = [self.db executeQuery:sql, compid, phenid];
    if([rs next]){
        MPhenomenon* phen = [MPhenomenon new];
        phen.uuid = [rs stringForColumnIndex:0];
        phen.subject = [rs stringForColumn:@"SUBJECT"];
        phen.desc = [rs stringForColumn:@"DESCRIPTION"];
        
        MTarget* target = phen.target;
        target.uuid = [rs stringForColumnIndex:4];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        return phen;
    }
    return nil;
}

- (MIssue*)loadIssueWithID:(NSString*)issueid
{
    if(!issueid)
        return nil;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from M_ISSUE as iss inner join M_TARGET as t on iss.TAR_ID = t.ID inner join R_COMP_TAR as rct on rct.TAR_ID = t.ID where rct.COMP_ID = ? and iss.ID = ? order by DATETIME desc limit 1";
    // select *
    // from M_ISSUE as iss
    // inner join M_TARGET as t on iss.TAR_ID = t.ID
    // inner join R_COMP_TAR as rct on rct.TAR_ID = t.ID
    // where rct.COMP_ID = 'cmp-001' and iss.ID = 'iss-001'
    // order by DATETIME desc
    // limit 1
    
    FMResultSet* rs = [self.db executeQuery:sql, compid, issueid];
    if([rs next]){
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumnIndex:0];
        issue.name = [rs stringForColumnIndex:2];
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        
        MTarget* target = issue.target;
        target.uuid = [rs stringForColumnIndex:5];
        target.name = [rs stringForColumnIndex:6];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.trend = [rs stringForColumn:@"TREND"];
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        return issue;
    }
    return nil;
}

- (MUser*)loadEmployeeWithID:(NSString*)empid
{
    if(!empid || [empid isEqualToString:@""])
        return nil;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select ind.NAME, comp.NAME, emp.* from M_EMPLOYEE as emp inner join M_INDUSTRY as ind on ind.ID = emp.IND_ID inner join M_COMPANY as comp on comp.ID = emp.COMP_ID where emp.ID = ? and emp.COMP_ID = ? limit 1";
    // select ind.NAME, comp.NAME, emp.*
    // from M_EMPLOYEE as emp
    // inner join M_INDUSTRY as ind on ind.ID = emp.IND_ID
    // inner join M_COMPANY as comp on comp.ID = emp.COMP_ID
    // where emp.ID = 'emp-001' and emp.COMP_ID = 'cmp-001'
    // limit 1
    
    FMResultSet* rs = [self.db executeQuery:sql, empid, compid];
    if([rs next]){
        
        MUser* employee = [MUser new];
        employee.industryName = [rs stringForColumnIndex:0];    // industry name
        employee.companyName = [rs stringForColumnIndex:1];     // company name
        employee.uuid = [rs stringForColumn:@"ID"];
        employee.industryId = [rs stringForColumn:@"IND_ID"];
        employee.companyId = [rs stringForColumn:@"COMP_ID"];
        employee.name = [rs stringForColumn:@"NAME"];            // user name
        employee.phone = [rs stringForColumn:@"PHONE"];
        employee.email = [rs stringForColumn:@"EMAIL"];
        employee.arrive_date = [rs stringForColumn:@"ARRIVE_DATE"];
        employee.thumbnail = [rs stringForColumn:@"THUMBNAIL"];
        
        employee.skillArray = [self loadSkillsWithEmpID:employee.uuid];
        
        return employee;
    }
    
    return nil;
}

- (NSArray*)loadSkillsWithEmpID:(NSString*)uuid
{
    NSString* sql = @"select * from R_EMP_SKILL as res inner join M_SKILL as sk on res.SKILL_ID = sk.ID where res.EMP_ID = ?";
    // select *
    // from R_EMP_SKILL as res
    // inner join M_SKILL as sk on res.SKILL_ID = sk.ID
    // where res.EMP_ID = 'emp-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while ([rs next]) {
        MSkill* skill = [MSkill new];
        skill.uuid = [rs stringForColumn:@"ID"];
        skill.name = [rs stringForColumn:@"NAME"];
        skill.level = [rs stringForColumn:@"LEVEL"];
        skill.emp_id = [rs stringForColumn:@"EMP_ID"];
        
        [array addObject:skill];
    }
    return array;
}

- (BOOL)loadTargetDetailWithTarget:(MTarget*)target
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_COMP_TAR where TAR_ID = ? and COMP_ID = ? order by DATETIME limit 1";
    
    FMResultSet* rs = [self.db executeQuery:sql, target.uuid, compid];
    if([rs next]){
        
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        return YES;
    }
    return NO;
}

- (BOOL)loadTargetDetailWithCustTarget:(MCustTarget*)target
{
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_COMP_TAR where TAR_ID = ? and COMP_ID = ? order by DATETIME limit 1";
    
    FMResultSet* rs = [self.db executeQuery:sql, target.tar_uuid, compid];
    if([rs next]){
        
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        return YES;
    }
    return NO;
}

- (NSArray*)targetArrayUnderCustGuide:(MCustGuide*)guide
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:guide.custTaregt];
    
    for (MCustActivity* act in guide.activityArray) {
        
        [array addObject:act.custTarget];
        
        for (MCustWorkItem* item in act.workItemArray) {
            [array addObject:item.target];
        }
    }
    return array;
}

- (void)adjustPreviosWithCustActivitys:(NSArray*)array
{
    for (MCustActivity* act1 in array) {
        for (MCustActivity* act2 in array) {
            NSString* prev1 = act2.previos1;
            NSString* prev2 = act2.previos2;
            if([prev1 isEqualToString:act1.act_m_id])
                act2.previos1 = act1.uuid;
            if([prev2 isEqualToString:act1.act_m_id])
                act2.previos2 = act1.uuid;
        }
    }
}

- (void)adjustPreviosWithCustWorkItems:(NSArray*)array
{
    for (MCustWorkItem* w1 in array) {
        for (MCustWorkItem* w2 in array) {
            NSString* prev1 = w2.previos1;
            NSString* prev2 = w2.previos2;
            if([prev1 isEqualToString:w1.wi_m_id])
                w2.previos1 = w1.uuid;
            if([prev2 isEqualToString:w1.wi_m_id])
                w2.previos2 = w1.uuid;
        }
    }
}

#pragma mark - insert/update/delete 操作

- (void)insertGuides:(NSArray*)array from:(NSInteger)from
{
    for (MGuide* guide in array) {
        [self insertGuide:guide from:from];
    }
}

// insert guide
- (BOOL)insertGuide:(MGuide*)guide from:(NSInteger)from
{
    NSString* uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_GUIDE_UUID_PREV];
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* gui_m_id = guide.uuid;
    NSString* name = guide.name;
    NSString* desc = guide.desc;
    NSString* tarid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    NSString* empid = guide.manager.uuid;
    NSString* release = @"0";
    NSString* status = @"0";
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:DATE_FORMATE_01];
    NSString* owner = [MDirector sharedInstance].currentUser.uuid;
    
    NSString* from1 = nil;
    NSString* from2 = nil;
    if(from == GUIDE_FROM_PHEN)
        from1 = [MDirector sharedInstance].selectedPhen.uuid;
    if(from == GUIDE_FROM_ISSUE)
        from2 = [MDirector sharedInstance].selectedIssue.uuid;
    
    NSString* sql = @"insert into U_GUIDE ('ID','COMP_ID','FROM_PHEN_ID','FROM_ISS_ID','GUI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','RELEASE','STATUS','CREATE_DATE','OWNER') VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    // insert into U_GUIDE
    // ('ID','COMP_ID','FROM_PHEN_ID','FROM_ISS_ID','GUI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','RELEASE','STATUS','CREATE_DATE','OWNER')
    // VALUES(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,)
    
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, from1, from2, gui_m_id, name, desc, tarid, empid, release, status, cre_dte, owner];
    if(b){
        [self insertTarget:guide.target withID:tarid];
        [self insertActivitys:guide.activityArray guideID:uuid];
    }else{
        NSLog(@"add guide failed : %@", [self.db lastErrorMessage]);
    }
    
    return b;
}

- (void)insertActivitys:(NSArray*)array guideID:(NSString*)guideid
{
    for (MActivity* act in array) {
        [self insertActivity:act guideID:guideid];
    }
}

- (BOOL)insertActivity:(MActivity*)act guideID:(NSString*)guideid
{
    NSString* sql = @"insert into U_ACTIVITY ('ID','COMP_ID','GUIDE_ID','ACT_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','PREVIOS_1','PREVIOS_2','STATUS','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_ACT_UUID_PREV];
    NSString* act_m_id = act.uuid;
    NSString* name = act.name;
    NSString* desc = act.desc;
    NSString* tarid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    NSString* empid = act.manager.uuid;
    //NSString* index = act.index;
    NSString* prev1 = act.previos1;
    NSString* prev2 = act.previos2;
    NSString* status = @"0";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, act_m_id, name, desc, tarid, empid, prev1, prev2, status, cre_dte];
    if(b){
        [self insertTarget:act.target withID:tarid];
        [self insertWorkItems:act.workItemArray activityID:uuid guideID:guideid];
    }else{
        NSLog(@"add activity failed : %@", [self.db lastErrorMessage]);
    }
    
    return b;
}

- (void)insertWorkItems:(NSArray*)array activityID:(NSString*)actid guideID:(NSString*)guideid
{
    for (MWorkItem* item in array) {
        [self insertWorkItem:item activityID:actid guideID:guideid];
    }
}

- (BOOL)insertWorkItem:(MWorkItem*)item activityID:(NSString*)actid guideID:(NSString*)guideid
{
    NSString* sql = @"insert into U_WORK_ITEM ('ID','COMP_ID','GUIDE_ID','ACT_ID','WI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','PREVIOS_1','PREVIOS_2','STATUS', 'ACCEPTED','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_WORK_ITEM_UUID_PREV];
    NSString* wi_m_id = item.uuid;
    NSString* name = item.name;
    NSString* desc = item.desc;
    NSString* tarid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    NSString* empid = item.manager.uuid;
    //NSString* index = item.index;
    NSString* previos1 = item.previos1;
    NSString* previos2 = item.previos2;
    NSString* status = @"0";
    NSString* accepted = @"0";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, actid, wi_m_id, name, desc, tarid, empid, previos1, previos2, status, accepted, cre_dte];
    if(b)
        [self insertTarget:item.target withID:tarid];
    else
        NSLog(@"add work item failed : %@", [self.db lastErrorMessage]);
    
    return b;
}

- (void)insertCustGuides:(NSArray*)array from:(NSInteger)from
{
    for (MCustGuide* guide in array) {
        [self insertGuide:guide from:from];
    }
}

// insert guide
- (BOOL)insertCustGuide:(MCustGuide*)guide from:(NSInteger)from
{
    NSString* uuid = guide.uuid;
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* gui_m_id = guide.gui_uuid;
    NSString* name = guide.name;
    NSString* desc = guide.desc;
    NSString* tarid = guide.custTaregt.uuid;
    NSString* empid = guide.manager.uuid;
    NSString* release = @"0";
    NSString* status = @"0";
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:DATE_FORMATE_01];
    NSString* owner = [MDirector sharedInstance].currentUser.uuid;
    
    NSString* from1 = nil;
    NSString* from2 = nil;
    if(from == GUIDE_FROM_PHEN)
        from1 = [MDirector sharedInstance].selectedPhen.uuid;
    if(from == GUIDE_FROM_ISSUE)
        from2 = [MDirector sharedInstance].selectedIssue.uuid;
    
    NSString* sql = @"insert into U_GUIDE ('ID','COMP_ID','FROM_PHEN_ID','FROM_ISS_ID','GUI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','RELEASE','STATUS','CREATE_DATE','OWNER') VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, from1, from2, gui_m_id, name, desc, tarid, empid, release, status, cre_dte, owner];
    if(b){
        [self insertCustTarget:guide.custTaregt withID:tarid];
        [self insertCustActivitys:guide.activityArray];
    }else{
        NSLog(@"add guide failed : %@", [self.db lastErrorMessage]);
    }
    
    return b;
}

- (void)insertCustActivitys:(NSArray*)array
{
    for (MCustActivity* act in array) {
        [self insertCustActivity:act];
    }
}

- (BOOL)insertCustActivity:(MCustActivity*)act
{
    NSString* sql = @"insert or replace into U_ACTIVITY ('ID','COMP_ID','GUIDE_ID','ACT_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','PREVIOS_1','PREVIOS_2','STATUS','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* guideid = act.guide_id;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = act.cre_dte;
    NSString* uuid = act.uuid;
    NSString* act_m_id = act.act_m_id;
    NSString* name = act.name;
    NSString* desc = act.desc;
    NSString* tarid = act.custTarget.uuid;
    NSString* empid = act.manager.uuid;
    //NSString* index = act.index;
    NSString* prev1 = act.previos1;
    NSString* prev2 = act.previos2;
    NSString* status = @"0";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, act_m_id, name, desc, tarid, empid, prev1, prev2, status, cre_dte];
    if(b){
        [self insertCustTarget:act.custTarget withID:tarid];
        [self insertCustWorkItems:act.workItemArray];
    }else{
        NSLog(@"add activity failed : %@", [self.db lastErrorMessage]);
    }
    
    return b;
}

- (void)insertCustWorkItems:(NSArray*)array
{
    for (MCustWorkItem* item in array) {
        [self insertCustWorkItem:(MCustWorkItem*)item];
    }
}

- (BOOL)insertCustWorkItem:(MCustWorkItem*)item
{
    NSString* sql = @"insert or replace into U_WORK_ITEM ('ID','COMP_ID','GUIDE_ID','ACT_ID','WI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','PREVIOS_1','PREVIOS_2','STATUS','ACCEPTED','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* guideid = item.guide_id;
    NSString* actid = item.act_id;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = item.cre_dte;
    
    NSString* uuid = item.uuid;
    NSString* wi_m_id = item.wi_m_id;
    NSString* name = item.name;
    NSString* desc = item.desc;
    NSString* tarid = item.custTarget.uuid;
    NSString* empid = item.manager.uuid;
    //NSString* index = item.index;
    NSString* previos1 = item.previos1;
    NSString* previos2 = item.previos2;
    NSString* status = item.status;
    NSString* accepted = item.accepted;
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, actid, wi_m_id, name, desc, tarid, empid, previos1, previos2, status, accepted, cre_dte];
    if(b)
        [self insertCustTarget:item.custTarget withID:tarid];
    else
        NSLog(@"add work item failed : %@", [self.db lastErrorMessage]);
    
    return b;
}

- (BOOL)insertTarget:(MTarget*)target withID:(NSString*)uuid
{
    NSString* sql = @"insert into U_TARGET ('ID','TAR_M_ID','NAME','VALUE_T','UNIT','START_DATE','COMPLETED','TREND','TYPE') values(?,?,?,?,?,?,?,?,?)";
    // ('ID','TAR_M_ID','NAME','VALUE_T','UNIT','START_DATE','COMPLETED','TREND','TYPE')
    // values(?,?,?,?,?,?,?,?,?)
    
    BOOL b = [self.db executeUpdate:sql, uuid, target.uuid, target.name, target.valueT, target.unit, target.startDate, target.completeDate,target.trend, @"1"];
    if(!b)
        NSLog(@"add target failed [%@] : %@", uuid, [self.db lastErrorMessage]);
    return b;
}

- (BOOL)insertCustTarget:(MCustTarget*)target withID:(NSString*)uuid
{
    NSString* sql = @"insert or replace into U_TARGET ('ID','TAR_M_ID','NAME','VALUE_T','UNIT','START_DATE','COMPLETED','TREND','TYPE') values(?,?,?,?,?,?,?,?,?)";
    
    BOOL b = [self.db executeUpdate:sql, uuid, target.tar_uuid, target.name, target.valueT, target.unit, target.startDate, target.completeDate,target.trend, target.type];
    if(!b)
        NSLog(@"add target failed [%@] : %@", uuid, [self.db lastErrorMessage]);
    return b;
}

- (BOOL)hasEmptyManagerUnderCustGudie:(MCustGuide*)guide
{
    // check guide
    NSString* sql = @"select * from U_GUIDE where ID = ? and (EMP_ID is null or EMP_ID = '') limit 1";
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid];
    if([rs next])
        return NO;
    
    // check activity
    NSString* sql2 = @"select * from U_ACTIVITY where GUIDE_ID = ? and (EMP_ID is null or EMP_ID = '') limit 1";
    FMResultSet* rs2 = [self.db executeQuery:sql2, guide.uuid];
    if([rs2 next])
        return NO;
    
    // check work item
    NSString* sql3 = @"select * from U_WOEK_ITEM where GUIDE_ID = ? and (EMP_ID is null or EMP_ID = '') limit 1";
    FMResultSet* rs3 = [self.db executeQuery:sql3, guide.uuid];
    if([rs3 next])
        return NO;
    return YES;
}

// 我的攻略 : 1 , 我的規劃 : 0
- (BOOL)updateGuide:(MCustGuide*)guide release:(BOOL)release
{
    NSString* rel = release ? @"1" : @"0";
    NSString* sql = @"update U_GUIDE set RELEASE = ? where ID = ?";
    
    BOOL b = [self.db executeUpdate:sql, rel, guide.uuid];
    if(!b)
        NSLog(@"update guide release to %@ failed: %@", rel, [self.db lastErrorMessage]);
    
    return b;
}

- (BOOL)deleteFromPlanWithCustGude:(MCustGuide*)guide
{
    // delete guide
    NSString* sql = @"delete from U_GUIDE where ID = ?";
    BOOL b = [self.db executeUpdate:sql, guide.uuid];
    if(!b)  
        NSLog(@"delete guide failed [%@] : %@", guide.uuid, [self.db lastErrorMessage]);
    
    // delete activitys
    sql = @"delete from U_ACTIVITY where GUIDE_ID = ?";
    BOOL b2 = [self.db executeUpdate:sql, guide.uuid];
    if(!b2)
        NSLog(@"delete activity failed [%@] : %@", guide.uuid, [self.db lastErrorMessage]);
    
    // delete WorkItems
    sql = @"delete from U_WORK_ITEM where GUIDE_ID = ?";
    BOOL b3 = [self.db executeUpdate:sql, guide.uuid];
    if(!b3)
        NSLog(@"delete work item failed [%@] : %@", guide.uuid, [self.db lastErrorMessage]);
    
    // delete guide/activity/WorkIem target
    NSArray* array = [self targetArrayUnderCustGuide:guide];
    for (MCustTarget* target in array) {
        BOOL b4 = [self.db executeUpdate:@"delete from U_TARGET where ID = ?", target.uuid];
        if(!b4)
            NSLog(@"delete target failed [%@] : %@", target.uuid, [self.db lastErrorMessage]);
    }
    
    return b;
}
//更新行業情報為已讀
- (void)updateIndustryInfo:(NSString*)ID
{
    NSString* READ=@"1";
    NSString* sql = @"update M_INFORMATION set READ = ? where ID = ?";
    BOOL b = [self.db executeUpdate:sql,READ,ID];
    if(!b)NSLog(@"update guide release to %@ failed: %@", READ, [self.db lastErrorMessage]);
    else NSLog(@"update Finish");
}

@end
