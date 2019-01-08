#import "AppRecord.h"
#import "NSString+MD5.h"
@implementation AppRecord
@synthesize appIcon;
- (void)dealloc
{
    [appIcon release];
    [imageURLString release];
    [super dealloc];
}
- (NSString *)imageURLString {
	return imageURLString;
}
- (void)setImageURLString:(NSString *)aString {
	if (aString != imageURLString) {
		[imageURLString release];
		imageURLString = [aString retain];
	}
}
- (NSString*)ImageCacheFile{

    NSString *MainBookResource=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainBookResource"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:MainBookResource]){//判断是否创建文件夹
        [[NSFileManager defaultManager]createDirectoryAtPath:MainBookResource withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [NSString stringWithFormat:@"%@/%@", MainBookResource,[self.imageURLString MD5String]];
}

@end

