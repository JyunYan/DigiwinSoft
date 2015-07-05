//
//  MDataBaseManager.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDataBaseManager.h"
#import "MDirector.h"

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

#pragma mark - 事件相關

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
    NSString* sql = @"select a.* from U_ACTIVITY as a where a.ID = ?";
    // select e.* from U_ACTIVITY as a
    // where a.ID = 'a-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, event.actId];
    while([rs next]){
        MCustActivity* act = [MCustActivity new];
        act.uuid = [rs stringForColumn:@"ID"];
        act.name = [rs stringForColumn:@"NAME"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        //act.emp_id = [rs stringForColumn:@"EMP_ID"];
        act.status = [rs stringForColumn:@"STATUS"];
        
        [array addObject:act];
    }
    
    return array;
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
    NSString* sql = @"select p.*, t.NAME, t.UNIT from R_IND_PHEN as rip inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID inner join M_TARGET as t on t.ID = p.TAR_ID where rip.IND_ID = ?";
    // select p.*, t.NAME, t.UNIT
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
        
        [self loadTargetDetailWithTarget:target];
        
        [array addObject:phen];
    }
    return array;
}

// p5, p25
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen
{
    NSString* sql = @"select g.*, t.NAME, t.UNIT from R_PHEN_GUIDE as rpg inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rpg.PHEN_ID = ?";
    // select g.*, t.NAME, t.UNIT
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
        
        // 指標
        MTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];  // 指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        
        [self loadTargetDetailWithTarget:target];
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadActivitySampleArrayWithGuide:guide]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadActivitySampleArrayWithGuide:(MGuide*)guide
{
    NSString* sql = @"select ma.*, mt.NAME, mt.UNIT from R_GUIDE_ACT as rga inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID inner join M_TARGET as mt on ma.TAR_ID = mt.ID where rga.GUIDE_ID = ?";
    // select ma.*, mt.NAME, mt.UNIT
    // from R_GUIDE_ACT as rga
    // inner join M_ACTIVITY as ma on rga.ACT_ID = ma.ID
    // inner join M_TARGET as mt on ma.TAR_ID = mt.ID
    // where rga.GUIDE_ID = 'gui-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid];
    while ([rs next]) {
        MActivity* act = [MActivity new];
        act.uuid = [rs stringForColumn:@"ID"];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        act.index = [rs stringForColumn:@"INDEX"];
        act.previos = [rs stringForColumn:@"PREVIOS"];
        act.name = [rs stringForColumnIndex:1];
        
        act.guide_id = guide.uuid;
        
        // 指標
        MTarget* target = act.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.name = [rs stringForColumnIndex:6];
        
        [self loadTargetDetailWithTarget:target];
        
        // 工作項目
        [act.workItemArray addObjectsFromArray:[self loadWorkItemSampleArrayWithActivity:act]];
        
        [array addObject:act];
    }
    return array;
}

- (NSArray*)loadWorkItemSampleArrayWithActivity:(MActivity*)act
{
    NSString* sql = @"select mw.*, mt.NAME, mt.UNIT from M_WORK_ITEM as mw inner join M_TARGET as mt on mw.TAR_ID = mt.ID where mw.ACT_ID = ?";
    // select mw.*, mt.NAME, mt.UNIT
    // from M_WORK_ITEM as mw
    // inner join M_TARGET as mt on mw.TAR_ID = mt.ID
    // where mw.ACT_ID = 'act-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.uuid];
    while ([rs next]) {
        MWorkItem* item = [MWorkItem new];
        item.uuid = [rs stringForColumn:@"ID"];
        item.desc = [rs stringForColumn:@"DESCRIPTION"];
        item.index = [rs stringForColumn:@"INDEX"];
        item.previos = [rs stringForColumn:@"PREVIOS"];
        item.name = [rs stringForColumnIndex:2];
        
        item.act_id = act.uuid;
        item.guide_id = act.guide_id;
        
        MTarget* target = item.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.name = [rs stringForColumnIndex:7];
        
        [self loadTargetDetailWithTarget:target];
        
        [array addObject:item];
        
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
- (NSArray*)loadIssueArrayByGudie:(MGuide*)guide
{
    NSString* industryId = [MDirector sharedInstance].currentUser.industryId;
    NSString* sql = @"select tar.NAME, tar.UNIT, iss.*, rit.* from R_GUIDE_ISSUE as rgi inner join M_ISSUE as iss on iss.ID = rgi.ISSUE_ID inner join M_TARGET as tar on iss.TAR_ID = tar.ID inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID where rgi.GUIDE_ID = ? AND rit.IND_ID = ?";
    // select iss.NAME, tar.NAME, tar.UNIT, rit.*
    // from R_GUIDE_ISSUE as rgi
    // inner join M_ISSUE as iss on iss.ID = rgi.ISSUE_ID
    // inner join M_TARGET as tar on iss.TAR_ID = tar.ID
    // inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID
    // where rgi.GUIDE_ID = 'gui-001' AND rit.IND_ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid, industryId];
    while([rs next]){
        
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumnIndex:4];   // 議題name
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        
        MTarget* target = issue.target;
        target.uuid = [rs stringForColumnIndex:3];  //指標id
        target.name = [rs stringForColumnIndex:0];   //指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        
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

// p29
- (NSArray*)loadHistoryTargetArrayWithTarget:(MTarget*)target
{
    NSString* indid = [MDirector sharedInstance].currentUser.industryId;
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select * from R_IND_TAR as rit inner join M_TARGET as tar on tar.ID = rit.TAR_ID inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID where rit.IND_ID = ? and tar.ID = ? and rct.COMP_ID = ? order by rct.DATETIME desc limit 12";
    // select *
    // from R_IND_TAR as rit
    // inner join M_TARGET as tar on tar.ID = rit.TAR_ID
    // inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID
    // where rit.IND_ID = 'ind-001' and tar.ID = 'tar-001' and rct.COMP_ID = 'cmp-001'
    // order by rct.DATETIME desc
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, indid, target.uuid, compid];
    while([rs next]){
        MTarget* target = [MTarget new];
        target.uuid = [rs stringForColumn:@"ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        
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
        
        // 關鍵活動
        
        [guide.activityArray addObjectsFromArray:[self loadCustActivityArrayWithGuide:guide]];
        
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
        
        // 指標
        MCustTarget* target = guide.custTaregt;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:15];
        target.unit = [rs stringForColumn:@"UNIT"];
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
        
        // 關鍵活動
        [guide.activityArray addObjectsFromArray:[self loadCustActivityArrayWithGuide:guide]];
        
        [array addObject:guide];
    }
    return array;
}

- (NSArray*)loadCustActivityArrayWithGuide:(MCustGuide*)guide
{
    NSString* sql = @"select * from U_ACTIVITY as ua inner join U_TARGET as ut on ut.ID = ua.TAR_ID where ua.GUIDE_ID = ?";
    // select *
    // from U_ACTIVITY as ua
    // inner join U_TARGET as ut on ut.ID = ua.TAR_ID
    // where ua.GUIDE_ID = 'g001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid];
    while ([rs next]) {
        MCustActivity* act = [MCustActivity new];
        act.uuid = [rs stringForColumnIndex:0];
        act.name = [rs stringForColumnIndex:4];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        act.index = [rs stringForColumn:@"INDEX"];
        act.previos = [rs stringForColumn:@"PREVIOS"];
        act.status = [rs stringForColumn:@"STATUS"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        
        // 指標
        MCustTarget* target = act.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:14];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
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
        item.index = [rs stringForColumn:@"INDEX"];
        item.previos = [rs stringForColumn:@"PREVIOS"];
        item.status = [rs stringForColumn:@"STATUS"];
        item.comp_id = [rs stringForColumn:@"COMP_ID"];
        item.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        item.act_id = [rs stringForColumn:@"ACT_ID"];
        item.wi_m_id = [rs stringForColumn:@"WI_M_ID"];
        
        // 指標
        MCustTarget* target = item.custTarget;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:15];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        [self loadTargetDetailWithCustTarget:target];
        
        // 負責人
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        item.manager = [self loadEmployeeWithID:empid];
        
        [array addObject:item];
    }
    return array;
}

#pragma mark - 通用

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
    NSString* sql = @"insert into U_ACTIVITY ('ID','COMP_ID','GUIDE_ID','ACT_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','INDEX','PREVIOS','STATUS','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_ACT_UUID_PREV];
    NSString* act_m_id = act.uuid;
    NSString* name = act.name;
    NSString* desc = act.desc;
    NSString* tarid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    NSString* empid = act.manager.uuid;
    NSString* index = act.index;
    NSString* prev = act.previos;
    NSString* status = @"0";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, act_m_id, name, desc, tarid, empid, index, prev, status, cre_dte];
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
    NSString* sql = @"insert into U_WORK_ITEM ('ID','COMP_ID','GUIDE_ID','ACT_ID','WI_M_ID','NAME','DESCRIPTION','TAR_ID','EMP_ID','INDEX','PREVIOS','STATUS','CREATE_DATE') values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* cre_dte = [[MDirector sharedInstance] getCurrentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* uuid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_WORK_ITEM_UUID_PREV];
    NSString* wi_m_id = item.uuid;
    NSString* name = item.name;
    NSString* desc = item.desc;
    NSString* tarid = [[MDirector sharedInstance] getCustUuidWithPrev:CUST_TARGET_UUID_PREV];
    NSString* empid = item.manager.uuid;
    NSString* index = item.index;
    NSString* previos = item.previos;
    NSString* status = @"0";
    
    BOOL b = [self.db executeUpdate:sql, uuid, compid, guideid, actid, wi_m_id, name, desc, tarid, empid, index, previos, status, cre_dte];
    if(b)
        [self insertTarget:item.target withID:tarid];
    else
        NSLog(@"add work item failed : %@", [self.db lastErrorMessage]);
    
    return b;
}

- (BOOL)insertTarget:(MTarget*)target withID:(NSString*)uuid
{
    NSString* sql = @"insert into U_TARGET ('ID','TAR_M_ID','NAME','VALUE_T','UNIT','START_DATE','COMPLETED') values(?,?,?,?,?,?,?)";
    // ('ID','TAR_M_ID','NAME','VALUE_T','UNIT','START_DATE','COMPLETED')
    // values(?,?,?,?,?,?,?)
    
    BOOL b = [self.db executeUpdate:sql, uuid, target.uuid, target.name, target.valueT, target.unit, target.startDate, target.completeDate];
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

@end
