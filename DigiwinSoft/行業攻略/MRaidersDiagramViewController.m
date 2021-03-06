//
//  MRaidersDiagramViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDiagramViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MGuide.h"
#import "MActivity.h"
#import "MWorkItem.h"
#import "MDirector.h"
#import "MDataBaseManager.h"

@interface MRaidersDiagramViewController ()
{
    NSArray *aryActivity;
    NSArray *aryWorkItem;
    MWorkItem* item;
    MActivity* act;
}
@end

@implementation MRaidersDiagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"攻略展開圖", @"攻略展開圖");
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;

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
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
}

#pragma mark - create view
- (void)loadData
{
    aryActivity = [[MDataBaseManager sharedInstance] loadActivitySampleArrayWithGuideID:_guide.gui_uuid];
    act = [aryActivity firstObject];
    aryWorkItem = act.workItemArray;
}
-(void)addMainMenu
{
    //screenSize
    //CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    //CGFloat screenWidth = screenSize.width;
    //CGFloat screenHeight = screenSize.height;
    
    NSString *reaosn, *name, *valueT, *unit, *valueR;
    if(_from == GUIDE_FROM_PHEN){
        MPhenomenon* phen = [MDirector sharedInstance].selectedPhen;
        reaosn = phen.subject;
        name = phen.target.name;
        valueT = phen.target.valueT;
        valueR = phen.target.valueR;
        unit = phen.target.unit;
    }else if(_from == GUIDE_FROM_ISSUE){
        MIssue* issue = [MDirector sharedInstance].selectedIssue;
        reaosn = issue.name;
        name = issue.target.name;
        valueT = issue.target.valueT;
        valueR = issue.target.valueR;
        unit = issue.target.unit;
    }

    //Label
    UILabel *labReason=[[UILabel alloc]initWithFrame:CGRectMake(20,80, DEVICE_SCREEN_WIDTH-40, 15)];
    labReason.text=[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"緣起", @"緣起"),reaosn];
    labReason.backgroundColor=[UIColor clearColor];
    [labReason setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labReason];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(15,110,DEVICE_SCREEN_WIDTH-30, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,125, 200, 15)];
    labTarget.text=[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"指標", @"指標"),name];;
    labTarget.backgroundColor=[UIColor clearColor];
    [labTarget setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTarget];
    
    //Label
    UILabel *labValue=[[UILabel alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+5,125,100, 15)];
    labValue.text=[NSString stringWithFormat:@"%@ : %@%@", NSLocalizedString(@"目標值", @"目標值"),valueT,unit];
    labValue.backgroundColor=[UIColor clearColor];
    [labValue setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labValue];

    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,160,DEVICE_SCREEN_WIDTH,DEVICE_SCREEN_HEIGHT-160)];
    imgGray.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [self.view addSubview:imgGray];
    
    //UITextField
    UITextField *txtName=[[UITextField alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+20, 46, 26)];
    txtName.borderStyle=UITextBorderStyleLine;
    txtName.layer.borderColor=[UIColor whiteColor].CGColor;
    txtName.enabled=NO;
    txtName.textAlignment = NSTextAlignmentCenter;
    txtName.text = NSLocalizedString(@"對策", @"對策");
    [txtName setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:txtName];
    
    //Label
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(70,imgGray.frame.origin.y+20, DEVICE_SCREEN_WIDTH-100, 26)];
    labTitle.text=_guide.name;
    labTitle.backgroundColor=[UIColor clearColor];
    [labTitle setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTitle];
    
    //Label
    UILabel *labTarget2=[[UILabel alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+60, 200, 15)];
    labTarget2.text=[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"指標", @"指標"),_guide.custTaregt.name];
    labTarget2.backgroundColor=[UIColor clearColor];
    [labTarget2 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTarget2];
    
    //Label
    UILabel *labValue2=[[UILabel alloc]initWithFrame:CGRectMake(labTarget2.frame.origin.x+labTarget2.frame.size.width+5,imgGray.frame.origin.y+60,100, 15)];
    labValue2.text=[NSString stringWithFormat:@"%@ : %@%@", NSLocalizedString(@"目標值", @"目標值"),_guide.custTaregt.valueT,_guide.custTaregt.unit];
    labValue2.backgroundColor=[UIColor clearColor];
    [labValue2 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labValue2];
    
    //tblActivity
    tblActivity=[[UITableView alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+90,(DEVICE_SCREEN_WIDTH/2)-20, DEVICE_SCREEN_HEIGHT-(imgGray.frame.origin.y+90))];
    tblActivity.delegate=self;
    tblActivity.dataSource = self;
    tblActivity.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblActivity.tag=101;
    tblActivity.bounces=NO;
    tblActivity.layer.borderColor = [UIColor grayColor].CGColor;
    tblActivity.layer.borderWidth = 1.f;
    [self.view addSubview:tblActivity];
    
    //default cell selected
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [tblActivity selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
    
    //tblWorkItem
    tblWorkItem=[[UITableView alloc]initWithFrame:CGRectMake(20+tblActivity.frame.size.width - 1,imgGray.frame.origin.y+90,(DEVICE_SCREEN_WIDTH/2)-20, DEVICE_SCREEN_HEIGHT-(imgGray.frame.origin.y+90))];
    tblWorkItem.delegate=self;
    tblWorkItem.dataSource = self;
    tblWorkItem.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblWorkItem.tag=102;
    tblWorkItem.bounces=NO;
    tblWorkItem.layer.borderColor = [UIColor grayColor].CGColor;
    tblWorkItem.layer.borderWidth = 1.f;
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
        return [aryActivity count];
    }else
    {
        return [aryWorkItem count];
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
        label.text=[aryActivity[indexPath.row]name];
        detailLabel.text=[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"指標", @"指標"), [[aryActivity[indexPath.row]target]name]];
        
    }
    else
    {
        label.text=[aryWorkItem[indexPath.row]name];
        detailLabel.text =[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"指標", @"指標"), [[aryWorkItem[indexPath.row]target]name]];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:detailLabel];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;

     if (tableView.tag==102) {
         cell.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==101) {
        act =aryActivity[indexPath.row];
        aryWorkItem = act.workItemArray;
        
        [tblWorkItem reloadData];
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
        labHeader.text = NSLocalizedString(@"關鍵活動", @"關鍵活動");
    }else
    {
        labHeader.text = NSLocalizedString(@"工作項目", @"工作項目");
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
