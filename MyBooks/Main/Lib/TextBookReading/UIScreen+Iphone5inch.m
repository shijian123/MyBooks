
#import "UIScreen+Iphone5inch.h"

@implementation UIScreen (Iphone5inch)
+(BOOL)isIphone5inch{
    return [UIDevice currentDevice].userInterfaceIdiom
    == UIUserInterfaceIdiomPhone
    && [UIScreen mainScreen].bounds.size.height
    * [UIScreen mainScreen].scale >= 1136;
}
+(NSString*)ImagePathToIphone5inch:(NSString*)path{
    if([UIScreen isIphone5inch]){
        if ([path hasSuffix:@"@2x.png"]) {
            path=[path stringByReplacingOccurrencesOfString:@"@2x.png" withString:@"-568h@2x.png"];
        }else{
            path=[path stringByReplacingOccurrencesOfString:@".png" withString:@"-568h@2x.png"];
        }
    }
    return path;
}
+(UIImage*)ImageToIphone5inch:(NSString*)path{
    if(![UIScreen isIphone5inch]){
        return [UIImage imagefileNamed: path];
    }else {
        
        NSString *fullpath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[UIScreen ImagePathToIphone5inch:path]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
            NSData *imagedata=[NSData dataWithContentsOfFile:fullpath];
            return [UIImage imageWithData:imagedata scale:2.0];
        }else{
            return [UIImage imagefileNamed: path];
        }
    }
}
@end
