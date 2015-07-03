//
//  MRaidersDiagramViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGuide.h"
@interface MRaidersDiagramViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tblActivity;
    UITableView *tblWorkItem;
    NSArray *aryActivity;
    NSArray *aryMActivity;
}
@property (nonatomic, weak) NSString *strTitle;
@property (nonatomic, weak) MGuide *guide;
@end
