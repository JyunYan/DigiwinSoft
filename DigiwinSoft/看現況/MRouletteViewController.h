//
//  MRouletteViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MManageItem.h"

@interface MRouletteViewController : UIViewController

@property (nonatomic, assign) NSInteger defaultIndex;

- (id)initWithManageItem:(MManageItem*)manaItem;

@end
