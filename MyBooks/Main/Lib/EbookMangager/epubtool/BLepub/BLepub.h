//
//  BLepub.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
#import "BLepubinfoelement.h"





@interface BLepub : NSObject


+(BLepubinfoelement*)getEpubookinfofrompath:(NSString*)filepath;

+(BLepubinfoelement*)getEpubookinfofrompath:(NSString*)filepath cachpath:(NSString*)cach;

@end
