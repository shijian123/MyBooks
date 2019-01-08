//
//  NSString+BLhtmlstringtool.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-27.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_WHITESPACE(_c) (_c == ' ' || _c == '\t' || _c == 0xA || _c == 0xB || _c == 0xC || _c == 0xD || _c == 0x85)

@interface NSString (BLhtmlstringtool)

- (NSString *)stringByNormalizingWhitespace;


- (NSString *)stringByReplacingHTMLEntities;


- (NSString *)stringByAddingHTMLEntities;

-(BOOL)isemputyhtmlstring;

-(void)createfunc;
@end
