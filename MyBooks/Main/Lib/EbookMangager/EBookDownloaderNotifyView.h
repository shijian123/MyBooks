#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@interface EBookDownloaderNotifyView : UIViewController
{
     NSDictionary *BookInfor;
     UIWindow *overlayWindow;
     IBOutlet UIProgressView *downProgress;
    BOOL  notilocked;
}
@property (nonatomic,retain) UIProgressView *downProgress;
@property (nonatomic,retain ) NSDictionary *BookInfor;
+(void)ShowEBookDownloaderNotifyViewWithBookInfor:(NSDictionary*)bookInfor;
-(void)loadWithBookInfor:(NSDictionary*)bookInfor;
-(IBAction)buttonClick:(id)sender;
 
@end
