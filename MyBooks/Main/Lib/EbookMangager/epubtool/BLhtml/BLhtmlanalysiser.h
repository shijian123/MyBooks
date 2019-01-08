//
//  BLhtmlanalysiser.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-27.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//
/*
vlaue               key
 1                   左边距
 2                   右边距
 3                   对齐方式
 4                   字体大小变化值  h1－h6   (4) 
 
 
 5                   imag    路径；宽高
 6                   行高 空行
 
 7                   del
 8                   sub
 9                   sup
 10                  ini粗体
 11                  hr
 12                  a
*/


#import <Foundation/Foundation.h>
#import "NSString+BLhtmlstringtool.h"
#import "BLhtmlinfo.h"

@interface BLhtmlanalysiser : NSObject<BLparserdelegate>
{
    BLhtmlinfo*   temp;
    @private
    NSMutableArray*indexarr;
}
@property(retain,nonatomic)BLhtmlinfo*   temp;
@property(retain,nonatomic)NSMutableArray*indexarr;


-(BLhtmlinfo*)gethtmlinfofromhtml:(NSString*)htmlpath;


-(BOOL)currenttagneednewline;




-(void)insertspedic:(NSMutableDictionary*)dic ;

-(NSString*)imadicisavaliable:(NSDictionary*)dic;

-(void)findstirng:(NSMutableString*)str;

@end
