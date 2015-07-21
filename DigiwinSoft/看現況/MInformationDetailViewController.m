//
//  MInformationDetailViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MInformationDetailViewController.h"
#import "MDirector.h"

@interface MInformationDetailViewController ()

@end

@implementation MInformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight + statusBarHeight;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:scrollView];

    
    posX = 0;
    posY = 0;
    width = screenWidth;
    height = width * 3 / 4;
    
    UIView* topView = [self createTopView:CGRectMake(posX, posY, width, height)];
    [scrollView addSubview:topView];
    
    
    posY = topView.frame.origin.x + topView.frame.size.height;
    height = scrollView.frame.size.height - posY;
    
    UIView* detailView = [self createDetailView:CGRectMake(posX, posY, width, height)];
    [scrollView addSubview:detailView];
    
    
    height = detailView.frame.origin.y + detailView.frame.size.height + 50;
    scrollView.contentSize = CGSizeMake(width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

-(UIView*) createTopView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = viewWidth;
    CGFloat height = viewHeight;

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    imageView.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
    [view addSubview:imageView];
    
    
    return view;
}

-(UIView*) createDetailView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    
    CGFloat viewX = rect.origin.x;
    CGFloat viewY = rect.origin.y;
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    
    CGFloat posX = 20;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 20;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.font = [UIFont boldSystemFontOfSize:19.];
    titleLabel.textColor = [[MDirector sharedInstance] getCustomBlueColor];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = @"電子零件》高頻高速IO及醫療用連接器挹注，正淩業績看俏";
    [view addSubview:titleLabel];
    
    [titleLabel sizeToFit];
    
    
    posY = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10;
    
    UILabel* dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    dateTimeLabel.font = [UIFont boldSystemFontOfSize:13.];
    dateTimeLabel.textColor = [UIColor grayColor];
    dateTimeLabel.text = @"2015/05/26 11:46  時報記者張漢綺台北報導";
    [view addSubview:dateTimeLabel];
    
    [dateTimeLabel sizeToFit];

    
    posY = dateTimeLabel.frame.origin.y + dateTimeLabel.frame.size.height + 20;
    
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    descLabel.font = [UIFont systemFontOfSize:15.];
    descLabel.textColor = [UIColor blackColor];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.text = @"正淩 (8147) 受惠於通訊高頻高速IO及醫療用連接器客戶訂單強勁，第1季每股盈餘達1.1元，正淩4月合併營收為9484萬元，創下單月歷史新高，隨著新產能開出及新訂單挹注，正淩總經理陳言成對公司未來業績深具信心，預估今年業績成長幅度將不低於去年，在買盤力挺下，今天股價強攻漲停板，創下2014年7月4日以來新高價。\n\n　正淩主攻通訊、工業及醫療用連接器，其中通訊部分有30%是企業端，客戶包括：Mellanox、H3C、Arista及Marvel，70%客戶為中興及華為等通訊廠，而通訊產品以高頻高速IO為主，約佔營收12%；公司看好高頻高速IO及醫療用連接器前景，大舉擴建新廠產能，隨著新產能開出及新訂單挹注，帶動正淩第1季及4月業績攀高，正淩第1季合併營收2.26億元，較去年同期成長21.5%，營業毛利為7447萬元，合併毛利率為32.81%，較去年同期增加2.92個百分點，稅前盈餘為2904萬元，稅後盈餘為2348萬元，每股盈餘為1.1元。\n\n　正淩4月合併營收為9484萬元，較去年同月成長65.71%，創下單月歷史新高，累計1到4月合併營收為3.21億元，較去年同期成長32.29%。\n\n　陳言成表示，公司針對物聯網5G世代已開發出新產品，心導管連接器及牙科或骨科儀器設備的金屬連接器出貨亦持續放量，隨著通訊、工業及醫療三大產品穩定成長，今年業績成長幅度將不低於去年，2016年後業績更將展現爆發力。";
    [view addSubview:descLabel];
    
    [descLabel sizeToFit];
    
    
    view.frame = CGRectMake(viewX, viewY, viewWidth, descLabel.frame.origin.y + descLabel.frame.size.height);
    
    return view;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
