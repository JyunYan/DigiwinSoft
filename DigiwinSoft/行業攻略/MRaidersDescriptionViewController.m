//
//  MRaidersDescriptionViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDescriptionViewController.h"
#import "MInventoryTurnoverViewController.h"
#import "MRaidersDiagramViewController.h"
#define TAG_BUTTON_SETTING  101
@interface MRaidersDescriptionViewController ()

@end

@implementation MRaidersDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"對策說明";
    self.view.backgroundColor = [UIColor whiteColor];

    [self prepareTestData];
    [self addMainMenu];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - create view
- (void)prepareTestData
{
}
-(void)addMainMenu
{
    
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    settingbutton.tag = TAG_BUTTON_SETTING;
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Normal.png"] forState:UIControlStateNormal];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"Button-Favorite-List-Pressed.png"] forState:UIControlStateHighlighted];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;

    
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    webViewVideo = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 20+44,screenWidth, 175.0)];
    webViewVideo.delegate=self;
    webViewVideo.backgroundColor=[UIColor redColor];
    webViewVideo.scalesPageToFit = YES;
    NSString *videoPath = @"https://www.youtube.com/watch?v=nZRMajL_ulA";
//    NSString *videoPath = @"https://www.youtube.com/embed/watch?v=nZRMajL_ulA";
    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:videoPath]];
    [webViewVideo loadRequest:videoRequest];
    [self.view addSubview:webViewVideo];
    
    //labTitle
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 20+44+175, screenWidth-100, 44)];
    labTitle.text=@"我的標題呀！我的標題呀！我的標題呀！";
    labTitle.backgroundColor=[UIColor whiteColor];
    [labTitle setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:labTitle];
     
    //btnTargetSet
    UIButton *btnTargetSet=[[UIButton alloc]initWithFrame:CGRectMake(10+(screenWidth-100)+5, 20+44+175+9, 75, 26)];
    btnTargetSet.backgroundColor=[UIColor greenColor];
    [btnTargetSet setTitle:@"指標設定" forState:UIControlStateNormal];
    [btnTargetSet addTarget:self action:@selector(actionTargetSet:) forControlEvents:UIControlEventTouchUpInside];
    btnTargetSet.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:btnTargetSet];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,labTitle.frame.origin.y+44,screenWidth, 1)];
    imgGray.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imgGray];
    
    //textView
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0,labTitle.frame.origin.y+labTitle.frame.size.height+2,screenWidth, 100)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=@"Apple News將登場 蘋果深耕新聞業\n\n（中央社華盛頓20日綜合外電報導）美國科技巨擘蘋果公司（Apple）即將以新推出的應用程式App更深入新聞產業，往後在新聞業扮演的角色，可能更加舉足輕重。法新社報導，「蘋果新聞」（Apple News）將隨著蘋果應用程式iOS 9推出，主要是想成為iPhone與iPad用戶的主要新聞來源，可能受到影響的包括「臉書」（Facebook）、谷歌（Google）與Flipboard等新聞App。蘋果還出人意表地披露，將招募有經驗的新聞工作者來管理新聞內容，與對手們運用演算法來做新聞的方式有所不同。密蘇里大學行動新聞教授史利夫卡（Judd Slivka）表示：「蘋果很希望讓人類來做新聞，而不是用演算法來做，這與蘋果一直以來所做的品牌宣言不謀而合。」「預期他們會把廣及新聞界與特殊內容領域的人才，整合為1支聰明的團隊。」蘋果雖未詳述其計畫，但該公司招募網頁寫道，「徵求有熱情、知識淵博的編輯，來幫忙找出國內外與地方新聞，並發送出去」。招募頁面寫道，編輯群「對於突發新聞應有很棒的直覺，在辨識演算法無法發掘、原創又有說服力的故事方面，也應該同樣傑出」。（譯者：中央社鄭詩韻）1040621\n";
    textView.font=[UIFont systemFontOfSize:12];
    textView.editable=NO;
    [self.view addSubview:textView];
    
    //btnAdd
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0,screenHeight-35,screenWidth, 35)];
    btn.backgroundColor=[UIColor purpleColor];
    [btn setTitle:@"+加入對策清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)actionAddMyList:(id)sender{
    NSLog(@"加入對策動作");
}
- (void)actionTargetSet:(id)sender{
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}

#pragma mark - UIButton
-(void)clickedBtnSetting:(id)sender
{
    MRaidersDiagramViewController *MRaidersDiagramVC=[[MRaidersDiagramViewController alloc]init];
    [self.navigationController pushViewController:MRaidersDiagramVC animated:YES];
  }

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView setUserInteractionEnabled:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"error : %@ \n", [error description]);
    [webView stopLoading];
}
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Determine if we want the system to handle it.
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
