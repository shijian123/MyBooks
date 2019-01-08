//
//  BLhtmlelement.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-26.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLparser.h"

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
 10                  ini
 11                  hr
 12                  a
 */




@interface BLhtmlinfo : NSObject
{
    NSMutableDictionary*  BLhtmlattributedic;
    
    NSMutableString*      BLhtmlstr;
    
    NSString*             BLhtmltitle;
}
@property(retain,nonatomic)NSMutableDictionary*  BLhtmlattributedic;
@property(retain,nonatomic)NSMutableString*      BLhtmlstr;
@property(retain,nonatomic)NSString*             BLhtmltitle;
-(void)writetofile:(NSString*)tofile;
+(BLhtmlinfo*)infowithcontentoffile:(NSString*)filepath;



-(void)changevaluetodata;

-(void)changedatatovalue;

@end
