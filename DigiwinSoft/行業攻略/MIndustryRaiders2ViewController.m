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
#import "MDirector.h"

#import "ASAnimationManager.h"
@interface MIndustryRaiders2ViewController ()<MIndustryRaidersTableViewCellDelegate>
{
    //screenSize
    //CGFloat screenWidth;
    //CGFloat screenHeight;
}

@property (nonatomic, assign) NSInteger operateIndex;

@end

@implementation MIndustryRaiders2ViewController

- (id)init
{
    if(self = [super init]){
        _operateIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"行業攻略";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self addMainMenu];
    
    //for p25 加入對策清單
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionAddPlan:) name:@"actionAddPlan" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    /*
    //rightBarButtonItem
    UIButton* settingbutton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 10, 25, 25)];
    [settingbutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [settingbutton addTarget:self action:@selector(clickedBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bar_item = [[UIBarButtonItem alloc] initWithCustomView:settingbutton];
    self.navigationItem.rightBarButtonItem = bar_item;
     */

    
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
    NSArray *aryGuide=[[MDataBaseManager sharedInstance]loadGuideSampleArrayWithPhen:_phen];
    aryList=[NSMutableArray arrayWithArray:aryGuide];
}
-(void) addMainMenu
{
    //Label
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 64,DEVICE_SCREEN_WIDTH, 40)];
    labTitle.text=self.phen.subject;
    labTitle.backgroundColor=[UIColor whiteColor];
    labTitle.textAlignment=NSTextAlignmentCenter;
    [labTitle setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:labTitle];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64+40,DEVICE_SCREEN_WIDTH, 10)];
    imgGray.backgroundColor=[UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [self.view addSubview:imgGray];
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:@"說明",@"建議對策",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 20+44+40+10,DEVICE_SCREEN_WIDTH, 40);
    [segmentedControl addTarget:self
                         action:@selector(actionSegmented:)
               forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor=[UIColor clearColor];
    segmentedControl.selectedSegmentIndex = 1;
    [self.view addSubview:segmentedControl];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,39,DEVICE_SCREEN_WIDTH, 1)];
    imgGray.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgGray];

    //imgblueBar
    imgblueBar=[[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_WIDTH/8)*5,36,DEVICE_SCREEN_WIDTH/4, 3)];
    imgblueBar.backgroundColor=[UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0];
    [segmentedControl addSubview:imgblueBar];
    
    //TableView
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-(20+44+40+10+40+35+49))];
    tbl.backgroundColor=[UIColor whiteColor];
    tbl.bounces=NO;
    tbl.delegate=self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];
    

    
    //btnAdd
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0,tbl.frame.origin.y+tbl.frame.size.height,DEVICE_SCREEN_WIDTH, 35)];
    btn.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    [btn setTitle:@"+加入我的規劃清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btn];
    
    //textView
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT-320)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=self.phen.desc;
    textView.font=[UIFont systemFontOfSize:12];
    textView.editable=NO;
    
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(10,textView.frame.origin.y+textView.frame.size.height+1,DEVICE_SCREEN_WIDTH-20, 1)];
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
            imgblueBar.frame=CGRectMake((DEVICE_SCREEN_WIDTH/8)*1,
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
            imgblueBar.frame=CGRectMake((DEVICE_SCREEN_WIDTH/8)*5,
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
#pragma mark - Notification
- (void)actionAddPlan:(NSNotification*) notification
{
    NSString *PassUUID=[notification object];
    for (int i=0; i<[aryList count]; i++) {
        MGuide *Guide=aryList[i];
        //找到相同UUID的Guid。
        if ([Guide.uuid isEqual:PassUUID]){
            //更改裡頭的IsCheck，reload cell。
            if ([aryList[i]isCheck]==NO) {
                [aryList[i] setIsCheck:YES];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [tbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"從對策說明勾選:%@",Guide.name);
            }else
            {
                NSLog(@"重複勾選");
            }
        }
    }
}
- (void)UpGuideTarget:(NSNotification*) notification
{
    MGuide *PassGuide=[notification object];
    NSString *PassUUID=PassGuide.uuid;
    for (int i=0; i<[aryList count]; i++) {
        MGuide *Guide=aryList[i];
        //找到相同UUID的Guid，置換裡面的Target。
        if ([Guide.uuid isEqual:PassUUID]){
            [aryList[i]setTarget:PassGuide.target];
            }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UpGuideTarget"
                                                  object:nil];
}
#pragma mark - UIButton

-(void)clickedBtnSetting:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate toggleLeft];
}
- (void)actionAddMyList:(id)sender{
    
    BOOL b = NO;
    for (MGuide* guide in aryList) {
        if (guide.isCheck) {
            b = YES;
            [[MDataBaseManager sharedInstance]insertGuide:guide from:_from];
            NSLog(@"加入:%@至DataBase",guide.name);
        }
    }
    
    if(b){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:@"成功加入我的規劃" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"訊息" message:@"請勾選對策" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didAssignManager:(NSNotification*)note
{
    MGuide* guide = (MGuide*)note.object;
    [aryList replaceObjectAtIndex:_operateIndex withObject:guide];
    
    [tbl reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAssignManager object:nil];
}

- (void)goToBackPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MIndustryRaidersTableViewCellDelegate 相關

- (void)btnManagerClicked:(MIndustryRaidersTableViewCell*)cell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAssignManager:) name:kDidAssignManager object:nil];
    
    NSIndexPath* indexPath = [tbl indexPathForCell:cell];
    _operateIndex = indexPath.row;
    MGuide* guide = [aryList objectAtIndex:_operateIndex];
    
    MDesignateResponsibleViewController *MDesignateResponsibleVC=[[MDesignateResponsibleViewController alloc]initWithGuide:guide];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MDesignateResponsibleVC];
    MIndustryRaidersNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];
}

-(void)btnTargetSetClicked:(MIndustryRaidersTableViewCell*)cell
{
    //for p27 帶回目標值與達成日
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpGuideTarget:)
                                                 name:@"UpGuideTarget"
                                               object:nil];
    
    NSIndexPath* indexPath = [tbl indexPathForCell:cell];
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    
    MInventoryTurnoverViewController *MInventoryTurnoverVC=[[MInventoryTurnoverViewController alloc]init];
    MInventoryTurnoverVC.guide=guide;
    [self.navigationController pushViewController:MInventoryTurnoverVC animated:YES];
}

- (void)btnRaidersClicked:(MIndustryRaidersTableViewCell*)cell{
    
    //for p27 帶回目標值與達成日
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpGuideTarget:)
                                                 name:@"UpGuideTarget"
                                               object:nil];
    
    NSIndexPath* indexPath = [tbl indexPathForCell:cell];
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    
    [MDirector sharedInstance].selectedPhen=_phen;
    
    MRaidersDescriptionViewController *MRaidersDescVC = [[MRaidersDescriptionViewController alloc] init];
    MRaidersDescVC.guide=guide;
    UINavigationController* MRaidersDescNav = [[UINavigationController alloc] initWithRootViewController:MRaidersDescVC];
    MRaidersDescNav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController presentViewController:MRaidersDescNav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIndustryRaidersTableViewCell *cell=(MIndustryRaidersTableViewCell *)[MIndustryRaidersTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    
    [cell prepareWithGuide:guide];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGuide* guide = [aryList objectAtIndex:indexPath.row];
    guide.isCheck = !guide.isCheck;
    
    MIndustryRaidersTableViewCell* cell = (MIndustryRaidersTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell prepareWithGuide:guide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    CGFloat offset = 0;
    
    UILabel *labRelation = [self createTitleLabelWithText:@"對策名稱" frame:CGRectMake(offset,0,DEVICE_SCREEN_WIDTH*0.45,30)];
    [viewSection addSubview:labRelation];
    
    offset += labRelation.frame.size.width;
    
    UILabel *labMeasure = [self createTitleLabelWithText:@"指派\n負責人" frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH*0.18, 30)];
    [viewSection addSubview:labMeasure];
    
    offset += labMeasure.frame.size.width;
    
    UILabel *labTargetSet = [self createTitleLabelWithText:@"目標\n設定" frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH*0.18, 30)];
    [viewSection addSubview:labTargetSet];
    
    offset += labTargetSet.frame.size.width;
    
    UILabel *labGrade = [self createTitleLabelWithText:@"攻略" frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH*0.18, 30)];
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

- (UILabel*)createTitleLabelWithText:(NSString*)text frame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor grayColor];
    label.text = text;
    
    return label;
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
