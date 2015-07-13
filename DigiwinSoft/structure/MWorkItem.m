//
//  MWorkItem.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MWorkItem.h"

@implementation MWorkItem

- (id)init
{
    self = [super init];
    if(self){
        
        _manager = [MUser new];
        _target = [MTarget new];
        _suggestSkill = [MSkill new];
    }
    return self;
}


@end
