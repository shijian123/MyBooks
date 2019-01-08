//
//  NSString+CY.m
//  MyBooks
//
//  Created by zcy on 2018/7/25.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "NSString+CY.h"

@implementation NSString (CY)

//获取当前时间戳  （以毫秒为单位）
+(NSString *)currentTimeStamp{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%.f", [datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

@end
