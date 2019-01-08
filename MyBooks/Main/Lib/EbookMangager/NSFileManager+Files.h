//
//  NSFileManager+Files.h
//  TodayWordNews
//
//  Created by lzq on 12-9-22.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Files)
- (NSMutableArray *)Files:(NSString *)path Search:(NSString *)search  error:(NSError **)error;
@end
