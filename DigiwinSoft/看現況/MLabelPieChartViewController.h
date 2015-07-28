//
//  MLabelPieChartViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/27.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLabelPieChartViewControllerDelegate <NSObject>

- (void)reloadTableView;

@end

@interface MLabelPieChartViewController : UIViewController

@property (nonatomic, strong) id<MLabelPieChartViewControllerDelegate> delegate;

- (id)initWithFrame:(CGRect) rect ValueTitleArray:(NSMutableArray*) valueTitleArray;

@end
