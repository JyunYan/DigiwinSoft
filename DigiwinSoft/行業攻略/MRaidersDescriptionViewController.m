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
#import "MRaidersDescriptionTableViewCell.h"

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

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
    
//    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}
#pragma mark - create view
- (void)prepareTestData
{
}
-(void)addMainMenu
{
    
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
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
    labTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 20+44+175, screenWidth-100, 44)];
    labTitle.text=_strTitle;
    labTitle.backgroundColor=[UIColor whiteColor];
    [labTitle setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTitle];
     
    //btnTargetSet
    UIButton *btnTargetSet=[[UIButton alloc]initWithFrame:CGRectMake(10+(screenWidth-100)+5, 20+44+175+9, 75, 26)];
    btnTargetSet.backgroundColor=[UIColor colorWithRed:114.0/255.0 green:198.0/255.0 blue:225.0/255.0 alpha:1.0];
    [btnTargetSet setTitle:@"指標設定" forState:UIControlStateNormal];
//    UIImage *btnImage = [UIImage imageNamed:@""];
//    [btnTargetSet setImage:btnImage forState:UIControlStateNormal];
    [btnTargetSet addTarget:self action:@selector(actionTargetSet:) forControlEvents:UIControlEventTouchUpInside];
    btnTargetSet.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:btnTargetSet];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,labTitle.frame.origin.y+44,screenWidth, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
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
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"+加入對策清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,textView.frame.origin.y+100,screenWidth, btn.frame.origin.y-
                                                         (textView.frame.origin.y+textView.frame.size.height))];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];

    [self.view addSubview:imgGray];

    
    //tblView
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(20,textView.frame.origin.y+120,screenWidth-40, 160)];
    tbl.scrollEnabled = NO;
    tbl.delegate=self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];
}
#pragma mark - UIButton
-(void)clickedBtnSetting:(id)sender
{
    MRaidersDiagramViewController *MRaidersDiagramVC=[[MRaidersDiagramViewController alloc]init];
    MRaidersDiagramVC.strTitle=labTitle.text;
    [self.navigationController pushViewController:MRaidersDiagramVC animated:YES];
}
-(void)clickedBtnBcak:(id)sender
{
[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionAddMyList:(id)sender{
    NSLog(@"加入對策動作");
}
- (void)actionTargetSet:(id)sender{
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}
- (void)goToBackPage:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRaidersDescriptionTableViewCell *cell=[MRaidersDescriptionTableViewCell cellWithTableView:tableView];
    cell.labRelation.text=@"關聯關聯關聯關聯";
    cell.labMeasure.text=@"衡量衡量衡量";
    cell.labMax.text=@"999";
    cell.labMin.text=@"000";

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor whiteColor];

    UILabel *labRelation = [[UILabel alloc] initWithFrame:CGRectMake(30,20,60,20)];
    labRelation.text = @"關聯議題";
    labRelation.textColor =[UIColor grayColor];
    labRelation.font = [UIFont systemFontOfSize:14.0f];
    labRelation.backgroundColor=[UIColor clearColor];
    [viewSection addSubview:labRelation];
    
    UILabel *labMeasure = [[UILabel alloc] initWithFrame:CGRectMake(140,20, 60,20)];
    labMeasure.text = @"衡量指標";
    labMeasure.textColor =[UIColor grayColor];
    labMeasure.backgroundColor = [UIColor clearColor];
    labMeasure.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labMeasure];

    
    UILabel *labGrade = [[UILabel alloc] initWithFrame:CGRectMake(240,10, 75,20)];
    labGrade.text = @"實績提升率";
    labGrade.textColor =[UIColor grayColor];
    labGrade.backgroundColor = [UIColor clearColor];
    labGrade.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labGrade];

    UILabel *labMin = [[UILabel alloc] initWithFrame:CGRectMake(237,30, 30,20)];
    labMin.text = @"Min.";
    labMin.textColor =[UIColor grayColor];
    labMin.backgroundColor = [UIColor clearColor];
    labMin.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labMin];
    
    UILabel *labMax = [[UILabel alloc] initWithFrame:CGRectMake(285,30, 32,20)];
    labMax.text = @"Max.";
    labMax.textColor =[UIColor grayColor];
    labMax.backgroundColor = [UIColor clearColor];
    labMax.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labMax];

    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,58,tbl.frame.size.width,2)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [viewSection addSubview:imgGray];
    
    return viewSection;
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
