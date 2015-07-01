//
//  MDirector.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDirector.h"

@implementation MDirector
static MDirector* _director = nil;

+(MDirector*) sharedInstance
{
    @synchronized([MDirector class])
    {
        if( !_director){
            
            _director=[[MDirector alloc] init];
        }
        return _director;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self){
       
    }
    
    return self;
}

@end
