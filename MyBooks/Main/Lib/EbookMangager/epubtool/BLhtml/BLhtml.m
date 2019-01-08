//
//  BLhtml.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-26.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLhtml.h"
#import "BLhtmlanalysiser.h"

@implementation BLhtml


+(BLhtmlinfo*)getinfofromhtml:(NSString*)htmlpath
{
    BLhtmlanalysiser* analy=[[[BLhtmlanalysiser alloc]init] autorelease];
    BLhtmlinfo* info=[analy  gethtmlinfofromhtml:htmlpath];
    
    return info;
    
}


@end
