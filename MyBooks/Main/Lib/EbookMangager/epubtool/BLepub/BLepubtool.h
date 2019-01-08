//
//  BLepubtool.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLparser.h"
#import "BLepubinfoelement.h"
#import "BLparserfordata.h"


@interface BLepubcontainerinfo : NSObject<BLparserdelegate>
+(NSString*)getOpfpath:(NSString*)Epubpath;
-(NSString*)getOpfpath:(NSString*)Epubpath;

@end


@interface BLepubOpfinfo : NSObject<BLparserdelegate>
{
   
    NSMutableDictionary* metadata;//author,bookname etc.
    NSMutableDictionary* manifest;//mainmediatype pic/xhtml
    NSMutableArray*      spine;//spine
    NSString* catchstring;
}
@property(retain,nonatomic)NSMutableDictionary* metadata;
@property(retain,nonatomic)NSMutableDictionary* manifest;
@property(retain,nonatomic)NSMutableArray*      spine;
@property(retain,nonatomic)NSString* catchstring;


-(BLepubinfoelement*)analysisOpf:(NSString*)Opfpath;

@end