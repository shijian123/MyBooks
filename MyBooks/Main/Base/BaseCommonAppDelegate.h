
#import <UIKit/UIKit.h>
#import "SmalleEbookWindow.h"
#define EbookManagerMessageClickRowsDirpath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"EbookManagerMessageClickRows.plist"]
#define ShowAnimatedAfterDelay 90.0
#define HotAppsBaseURL @"http://www.iosteam.com/hotapps/"
#define NotificationViewFillColor [UIColor colorWithRed:255.0/255.0 green:97.0/255.0 blue:0 alpha:0.8]
#define NotificationViewStrokeColor [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:0 alpha:1.0]

//百度统计事件
//百度页面统计,传入为pageName
#define BaiduMobStatPageviewStartWithNameNotification @"BaiduMobStat-PageviewStartWithNameNotification"
#define BaiduMobStatPageviewEndWithNameNotification @"BaiduMobStat-PageviewEndWithNameNotification"
/*百度事件统计,传入的数据为:eventId,eventLabel
 1=其他
 100004=小书城启动次数
 100003=热门推荐点击次数
 100002=强制营销点击次数
 100001=图书阅读次数
 100000=图书下载次数
 */
#define BaiduMobStatCustomEventNotification @"BaiduMobStat-CustomEventNotification"

//@class GCDiscreetNotificationView;
@interface BaseCommonAppDelegate : EbookWindowReader <UIApplicationDelegate>
{
//    GCDiscreetNotificationView *_notificationView;
//    NSMutableArray *_messageRows;
//    NSMutableDictionary *_messageClickRows;
    
}
//极光推送初始
//-(void)startJuPush:(NSDictionary *)launchOptions;

-(void)AddLocalBookList:(NSDictionary*)booklist;//添加来自远程通知的书籍，并显示

//-(void)CreateNotificationXML;//加载营销数据，顶部自定义广告条
//-(void)StartBaiduMobStat;//启动百度统计

@end
