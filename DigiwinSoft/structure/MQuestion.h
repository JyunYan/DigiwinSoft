//
//  MQuestion.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/5.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQuestion : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* reads;

@property (nonatomic, strong) NSAttributedString* attrSubject;   //有顏色的字串

@property (nonatomic, strong) NSArray* issueArray;

@end
