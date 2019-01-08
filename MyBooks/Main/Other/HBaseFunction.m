//
//  HBaseFunction.m
//  History
//
//  Created by 朝阳 on 14-9-5.
//  Copyright (c) 2014年 Work. All rights reserved.
//


#import "HBaseFunction.h"

@implementation HBaseFunction

/**
 *  获得书籍封面
 *  @param dic 书籍的字典
 *  @param imageStyley 几号书城
 *  @return NSString 返回书籍的封面URL
 **/

+(NSString *)getmutilogoImageUrl:(NSDictionary *)bookInfo imageStyley:(NSInteger)imageStyley
{
    
    NSString *imageUrl;
    /*
    if ([bookInfo[@"mutilogo"]isEqualToString:@""]||bookInfo[@"mutilogo"] == nil) {
        if (imageStyley == 1) {
            imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelativeOne];
            
        }else if(imageStyley == 2)
        {
            imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelative];
        }else if(imageStyley == 3)
        {
            imageUrl=[[bookInfo objectForKey:@"logo"] epubRelativeThree];
        }else
        {
            
            imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelativeFour];
            
        }
        
    }else
    {
        NSArray *imageArr = [[bookInfo objectForKey:@"mutilogo"] componentsSeparatedByString:@","];
        if (imageStyley == 1) {
            imageUrl=[[imageArr objectAtIndex:0] absoluteorRelativeOne];
            
        }else if(imageStyley == 2)
        {
            imageUrl=[[imageArr objectAtIndex:0] absoluteorRelative];
        }else if(imageStyley == 3)
        {
            imageUrl=[[imageArr objectAtIndex:0] epubRelativeThree];
        }else
        {
            imageUrl=[[imageArr objectAtIndex:0] absoluteorRelativeFour];
            
        }
        
    }
    */
    
    if (imageStyley == 1) {
        imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelativeOne];
        
    }else if(imageStyley == 2)
    {
        imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelative];
    }else if(imageStyley == 3)
    {
        imageUrl=[[bookInfo objectForKey:@"logo"] epubRelativeThree];
    }else
    {
        
        imageUrl=[[bookInfo objectForKey:@"logo"] absoluteorRelativeFour];
        
    }

    return imageUrl;
    
}


@end
