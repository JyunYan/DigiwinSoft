//
//  ViewController.m
//  RotateDemo
//
//  Created by meowhoo on 2015/7/30.
//  Copyright (c) 2015年 amigosoft. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic) NSArray* sections;

@property (nonatomic) UILabel* sectionLabel;

@end

@implementation ViewController

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CircularTextView* text_view = [[CircularTextView alloc] initWithFrame:CGRectMake(20,20,400,400)];
    
    self.sections = [NSArray arrayWithObjects:@"AAAAA1234567",@"BBBBB", @"CCCCC", @"DDDDD", @"EEEEE", @"FFFFF", @"GGGGG", @"HHHHH", @"IIIII", @"JJJJJ", @"KKKKK", @"LLLLL", nil];
    
    text_view.deleagte = self;
    [self.view addSubview:text_view];
    
    self.sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,400,120,20)];
    [self.view addSubview:self.sectionLabel];
    
    //self.sectionLabel.text = @"lkfjnvslkdfjnvldksfjnv";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(int) numberOfSectionsInTextView:(CircularTextView*)textView
{
    return (int)self.sections.count;
}

-(NSString*) secionTitleInTextView:(CircularTextView*)textView index:(int)index
{
    NSString* s = self.sections[index];
    return s;
}


-(void) textView:(CircularTextView*) textView finishPanAtIndex:(NSInteger) index
{
    NSString* section = self.sections[index];
    NSLog(@"Section = %@", section);
    
    self.sectionLabel.text = section;
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
