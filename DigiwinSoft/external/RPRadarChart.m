//
//  RPRadarChart.m
//  RadarChart
//
//                       Radar Chart
//
//
//  Created by Juan Pablo Illanes Sotta (@raspum) on 06-06-12.
//  Copyright (c) 2012 Juan Pablo Illanes Sotta. All rights reserved.
//
//  Enhanced by Wonil Kim (@wonkim99) 10-18-12
//   - Use data source to resolve data/color randomly matching issue
//   - Implement simple line touch detection feature

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

//----------------
//
//          Simple RadrChart that displays the data containded in
//  NSDictionary. Expects Keys to be the Var Name (Edge Label) and the 
//  Object to be an NSNumber with float values.
//
//--------------- 
#define RADAR_CHART_WIDTH 200
#define RADAR_CHART_HEIGHT 200
#import <float.h>
#import <QuartzCore/CALayer.h>
#import "RPRadarChart.h"
#import <QuartzCore/QuartzCore.h>
#define clickTo    @"clickTo"
#define kClickScroll    @"clickScroll"

@interface RPRadarChart ()

@property (nonatomic, strong) NSMutableArray* spokeButtons;

-(void) drawChartInContext:(CGContextRef) cx forIndex:(NSInteger)index;

@end

@implementation RPRadarChart
{
    NSMutableArray *paths;
    NSMutableArray *colors;
    CGAffineTransform transform;
    CGContextRef bitmapCtx;
    char *scanWindow;
}

@synthesize backLineWidth, frontLineWidth, lineColor, fillColor, dotColor, dotRadius, drawGuideLines,showGuideNumbers, showValues, fillArea, guideLineSteps, dataSource, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        maxSize = MIN(frame.size.width, frame.size.height) / 2. * 0.6;
        backLineWidth = 1.0f;
        frontLineWidth = 2.0f;
        dotRadius = 3;
        guideLineSteps = 4;
        drawGuideLines = YES;
        showGuideNumbers = YES;
        showValues = YES;
        fillArea = YES;
        lineColor = [UIColor whiteColor];
        dotColor = [UIColor redColor];
        fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
        
        _spokeButtons = [NSMutableArray new];
        
        _currentSpokeIndex = -1;
    }
    return self;
}

#define SCAN_WINDOW_WIDTH   12
#define SCAN_WINDOW_HEIGHT  12

typedef struct {
    unsigned char r, g, b;
} RGB;

static double colorDistance(RGB e1, RGB e2)
{
    long rmean = ( (long)e1.r + (long)e2.r ) / 2;
    long r = (long)e1.r - (long)e2.r;
    long g = (long)e1.g - (long)e2.g;
    long b = (long)e1.b - (long)e2.b;
    return sqrt((((512+rmean)*r*r)>>8) + 4*g*g + (((767-rmean)*b*b)>>8));
}

- (BOOL)color:(UIColor*)aColor inScanWindow:(unsigned char*)window
{
    const size_t pixelBytes = CGBitmapContextGetBitsPerPixel(bitmapCtx) / 8;
    const size_t scanRowBytes = pixelBytes * SCAN_WINDOW_WIDTH;
    
    for (int y = 0; y < SCAN_WINDOW_HEIGHT; y++) {
        for (int x = 0; x < SCAN_WINDOW_WIDTH; x++) {
            unsigned char *pixel = window + (x * pixelBytes) + (y * scanRowBytes);
            unsigned int r = pixel[1];
            unsigned int g = pixel[2];
            unsigned int b = pixel[3];
            float tr, tg, tb, ta;
            [aColor getRed:&tr green:&tg blue:&tb alpha:&ta];
            
            RGB c1 = {r, g, b};
            RGB c2 = {(int)(tr*255), (int)(tg*255), (int)(tb*255)};
            if (colorDistance(c1, c2) < 10) {
                return YES;
            }
        }
    }
    
    return NO;
}

// get scan window data pointer
- (char*)getScanWindowAtPoint:(CGPoint)point
{
    const char *data = CGBitmapContextGetData(bitmapCtx);
    const size_t height = CGBitmapContextGetHeight(bitmapCtx);
    const size_t pixelBytes = CGBitmapContextGetBitsPerPixel(bitmapCtx) / 8;
    const size_t rowBytes = CGBitmapContextGetBytesPerRow(bitmapCtx);
    const size_t scanRowBytes = pixelBytes * SCAN_WINDOW_WIDTH;
    
    if (scanWindow == NULL) {
        scanWindow = malloc(scanRowBytes * SCAN_WINDOW_HEIGHT);
    }
    
    const int x = (int)point.x - (SCAN_WINDOW_WIDTH/2);
    int y = (int)point.y - (SCAN_WINDOW_HEIGHT/2);
    // convery y position to internal buffer position
    y = height - y - 1;
    
    for (unsigned int i = 0; i < SCAN_WINDOW_HEIGHT; i++) {
        memcpy(scanWindow + i * scanRowBytes, data + (x * pixelBytes) + ((y - i) * rowBytes), scanRowBytes);
    }
    
    return scanWindow;
}

// Move rect to the other position to make it fit into screen
- (CGRect)fitIntoScreenRect:(CGRect)rect
{
    float newX = rect.origin.x;
    float newY = rect.origin.y;
    CGRect boundary = self.frame;
    if (rect.origin.x + rect.size.width > boundary.size.width) {
        newX = (boundary.size.width - rect.size.width);
    }
    if (rect.origin.y + rect.size.height > boundary.size.height) {
        newY = (boundary.size.height - rect.size.height);
    }
    return CGRectMake(newX, newY, rect.size.width, rect.size.height);
}

// calibrate touch point x, y to make it recognisable as touch for line
- (CGPoint)calibratePointForBetterTouch:(CGPoint)point
{
    const NSInteger diff = 10;
    const NSInteger centerX = 0;
    const NSInteger centerY = 0;
    
    CGPoint calibratedPoint = point;
    
    if (point.x < centerX) {
        if (point.y < centerY) {
            calibratedPoint.x = point.x + diff;
            calibratedPoint.y = point.y + diff;
        } else {
            calibratedPoint.x = point.x + diff;
            calibratedPoint.y = point.y - diff;
        }
    } else {
        if (point.y < centerY) {
            calibratedPoint.x = point.x - diff;
            calibratedPoint.y = point.y + diff;
        } else {
            calibratedPoint.x = point.x - diff;
            calibratedPoint.y = point.y - diff;
        }
    }
    
    return calibratedPoint;
}

// check about tap gesture and shows detail information if needed
- (void)handleSingleTap:(UITapGestureRecognizer*)sender
{
    NSInteger pathIndex = 0;
    bool touched = false;
    const CGPoint point = [sender locationInView:self];
    const CGPoint pointForPath = CGPointMake(point.x - self.frame.size.width/2, point.y - self.frame.size.height/2);
    
    NSLog(@"Tap point (%f, %f)", point.x, point.y);
    
    UIColor *color;
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (NSValue *value in paths) {
            CGMutablePathRef path = [value pointerValue];
            if (true == CGPathContainsPoint(path, nil, pointForPath, false) ||
                true == CGPathContainsPoint(path, nil, [self calibratePointForBetterTouch:pointForPath], false)) {
                char *window = [self getScanWindowAtPoint:point];
                color = [colors objectAtIndex:pathIndex];
                if (YES == [self color:(UIColor*)color inScanWindow:(unsigned char*)window]) {
                    NSLog(@"Path %d touched", pathIndex);
                    touched = true;
                    break;
                }
                color = nil;
            }
            pathIndex++;
        }
    }
    
    if (touched) {
        [delegate radarChart:self lineTouchedForData:pathIndex atPosition:point];
    }
}

// Release old paths stored in paths array
- (void)releaseOldPaths
{
    if (paths) {
        for (NSValue *value in paths) {
            CGMutablePathRef path = [value pointerValue];
            CGPathRelease(path);
            path = nil;
        }
        paths = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self clean];
    
    if (self.dataSource == nil) {
        NSLog(@"No data source for radar chart");
        return;
    }
    
    if (bitmapCtx == nil) {
        CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
        bitmapCtx = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, rect.size.width * 4, colorRef, kCGImageAlphaPremultipliedFirst);
    } else {
        CGContextClearRect(bitmapCtx, rect);
    }
    
    UIGraphicsPushContext(bitmapCtx);
    CGContextSaveGState(bitmapCtx);
    CGContextTranslateCTM(bitmapCtx, rect.size.width / 2, rect.size.height / 2);
    
    
    maxValue = [dataSource maximumValueInRadarChart:self];
    
    const NSInteger dataCounts = [self.dataSource numberOfDatasInRadarChart:self];
    paths = [NSMutableArray arrayWithCapacity:dataCounts];
    colors = [NSMutableArray arrayWithCapacity:dataCounts];
    
    //實心圓
    [self drawBaseBackGroundInContext:bitmapCtx];
    
    //多角形
    for (int i=0; i < dataCounts; i++) {
        [self drawChartInContext:bitmapCtx forIndex:i];
    }
    
    //圓邊線&輻射線
    [self drawBackGroundInContext:bitmapCtx];
    [self releaseOldPaths];
    
    // draw bitmap to screen context and pop the previous context
    CGImageRef imgRef = CGBitmapContextCreateImage(bitmapCtx);
    UIGraphicsPopContext();
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imgRef);
    CGImageRelease(imgRef);
    
    CGContextRestoreGState(bitmapCtx);
}

-(void) drawChartInContext:(CGContextRef) cx forIndex:(NSInteger)index
{
    CGContextSetLineWidth(cx, frontLineWidth);
    
    // NSDictionary *d = (key == nil) ? values : [values objectForKey:key] ;
    const NSInteger numberOfSpokes = [dataSource numberOfSopkesInRadarChart:self];
    UIColor *flColor = fillColor;
    UIColor *stColor = lineColor;
    UIColor *dtColor = dotColor;
    
    stColor = dtColor = [dataSource radarChart:self colorForData:index];
    flColor = [dtColor colorWithAlphaComponent:0.5];
    [colors setObject:stColor atIndexedSubscript:index];
    
    float mvr = (2*M_PI) / numberOfSpokes;
    float fx =0;
    float fy =0;
    int mi = 0;
    
    //DRAW LINES (多角形區域)
    CGContextSetAllowsAntialiasing(cx, true);
    CGMutablePathRef path = CGPathCreateMutable();
    [paths addObject:[NSValue valueWithPointer:path]];
    
    for (int spoke=0; spoke < numberOfSpokes; spoke++) {
        float orgValue = [dataSource radarChart:self valueForData:index forSpoke:spoke];
        float v = (orgValue / maxValue) * maxSize;
        float a = (mvr * mi) - M_PI_2;
        float x = v * cos(a);
        float y = v * sin(a);
        
        if(fx == 0 && fy == 0) {
            CGPathMoveToPoint(path, NULL, x, y);
            fx = x;
            fy = y;
        } else {
            CGPathAddLineToPoint(path, NULL, x,  y);
        }
        mi++;
    }
    CGPathAddLineToPoint(path, NULL, fx, fy);
    CGContextAddPath(cx, path);
    if (fillArea) {
        CGContextSetFillColorWithColor(cx, flColor.CGColor);
        CGContextFillPath(cx);
    }
    CGContextSetStrokeColorWithColor(cx, stColor.CGColor);
    CGContextAddPath(cx, path);
    CGContextStrokePath(cx);
    CGContextSetAllowsAntialiasing(cx, true);
    
    // DRAW VALUES (多角形每個點的值)
    mi= 0;
    for (int spoke=0; spoke < numberOfSpokes; spoke++) {
        float orgValue = [dataSource radarChart:self valueForData:index forSpoke:spoke];
        float v = (orgValue / maxValue) * maxSize;
        float a = (mvr * mi) - M_PI_2;
        float x = v * cos(a);
        float y = v * sin(a);
        
        CGContextSetFillColorWithColor(cx, dtColor.CGColor);
        CGContextFillEllipseInRect(cx, CGRectMake(x-dotRadius, y-dotRadius, dotRadius*2, dotRadius*2));
        if (showValues) {
            NSString *str = [NSString stringWithFormat:@"%1.0f", orgValue];
            x += 5;
            y -= 7;
            CGContextSetFillColorWithColor(cx, [UIColor blackColor].CGColor);
            [str drawAtPoint:CGPointMake(x, y) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        }
        mi++;
    }
    CGContextMoveToPoint(cx, 0, 0);
    
}

-(void) drawBackGroundInContext:(CGContextRef) cx
{
    CGContextSetLineWidth(cx, backLineWidth);
    
    const NSInteger numberOfSpokes = [dataSource numberOfSopkesInRadarChart:self];
    
    float mvr = (2 * M_PI) / numberOfSpokes;
    float spcr = maxSize / guideLineSteps;
    
    
    
    //Index Lines (空心同心圓)
    if (drawGuideLines) {
        CGContextSetStrokeColorWithColor(cx, [UIColor whiteColor].CGColor);
        for (int j = 0; j <= guideLineSteps; j++) {
            float cur = j*spcr;
            CGContextStrokeEllipseInRect(cx, CGRectMake(-cur, -cur, cur*2, cur*2));
        }
        CGContextStrokePath(cx);
    }
    
    //Base lines (輻射線)
    CGContextSetStrokeColorWithColor(cx, [UIColor whiteColor].CGColor);
    for (int i = 0; i < numberOfSpokes; i++) {
        float a = (mvr * i) - M_PI_2;
        float x = maxSize * cos(a);
        float y = maxSize * sin(a);
        CGContextMoveToPoint(cx, 0, 0);
        CGContextAddLineToPoint(cx, x , y);
        
        CGContextStrokePath(cx);
        
        /*
        NSString *tx = [dataSource radarChart:self titleForSpoke:i];
        CGSize s =[tx sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        x -= s.width/2;
        x += 5;
        y += (y>0) ? 10 : -20;
        CGContextSetFillColorWithColor(cx, [UIColor whiteColor].CGColor);
        [tx drawAtPoint:CGPointMake(x, y) withFont: [UIFont fontWithName:@"Helvetica-Bold" size:11]];
         */
        
        //製作外圍按鍵
        x = (maxSize*1.7) * cos(a); //正弦，更改後面加上的常數，可調整標籤靠近圓的距離
        y = (maxSize*1.3) * sin(a); //餘弦，更改後面加上的常數，可調整標籤靠近圓的距離
        
        CGPoint center = CGPointMake(x + self.frame.size.width/2., y + self.frame.size.height/2.);
        NSString* title = [dataSource radarChart:self titleForSpoke:i];
        UIButton* button = [self createSpokeButtonWithCenter:center size:CGSizeMake(maxSize*0.85, maxSize*0.46) title:title tag:i];
        [self addSubview:button];
        [_spokeButtons addObject:button];
    }
    
    [self setSpokeButtonSelected];
    
    //Index Texts
    if (showGuideNumbers) {
        for(float i = spcr; i <= maxSize; i+=spcr)
        {
            NSString *str = [NSString stringWithFormat:@"%1.0f",( i * maxValue) / maxSize];
            CGSize s = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
            float x = i * cos(M_PI_2) + 5 + s.width;
            float y = i * sin(M_PI_2) + 5;
            CGContextSetFillColorWithColor(cx, [UIColor darkGrayColor].CGColor);
            [str drawAtPoint:CGPointMake(- x, - y) withFont: [UIFont fontWithName:@"Helvetica" size:11]];
        }
    }
    CGContextMoveToPoint(cx, 0, 0);
    
}

-(void) drawBaseBackGroundInContext:(CGContextRef) cx
{
    //實心圓
    CGContextSetFillColorWithColor(cx, [UIColor colorWithRed:212.0/255.0 green:219.0/255.0 blue:227.0/255.0 alpha:1.].CGColor);
    CGContextAddArc(cx, 0, 0, maxSize, 0, M_PI*2, 0);
    CGContextFillPath(cx);
}

- (UIButton*)createSpokeButtonWithCenter:(CGPoint)center size:(CGSize)size title:(NSString*)title tag:(NSInteger)tag
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    button.center = center;
    button.tag = tag;
    button.backgroundColor=[UIColor whiteColor];
    button.titleLabel.numberOfLines=2;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"rect_white.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"rect_blue.png"] forState:UIControlStateSelected];
    //[[button layer] setCornerRadius:8.0]; //设置矩圆角半径
    //[[button layer] setBorderWidth:2.0f];
    //[[button layer] setBorderColor:[UIColor colorWithRed:140.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor];
    
    [button addTarget:self action:@selector(btnTitilClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    [_spokeButtons removeAllObjects];
}


#pragma mark - spoke button methods

- (void)btnTitilClick:(id)sender
{
    //1為p9使用，按下lab時push to p8。0為p7使用，按下lab時滾動下方scroll。
    
    UIButton* button = (UIButton*)sender;
    
    if(delegate && [delegate respondsToSelector:@selector(radarChart:didSelectedSpokeWithIndx:)]){
       
        _currentSpokeIndex = button.tag;
        [self setSpokeButtonSelected];
        [delegate radarChart:self didSelectedSpokeWithIndx:button.tag];
    }
}

- (void)setSpokeButtonSelected
{
    for (int i=0; i<_spokeButtons.count; i++) {
        UIButton* button = [_spokeButtons objectAtIndex:i];
        if(i == _currentSpokeIndex){
            //selected
            [button setSelected:YES];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [[button layer] setBorderColor:[UIColor colorWithRed:140.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor];
//            [button setBackgroundColor:[UIColor colorWithRed:140.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0]];
        }else{
            //unselected
            [button setSelected:NO];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [[button layer] setBorderColor:[UIColor colorWithRed:140.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor];
//            button.backgroundColor=[UIColor whiteColor];
        }
    }
}

#pragma mark - Setters

- (void)setCurrentSpokeIndex:(NSInteger)currentSpokeIndex
{
    _currentSpokeIndex = currentSpokeIndex;
    [self setSpokeButtonSelected];
}

-(void) setLineColor:(UIColor *)v
{ 
    lineColor = v;
    [self setNeedsDisplay];
    
}

-(void) setFillColor:(UIColor *)v
{ 
    fillColor = v;
    [self setNeedsDisplay];
    
}
-(void) setBackLineWidth:(float)v
{ 
    backLineWidth = v;
    [self setNeedsDisplay];    
}

-(void) setFrontLineWidth:(float)v
{ 
    frontLineWidth = v;
    [self setNeedsDisplay];    
}

-(void) setDotColor:(UIColor *)v
{ 
    dotColor = v;
    [self setNeedsDisplay];    
}

-(void) setDotRadius:(float) v
{ 
    dotRadius = v;
    [self setNeedsDisplay];    
}

-(void) setShowValues:(BOOL)v
{
    showValues = v;
    [self setNeedsDisplay];
}

-(void) setFillArea:(BOOL)v
{
    fillArea = v;
    [self setNeedsDisplay];
}

-(void) setDrawGuideLines:(BOOL)v
{
    drawGuideLines = v;
    [self setNeedsDisplay];
}

-(void) setGuideLineSteps:(NSInteger)v
{
    guideLineSteps = v;
    [self setNeedsDisplay];
}

-(void) setShowGuideNumbers:(BOOL)v
{
    showGuideNumbers = v;
    [self setNeedsDisplay];
}

-(void)dealloc
{
    CGContextRelease(bitmapCtx);
    if (scanWindow) free(scanWindow);
    scanWindow = NULL;
}

@end
