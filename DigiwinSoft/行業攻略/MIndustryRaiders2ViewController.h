//
//  MIndustryRaiders2ViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPhenomenon.h"
#import "MConfig.h"

@interface MIndustryRaiders2ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *aryList;
    UITableView *tbl;
    UITextView *textView;
    UIButton *btn;
    UILabel *labTarget;
    UITextField *txtField;
    UIImageView *imgblueBar;
    UIImageView *imgGray;
}
@property (nonatomic, strong) MPhenomenon *phen;
@property (nonatomic, assign) NSInteger from;
@end
