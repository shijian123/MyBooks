//
//  NSString+Stringhttpfix.m
//  OfficerEye
//
//  Created by BLapple on 13-3-30.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "NSString+Stringhttpfix.h"

@implementation NSString (Stringhttpfix)

+(NSString*)absoluteorRelative:(NSString*)url
{
    return  [[url lowercaseString] hasPrefix:@"http://"]?url:[EbookWebXmlServiceBaseUrl stringByAppendingString:url];
}
-(NSString*)absoluteorRelative{
    return  [[self lowercaseString] hasPrefix:@"http://"]?self:[EbookWebXmlServiceBaseUrl stringByAppendingString:self];
}
//EbookWebXmlServiceBaseUrlOne
-(NSString*)absoluteorRelativeOne{
    return  [[self lowercaseString] hasPrefix:@"http://"]?self:[EbookWebXmlServiceBaseUrlOne stringByAppendingString:self];
}
-(NSString*)epubRelativeThree{
    return  [[self lowercaseString] hasPrefix:@"http://"]?self:[epubWebXmlServiceBaseUrlThree stringByAppendingString:self];
}
//ebook.dlmdj组装url
-(NSString*)absoluteorRelativeFour{
    return  [[self lowercaseString] hasPrefix:@"http://"]?self:[EbookWebXmlServiceBaseUrlFour stringByAppendingString:self];
}

-(NSString*)epubRelative{
    return  [[self lowercaseString] hasPrefix:@"http://"]?self:[epubWebXmlServiceBaseUrl stringByAppendingString:self];
}


- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
