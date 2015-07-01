//
//  MRecommendTreasuresViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRecommendTreasuresViewController.h"
#import "AppDelegate.h"


@interface MRecommendTreasuresViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerView;

@property (nonatomic, strong) MTreasure* treasure;

@end

@implementation MRecommendTreasuresViewController

- (id)initWithTreasure:(MTreasure*) treasure {
    self = [super init];
    if (self) {
        _treasure = treasure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"建議寶物";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addMainMenu];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenFrame.size.width;
    CGFloat screenHeight = screenFrame.size.height;
    
    
    CGFloat posX = 0;
    CGFloat posY = 0;
    CGFloat width = screenWidth;
    CGFloat height = width * 3 / 4 + statusBarHeight;
    
    UIView* videoView = [self createMoviePlayerView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:videoView];
    
    
    posY = videoView.frame.origin.y + videoView.frame.size.height;
    width = screenWidth;
    height = screenHeight - posY - navBarHeight;
    
    UIView* tableView = [self createDetailView:CGRectMake(posX, posY, width, height)];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right_bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = right_bar_item;
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

- (UIView*)createMoviePlayerView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor blackColor];
    
    
//    NSURL *movieURL = [NSURL URLWithString:_treasure.url];
    NSURL *movieURL = [NSURL URLWithString:@"http://techslides.com/demos/sample-videos/small.mp4"];
    _moviePlayerView = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        
    _moviePlayerView.scalingMode = MPMovieScalingModeAspectFit;
    
    [_moviePlayerView.view setFrame:CGRectMake(0, 30, rect.size.width, rect.size.height - 30)];
    [view addSubview: _moviePlayerView.view];
    
    [_moviePlayerView prepareToPlay];
    
    return view;
}

- (UIView*)createDetailView:(CGRect) rect
{
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat textSize = 15.0f;
    
    CGFloat viewWidth = rect.size.width;

    
    CGFloat posX = 25;
    CGFloat posY = 10;
    CGFloat width = viewWidth - posX * 2;
    CGFloat height = 30;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:textSize];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = _treasure.name;
    [view addSubview:titleLabel];
    
    
    posX = 0;
    posY = titleLabel.frame.origin.x + titleLabel.frame.size.height;
    width = viewWidth;
    
    UIView* lineView1 = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView1];
    
    
    posX = 25;
    posY = lineView1.frame.origin.y + lineView1.frame.size.height + 10;
    width = viewWidth - posX * 2;
    
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:textSize];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:detailLabel];

    detailLabel.text = _treasure.desc;
    [detailLabel sizeToFit];

    
    posX = 20;
    posY = detailLabel.frame.origin.y + detailLabel.frame.size.height + 20;
    width = viewWidth - posX * 2;

    UIView* lineView2 = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineView2];
    
    
    posX = 25;
    posY = lineView2.frame.origin.y + lineView2.frame.size.height + 20;
    width = 30;
    height = 30;

    UIImageView* imageViewPhone = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    imageViewPhone.image = [UIImage imageNamed:@"icon_phone.png"];
    [view addSubview:imageViewPhone];

    
    posX = imageViewPhone.frame.origin.x + imageViewPhone.frame.size.width + 10;
    width = viewWidth - posX - 35;

    UILabel* phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:20.0f];
    phoneLabel.text = _treasure.phone;
    [view addSubview:phoneLabel];


    return view;
}

#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
