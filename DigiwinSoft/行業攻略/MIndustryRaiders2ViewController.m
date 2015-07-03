//
//  MIndustryRaiders2ViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

/* 行業攻略 p03/05*/

#import "MIndustryRaiders2ViewController.h"
#import "MIndustryRaidersTableViewCell.h"
#import "MRaidersDescriptionViewController.h"
#import "MDesignateResponsibleViewController.h"
#import "MDataBaseManager.h"
#import "AppDelegate.h"
#import "MInventoryTurnoverViewController.h"
@interface MIndustryRaiders2ViewController ()

@end

@implementation MIndustryRaiders2ViewController
{
    //screenSize
    CGFloat screenWidth;
    CGFloat screenHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"行業攻略";
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
 
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;

    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(goToBackPage:)];
    self.navigationItem.leftBarButtonItem = back;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([tbl respondsToSelector:@selector(setSeparatorInset:)]) {
        [tbl setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tbl respondsToSelector:@selector(setLayoutMargins:)]) {
        [tbl setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - create view
- (void)loadData
{
    aryList=[[MDataBaseManager sharedInstance]loadGuideSampleArrayWithPhen:_phen];
}
-(void) addMainMenu
{
    CGSize screenSize =[[UIScreen mainScreen]bounds].size;
     screenWidth = screenSize.width;
     screenHeight = screenSize.height;

    //Label
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 64,screenWidth, 40)];
    labTitle.text=self.phen.subject;
    labTitle.backgroundColor=[UIColor whiteColor];
    labTitle.textAlignment=NSTextAlignmentCenter;
    [labTitle setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:labTitle];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64+40,screenWidth, 10)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [self.view addSubview:imgGray];
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:@"說明",@"建議對策",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 20+44+40+10,screenWidth, 40);
    [segmentedControl addTarget:self
                         action:@selector(actionSegmented:)
               forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor=[UIColor clearColor];
    [self.view addSubview:segmentedControl];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,39,screenWidth, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgGray];

    //imgblueBar
    imgblueBar=[[UIImageView alloc]initWithFrame:CGRectMake((screenWidth/8)*5,36,screenWidth/4, 3)];
    imgblueBar.backgroundColor=[UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgblueBar];
    
    //TableView
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,screenWidth, screenHeight-(20+44+40+10+40+35+49))];
    tbl.backgroundColor=[UIColor whiteColor];
    tbl.bounces=NO;
    tbl.delegate=self;
    tbl.dataSource = self;
    

    
    //btnAdd
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0,tbl.frame.origin.y+tbl.frame.size.height,screenWidth, 35)];
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"+加入我的規劃清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    
    
    //textView
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,screenWidth, screenHeight-320)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=self.phen.desc;
    textView.font=[UIFont systemFontOfSize:12];
    textView.editable=NO;
    
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(10,textView.frame.origin.y+textView.frame.size.height+1,screenWidth-20, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    
    //Label
    labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,textView.frame.origin.y+textView.frame.size.height+30,75,20)];
    labTarget.text=@"指標項目";
    labTarget.backgroundColor=[UIColor whiteColor];
    labTarget.textAlignment=NSTextAlignmentCenter;
    [labTarget setFont:[UIFont systemFontOfSize:12]];
    

    //TextField
    txtField=[[UITextField alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+3,textView.frame.origin.y+textView.frame.size.height+27,200,26)];
    txtField.backgroundColor=[UIColor whiteColor];
    txtField.borderStyle=UITextBorderStyleLine;
    txtField.text=self.phen.target.name;
    txtField.enabled=NO;
    txtField.font=[UIFont systemFontOfSize:12];
    txtField.delegate = self;
    
           segmentedControl.selectedSegmentIndex = 0;
        [self.view addSubview:imgGray];
        [self.view addSubview:textView];
        [self.view addSubview:labTarget];
        [self.view addSubview:txtField];
        imgblueBar.frame=CGRectMake((screenWidth/8)*1,
                                    imgblueBar.frame.origin.y,
                                    imgblueBar.frame.size.width,
                                    imgblueBar.frame.size.height);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)actionSegmented:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            [tbl removeFromSuperview];
            [btn removeFromSuperview];
            [self.view addSubview:imgGray];
            [self.view addSubview:textView];
            [self.view addSubview:labTarget];
            [self.view addSubview:txtField];
            
            
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            imgblueBar.frame=CGRectMake((screenWidth/8)*1,
                                        imgblueBar.frame.origin.y,
                                        imgblueBar.frame.size.width,
                                        imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        case 1:
        {
            [self.view addSubview:tbl];
            [self.view addSubview:btn];
            [imgGray removeFromSuperview];
            [textView removeFromSuperview];
            [txtField removeFromSuperview];
            [labTarget removeFromSuperview];
            
            //imgblueBar Animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            //設定動畫開始時的狀態為目前畫面上的樣子
            [UIView setAnimationBeginsFromCurrentState:YES];
            imgblueBar.frame=CGRectMake((screenWidth/8)*5,
                                        imgblueBar.frame.origin.y,
                                        imgblueBar.frame.size.width,
                                        imgblueBar.frame.size.height);
            [UIView commitAnimations];
            break;
        }
        default:
        {
            NSLog(@"Error");
            break;
        }
    }
}
#pragma mark - UIButton
-(void)btnTargetSet:(id)sender
{
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    MIndustryRaidersTableViewCell * cell = (MIndustryRaidersTableViewCell *)[[sender superview] superview];
    NSIndexPath* indexPath = [tbl indexPathForCell:cell];
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    MInventoryTurnoverVC.target=guide.target;
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}
-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
- (void)actionAddMyList:(id)sender{
    NSLog(@"加入我的規劃清單動作");
}
- (void)actionCheck:(UIButton *)sender{
   
    MIndustryRaidersTableViewCell * cell = (MIndustryRaidersTableViewCell *)[[sender superview] superview];
    
    if (cell.isCheck==NO) {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox_fill.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    }
    cell.isCheck=!cell.isCheck;
}
- (void)btnManager:(id)sender{
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]init];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

- (void)btnRaiders:(id)sender{
    
    MRaidersDescriptionViewController *MRaidersDescVC = [[MRaidersDescriptionViewController alloc] init];
    MIndustryRaidersTableViewCell * cell = (MIndustryRaidersTableViewCell *)[[sender superview] superview];
    NSIndexPath* indexPath = [tbl indexPathForCell:cell];
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    MRaidersDescVC.guide=guide;
    UINavigationController* MRaidersDescNav = [[UINavigationController alloc] initWithRootViewController:MRaidersDescVC];
    MRaidersDescNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MRaidersDescNav animated:YES completion:nil];
}
- (void)goToBackPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 32.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIndustryRaidersTableViewCell *cell=[MIndustryRaidersTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //對策名稱
    cell.labName.text=[aryList[indexPath.row]name];
    cell.labName.font=[UIFont systemFontOfSize:12];
    cell.labName.frame=CGRectMake(30, 16, 140, 18);
    cell.labName.backgroundColor=[UIColor clearColor];
    
    //Check
    [cell.btnCheck  setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    cell.btnCheck.frame=CGRectMake(12, 16, 16, 16);
    [cell.btnCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    //指派負責人
    UIImage *imgManager = [UIImage imageNamed:@"icon_manager.png"];
    [cell.btnManager setBackgroundImage:imgManager forState:UIControlStateNormal];
    cell.btnManager.frame=CGRectMake(((screenWidth/2)*1)+8,23, 22, 22);
    [cell.btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
    
    //目標設定
    UIImage *imgTargetSet = [UIImage imageNamed:@"icon_manager.png"];
    [cell.btnTargetSet setBackgroundImage:imgTargetSet forState:UIControlStateNormal];
    cell.btnTargetSet.frame=CGRectMake(((screenWidth/4)*3)-18,23, 22,22);
    [cell.btnTargetSet addTarget:self action:@selector(btnTargetSet:) forControlEvents:UIControlEventTouchUpInside];
    
    //攻略
    UIImage *imgRaiders = [UIImage imageNamed:@"icon_raider.png"];
    [cell.btnRaiders setBackgroundImage:imgRaiders forState:UIControlStateNormal];
    cell.btnRaiders.frame=CGRectMake(((screenWidth/4)*3)+30,23 , 22, 22);
    [cell.btnRaiders addTarget:self action:@selector(btnRaiders:) forControlEvents:UIControlEventTouchUpInside];
    
    //星星數量
    NSInteger iStarNum=[[aryList[indexPath.row]review]integerValue];
    for (int i=0; i<5; i++){
        UIImageView *imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(30+(17*i), 36,16,16)];
        if(i<iStarNum){
            imgStar.image=[UIImage imageNamed:@"star_fill.png"];
        }else
        {
            imgStar.image=[UIImage imageNamed:@"star_empty.png"];
        }
        [cell addSubview:imgStar];
    }
    
    //取消勾選
    cell.isCheck=NO;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    UILabel *labRelation = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/4)-30,5,60,20)];
    labRelation.text = @"對策名稱";
    labRelation.textColor =[UIColor grayColor];
    labRelation.font = [UIFont systemFontOfSize:12.0f];
    labRelation.backgroundColor=[UIColor clearColor];
    [viewSection addSubview:labRelation];
    
    UILabel *labMeasure = [[UILabel alloc] initWithFrame:CGRectMake(((screenWidth/2)*1)-12,-2, 60,34)];
    labMeasure.text = @"指派\n負責人";
    labMeasure.numberOfLines=2;
    labMeasure.textAlignment = NSTextAlignmentCenter;
    labMeasure.textColor =[UIColor grayColor];
    labMeasure.backgroundColor = [UIColor clearColor];
    labMeasure.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labMeasure];
    
    UILabel *labTargetSet = [[UILabel alloc] initWithFrame:CGRectMake(((screenWidth/4)*3)-20,-2, 26,34)];
    labTargetSet.text = @"目標\n設定";
    labTargetSet.numberOfLines=2;
    labTargetSet.textColor =[UIColor grayColor];
    labTargetSet.backgroundColor = [UIColor clearColor];
    labTargetSet.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labTargetSet];

    
    UILabel *labGrade = [[UILabel alloc] initWithFrame:CGRectMake(((screenWidth/4)*3)+30,5, 30,20)];
    labGrade.text = @"攻略";
    labGrade.textColor =[UIColor grayColor];
    labGrade.backgroundColor = [UIColor clearColor];
    labGrade.font = [UIFont systemFontOfSize:12.0f];
    [viewSection addSubview:labGrade];
    
    return viewSection;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
