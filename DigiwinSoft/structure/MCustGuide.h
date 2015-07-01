//
//  MCustGuide.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"
#import "MCustTarget.h"
#import "MPhenomenon.h"
#import "MIssue.h"

@interface MCustGuide : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* companyID;

@property (nonatomic, strong) NSString* fromPhenID;
@property (nonatomic, strong) NSString* fromIssueID;
@property (nonatomic, strong) NSString* fromSubject;

@property (nonatomic, strong) MPhenomenon* fromPhen;
@property (nonatomic, strong) MIssue* fromIssue;

@property (nonatomic, strong) NSString* gui_uuid;
@property (nonatomic, strong) NSString* status;

@property (nonatomic, assign) BOOL bRelease;

@property (nonatomic, strong) NSString* name;   //名稱
@property (nonatomic, strong) NSString* desc;   //描述
@property (nonatomic, strong) NSString* review; //評價(星數)

@property (nonatomic, strong) MCustTarget* target;  //指標
@property (nonatomic, strong) MUser* manager;   //負責人
@property (nonatomic, strong) NSMutableArray* activityArray;    //關鍵活動

@end
