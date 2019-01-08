//
//  NSString+Stringhttpfix.h
//  OfficerEye
//
//  Created by BLapple on 13-3-30.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EbookWebXmlServiceBaseUrl @"http://ebookservice2.oss.aliyuncs.com"
#define epubWebXmlServiceBaseUrlThree @"http://ebookservice3.oss.aliyuncs.com"
#define EbookWebXmlServiceBaseUrlOne @"http://ebookservice.oss.aliyuncs.com"
#define EbookWebXmlServiceBaseUrlFour @"http://ebook.dlmdj.com"
#define epubWebXmlServiceBaseUrl @"http://ebookservice3.oss.aliyuncs.com"

#define SearchBaseUrl2 @"http://ring.dlmdj.com"
#define SearchBaseUrl1 @"http://ebook.dlmdj.com"


@interface NSString (Stringhttpfix)
+(NSString*)absoluteorRelative:(NSString*)url;
-(NSString*)absoluteorRelative;//二号书城组装url
-(NSString*)epubRelativeThree;//epub书城的logo组装

-(NSString*)absoluteorRelativeOne;//一号书城组装url
-(NSString*)absoluteorRelativeFour;//ebook.dlmdj组装url

-(NSString*)epubRelative;//epub书城的logo组装


/**
 *  计算字符串的size大小
 *
 *  @param font 字体大小
 *  @param maxW 最大的宽度
 *
 *  @return 返回size尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  计算字符串的size大小（默认宽度为最大）
 */
- (CGSize)sizeWithFont:(UIFont *)font;

@end
