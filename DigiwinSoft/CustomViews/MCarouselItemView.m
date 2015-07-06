//
//  MCarouselItemView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MCarouselItemView.h"

@implementation MCarouselItemView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGFloat radius = (_onFacus) ? 5. : 3.;
    CGPoint point = CGPointMake(self.frame.size.width / 2., 5.);
    UIFont* font = [UIFont boldSystemFontOfSize:_pointSize];
    UIColor* color = [UIColor colorWithWhite:1.f alpha:_alpha];
    
    // draw white circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddArc(context, point.x, point.y, radius, 0, 2 * M_PI, 1);
    CGContextFillPath(context);
    
    // draw string
    NSMutableArray* array = [NSMutableArray new];
    NSInteger index = 0;
    for (int i = 0; i < 2; index++) {
        
        if(_content.length - index > 10){
            NSString* string = [_content substringWithRange:NSMakeRange(index, 10)];
            [array addObject:string];
        }else{
            NSString* string = [_content substringWithRange:NSMakeRange(index, _content.length - index)];
            [array addObject:string];
        }
        
        index += 10;
        if(index >= _content.length)
            break;
    }
    
    
    CGFloat x = (self.bounds.size.width - _pointSize * array.count) / 2.;
    for (NSString* str in array) {
       // NSString* string = [self getContentWithString:str];
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName:font,
                                                                                     NSForegroundColorAttributeName:color,
                                                                    NSVerticalGlyphFormAttributeName:[NSNumber numberWithInt:1]}];
        [attString drawInRect:CGRectMake(x, self.bounds.origin.y + 15., _pointSize, self.bounds.size.height)];
        x+= _pointSize;
    }
}

- (void)setOnFacus:(BOOL)onFacus
{
    _onFacus = onFacus;
    if(onFacus){
        _pointSize = (DEVICE_SCREEN_HEIGHT == 480) ? 18. : 22.;
        _alpha = 1.;
    }else{
        _pointSize = 14.;
        _alpha = 1.;
    }
}

- (NSString*)getContentWithString:(NSString*)str
{
    NSMutableString* string = [[NSMutableString alloc] initWithString:@""];
    for(int i=0; i < str.length; i++){
        
        unichar ch = [str characterAtIndex:i];
        
        if(i == str.length - 1)
            [string appendFormat:@"%C", ch];
        else
            [string appendFormat:@"%C\n", ch];
    }
    return string;
}

@end
