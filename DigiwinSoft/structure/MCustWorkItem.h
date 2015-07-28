//
//  MCustWorkItem.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/2.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MWorkItem.h"
#import "MCustTarget.h"

@interface MCustWorkItem : MWorkItem

@property (nonatomic, strong) NSString* comp_id;
@property (nonatomic, strong) NSString* wi_m_id;
@property (nonatomic, strong) NSString* status;     // 0:未開始 1:進行中 2:已完成
@property (nonatomic, strong) NSString* accepted;   // 0:未接受 1:已接受

@property (nonatomic, strong) NSString* cre_dte;

@property (nonatomic, strong) MCustTarget* custTarget;

@end
