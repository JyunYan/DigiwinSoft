//
//  MCustGuide.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCustGuide.h"

@implementation MCustGuide

-(id)init
{
    if(self = [super init]){
        
        _custTaregt = [MCustTarget new];
        _fromIssue = [MIssue new];
        _fromPhen = [MPhenomenon new];
    }
    return self;
}

@end
