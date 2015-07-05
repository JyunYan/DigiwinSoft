//
//  MCarouselItemView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCarouselItemView : UIView

@property (nonatomic, strong) NSString* content;
@property (nonatomic, assign) CGFloat pointSize;
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, assign) BOOL onFacus;

@end
