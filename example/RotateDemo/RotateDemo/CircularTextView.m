
#include <math.h>
static inline double radians (double degrees) {return degrees * M_PI/180;}


#import "CircularTextView.h"


#pragma mark -


@interface CircularTextView ()


@property (nonatomic) float currentDegree;

@property (nonatomic) CGPoint lastTranslate;

@property (nonatomic) int sectionCount;

@end



@implementation CircularTextView



-(id) initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame])
    {
        //
        self.backgroundColor = [UIColor clearColor];
    
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPan:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}




- (void)actionTap:(UITapGestureRecognizer*)sender {
    
    
    if( !self.deleagte)
        return;
    
    UIView *view = sender.view;
    if (sender.state==UIGestureRecognizerStateEnded)
    {
        /*
        CGPoint point = [sender locationInView:self];
        
        CGPoint center = CGPointMake( self.frame.size.width * 0.5f,  self.frame.size.height * 0.5f);
    
        float x = point.x - center.x;
        float y = -(point.y - center.y);
        
        float r = atan2f(x, y);
        
        float degree = r * 180 / M_PI;
        
        if( degree < 0)
            degree += 360.0f;
        
        NSLog(@"degree = %f", degree);
        
        
        int section_count = [self.deleagte numberOfSectionsInTextView:self];
        
        float section_angle = 360.0f / section_count;
        float half_section_angle = 0.5f * section_angle;
        
        int n = (degree - 0.5f * section_angle ) / section_angle;
        n++;
        if( degree < half_section_angle || degree >= (360.0f - half_section_angle))
        {
            n = 0;
        }
        
        
        NSLog(@"n = %d", n);
        
        [self.deleagte textView:self clickSectionAtIndex:n];
        */
        
    }
    
    
    
    int stop = 0;
    stop++;
    
}

- (void)actionPan:(UIPanGestureRecognizer *)recognizer;
{
    
    if( !self.deleagte)
        return;
    
    static CGPoint lastTranslate;   // the last value
    
    CGPoint translate = [recognizer translationInView:self];
    
    NSLog(@"traslate x = %f  translate y = %f", translate.x, translate.y);
    
    CGPoint point = [recognizer locationInView:self];
    //CGPoint center = CGPointMake( self.frame.size.width * 0.5f,  self.frame.size.height * 0.5f);
    float half_height = self.frame.size.height * 0.5f;
    float half_width = self.frame.size.width * 0.5f;
    //X
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        
        self.lastTranslate = translate;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        //X 偏移
        
        float dx = translate.x - lastTranslate.x;
        float dy = translate.y - lastTranslate.y;
        
        if( fabs(dx) > half_width * 0.4f)
        {
            if( dx > 0)
                dx = half_width * 0.4f;
            else
                dx = half_width * -0.4f;
        }
        if( fabs(dy) > half_height * 0.4f)
        {
            if( dy > 0)
                dy = half_height * 0.4f;
            else
                dy = half_height * -0.4f;
        }
        NSLog(@"dx = %f  dy = %f ", dx, dy);
        
        
        
        float r = atan2f(dx, half_height);
        float degree_x = r * 180 / M_PI;
        
        if( point.y < half_height)
        {
            self.currentDegree += degree_x;
        }
        else
        {
            self.currentDegree -= degree_x;
        }
        
        r = atan2f(dy , half_width);
        float degree_y = r * 180 / M_PI;
        
        if( point.x > half_width)
        {
            self.currentDegree += degree_y;
        }
        else
        {
            self.currentDegree -= degree_y;
        }
        
        self.lastTranslate = translate;
        
        NSLog(@"degree_x = %f  degree_y = %f  current_degree = %f", degree_x, degree_y, self.currentDegree);
        
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        self.transform = CGAffineTransformMakeRotation(radians(self.currentDegree));
        [UIView commitAnimations];
        //[self moveSubviewsBy:translate];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        
        //normalize degree
        if( self.currentDegree > 0)
        {
            int n = self.currentDegree / 360.0f;
            float n_degree = self.currentDegree - n * 360.0f;
            self.currentDegree = n_degree;
        }
        else
        {
            float n_degree = self.currentDegree + 360.0f;
            self.currentDegree = n_degree;
        }
        int section_count = [self.deleagte numberOfSectionsInTextView:self];
        //
        float section_angle = 360.0f / section_count;
        float half_section_angle = 0.5f * section_angle;
        
        int n = (self.currentDegree - 0.5f * section_angle ) / section_angle;
        n++;
        if( self.currentDegree < half_section_angle || self.currentDegree >= (360.0f - half_section_angle))
        {
            n = 0;
        }
        
        int actual_n = section_count - n;
        if( actual_n == section_count)
            actual_n = 0;
        
        NSLog(@"actual_n = %d", actual_n);
        
        [self.deleagte textView:self finishPanAtIndex:actual_n];
    }
    
    
}


- (void)_drawLabel:(NSString *)label withFont:(UIFont *)font forWidth:(CGFloat)width
           atPoint:(CGPoint)point withAlignment:(NSTextAlignment)alignment color:(UIColor *)color angle:(float) angle
{
    // obtain current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save context state first
    CGContextSaveGState(context);
    
    CGPoint center = CGPointMake( self.frame.size.width * 0.5f,  self.frame.size.height * 0.5f);
    
    CGContextTranslateCTM (context, center.x, center.y);
    
    CGContextRotateCTM (context, radians(angle));
    
    
    
    // obtain size of drawn label
    //CGSize size = [label sizeWithFont:font
    //                         forWidth:width
    //                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect = [label boundingRectWithSize:maximumLabelSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
    
    rect.origin.x = point.x - rect.size.width * 0.5f;
    rect.origin.y = point.y;
    
    
    // set text color in context
    CGContextSetFillColorWithColor(context, color.CGColor);
        
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = alignment;
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: color
                                  };
    [label drawInRect:rect withAttributes:attributes];
    
    
    // restore context state
    CGContextRestoreGState(context);
}

-(void)drawInContext:(CGContextRef)context
{
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    
    //CGPoint center = CGPointMake( self.frame.size.width * 0.5f,  self.frame.size.height * 0.5f);
    CGFloat half_height = self.frame.size.height * 0.5f;
    
    
    if( !self.deleagte)
        return;
    
    int count = [self.deleagte numberOfSectionsInTextView:self];
    
    for(int i = 0; i < count; i++)
    {
        float angle = i * 360.0 / count;
        NSString* section = [self.deleagte secionTitleInTextView:self index:i];
        [self _drawLabel:section withFont:[UIFont systemFontOfSize:12] forWidth:50 atPoint:CGPointMake(0,-1 * half_height) withAlignment:NSTextAlignmentCenter color:[UIColor blackColor] angle: angle];
    }
    
    /*
    [self _drawLabel:@"AAAA12345" withFont:[UIFont systemFontOfSize:14] forWidth:50 atPoint:CGPointMake(0,-1 * half_height) withAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] angle:0];
    [self _drawLabel:@"BBB" withFont:[UIFont systemFontOfSize:14] forWidth:100 atPoint:CGPointMake(0,-1 * half_height) withAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] angle:45];
    [self _drawLabel:@"CCCC" withFont:[UIFont systemFontOfSize:14] forWidth:100 atPoint:CGPointMake(0,-1 * half_height) withAlignment:NSTextAlignmentCenter color:[UIColor whiteColor] angle:90];
    */
    
    
}

-(void) reloadData{
    
    [self setNeedsDisplay];
}


@end