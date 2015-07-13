//
//  MGuide.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGuide.h"

@implementation MGuide

- (id)init
{
    if(self = [super init]){
        
        _manager = [MUser new];
        _target = [MTarget new];
        _suggestSkill = [MSkill new];
        
        _activityArray = [NSMutableArray new];
    }
    return self;
}

@end
