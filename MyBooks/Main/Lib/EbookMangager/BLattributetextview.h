//
//  BLattributetextview.h
//  yanqing
//
//  Created by BLapple on 14-3-18.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface BLattributetextview : UIView
{
    float width;
    float height;
    CTFramesetterRef framesetter;
}
@property(retain,nonatomic)NSMutableAttributedString*attristring;
-(id)initWithFrame:(CGRect)frame width:(float)_width string:(NSMutableAttributedString*)attristring;

-(float)getheight;

@end
