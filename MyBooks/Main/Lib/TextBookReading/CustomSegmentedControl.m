//
//  CustomSegmentedControl.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentedControl.h"
@implementation CustomSegmentedControlImages
@synthesize defualtImagePath,checkImagePath;
+ (id)initWithImages:(NSString*)InputdefualtImagePath CheckImagePath:(NSString*)InputcheckImagePath{
    CustomSegmentedControlImages *seg=[[[CustomSegmentedControlImages alloc] init] autorelease];
    if (seg) {
        seg.defualtImagePath=InputdefualtImagePath;
        seg.checkImagePath=InputcheckImagePath;
    }
    return seg;
}
-(void)dealloc{
    [defualtImagePath release];
    [checkImagePath release];
    [super dealloc];
}
@end
@implementation CustomSegmentedControl
@synthesize delegate;
@synthesize ImageItems;
-(void)dealloc{
    self.ImageItems=nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame items:(NSArray*)buttonImageItems
{
    self = [super initWithFrame:frame];
    if (self) {
        selectedSegmentIndex=0; 
        self.backgroundColor=[UIColor clearColor];
        [self ADDitems:buttonImageItems];
    }
    return self;
}
- (void)ADDitems:(NSArray*)buttonImageItems{
    
    self.ImageItems=buttonImageItems;
   
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];  
    }
    for (int i=0; i<[buttonImageItems count]; i++) {
        if ([[buttonImageItems objectAtIndex:i] isKindOfClass:[CustomSegmentedControlImages class]]) {
            CustomSegmentedControlImages *img=(CustomSegmentedControlImages *)[buttonImageItems objectAtIndex:i];
            UIButton *btn=[UIButton buttonWithType: UIButtonTypeCustom];
            if (i==selectedSegmentIndex) {
                [btn setImage:[UIImage imagefileNamed:img.checkImagePath ] forState:0];
            }else {
                [btn setImage:[UIImage imagefileNamed:img.defualtImagePath ] forState:0];
            }
            btn.frame=CGRectMake(i*self.frame.size.width/[buttonImageItems count], 0, self.frame.size.width/[buttonImageItems count] , self.frame.size.height);
            [btn addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown]; 
            btn.tag=100000+i;
            [self addSubview:btn];
        }
    }
}
-(void)setSelectedSegmentIndex:(NSInteger)selectedsegmentindex{
    if (selectedsegmentindex!=selectedSegmentIndex) {
        selectedSegmentIndex=selectedsegmentindex;
     
        for (int i=0; i<[ImageItems count]; i++) {
            if ([[ImageItems objectAtIndex:i] isKindOfClass:[CustomSegmentedControlImages class]]) {
                CustomSegmentedControlImages *img=(CustomSegmentedControlImages *)[ImageItems objectAtIndex:i];
                UIButton *btn=(UIButton *)[self viewWithTag:i+100000];
                if (i==selectedSegmentIndex) {
                    [btn setImage:[UIImage imagefileNamed:img.checkImagePath ] forState:0];
                }else {
                    [btn setImage:[UIImage imagefileNamed:img.defualtImagePath ] forState:0];
                }
            }
        }
    }
}
-(NSInteger)selectedSegmentIndex{
    return selectedSegmentIndex;
}
- (void)touchDownAction:(UIButton *)button {  
    NSInteger selectedsegmentindex=button.tag-100000;
    if (selectedsegmentindex!=selectedSegmentIndex) {
    [self setSelectedSegmentIndex:selectedsegmentindex] ;
   if ([(NSObject*)delegate respondsToSelector:@selector(SelectIndexChangedForCustomSegmentedControl:)])  
   {
       [self.delegate SelectIndexChangedForCustomSegmentedControl:selectedSegmentIndex];
   }
    }
}

@end
