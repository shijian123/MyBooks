#import "EbookMangagerTextBookDataEnqin.h"
#import "EBookLocalStore.h"
#import "NSString+MD5.h"
@implementation EbookMangagerTextBookDataEnqin
@synthesize bookInfor,CurrentChapterBookTextData,bookChapterlist;
-(void)dealloc{
    [bookChapterlist release];
    [bookInfor release];
    [CurrentChapterBookTextData release];
    [super dealloc];
}
-(id)init{
    if (self=[super init]) {
          
     }
    return self;
}
// 获取每个卷有多少个章节
-(NSInteger)numberOfChaptersInFormal:(NSInteger)section{
    return [self.bookChapterlist count];
}             

// 获取每章节的标题
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter titleForHeaderInChapters:(NSIndexPath*)indexPath{
     return [[self.bookChapterlist objectAtIndex:indexPath.row] objectForKey:@"title"];
    }    

// 获取每章节的文本内容
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter TextContentInChapters:(NSIndexPath*)indexPath isCache:(BOOL)cacheChapter
{
    NSString *str= [[EBookLocalStore defaultEBookLocalStore] ObtainBookChapterContentForPath:self.bookInfor ChapterPath:[[self.bookChapterlist objectAtIndex:indexPath.row] objectForKey:@"path"]] ;
     NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
     NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    if(str==nil||str.length==0)
    {
    str=@" ";
    }
    
    str=[reg stringByReplacingMatchesInString:str  options:NSMatchingReportProgress  range:NSMakeRange(0, [str length])  withTemplate:@"\n"];
     str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"  　 　 　　"]];
//    str=[str stringByReplacingOccurrencesOfString:@"  " withString:@"　"];
    if (cacheChapter) {
        self.CurrentChapterBookTextData=[NSMutableString string];
        [self.CurrentChapterBookTextData appendString:str];
    }
    return str; 
}

// 获取某一章节某些文本内容
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter NSRangeInCurrentChapter:(NSRange)Range {
    if ((Range.location+Range.length)>[self.CurrentChapterBookTextData length]) {
        Range=NSMakeRange(Range.location, [self.CurrentChapterBookTextData length]-Range.location );
        if(Range.location>=[self.CurrentChapterBookTextData length])
        {
            return @" ";
        }
     }
    return [[self.CurrentChapterBookTextData substringWithRange:Range] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet ]];
}
       
// 获取书籍上次阅读的位置，字符串位置

-(NSString*)TextBookReadingForKeyWord{
 return  [[self.bookInfor objectForKey:@"url"] MD5String];
}
-(NSString*)TextBookReadingForTitle{
    NSString* namestring=[self.bookInfor objectForKey:@"name"];
    if(namestring==nil)
    {
        namestring=[self.bookInfor objectForKey:@"title"];
    }
    
    return namestring;
}
//获取书籍的名称


@end
