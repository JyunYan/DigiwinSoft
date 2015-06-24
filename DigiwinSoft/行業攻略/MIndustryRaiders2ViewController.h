//
//  MIndustryRaiders2ViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIndustryRaiders2ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *aryList;
    UITableView *tbl;
    UITextView *textView;
    UIButton *btn;
    UILabel *labTarget;
    UITextField *txtField;
    UIImageView *imgblueBar;
}
@property (nonatomic, weak) NSString *strTitle;
@end
