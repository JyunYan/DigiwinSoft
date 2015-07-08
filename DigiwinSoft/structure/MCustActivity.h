//
//  MCustActivity.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/2.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MActivity.h"
#import "MCustTarget.h"

@interface MCustActivity : MActivity

@property (nonatomic, strong) NSString* comp_id;
@property (nonatomic, strong) NSString* act_m_id;
@property (nonatomic, strong) NSString* status;

@property (nonatomic, strong) NSString* cre_dte;

@property (nonatomic, strong) MCustTarget* custTarget;

@end
