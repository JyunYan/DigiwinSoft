//
//  MDirector.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"
#import "MUser.h"
#import "MIndustry.h"
#import "MPhenomenon.h"
#import "MIssue.h"

@interface MDirector : NSObject

@property (nonatomic, strong) MUser* currentUser;           // 目前的user
@property (nonatomic, strong) MIndustry* currentIndustry;   // 目前的行業

@property (nonatomic, assign) BOOL isLogin; //是否登入

@property (nonatomic, strong) MPhenomenon* selectedPhen;
@property (nonatomic, strong) MIssue* selectedIssue;

+(MDirector*) sharedInstance;

#pragma mark - scale
-(CGSize) getScaledSize:(CGSize)size;
-(CGRect) getScaledRect:(CGRect)frame;

#pragma mark - get color methods
- (UIColor*)getCustomOrangeColor;
- (UIColor *)getCustomGrayColor;
- (UIColor *)getCustomLightGrayColor;
- (UIColor *)getCustomLightestGrayColor;
- (UIColor *)getCustomBlueColor;
- (UIColor *)getCustomRedColor;
- (UIColor *)getForestGreenColor;

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2;

- (void)showAlertDialog:(NSString*) msg;
- (void)showHUD;
- (void)hideHUD;

// 隨機產生uuid
- (NSString*)getCustUuidWithPrev:(NSString*)prev;

// 取得目前時間字串
- (NSString*)getCurrentDateStringWithFormat:(NSString*)format;

- (CGFloat) getOriginY;

@end
