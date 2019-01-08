//
//  NSFileManager+TextBookReadingFileManager.h
//  Smallebook
//
//  Created by lzq on 12-10-13.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (TextBookReadingFileManager)
- (NSString *)CreateCachePathByAppending:(NSString*)appendingPath;
- (NSString *)CreateBookMarksDirectory;//创建读书书签目录
- (NSString *)CreateBookPageSegmentsDirectory;//创建书籍页面分析数据保存目录
- (NSString *)GetBookMarkPathWithKeyWord:(NSString*)keyword;//获取书籍书签地址
- (NSString *)GetBookPageSegmentPathWithKeyWord:(NSString*)keyword;//获取书籍页面分段数据地址
- (BOOL)ClearBookCacheDataWithKeyWord:(NSString*)keyword;//清除某本书籍相关数据
- (BOOL)ClearAllBookPageSegments;//清除所有书籍的页面分页数据
@end
