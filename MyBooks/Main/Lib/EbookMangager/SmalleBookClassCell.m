//
//  SmalleBookClassCell.m
//  Smallebook
//
//  Created by lzq on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SmalleBookClassCell.h"

@implementation SmalleBookClassCell
@synthesize bookclassname;
- (void)dealloc {
    [bookclassname release];
    [super dealloc];
}
@end
