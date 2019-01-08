
#import "NSFileManager+TextBookReadingFileManager.h"
@implementation NSFileManager (TextBookReadingFileManager)
- (NSString *)CreateCachePathByAppending:(NSString*)appendingPath {
    //	NSString *savefile=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    NSString *savefile=[self searchbestpath];
    
    savefile=[savefile stringByAppendingPathComponent:appendingPath];
    return savefile;
}

-(NSString*)searchbestpath
{
    NSString* diskpath =[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray* fileList=  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:diskpath error:nil ];
    
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    BOOL isDir = NO;
    
    for (NSString *file in fileList) {
        NSString *path = [diskpath stringByAppendingPathComponent:file];
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [arr addObject:file];
        }
        else
        {
            
        }
        isDir = NO;
    }
    BOOL match=NO;
    NSString* versionstr=nil;
    for(int i=60;i>=10;i--)
    {
        versionstr=[NSString stringWithFormat:@"%d.%d",i/10,i%10];
        for(NSString* file in arr)
        {
            if([versionstr isEqualToString:file])
            {
                match=YES;
                break;
            }
        }
        if(match)
        {
            break;
        }
    }
    if(!match||versionstr.length==0)
    {
        versionstr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return [diskpath stringByAppendingPathComponent:versionstr];
    
}

- (NSString *)CreateBookMarksDirectory{
    //创建文件夹
    NSString *path=[self CreateCachePathByAppending:@"/bookreadingdata/bookmarks/"];
    [self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil];

    return path;
}
- (NSString *)CreateBookPageSegmentsDirectory{
    NSString *path=[self CreateCachePathByAppending:@"/bookreadingdata/segments/"];
    [self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil];
    return path;
}
- (NSString *)GetBookMarkPathWithKeyWord:(NSString*)keyword{
    return  [NSString stringWithFormat:@"%@/BookHistory-%@.dat",[self CreateCachePathByAppending:@"/bookreadingdata/bookmarks/"],keyword];
}
- (NSString *)GetBookPageSegmentPathWithKeyWord:(NSString*)keyword{
    return  [NSString stringWithFormat:@"%@/allpages-%@.dat",[self CreateCachePathByAppending:@"/bookreadingdata/segments/"],keyword];
}
- (BOOL)ClearBookCacheDataWithKeyWord:(NSString*)keyword{
    BOOL DeleteBookMarkPath=NO;
    BOOL DeleteBookPageSegmentPath=NO;
    NSString *BookMarkPath=[self GetBookMarkPathWithKeyWord:keyword];
    NSString *BookPageSegmentPath=[self GetBookPageSegmentPathWithKeyWord:keyword];
    if ([self fileExistsAtPath:BookMarkPath]) {
        DeleteBookMarkPath=[self removeItemAtPath:BookMarkPath error:nil];
    }
    if ([self fileExistsAtPath:BookPageSegmentPath]) {
        DeleteBookPageSegmentPath=[self removeItemAtPath:BookPageSegmentPath error:nil];
    }
    return DeleteBookMarkPath&&DeleteBookPageSegmentPath;
}
- (BOOL)ClearAllBookPageSegments{
    BOOL DeleteBookPageSegmentDirectory=NO;
    NSString *BookPageSegmentDirectory=[self CreateCachePathByAppending:@"/bookreadingdata/segments/"];
    if ([self fileExistsAtPath:BookPageSegmentDirectory]) {
        DeleteBookPageSegmentDirectory= [self   removeItemAtPath: BookPageSegmentDirectory  error:nil];
    }
    return DeleteBookPageSegmentDirectory;
}
@end
