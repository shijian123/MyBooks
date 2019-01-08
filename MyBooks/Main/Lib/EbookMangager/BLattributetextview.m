//
//  BLattributetextview.m
//  yanqing
//
//  Created by BLapple on 14-3-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BLattributetextview.h"

@implementation BLattributetextview
@synthesize attristring;
-(void)dealloc
{
    self.attristring=nil;
    CFRelease(framesetter);
    [super dealloc];
}

-(float)getheight
{
    return height;
}


-(id)initWithFrame:(CGRect)frame width:(float)_width string:(NSMutableAttributedString*)attristring
{

    self = [super init];
    if (self) {
        width=_width;
        self.userInteractionEnabled=NO;
        self.attristring=attristring;
        [self countself];
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
        self.backgroundColor=[UIColor clearColor];
        // Initialization code
    }
    return self;
}




- (void)countself{
//    int total_height = 0;
    
    framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attristring);    //string 为要计算高度的NSAttributedString

    CFRange range;
    
    CGSize tosize=  CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, CGFLOAT_MAX), &range);
  
    height=tosize.height;
    
 
    return;

}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    CGContextScaleCTM(context, 1.0 ,-1.0);

    CGRect drawingRect = CGRectMake(0, 0, width, self.frame.size.height);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
  
    CTFrameDraw(textFrame, context);
    CGPathRelease(path);

    if(textFrame!=NULL)
    {
        CFRelease(textFrame);
    }
}


@end
