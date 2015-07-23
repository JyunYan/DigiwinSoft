//
//  MCircleLayout.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCircleLayout.h"

@interface MCircleLayout ()

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint center;

@end

@implementation MCircleLayout

-(void)prepareLayout
{   //和init相似，必须call super的prepareLayout以保证初始化正确
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MAX(size.width, size.height)/2;
}

//整个collectionView的内容大小就是collectionView的大小（没有滚动）
-(CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

//通过所在的indexPath确定位置。
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path]; //生成空白的attributes对象，其中只记录了类型是cell以及对应的位置是indexPath
    //配置attributes到圆周上
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * path.item * M_PI / _cellCount), _center.y + _radius * sinf(2 * path.item * M_PI / _cellCount));
    return attributes;
}

//用来在一开始给出一套UICollectionViewLayoutAttributes
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

//插入前，cell在圆心位置，全透明
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x, _center.y);
    return attributes;
}

//删除时，cell在圆心位置，全透明，且只有原来的1/10大
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x, _center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end
