

#import <UIKit/UIKit.h>

@interface AppRecord : NSObject
{
    UIImage *appIcon;
    NSString *imageURLString;
}
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) NSString *imageURLString;
- (NSString*)ImageCacheFile;
@end
