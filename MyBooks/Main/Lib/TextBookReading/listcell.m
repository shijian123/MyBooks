//
//  listcell.m
//  BLReadEngineAl
//
//  Created by 3G 北邮 on 13-1-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "listcell.h"

@implementation listcell
@synthesize choosed;
@synthesize lab,index;
@synthesize daytimeline,nighttimeline;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  movde:(NSString*)divicemode  device:(NSString*)device
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
