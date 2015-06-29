//
//  MDirector.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"

@interface MDirector : NSObject

@property (nonatomic, strong) MUser* currentUser;   // 目前的user

+(MDirector*) sharedInstance;

@end
