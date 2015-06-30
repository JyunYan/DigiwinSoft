//
//  ASIndustryRaidersViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"

@interface MIndustryRaidersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbl;
    UIImageView *img;
    NSMutableArray *aryList;
}

@end
