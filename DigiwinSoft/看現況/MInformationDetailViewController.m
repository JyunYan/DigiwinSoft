//
//  MInformationDetailViewController.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MInformationDetailViewController.h"
#import "MDirector.h"
#import "MConfig.h"

#import "AFNetworking.h"
#import "MReachabilityManager.h"
#import "ASFileManager.h"
#import "UIImageView+AFNetworking.h"


#define TAG_IMAGEVIEW 100


@interface MInformationDetailViewController ()

@property (nonatomic, strong) MIndustryInfo* info;

@end

@implementation MInformationDetailViewController

- (id)initWithIndustryInfo:(MIndustryInfo*)info
{
    if(self = [super init]){
        _info = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addMainMenu];
    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create view

-(void) addMainMenu
{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = back;
}

-(UIView*) createTopView:(CGRect) rect
{
    NSURL* url = [NSURL URLWithString:_info.url];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.tag = TAG_IMAGEVIEW;
    [imageView setImageWithURL:url placeholderImage:nil];
    
    return imageView;
}

- (void)initContentView
{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0., 64., DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64-49)];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    
    CGFloat posX = DEVICE_SCREEN_WIDTH*0.05;
    CGFloat posY = 0.;
    
    //圖示
    UIView* topView = [self createTopView:CGRectMake(0, posY, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_WIDTH*0.5)];
    [scrollView addSubview:topView];
    
    posY += topView.frame.size.height + 10.;
    
    //標題
    UILabel* subject = [self createLabelWithOrigin:CGPointMake(posX, posY)
                                          maxWidth:DEVICE_SCREEN_WIDTH*0.9
                                              font:[UIFont boldSystemFontOfSize:19.]
                                              text:_info.subject];
    subject.textColor = [[MDirector sharedInstance] getCustomBlueColor];
    [scrollView addSubview:subject];
    
    posY += subject.frame.size.height + 10.;
    
    //內容
    UILabel* content = [self createLabelWithOrigin:CGPointMake(posX, posY)
                                          maxWidth:DEVICE_SCREEN_WIDTH*0.9
                                              font:[UIFont boldSystemFontOfSize:14.]
                                              text:_info.desc];
    [scrollView addSubview:content];
    
    posY += content.frame.size.height + 10.;
    
    scrollView.contentSize = CGSizeMake(DEVICE_SCREEN_WIDTH, posY);
    
    
}

- (UILabel*)createLabelWithOrigin:(CGPoint)origin maxWidth:(CGFloat)width font:(UIFont*)font text:(NSString*)text
{
    CGSize maxSize = CGSizeMake(width, 2000);
    CGSize size = [self calculateSizeWithText:text maxSize:maxSize font:font];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
    label.font = font;
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = text;
    
    return label;
}

#pragma mark - UIButton

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)calculateSizeWithText:(NSString*)text maxSize:(CGSize)maxSize font:(UIFont*)font
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dict
                                     context:nil].size;
    return size;
}

#pragma mark -request method

-(UIImage*)loadLocationImage:(NSString*)urlstr
{
    if(!urlstr)
        return nil;
    
    NSArray* array = [urlstr componentsSeparatedByString:@"/"];
    NSString* filename = [array lastObject];
    
    return [ASFileManager loadImageWithFileName:filename];
}

-(void)saveImage:(UIImage*)image Url:(NSString*)urlstr
{
    NSArray* array = [urlstr componentsSeparatedByString:@"/"];
    NSString* filename = [array lastObject];
    [ASFileManager saveImage:image FileName:filename];
}

@end
