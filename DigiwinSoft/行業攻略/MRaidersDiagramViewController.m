//
//  MRaidersDiagramViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDiagramViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MRaidersDiagramTableViewCell.h"
#import "MGuide.h"
#import "MActivity.h"
@interface MRaidersDiagramViewController ()

@end

@implementation MRaidersDiagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"攻略展開圖";
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
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
}

#pragma mark - create view
- (void)prepareTestData
{
    
//    NSDictionary *dis1=[[NSDictionary alloc]initWithObjectsAndKeys:
//                        @"制定最小製造批量標準",@"Activity",
//                        @"指標:半成品週轉天數",@"SubActivity",
//                        @"瓶頸製程工時計算",@"WorkItem",
//                        @"指標:半成品週轉天數",@"SubWorkItem", nil];
//    
//    NSDictionary *dis2=[[NSDictionary alloc]initWithObjectsAndKeys:
//                        @"使用標準需求指導計畫",@"Activity",
//                        @"指標:半成品週轉天數",@"SubActivity",
//                        @"決定換線損失計數值",@"WorkItem",
//                        @"指標:半成品週轉天數",@"SubWorkItem", nil];
//
//    aryList=[[NSMutableArray alloc]initWithObjects:dis1,dis2,nil];
    
    
    MGuide *g=_guide;
//    aryActivity=_guide.activityArray;
}
-(void)addMainMenu
{
    //screenSize
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    //Label
    UILabel *labReason=[[UILabel alloc]initWithFrame:CGRectMake(20,80, screenWidth-40, 15)];
    labReason.text=@"緣起:小批量接單沒好配套，呆滯急遽增加。";
    labReason.backgroundColor=[UIColor clearColor];
    [labReason setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labReason];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(15,110,screenWidth-30, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,125, 200, 15)];
    labTarget.text=@"指標:呆滯佔比";
    labTarget.backgroundColor=[UIColor clearColor];
    [labTarget setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTarget];
    
    //Label
    UILabel *labValue=[[UILabel alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+30,125,100, 15)];
    labValue.text=@"現值:30%";
    labValue.backgroundColor=[UIColor clearColor];
    [labValue setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labValue];

    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,160,screenWidth,screenHeight-160)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //UITextField
    UITextField *txtName=[[UITextField alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+20, 46, 26)];
    txtName.borderStyle=UITextBorderStyleLine;
    txtName.layer.borderColor=[UIColor whiteColor].CGColor;
    txtName.enabled=NO;
    txtName.textAlignment = NSTextAlignmentCenter;
    txtName.text=@"對策";
    [txtName setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:txtName];
    
    //Label
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(70,imgGray.frame.origin.y+20, screenWidth-100, 26)];
    labTitle.text=_strTitle;
    labTitle.backgroundColor=[UIColor clearColor];
    [labTitle setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTitle];
    
    //Label
    UILabel *labTarget2=[[UILabel alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+60, 200, 15)];
    labTarget2.text=@"指標:半成品週轉天數";
    labTarget2.backgroundColor=[UIColor clearColor];
    [labTarget2 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTarget2];
    
    //Label
    UILabel *labValue2=[[UILabel alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+30,imgGray.frame.origin.y+60,100, 15)];
    labValue2.text=@"現值:40天";
    labValue2.backgroundColor=[UIColor clearColor];
    [labValue2 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labValue2];
    
    //tblActivity
    tblActivity=[[UITableView alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+90,(screenWidth/2)-20, screenHeight-(imgGray.frame.origin.y+90))];
    tblActivity.scrollEnabled = NO;
    tblActivity.delegate=self;
    tblActivity.dataSource = self;
    tblActivity.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblActivity.tag=101;
    [self.view addSubview:tblActivity];
    
    //tblWorkItem
    tblWorkItem=[[UITableView alloc]initWithFrame:CGRectMake(20+tblActivity.frame.size.width,imgGray.frame.origin.y+90,(screenWidth/2)-20, screenHeight-(imgGray.frame.origin.y+90))];
    tblWorkItem.scrollEnabled = NO;
    tblWorkItem.delegate=self;
    tblWorkItem.dataSource = self;
    tblWorkItem.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblWorkItem.tag=102;
    [self.view addSubview:tblWorkItem];


}
#pragma mark - UIButton
- (void)goToBackPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    return 30.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==101)
    {
        return 2;
    }else
    {
        return 2;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(5,5,tableView.frame.size.width-10,20)];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.backgroundColor=[UIColor clearColor];
    
    UILabel *detailLabel;
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,24,tableView.frame.size.width-10,20)];
    detailLabel.font = [UIFont systemFontOfSize:11.0];
    detailLabel.textColor=[UIColor grayColor];
    detailLabel.backgroundColor=[UIColor clearColor];
    
    
    if (tableView.tag==101)
    {
//        label.text=aryActivity[indexPath.row];
//        detailLabel.text=[aryList[indexPath.row]objectForKey:@"SubActivity"];
    }
    else
    {
//        label.text=[aryList[indexPath.row]objectForKey:@"WorkItem"];
//        detailLabel.text =[aryList[indexPath.row]objectForKey:@"SubWorkItem"];
    }
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:detailLabel];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==101) {
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];
    viewSection.backgroundColor=[UIColor whiteColor];
    
    UILabel *labHeader=[[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2-30,5,60,20)];
    labHeader.textColor =[UIColor grayColor];
    labHeader.font = [UIFont systemFontOfSize:14.0f];
    labHeader.backgroundColor=[UIColor clearColor];
    [viewSection addSubview:labHeader];
    
    if(tableView.tag==101){
        labHeader.text = @"關聯議題";
    }else
    {
        labHeader.text = @"工作項目";
    }
    
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,30,tableView.frame.size.width,2)];
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
