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
    // select * from M_EVENT as e
    // inner join R_EVT_SITU as res on e.ID = res.EVT_ID
    // inner join M_SITUATION as s on s.ID = res.SITU_ID
    // inner join R_SITU_REA as rsr on s.ID = rsr.SITU_ID
    // inner join M_REASON as r on r.ID = rsr.REA_ID
    // where e.ID = 'evt_001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, event.uuid];
    while([rs next]){
        MSituation* situ = [MSituation new];
        situ.uuid = [rs stringForColumn:@"ID"];
        situ.name = [rs stringForColumnIndex:1];    // situ name
        situ.reason = [rs stringForColumnIndex:2];  // reason name
        
        [array addObject:situ];
    }
    
    return array;
}

// p19
- (NSArray*)loadTreasureWithActivity:(MActivity*)act
{
    NSString* sql = @"select t.* from M_WORK_ITEM as wi inner join R_SOR_TRE as rst on wi.ID = rst.SOR_ID inner join M_TREASURE as t on t.ID = rst.TRE_ID where wi.ACT_ID = ? group by t.ID";
    // select t.* from M_WORK_ITEM as wi
    // inner join R_SOR_TRE as rst on wi.ID = rst.SOR_ID
    // inner join M_TREASURE as t on t.ID = rst.TRE_ID
    // where wi.ACT_ID = 'act-001'
    // group by t.ID
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, act.uuid];
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
    NSString* sql = @"select p.*, t.NAME from M_INDUSTRY as i inner join R_IND_PHEN as rip on i.ID = rip.IND_ID inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID inner join R_PHEN_TAR as rpt on p.ID =  rpt.PHEN_ID inner join M_TARGET as t on t.ID = rpt.TAR_ID where i.ID = ?";
    // select p.*, t.NAME
    // from M_INDUSTRY as i
    // inner join R_IND_PHEN as rip on i.ID = rip.IND_ID
    // inner join M_PHENOMENON as p on p.ID = rip.PHEN_ID
    // inner join R_PHEN_TAR as rpt on p.ID =  rpt.PHEN_ID
    // inner join M_TARGET as t on t.ID = rpt.TAR_ID
    // where i.ID = 'ind-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, uuid];
    while([rs next]){
        
        MPhenomenon* phen = [MPhenomenon new];
        phen.uuid = [rs stringForColumn:@"ID"];
        phen.subject = [rs stringForColumn:@"SUBJECT"];
        phen.desc = [rs stringForColumn:@"DESCRIPTION"];
        phen.target = [rs stringForColumn:@"NAME"];
        
        [array addObject:phen];
    }
    return array;
}

// p5
- (NSArray*)loadGuideSampleArrayWithPhen:(MPhenomenon*)phen
{
    NSString* sql = @"select g.*, t.NAME from R_PHEN_GUIDE as rpg inner join M_GUIDE as g on g.ID = rpg.GUIDE_ID inner join M_TARGET as t on t.ID = g.TAR_ID where rpg.PHEN_ID = ?";
    // select g.*, t.NAME
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
        target.name = [rs stringForColumnIndex:6];
        
        [array addObject:guide];
    }
    return array;
}

@end
