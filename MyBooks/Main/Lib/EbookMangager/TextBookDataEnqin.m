//
//  TextBookDataEnqin.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TextBookDataEnqin.h"
@implementation TextBookDataEnqin
@synthesize bookInfor,CurrentChapterBookTextData,BookKeyWord,BookName,sql,saveinfodic;
-(void)dealloc{
    self.saveinfodic=nil;
    [sql CloseDataBase];
    [sql release]; 
    [bookInfor release];
    [CurrentChapterBookTextData release];
    [BookKeyWord release];
    [BookName release];
    [super dealloc];
}
-(id)init{
    if (self=[super init]) {
        self.sql=[[[SqlClient alloc] init] autorelease];
        [self.sql OpenDataBase];
        self.CurrentChapterBookTextData=[NSString string];
    }
    return self;
}
// 获取每个卷有多少个章节
-(NSInteger)numberOfChaptersInFormal:(NSInteger)section{
    return [self.bookInfor count];
}             

// 获取每章节的标题
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter titleForHeaderInChapters:(NSIndexPath*)indexPath{
     return [[self.bookInfor objectAtIndex:indexPath.row] objectForKey:@"chaptertitle"];
    }    

// 获取每章节的文本内容
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter TextContentInChapters:(NSIndexPath*)indexPath isCache:(BOOL)cacheChapter
{
    NSString *str=[self.sql contentOfchapter:[[[self.bookInfor  objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　| )*";
	NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    str=[reg stringByReplacingMatchesInString:str  options:NSMatchingReportProgress  range:NSMakeRange(0, [str length])  withTemplate:@"\n"];
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    ;
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"  　 　 　　 "]];
    
    
    
    
//	str=[str stringByReplacingOccurrencesOfString:@"  " withString:@"　"];
    if (cacheChapter ) {
        self.CurrentChapterBookTextData=str;
    }
    return  str;
}

// 获取某一章节某些文本内容
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter NSRangeInCurrentChapter:(NSRange)Range {
    if ((Range.location+Range.length)>[self.CurrentChapterBookTextData length]) {
        Range=NSMakeRange(Range.location, [self.CurrentChapterBookTextData length]-Range.location );
        if(Range.location>=[self.CurrentChapterBookTextData length])
        {
            return @" ";
        }
        //NSLog(@"NEW RANG");
    }
    return [[self.CurrentChapterBookTextData substringWithRange:Range] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet ]];
}
       
// 获取书籍上次阅读的位置，字符串位置

-(NSString*)TextBookReadingForKeyWord{
 return  self.BookKeyWord;
}
-(NSString*)TextBookReadingForTitle{
    return BookName;
}
//获取书籍的名称

@end
