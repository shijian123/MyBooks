//
//  customcontroller.m
//  OfficerEye
//
//  Created by BLapple on 13-1-25.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "customcontroller.h"

@implementation customcontroller

@synthesize rightbackgroundcolor,CurrenPageIndex;

-(void)dealloc{
    [rightbackgroundcolor release];
    [super dealloc];
}

-(NSInteger)getCurrentPageNumber{
    return CurrenPageIndex;
}

-(BOOL)reload{
    [self  JunpToshowNewPage:CurrenPageIndex];
    return YES;
}
@end
