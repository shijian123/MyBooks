//
//  epubtextdataengine.m
//  yanqing
//
//  Created by BLapple on 13-10-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "epubtextdataengine.h"

@implementation epubtextdataengine
@synthesize bookpath,bookdisk,mutiinfo,booktitle,bookcontentpath,bookcontenttype;
-(void)dealloc
{
    self.bookcontenttype=nil;
    self.bookpath=nil;
    self.bookdisk=nil;
    self.mutiinfo=nil;
    self.bookInfor=nil;
    self.bookChapterlist=nil;
    self.CurrentChapterBookTextData=nil;
    self.booktitle=nil;
    self.bookcontentpath=nil;
    [super dealloc];
}

-(NSMutableArray*)makebookChapterlist:(NSString*)_bookpath
{
    self.bookpath=_bookpath;
    self.bookdisk=[self.bookpath stringByAppendingPathComponent:@"BLinfo"];
    NSString* blinfopath=[self.bookdisk stringByAppendingPathComponent:@"BLinfo"];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:blinfopath])
    {
        return nil;
    }
    self.mutiinfo=[NSMutableArray arrayWithContentsOfFile:blinfopath];
    
    self.bookcontentpath=[self.mutiinfo objectAtIndex:2];
    self.bookcontenttype=[self.mutiinfo objectAtIndex:3];
    self.booktitle=[self.mutiinfo objectAtIndex:4];

    return self.bookcontentpath;
}

//// 获取每个卷有多少个章节
-(NSInteger)numberOfChaptersInFormal:(NSInteger)section
{
    return [self.booktitle count];
}

- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter titleForHeaderInChapters:(NSIndexPath*)indexPath{
    return [self.booktitle objectAtIndex:indexPath.row] ;
}

- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter TextContentInChapters:(NSIndexPath*)indexPath isCache:(BOOL)cacheChapter
{

    NSString* path= [self.bookdisk stringByAppendingPathComponent:[self.bookcontentpath objectAtIndex:indexPath.row]];
    
    NSString* str=nil;
    BLhtmlinfo* html=nil;
    switch ([[self.bookcontenttype objectAtIndex:indexPath.row] intValue]) {
        case 1://text
            
           str= [[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] autorelease];

                    
            break;
        case 2://html
            html=[BLhtmlinfo infowithcontentoffile:path];
            
            break;
        case 3://yafeitext
        {
            NSString* contentstring=nil;
            
            //调试 暂时注释
//            contentstring=[SpileTextSDK  spileContent:self.bookpath titleIndex:indexPath.row root:self.bookdisk];
            
//            contentstring=[self getregs:contentstring];
//            [formaterr setstrwithstr:contentstring prestr:titlestring]
//            ;
            str=contentstring;
            
        }
            break;
        case 4://gongsitext
        {
            NSString* contentstring=nil;
            
//            if([[bookpan.bookinfo objectForKey:@"islocal"] boolValue])
//            {
//                path=    [[[[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"addbooks.bundle"] stringByAppendingPathComponent:[[bookpan  bookinfo] objectForKey:@"id"]] stringByAppendingPathComponent:@"BLinfo"] stringByAppendingPathComponent:[content objectAtIndex:indexPath.row]];
//                contentstring=[SpileTextSDK  getcontentformfile:path];
//            }
//            else
//            {
            
            //调试 暂时注释
//                contentstring=[SpileTextSDK  getcontentformfile:[self.bookpath stringByAppendingPathComponent:[self.bookcontentpath objectAtIndex:indexPath.row]]];
            
//            }
            
            str=contentstring;

        }
            break;
        case 5:
        {
            /*
             NSString* contentstring=[sqlengine simpleTextBookReading:nil TextContentInChapters:[NSIndexPath indexPathForRow:chapter inSection:0] isCache:NO];
             contentstring=[self getregs:contentstring];
             [formaterr setstrwithstr:contentstring prestr:titlestring]
             ;
             [contentstring writeToFile:[BLdiskpath stringByAppendingPathComponent:[content objectAtIndex:chapter]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
             [contenttype removeObjectAtIndex:chapter];
             [contenttype insertObject:[NSNumber numberWithInt:1] atIndex:chapter];
             */
        }
            break;
        default:
            break;
    }
    
//    BLhtmlinfo* html=[BLhtmlinfo infowithcontentoffile:path];
    if(str==nil)
    {
        if(html.BLhtmlstr!=nil&& [html.BLhtmlstr isKindOfClass:[NSString class]]&&html.BLhtmlstr.length>0)
        {
            str= html.BLhtmlstr;
        }
        else
        {
            str= @" ";
        }
    }

    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　| )*";
	NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    str=[reg stringByReplacingMatchesInString:str  options:NSMatchingReportProgress  range:NSMakeRange(0, [str length])  withTemplate:@"\n"];
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    ;
    if(str==nil||str.length==0)
    {
        str=@" ";
    }
    
    if (cacheChapter) {
        self.CurrentChapterBookTextData=[NSMutableString string];
        [self.CurrentChapterBookTextData appendString:str];
    }
    
    
    
    return str;
    
}



//
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter NSRangeInCurrentChapter:(NSRange)Range
{
    if ((Range.location+Range.length)>[self.CurrentChapterBookTextData length]) {
        Range=NSMakeRange(Range.location, [self.CurrentChapterBookTextData length]-Range.location );
        if(Range.location>=[self.CurrentChapterBookTextData length])
        {
            return @" ";
        }
    }
    return [[self.CurrentChapterBookTextData substringWithRange:Range] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet ]];
}


-(BLhtmlinfo*)blhtmlinfoforchapter:(int)chapter
{
    NSString* path= [self.bookdisk stringByAppendingPathComponent:[self.bookcontentpath objectAtIndex:chapter]];
    
    BLhtmlinfo* html=[BLhtmlinfo infowithcontentoffile:path];
    
    return html;
}

-(NSString*)TextBookReadingForKeyWord{
    
        NSString*namestr=[self.bookInfor objectForKey:@"name"];
        
        if(namestr==nil)
        {
            namestr=[self.bookInfor objectForKey:@"title"];
        }
        return [NSString stringWithFormat:@"wifibooke%@",[namestr MD5String]] ;

}

-(NSString*)TextBookReadingForTitle{
    NSString* namestring=[self.bookInfor objectForKey:@"name"];
    if(namestring==nil)
    {
        namestring=[self.bookInfor objectForKey:@"title"];
    }
    
    return namestring;
}
//
@end
