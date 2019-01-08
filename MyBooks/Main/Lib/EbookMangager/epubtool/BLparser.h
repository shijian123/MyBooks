//
//  BLparser.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-23.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLparserProtocol.h"








typedef NS_ENUM(NSInteger, BLParsertype) {
    BLdefaultparser=0,
    BLNSXMLParser=1,
    BLhtmlParser=2,
    
};

@interface BLparser : NSObject
{

    id<BLparserdelegate>delegate;


}

@property(retain,nonatomic)id<BLparserdelegate>delegate;
//use


-(BOOL)parse;
-(BOOL)isparsing;


-(void)stopparse;



//init

- (id)initWithData:(NSData *)data parsertype:(BLParsertype)parsertype;

-(id)initWithData:(NSData*)data encoding:(NSStringEncoding)encoding parsertype:(BLParsertype)parsertype;


@end
