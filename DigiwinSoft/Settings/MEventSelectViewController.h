//
//  MEventSelectViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/25.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDataBaseManager.h"

@interface MEventSelectViewController : UIViewController

- (id)initWithEvent:(MEvent*) event User:(MUser*) user;

@end
