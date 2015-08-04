//
//  MIndustryRaiders2ViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPhenomenon.h"
#import "MIssue.h"
#import "MConfig.h"

@interface MIndustryRaiders2ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    //UITextView *textView;
    //UIButton *btn;
    //UILabel *labTarget;
    //UITextField *txtField;
    //UIImageView *imgGray;
}

@property (nonatomic, strong) MPhenomenon *phen;
@property (nonatomic, strong) MIssue* issue;

- (id)initWithPhenomenon:(MPhenomenon*)phen;
- (id)initWithIssue:(MIssue*)issue;
@end
