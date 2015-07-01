//
//  MRaidersDescriptionViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 攻略說明 */

#import "MRaidersDescriptionViewController.h"
#import "MInventoryTurnoverViewController.h"
#import "MRaidersDiagramViewController.h"
#import "MRaidersDescriptionTableViewCell.h"
#import "MDataBaseManager.h"
#import "MGuide.h"
#import "MTarget.h"
@interface MRaidersDescriptionViewController ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@end

@implementation MRaidersDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"對策說明";
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadData];
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
- (void)loadData
{
    aryList=[[MDataBaseManager sharedInstance]loadIssueArrayByGudie:_guide];
}
-(void)addMainMenu
{
    
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;

    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //webView
    webViewVideo = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 20+44,screenWidth, 100.0)];
    webViewVideo.delegate=self;
    webViewVideo.backgroundColor=[UIColor redColor];
    webViewVideo.scalesPageToFit = YES;
    NSString *videoPath = @"https://www.youtube.com/watch?v=nZRMajL_ulA";
//    NSString *videoPath = @"https://www.youtube.com/embed/watch?v=nZRMajL_ulA";
    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:videoPath]];
    [webViewVideo loadRequest:videoRequest];
    [self.view addSubview:webViewVideo];
    
    //labTitle
    labTitle=[[UILabel alloc]initWithFrame:CGRectMake(10,webViewVideo.frame.size.height+webViewVideo.frame.origin.y, screenWidth-100, 44)];
    labTitle.text=_guide.name;
    labTitle.backgroundColor=[UIColor whiteColor];
    [labTitle setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTitle];
     
    //btnTargetSet
    UIButton *btnTargetSet=[[UIButton alloc]initWithFrame:CGRectMake(10+(screenWidth-100)+5,labTitle.frame.origin.y+10, 75, 24)];
    btnTargetSet.backgroundColor=[UIColor colorWithRed:116.0/255.0 green:192.0/255.0 blue:222.0/255.0 alpha:1];
//之後有圖取消註解，換圖即可
//    btnTargetSet.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 56);
//    UIImage *btnImage = [UIImage imageNamed:@"icon_setting.png"];
//    [btnTargetSet setImage:btnImage forState:UIControlStateNormal];
//    btnTargetSet.titleEdgeInsets = UIEdgeInsetsMake(-10, -156, -10, -60);
    [btnTargetSet setTitle:@"指標設定" forState:UIControlStateNormal];
    [btnTargetSet addTarget:self action:@selector(actionTargetSet:) forControlEvents:UIControlEventTouchUpInside];
    btnTargetSet.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:btnTargetSet];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,labTitle.frame.origin.y+44,screenWidth, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    imgGray.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imgGray];
    
    //textView
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0,labTitle.frame.origin.y+labTitle.frame.size.height+2,screenWidth, 100)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=_guide.desc;
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
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(10,textView.frame.origin.y+110,screenWidth-20, 120)];
    tbl.delegate=self;
    tbl.dataSource = self;
    tbl.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRaidersDescriptionTableViewCell *cell=[MRaidersDescriptionTableViewCell cellWithTableView:tableView];
    cell.labRelation.text=[aryList[indexPath.row]name];
    cell.labRelation.backgroundColor=[UIColor clearColor];
    cell.labRelation.font = [UIFont systemFontOfSize:12];
    cell.labRelation.textColor=[UIColor blackColor];
    cell.labRelation.frame=CGRectMake((tbl.frame.size.width/4)-65, 14, 115, 16);

    MTarget *target=[aryList[indexPath.row]target];
    
    
    cell.labMeasure.text=target.name;
    cell.labMeasure.textColor=[UIColor blackColor];
    cell.labMeasure.backgroundColor=[UIColor clearColor];
    cell.labMeasure.font = [UIFont systemFontOfSize:12];
    cell.labMeasure.frame=CGRectMake((tbl.frame.size.width/2)-42, 14, 90, 16);
    

    cell.labMax.text=target.upMax;
    cell.labMax.textColor=[UIColor blackColor];
    cell.labMax.backgroundColor=[UIColor clearColor];
    cell.labMax.font = [UIFont systemFontOfSize:12];
    cell.labMax.frame=CGRectMake(((tbl.frame.size.width/4)*3)+34, 14, 30, 16);

    
    cell.labMin.text=target.upMin;
    cell.labMin.textColor=[UIColor blackColor];
    cell.labMin.backgroundColor=[UIColor clearColor];
    cell.labMin.font = [UIFont systemFontOfSize:12];
    cell.labMin.frame=CGRectMake(((tbl.frame.size.width/4)*3)-16, 14, 30, 16);

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor whiteColor];

    UILabel *labRelation = [[UILabel alloc] initWithFrame:CGRectMake((tbl.frame.size.width/4)-45,10,60,20)];
    labRelation.text = @"關聯議題";
    labRelation.textColor =[UIColor grayColor];
    labRelation.font = [UIFont systemFontOfSize:12.0f];
    labRelation.backgroundColor=[UIColor clearColor];
    [viewSection addSubview:labRelation];
    
    UILabel *labMeasure = [[UILabel alloc] initWithFrame:CGRectMake((tbl.frame.size.width/2)-30,10, 60,20)];
    labMeasure.text = @"衡量指標";
    labMeasure.textColor =[UIColor grayColor];
    labMeasure.backgroundColor = [UIColor clearColor];
    labMeasure.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labMeasure];

    
    UILabel *labGrade = [[UILabel alloc] initWithFrame:CGRectMake(((tbl.frame.size.width/4)*3)-10,0, 75,20)];
    labGrade.text = @"實績提升率";
    labGrade.textColor =[UIColor grayColor];
    labGrade.backgroundColor = [UIColor clearColor];
    labGrade.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labGrade];

    UILabel *labMin = [[UILabel alloc] initWithFrame:CGRectMake(labGrade.frame.origin.x-5,20, 30,20)];
    labMin.text = @"Min.";
    labMin.textColor =[UIColor grayColor];
    labMin.backgroundColor = [UIColor clearColor];
    labMin.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labMin];
    
    UILabel *labMax = [[UILabel alloc] initWithFrame:CGRectMake(labGrade.frame.origin.x+(labGrade.frame.size.width/2)+8,20, 32,20)];
    labMax.text = @"Max.";
    labMax.textColor =[UIColor grayColor];
    labMax.backgroundColor = [UIColor clearColor];
    labMax.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labMax];

    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,40,tbl.frame.size.width,2)];
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
