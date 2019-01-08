//
//  BLhtml.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-26.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLhtmlinfo.h"

@interface BLhtml : NSObject

+(BLhtmlinfo*)getinfofromhtml:(NSString*)htmlpath;



@end
