//
//  RVCollectionViewLayout.m
//  RouletteViewDemo
//
//  Created by Kenny Tang on 3/16/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "RVCollectionViewLayout.h"
#import "RVCollectionViewCell.h"
#import "MConfig.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation RVCollectionViewLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(100.0f, 153.0f);
    self.sectionInset = UIEdgeInsetsMake(0, 70, 0, 60);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.itemSize = CGSizeMake(100.0f, 153.0f);
        self.sectionInset = UIEdgeInsetsMake(0, 60, 0, 60);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    self.superView = self.collectionView.superview;
}
/**
This method is called by UICollectionView for laying out cells in the visible rect.
 */

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray * modifiedLayoutAttributesArray = [NSMutableArray array];
    //寬度中間
    CGFloat horizontalCenter = (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * layoutAttributes, NSUInteger idx, BOOL *stop) {
        
        CGPoint pointInCollectionView = layoutAttributes.frame.origin;
        CGPoint pointInMainView = [self.superView convertPoint:pointInCollectionView fromView:self.collectionView];
        
//        NSLog(@"pointInMainView:%@",NSStringFromCGPoint(pointInMainView));
        
        CGPoint centerInCollectionView = layoutAttributes.center;
        CGPoint centerInMainView = [self.superView convertPoint:centerInCollectionView fromView:self.collectionView];
        
//        NSLog(@"centerInMainView:%@",NSStringFromCGPoint(centerInMainView));

        float rotateBy = 0.0f;
        CGPoint translateBy = CGPointZero;
        
        // we find out where this cell is relative to the center of the viewport, and invoke private methods to deduce the
        // amount of rotation to apply找到中心，算出旋轉量
        
        NSLog(@"collectionView.frame.size.width:%f",self.collectionView.frame.size.width);
        
        if (pointInMainView.x < self.collectionView.frame.size.width){
            
            NSLog(@"layoutAttributes:%@",layoutAttributes);
            
            translateBy = [self calculateTranslateBy:horizontalCenter attribs:layoutAttributes];
            rotateBy = [self calculateRotationFromViewPortDistance:pointInMainView.x center:horizontalCenter];
            
            //中心
            CGPoint rotationPoint = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height);
            
            
            // there are two transforms and one rotation. this is needed to make the view appear to have rotated around
            // a certain point.做兩次變換一次旋轉，做出繞著一個點旋轉的效果
            
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DTranslate(transform, rotationPoint.x - centerInMainView.x, rotationPoint.y - centerInMainView.y-0, -1.0);
            
            //(后面3个 数字分别代表不同的轴来翻转)
            transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-rotateBy), 0.0, 0.0, -1.0);
            
            
            // -30.0f to lift the cards up a bit 可調整整個圓的xyz
            transform = CATransform3DTranslate(transform, centerInMainView.x - rotationPoint.x+45, centerInMainView.y-rotationPoint.y-0.0f, 0.0);
            
            
//            transform = CATransform3DTranslate(transform, 0, 0, -240);
//            transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-rotateBy), 1, 0, 0);
//            transform = CATransform3DTranslate(transform, 0, 0, 240);
            
            layoutAttributes.transform3D = transform;
            
            
            // right card is always on top牌面圖層重疊調整。(原API用途，我們應該用不到)
            layoutAttributes.zIndex = layoutAttributes.indexPath.item;
            
            [modifiedLayoutAttributesArray addObject:layoutAttributes];
        }
    }];
    return modifiedLayoutAttributesArray;
}


/*
 Linear equation for translating one range to another
 */
- (float)remapNumbersToRange:(float)inputNumber fromMin:(float)fromMin fromMax:(float)fromMax toMin:(float)toMin toMax:(float)toMax {
    return (inputNumber - fromMin) / (fromMax - fromMin) * (toMax - toMin) + toMin;
}


-(CGPoint)calculateTranslateBy:(CGFloat)horizontalCenter attribs:(UICollectionViewLayoutAttributes *) layoutAttributes{
    
    float translateByY = -layoutAttributes.frame.size.height/2.0f;
    float distanceFromCenter = layoutAttributes.center.x - horizontalCenter;
    float translateByX = 0.0f;
    
    if (distanceFromCenter < 1){
        translateByX = -1 * distanceFromCenter;
    }else{
        translateByX = -1 * distanceFromCenter;
    }
    return CGPointMake(distanceFromCenter, translateByY);
}


-(float)calculateRotationFromViewPortDistance:(float)x center:(float)horizontalCenter{
    
    //調整toMin,toMax即可調整左右消失的高度，有可能要依照螢幕大小做調整
    float rotateByDegrees = [self remapNumbersToRange:x fromMin:-122 fromMax:258 toMin:-25 toMax:25];
//    NSLog(@"%f",x);
    return rotateByDegrees;
}


/*
 http://stackoverflow.com/questions/13749401/stopping-the-scroll-in-a-uicollectionview
 */

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 1.4f);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x,
                                   0.0f, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat distanceFromCenter = layoutAttributes.center.x - horizontalCenter;
        if (ABS(distanceFromCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = distanceFromCenter;
        }
    }
    
    return CGPointMake(
                       proposedContentOffset.x + offsetAdjustment,
                       proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end

