//
//  HBaseFunction.h
//  History
//
//  Created by 朝阳 on 14-9-5.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBaseFunction : NSObject
/**
 *  获得书籍封面
 *  @param bookInfo 书籍的字典
 *  @param imageStyley 几号书城
 *  @return NSString 返回书籍的封面URL
 **/

+(NSString *)getmutilogoImageUrl:(NSDictionary *)bookInfo imageStyley:(NSInteger)imageStyley;

@end
