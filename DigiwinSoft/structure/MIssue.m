//
//  MIssue.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIssue.h"

@implementation MIssue

- (id)init
{
    if(self = [super init]){
        
        _target = [MTarget new];
    }
    return self;
}

@end
