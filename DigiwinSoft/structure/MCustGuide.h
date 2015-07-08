//
//  MCustGuide.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGuide.h"
#import "MCustTarget.h"
#import "MPhenomenon.h"
#import "MIssue.h"

@interface MCustGuide : MGuide

@property (nonatomic, strong) NSString* companyID;
@property (nonatomic, strong) NSString* gui_uuid;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* owner;

@property (nonatomic, strong) NSString* fromPhenID;
@property (nonatomic, strong) NSString* fromIssueID;
@property (nonatomic, strong) NSString* fromSubject;

@property (nonatomic, strong) NSString* cre_dte;

@property (nonatomic, strong) MPhenomenon* fromPhen;
@property (nonatomic, strong) MIssue* fromIssue;

@property (nonatomic, assign) BOOL bRelease;

@property (nonatomic, strong) MCustTarget* custTaregt;  //指標

@end
