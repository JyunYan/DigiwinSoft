//
//  MRaidersDiagramViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRaidersDiagramViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbl;
}
@property (nonatomic, weak) NSString *strTitle;
@end
