//
//  MDataBaseManager.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDataBaseManager.h"
#import "MUser.h"

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
        
        return YES;
    }else{
        return NO;
    }
}

@end
