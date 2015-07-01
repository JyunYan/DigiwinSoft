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
    NSString* sql = @"select p.*, t.NAME, t.UNIT from M_INDUSTRY as i inner join R_IND_PHEN as rip on i.ID = rip.IND_ID inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID inner join M_TARGET as t on t.ID = p.TAR_ID where i.ID = ?";
    // select p.*, t.NAME, t.UNIT
    // from M_INDUSTRY as i
    // inner join R_IND_PHEN as rip on i.ID = rip.IND_ID
    // inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID
    // inner join M_TARGET as t on t.ID = p.TAR_ID
    // where i.ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while([rs next]){
        
        MPhenomenon* phen = [MPhenomenon new];
        phen.uuid = [rs stringForColumn:@"ID"];
        phen.subject = [rs stringForColumn:@"SUBJECT"];
        phen.desc = [rs stringForColumn:@"DESCRIPTION"];
        //phen.target = [rs stringForColumn:@"NAME"];
        
        MTarget* target = phen.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.unit = [rs stringForColumn:@"UNIT"];
        
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
        
        MTarget* target = guide.target;
        target.uuid = [rs stringForColumn:@"TAR_ID"];
        target.name = [rs stringForColumnIndex:6];  // 指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        
        [array addObject:guide];
    }
    return array;
}

// p25
- (NSArray*)loadIssueArrayByGudie:(MGuide*)guide
{
    NSString* industryId = [MDirector sharedInstance].currentUser.industryId;
    NSString* sql = @"select iss.*, tar.NAME, tar.UNIT, rit.* from M_ISSUE as iss inner join M_TARGET as tar on iss.TAR_ID = tar.ID inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID inner join R_GUIDE_ISSUE as rgi on iss.ID = rgi.ISSUE_ID where rgi.GUIDE_ID = ? AND rit.IND_ID = ?";
    // select iss.NAME, tar.NAME, tar.UNIT, rit.*
    // from M_ISSUE as iss
    // inner join M_TARGET as tar on iss.TAR_ID = tar.ID
    // inner join R_IND_TAR as rit on rit.TAR_ID = tar.ID
    // inner join R_GUIDE_ISSUE as rgi on iss.ID = rgi.ISSUE_ID
    // where rgi.GUIDE_ID = 'gui-001' AND rit.IND_ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid, industryId];
    while([rs next]){
        
        MIssue* issue = [MIssue new];
        issue.uuid = [rs stringForColumn:@"ID"];
        issue.name = [rs stringForColumnIndex:2];   // 議題name
        issue.desc = [rs stringForColumn:@"DESCRIPTION"];
        issue.reads = [rs stringForColumn:@"READS"];
        
        MTarget* target = issue.target;
        target.uuid = [rs stringForColumnIndex:1];  //指標id
        target.name = [rs stringForColumnIndex:5];   //指標name
        target.unit = [rs stringForColumn:@"UNIT"];
        
        target.top = [rs stringForColumn:@"TOP"];
        target.avg = [rs stringForColumn:@"AVG"];
        target.bottom = [rs stringForColumn:@"BOTTOM"];
        target.upMin = [rs stringForColumn:@"UP_MIN"];
        target.upMax = [rs stringForColumn:@"UP_MAX"];
        
        [array addObject:issue];
    }
    return array;
}

// p27
- (BOOL)loadTargetSettingsSampleIntoGuide:(MGuide*)guide
{
    if(!guide)
        return NO;
    
    NSString* compid = [MDirector sharedInstance].currentUser.companyId;
    NSString* sql = @"select rct.* from M_GUIDE as g inner join M_TARGET as t on g.TAR_ID = t.ID inner join R_COMP_TAR as rct on t.ID = rct.TAR_ID where g.ID = 'gui-001' and rct.COMP_ID = 'cmp-001' order by rct.DATETIME desc";
    // select rct.*
    // from M_GUIDE as g
    // inner join M_TARGET as t on g.TAR_ID = t.ID
    // inner join R_COMP_TAR as rct on t.ID = rct.TAR_ID
    // where g.ID = 'gui-001' and rct.COMP_ID = 'cmp-001'
    // order by rct.DATETIME desc
    // limit 1
    
    FMResultSet* rs = [self.db executeQuery:sql, guide.uuid, compid];
    if([rs next]){
        
        MTarget* target = guide.target;
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        
        return YES;
        
    }else{
        NSLog(@"no match target settings sample !!");
        return NO;
    }
}

#pragma mark - 我的規劃/我的攻略

// No:規劃(未發佈) Yes:攻略(發佈)
- (NSArray*)loadCustomGuideArrayByRelease:(BOOL)release
{
    NSString* sql = @"select * from U_GUIDE where RELEASE = ? order by CREATE_DATE";
    // select mt.NAME, g.*, ut.*
    // from U_GUIDE as g
    // inner join U_TARGET as ut on g.TAR_ID = ut.ID
    // inner join M_TARGET as mt on ut.TAR_M_ID = mt.ID
    // where g.RELEASE = false
    // order by CREATE_DATE
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, release];
    while([rs next]){
        
        MCustGuide* guide = [MCustGuide new];
        guide.uuid = [rs stringForColumn:@"ID"];
        guide.companyID = [rs stringForColumn:@"COMP_ID"];
        guide.gui_uuid = [rs stringForColumn:@"GUI_M_ID"];
        guide.name = [rs stringForColumn:@"NAME"];
        guide.desc = [rs stringForColumn:@"DESCRIPTION"];
        guide.bRelease = [rs boolForColumn:@"RELEASE"];
        guide.status = [rs stringForColumn:@"STATUS"];
        
        NSString* tarID = [rs stringForColumn:@"TAR_ID"];
        guide.target = [self loadCustTargetWithID:tarID];
        
        NSString* phenId = [rs stringForColumn:@"FROM_PHEN_ID"];
        guide.fromPhen = [self loadPhenWithID:phenId];
        
        NSString* issueId = [rs stringForColumn:@"FROM_ISS_ID"];
        guide.fromIssue = [self loadIssueWithID:issueId];
        
        [array addObject:guide];
        
    }
    
    return array;
}

- (MCustTarget*)loadCustTargetWithID:(NSString*)tarid
{
    if(!tarid)
        return nil;
    
    NSString* sql = @"select * from U_TARGET where ID = ?";
    
    FMResultSet* rs = [self.db executeQuery:sql, tarid];
    if([rs next]){
        MCustTarget* target = [MCustTarget new];
        
        target.uuid = [rs stringForColumn:@"ID"];
        target.tar_uuid = [rs stringForColumn:@"TAR_M_ID"];
        target.name = [rs stringForColumn:@"NAME"];
        target.valueR = [rs stringForColumn:@"VALUE_R"];
        target.valueT = [rs stringForColumn:@"VALUE_T"];
        target.unit = [rs stringForColumn:@"UNIT"];
        target.startDate = [rs stringForColumn:@"START_DATE"];
        target.completeDate = [rs stringForColumn:@"COMPLETED"];
        
        return target;
    }
    return nil;
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


@end
