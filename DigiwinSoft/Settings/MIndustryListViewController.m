//
//  MIndustryListViewController.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/9/4.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryListViewController.h"
#import "MDirector.h"
#import "MDataBaseManager.h"
#import "MIndustry.h"

@interface MIndustryListViewController ()

@property (nonatomic, strong) NSArray* industrys;

@end

@implementation MIndustryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _industrys = [[MDataBaseManager sharedInstance] loadIndustryArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 121.;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 121.)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120.)];
    label.backgroundColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = @"行業切換";
    [header addSubview:label];
    
    UIView* bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.tableView.frame.size.width, 1)];
    bottomline.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:bottomline];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _industrys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MIndustryListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        UIView* bgSelectionView = [[UIView alloc] init];
        bgSelectionView.backgroundColor = [UIColor colorWithRed:53.0f/255.0f green:166.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        bgSelectionView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgSelectionView;
        
        UIView* bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.tableView.frame.size.width, 1)];
        bottomline.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:bottomline];
    }
    
    MIndustry* industry = [_industrys objectAtIndex:indexPath.row];
    
    cell.textLabel.text = industry.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    MIndustry* industry = [_industrys objectAtIndex:indexPath.row];
    MIndustry* current = [MDirector sharedInstance].currentIndustry;
    
    if(![industry.uuid isEqualToString:current.uuid]){
        
    }
    [MDirector sharedInstance].currentIndustry = industry;
    [[NSNotificationCenter defaultCenter] postNotificationName:kIndustryDidChanged object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
