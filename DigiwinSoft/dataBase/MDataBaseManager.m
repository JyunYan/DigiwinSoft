//
//  MDataBaseManager.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDataBaseManager.h"
#import "MDirector.h"
#import "MUser.h"
#import "MGuide.h"
#import "MEvent.h"

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
        user.industryName = [rs stringForColumnIndex:0];
        user.companyName = [rs stringForColumnIndex:1];
        user.uuid = [rs stringForColumn:@"ID"];
        user.industryId = [rs stringForColumn:@"IND_ID"];
        user.companyId = [rs stringForColumn:@"COMP_ID"];
        user.name = [rs stringForColumnIndex:5];
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

- (NSArray*)loadEventsWithEmpID:(NSString*)empid
{
    NSString* sql = @"select e.* from U_ACTIVITY as a inner join U_EVENT as e on a.ID = e.ACT_ID where a.EMP_ID = ?";
    // select * from U_ACTIVITY as a
    // inner join U_EVENT as e on a.ID = e.ACT_ID
    // where a.EMP_ID = 'emp-001'
    
    NSMutableArray* array = [NSMutableArray new];
    
    FMResultSet* rs = [self.db executeQuery:sql, empid];
    if([rs next]){
        
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

- (NSArray*)loadSituationWithEvent:(MEvent*)event
{
    return nil;
}

- (NSMutableArray*) getGuideArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* sql = @"select g.ID, g.NAME, g.DESCRIPTION, g.REVIEW, t.NAME from M_GUIDE as g inner join M_TARGET as t on g.TARGET_ID = t.ID";
    
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        MGuide* guide = [MGuide new];
        guide.uuid = [rs stringForColumnIndex:0];
        guide.name = [rs stringForColumnIndex:1];
        guide.desc = [rs stringForColumnIndex:2];
        guide.review = [rs stringForColumnIndex:3];
        
        guide.target = [rs stringForColumnIndex:4];
        
        [array addObject:guide];
    }
    
    return array;
}

@end
