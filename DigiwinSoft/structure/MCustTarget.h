//
//  MCustTarget.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTarget.h"

@interface MCustTarget : MTarget

@property (nonatomic, strong) NSString* tar_uuid;

- (void)copyFromTarget:(MTarget*)target;

@end
