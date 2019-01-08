//
//  PerCenterViewConPostDatas.h
//  SSBar
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlDataSet1.h"
#import "DownloadHelper.h"
@interface XMLDownLoad : NSObject{
    DownloadHelper *downHelper;
    NSString *strTags;
    BOOL cancel;
}
@property(retain,nonatomic) DownloadHelper *downHelper;
@property(retain,nonatomic) NSString *strTags;
+(void)startDown:(NSString *)downUrl downLoadTag:(int)downTags;
-(NSString *)getFileName:(int)tags;
+(void)stopDownLoad;
@end
