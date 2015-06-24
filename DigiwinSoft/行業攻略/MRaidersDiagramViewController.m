//
//  MRaidersDiagramViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDiagramViewController.h"
#import <QuartzCore/QuartzCore.h>
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
}

#pragma mark - create view
- (void)prepareTestData
{
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
    labReason.backgroundColor=[UIColor redColor];
    [labReason setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labReason];
    
    //imgGray
    UIImageView *imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(15,105,screenWidth-30, 1)];
    imgGray.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imgGray];
    
    //Label
    UILabel *labTarget=[[UILabel alloc]initWithFrame:CGRectMake(20,125, 200, 15)];
    labTarget.text=@"指標:呆滯佔比";
    labTarget.backgroundColor=[UIColor redColor];
    [labTarget setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labTarget];
    
    //Label
    UILabel *labValue=[[UILabel alloc]initWithFrame:CGRectMake(labTarget.frame.origin.x+labTarget.frame.size.width+30,125,100, 15)];
    labValue.text=@"現值:30%";
    labValue.backgroundColor=[UIColor redColor];
    [labValue setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labValue];

    
    //imgGray
    imgGray=[[UIImageView alloc]initWithFrame:CGRectMake(0,160,screenWidth,screenHeight-160)];
    imgGray.backgroundColor=[UIColor grayColor];
    [self.view addSubview:imgGray];
    
    //UITextField
    UITextField *txtName=[[UITextField alloc]initWithFrame:CGRectMake(20,imgGray.frame.origin.y+20, 45, 20)];
    txtName.borderStyle=UITextBorderStyleLine;
    txtName.layer.borderColor=[UIColor whiteColor].CGColor;
    txtName.enabled=NO;
    txtName.text=@"對策";
    [txtName setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:txtName];

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
