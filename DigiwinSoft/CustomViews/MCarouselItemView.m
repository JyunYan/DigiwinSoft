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
    // Drawing code
    
    NSArray* array = [_content componentsSeparatedByString:@"，"];
    UIFont* font = [UIFont systemFontOfSize:_pointSize];
    UIColor* color = [UIColor colorWithWhite:1.f alpha:_alpha];
    //color = [UIColor colorWithRed:0. green:0. blue:0. alpha:_alpha];
    CGFloat x = (self.bounds.size.width - _pointSize * array.count) / 2.;
    
    for (NSString* str in array) {
       // NSString* string = [self getContentWithString:str];
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName:font,
                                                                                     NSForegroundColorAttributeName:color,
                                                                                     NSVerticalGlyphFormAttributeName:[NSNumber numberWithInt:1]}];
        [attString drawInRect:CGRectMake(x, self.bounds.origin.y, _pointSize, self.bounds.size.height)];
        x+= _pointSize;
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
