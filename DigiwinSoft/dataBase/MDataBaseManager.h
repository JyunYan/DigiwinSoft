//
//  MDataBaseManager.h
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface MDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabase* db;

+(MDataBaseManager*) sharedInstance;

@end
