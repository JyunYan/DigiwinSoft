//
//  MRouletteViewController.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRouletteViewController.h"
#import "RVCollectionViewCell.h"
#import "RVCollectionViewLayout.h"
#import "MConfig.h"
@interface MRouletteViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * mCollection;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) NSMutableArray * imageNamesArray;
@property (nonatomic, strong) RVCollectionViewLayout * collectionViewLayout;
@end

@implementation MRouletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Roulette";
    
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64.-49.)];
    backgroundImageView.image=[UIImage imageNamed:@"bg_status.png"];
    [self.view addSubview:backgroundImageView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createRoulett];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createRoulett
{
    
    RVCollectionViewLayout* flowLayout = [[RVCollectionViewLayout alloc]init];
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _mCollection=[[UICollectionView alloc]initWithFrame:CGRectMake(1, 85,DEVICE_SCREEN_WIDTH-2,150) collectionViewLayout:flowLayout];
    _mCollection.delegate=self;
    _mCollection.dataSource=self;
    _mCollection.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [_mCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemIdentifier"];
    _mCollection.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _mCollection.showsHorizontalScrollIndicator = NO;
    _mCollection.showsVerticalScrollIndicator = NO;
    _mCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_mCollection];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (RVCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ItemIdentifier" forIndexPath:indexPath];
    //cell.imageView = self.imagesArray[indexPath.item];
    //cell.imageName = self.imageNamesArray[indexPath.item];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // implement your cell selected logic here
    UIImageView * selectedImageView = self.imagesArray[indexPath.item];
    NSLog(@"selected image: %@", selectedImageView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating...");
    [self printCurrentCard];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate){
        NSLog(@"scrollViewDidEndDragging...");
        [self printCurrentCard];
    }
}

- (void)printCurrentCard{
    NSArray * visibleCards = _mCollection.visibleCells;
    [visibleCards enumerateObjectsUsingBlock:^(RVCollectionViewCell * visibleCell, NSUInteger idx, BOOL *stop) {
//        NSLog(@"visible cell: %@", visibleCell.imageName);
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVICE_SCREEN_WIDTH - 20)/3., 80.);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.;
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
