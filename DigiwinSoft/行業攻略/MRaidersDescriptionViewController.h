//
//  MRaidersDescriptionViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MRaidersDescriptionViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tbl;
    UIWebView *webViewVideo;
    UIButton *btn;
    UILabel *labTitle;
    NSMutableArray *aryList;
}
@property (nonatomic, weak) NSString *strTitle;
@end
