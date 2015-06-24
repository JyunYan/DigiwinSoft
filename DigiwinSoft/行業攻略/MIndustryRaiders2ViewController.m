//
//  MIndustryRaiders2ViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryRaiders2ViewController.h"
#import "MIndustryRaidersTableViewCell.h"
#import "MRaidersDescriptionViewController.h"
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
    //aryList
    aryList=[[NSMutableArray alloc]initWithObjects:@"MyData1MyData1",@"MyData2MyData2",@"MyData3MyData3",@"MyData4MyData4",@"MyData5MyData5",@"MyData6MyData6",@"MyData7MyData7", nil];
}
-(void) addMainMenu
{
    CGSize screenSize =[[UIScreen mainScreen]bounds].size;
     screenWidth = screenSize.width;
     screenHeight = screenSize.height;

    //Label
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 20+44,screenWidth, 40)];
    labTitle.text=_strTitle;
    labTitle.backgroundColor=[UIColor whiteColor];
    labTitle.textAlignment=NSTextAlignmentCenter;
    [labTitle setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:labTitle];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20+44+40,screenWidth, 10)];
    imgGray.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imgGray];
    
    //Segmented
    NSArray *itemArray = [NSArray arrayWithObjects:@"說明",@"建議對策",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, 20+44+40+10,screenWidth, 40);
    segmentedControl.selectedSegmentIndex = 1;
    [segmentedControl addTarget:self
                         action:@selector(actionSegmented:)
               forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor=[UIColor clearColor];
    [self.view addSubview:segmentedControl];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} forState:UIControlStateSelected];
    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,39,screenWidth, 1)];
    imgGray.backgroundColor=[UIColor grayColor];
    [segmentedControl addSubview:imgGray];

    //imgblueBar
    imgblueBar=[[UIImageView alloc]initWithFrame:CGRectMake((screenWidth/8)*5,36,screenWidth/4, 3)];
    imgblueBar.backgroundColor=[UIColor greenColor];
    [segmentedControl addSubview:imgblueBar];
    
    //TableView
    tbl=[[UITableView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,screenWidth, screenHeight-(20+44+40+10+40+35+49))];
    tbl.backgroundColor=[UIColor redColor];
    tbl.delegate=self;
    tbl.dataSource = self;
    [self.view addSubview:tbl];

    
    //btnAdd
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0,tbl.frame.origin.y+tbl.frame.size.height,screenWidth, 35)];
    btn.backgroundColor=[UIColor purpleColor];
    [btn setTitle:@"+加入我的規劃清單" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(actionAddMyList:) forControlEvents:UIControlEventTouchUpInside]; //設定按鈕動作
    [self.view addSubview:btn];
    
    //textView
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0,20+44+40+10+40,screenWidth, screenHeight-320)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.text=@"Apple News將登場 蘋果深耕新聞業\n\n（中央社華盛頓20日綜合外電報導）美國科技巨擘蘋果公司（Apple）即將以新推出的應用程式App更深入新聞產業，往後在新聞業扮演的角色，可能更加舉足輕重。法新社報導，「蘋果新聞」（Apple News）將隨著蘋果應用程式iOS 9推出，主要是想成為iPhone與iPad用戶的主要新聞來源，可能受到影響的包括「臉書」（Facebook）、谷歌（Google）與Flipboard等新聞App。蘋果還出人意表地披露，將招募有經驗的新聞工作者來管理新聞內容，與對手們運用演算法來做新聞的方式有所不同。密蘇里大學行動新聞教授史利夫卡（Judd Slivka）表示：「蘋果很希望讓人類來做新聞，而不是用演算法來做，這與蘋果一直以來所做的品牌宣言不謀而合。」「預期他們會把廣及新聞界與特殊內容領域的人才，整合為1支聰明的團隊。」蘋果雖未詳述其計畫，但該公司招募網頁寫道，「徵求有熱情、知識淵博的編輯，來幫忙找出國內外與地方新聞，並發送出去」。招募頁面寫道，編輯群「對於突發新聞應有很棒的直覺，在辨識演算法無法發掘、原創又有說服力的故事方面，也應該同樣傑出」。（譯者：中央社鄭詩韻）1040621\n";
    textView.font=[UIFont systemFontOfSize:16];
    textView.editable=NO;
    
    //Label
    labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,textView.frame.origin.y+textView.frame.size.height+30,75,20)];
    labTarget.text=@"指標項目";
    labTarget.backgroundColor=[UIColor whiteColor];
    labTarget.textAlignment=NSTextAlignmentCenter;
    [labTarget setFont:[UIFont systemFontOfSize:18]];
    

    //TextField
    txtField=[[UITextField alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+3,textView.frame.origin.y+textView.frame.size.height+27,200,26)];
    txtField.backgroundColor=[UIColor whiteColor];
    txtField.borderStyle=UITextBorderStyleLine;
    txtField.font=[UIFont systemFontOfSize:18];
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
- (void)actionAddMyList:(id)sender{
    NSLog(@"加入我的規劃清單動作");
}
- (void)actionCheck:(UIButton *)sender{
    NSUInteger tt = sender.tag;
    NSLog(@"%lu",(unsigned long)tt);
    
    MIndustryRaidersTableViewCell * cell = (MIndustryRaidersTableViewCell *)[[sender superview] superview];
    
    if (cell.isCheck==NO) {
        cell.btnCheck.backgroundColor=[UIColor redColor];
        cell.isCheck=YES;
    }
    else
    {
        cell.btnCheck.backgroundColor=[UIColor grayColor];
        cell.isCheck=NO;
    }
}
- (void)btnManager:(id)sender{
    NSLog(@"btnManager");
}

- (void)btnRaiders:(id)sender{
    
    MRaidersDescriptionViewController *MIndustryRaiders2VC = [[MRaidersDescriptionViewController alloc] init];
    UINavigationController* MIndustryRaidersNav = [[UINavigationController alloc] initWithRootViewController:MIndustryRaiders2VC];
    [self.navigationController presentViewController:MIndustryRaidersNav animated:YES completion:nil];

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
    cell.labName.text=aryList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.btnCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCheck.tag = indexPath.row;
    [cell.btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnManager.tag = indexPath.row;
    [cell.btnRaiders addTarget:self action:@selector(btnRaiders:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnRaiders.tag = indexPath.row;
    cell.isCheck=NO;
    cell.tag=indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewSection = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 100, 20)];
    viewSection.backgroundColor=[UIColor grayColor];
    
    UILabel *labRelation = [[UILabel alloc] initWithFrame:CGRectMake(90,5,60,20)];
    labRelation.text = @"對策名稱";
    labRelation.textColor =[UIColor blackColor];
    labRelation.font = [UIFont systemFontOfSize:14.0f];
    labRelation.backgroundColor=[UIColor clearColor];
    [viewSection addSubview:labRelation];
    
    UILabel *labMeasure = [[UILabel alloc] initWithFrame:CGRectMake(200,5, 85,20)];
    labMeasure.text = @"指派負責人";
    labMeasure.textColor =[UIColor blackColor];
    labMeasure.backgroundColor = [UIColor clearColor];
    labMeasure.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labMeasure];
    
    
    UILabel *labGrade = [[UILabel alloc] initWithFrame:CGRectMake(300,5, 75,20)];
    labGrade.text = @"攻略";
    labGrade.textColor =[UIColor blackColor];
    labGrade.backgroundColor = [UIColor clearColor];
    labGrade.font = [UIFont systemFontOfSize:14.0f];
    [viewSection addSubview:labGrade];
    
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
