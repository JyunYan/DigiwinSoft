//
//  MIssType.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIssType : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* gainR;  //實際收益
@property (nonatomic, strong) NSString* gainP;  //預計收益

@end
