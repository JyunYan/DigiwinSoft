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
        
        [MDirector sharedInstance].currentUser = user;
        
        return YES;
    }else{
        return NO;
    }
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
        MActivity* act = [MActivity new];
        act.uuid = [rs stringForColumn:@"ID"];
        act.name = [rs stringForColumn:@"NAME"];
        act.comp_id = [rs stringForColumn:@"COMP_ID"];
        act.guide_id = [rs stringForColumn:@"GUIDE_ID"];
        act.act_m_id = [rs stringForColumn:@"ACT_M_ID"];
        act.desc = [rs stringForColumn:@"DESCRIPTION"];
        act.emp_id = [rs stringForColumn:@"EMP_ID"];
        act.status = [rs stringForColumn:@"STATUS"];
        
        [array addObject:act];
    }
    
    return array;
}

// p19
- (NSArray*)loadTreasureWithActivity:(MActivity*)act
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
        
        MTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];  // 指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        
        [self loadTargetDetailWithTarget:target];
        
        [array addObject:guide];
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
    NSString* sql = @"select * from R_IND_TAR as rit inner join M_TARGET as tar on tar.ID = rit.TAR_ID inner join R_COMP_TAR as rct on tar.ID = rct.TAR_ID where rit.IND_ID = ? and tar.ID = ? and rct.COMP_ID = ? order by rct.DATETIME limit 12";
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
        
        [array addObject:target];
    }
    return array;
}

#pragma mark - 我的規劃/我的攻略

// No:規劃(未發佈) Yes:攻略(發佈)
- (NSArray*)loadCustomGuideArrayByRelease:(BOOL)release
{
    NSString* releaseStr = release ? @"1" : @"0";
    NSString* owner = [MDirector sharedInstance].currentUser.uuid;
    
    NSString* sql = @"select * from U_GUIDE as ug inner join U_TARGET as ut on ug.TAR_ID = ut.ID  where ug.RELEASE = ? and ug.OWNER = ? order by CREATE_DATE";
    // select mt.NAME, gu.*, ut.*
    // from U_GUIDE as ug
    // inner join U_TARGET as ut on g.TAR_ID = ut.ID
    // where ug.RELEASE = false and ug.OWNER = 'emp-001'
    // order by CREATE_DATE
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, releaseStr, owner];
    while([rs next]){
        
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [rs stringForColumnIndex:0];
        guide.companyID = [rs stringForColumn:@"COMP_ID"];
        guide.gui_uuid = [rs stringForColumn:@"GUI_M_ID"];
        guide.name = [rs stringForColumn:@"NAME"];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.bRelease = [rs boolForColumn:@"RELEASE"];
        guide.status = [rs stringForColumn:@"STATUS"];
        
        MCustTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumnIndex:16];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        
        NSString* phenId = [rs stringForColumn:@"FROM_PHEN_ID"];
        guide.fromPhen = [self loadPhenWithID:phenId];
        
        NSString* issueId = [rs stringForColumn:@"FROM_ISS_ID"];
        guide.fromIssue = [self loadIssueWithID:issueId];
        
        NSString* empid = [rs stringForColumn:@"EMP_ID"];
        guide.manager = [self loadEmployeeWithID:empid];
        
        [array addObject:guide];
        
    }
    
    return array;
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
    NSString* sql = @"select * from M_ISSUE as iss inner join M_TARGET as t on iss.TAR_ID = t.ID inner join R_COMP_TAR as rct on rct.TAR_ID = t.ID where rct.COMP_ID = 'cmp-001' and iss.ID = 'iss-001' order by DATETIME desc limit 1";
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
    NSString* sql = @"select * from M_USER as u inner join M_EMPLOYEE as emp on u.EMP_ID = emp.ID where u.EMP_ID = 'emp-001' and u.COMP_ID = 'cmp-001' limit 1";
    // select *
    // from M_USER as u
    // inner join M_EMPLOYEE as emp on u.EMP_ID = emp.ID
    // where u.EMP_ID = 'emp-001' and u.COMP_ID = 'cmp-001'
    // limit 1
    
    FMResultSet* rs = [self.db executeQuery:sql, empid, compid];
    if([rs next]){
        
        MUser* employee = [MUser new];
        employee.industryName = [rs stringForColumnIndex:0];    // industry name
        employee.companyName = [rs stringForColumnIndex:1];     // company name
        employee.uuid = [rs stringForColumn:@"ID"];
        employee.industryId = [rs stringForColumn:@"IND_ID"];
        employee.companyId = [rs stringForColumn:@"COMP_ID"];
        employee.name = [rs stringForColumnIndex:5];            // user name
        employee.phone = [rs stringForColumn:@"PHONE"];
        employee.email = [rs stringForColumn:@"EMAIL"];
        employee.arrive_date = [rs stringForColumn:@"ARRIVE_DATE"];
        employee.thumbnail = [rs stringForColumn:@"THUMBNAIL"];
        
        return employee;
    }
    
    return nil;
}

@end
