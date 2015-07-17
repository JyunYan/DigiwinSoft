//
//  MRaidersTableHeader.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/16.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRaidersTableHeader : UIView

@property (nonatomic, assign) CGSize size;

- (UILabel*)createTitleLabelWithText:(NSString*)text frame:(CGRect)frame;

@end


/**
 對策 header
 **/
@interface MGuideTableHeader : MRaidersTableHeader
- (void)prepare;
@end


/**
 關鍵活動 header
 **/
@interface MActivityTableHeader : MRaidersTableHeader
- (void)prepare;
@end


/**
 工作項目 header
 **/
@interface MWorkItemTableHeader : MRaidersTableHeader
- (void)prepare;
@end