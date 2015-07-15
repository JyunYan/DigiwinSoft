//
//  MReport.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/13.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MReport : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* gui_id;
@property (nonatomic, strong) NSString* act_id;
@property (nonatomic, strong) NSString* wi_id;

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* completed;
@property (nonatomic, strong) NSString* create_date;

@end
