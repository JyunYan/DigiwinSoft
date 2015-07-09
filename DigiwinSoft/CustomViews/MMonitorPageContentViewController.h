//
//  MMonitorPageContentViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMonitorPageContentViewDelegate <NSObject>

@end

@interface MMonitorPageContentViewController : UIViewController

@property (nonatomic, strong) id<MMonitorPageContentViewDelegate> delegate;

@property (nonatomic, assign) int pageIndex;

- (id)initWithFrame:(CGRect) rect;

@end
