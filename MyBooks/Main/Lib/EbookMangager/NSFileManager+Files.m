//
//  NSFileManager+Files.m
//  TodayWordNews
//
//  Created by lzq on 12-9-22.
//
//

#import "NSFileManager+Files.h"
@implementation NSFileManager (Files)
- (NSMutableArray *)Files:(NSString *)path Search:(NSString *)search  error:(NSError **)error{
    NSString *pattern=search;
    if (pattern==nil || [pattern length]==0) {
         pattern=@"*.*";
    }
    pattern=[pattern stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    pattern=[pattern stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    pattern=[pattern stringByReplacingOccurrencesOfString:@"?" withString:@".?"];
    pattern=[NSString stringWithFormat:@"^%@$",pattern];
    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:error];
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
     NSArray *fileList=[self contentsOfDirectoryAtPath:path error:error];
     for (NSString *file in fileList) {
         if ([reg numberOfMatchesInString:file  options: NSMatchingReportCompletion range:NSMakeRange(0,[file length]) ]>0) {
             NSString *filepath = [path stringByAppendingPathComponent:file];
             [self fileExistsAtPath:filepath isDirectory:(&isDir)];
             if (!isDir) {
                 [dirArray addObject:file];
             }
         }
        isDir = NO;
    }
    return [dirArray autorelease];
 }
@end
