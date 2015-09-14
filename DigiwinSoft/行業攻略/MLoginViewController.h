//
//  MLoginViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLoginViewController;

@protocol MLoginViewControllerDelegate <NSObject>

- (void)didLoginSuccessed:(MLoginViewController*)viewController;

@end

@interface MLoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) id<MLoginViewControllerDelegate> delegate;

@end
