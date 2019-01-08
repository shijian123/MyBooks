#import <Foundation/Foundation.h>
#import "EbookMangagerTextBookDataEnqin.h"
//#import "PublicDATA1.h"
#import "EBookLocalStore.h"
#import "NSString+Stringhttpfix.h"
#import "epubtextdataengine.h"
//#import "BLwifistore.h"
@class LeveyTabBarController;
@class SimpleTextBookReading;
@class AdSageView;

@interface EbookWindowReader : UIResponder{
    UIWindow *MainWindow;
    UIView* leveshade;
    UIViewController *MainViewController;
}
@property (nonatomic, retain)  UIViewController *MainViewController;
@property(retain,nonatomic) UIView *leveshade;
@property (assign, nonatomic)  UIWindow *MainWindow;


-(void)SetupBookReadNotificatioKeyword:(NSString*)NotificatioKeyword;
-(void)SetupUncaughtExceptionHandler;
-(void)LoadALLSpecilRowsOnline:(NSArray*)SpecilIDArray; 
@end

@interface SmalleEbookWindow : EbookWindowReader<UINavigationControllerDelegate>
{
    LeveyTabBarController *leveyTabBarController;
    UIWindow *EbookWindow;
    BOOL preStatusbarstate;
    
}
@property (nonatomic, retain)  LeveyTabBarController *leveyTabBarController;
@property (strong, nonatomic)  UIWindow *EbookWindow;
+(void)ShowSmallEBook;//启动读书界面
+(void)Tongji:(NSString*)bookid;//统计书籍下载次数

+(void)LoadSpecilRowsOnline:(NSString*)SpecilID  delegateTarget:(id)target;//在线获取内部专题列表
+(NSMutableArray*)LoadSpecialRowsOnlocal:(NSString*)SpecilID;//从本地获取内部专题列表
+(void)SaveSpecialRowsOnCache:(NSString*)SpecilID row:(NSMutableArray*)Rows;//保存专题列表到本地缓存
+ (NSMutableDictionary*)BuilteBookStatus:(NSDictionary*)bookinfor;//将在线书库的格式转化成下载的格式

//使用3号epub书城处理书籍字典的方法：吕
+ (NSMutableDictionary*)BuilteEpubBookStatus:(NSMutableDictionary*)bookinfor;
//一号书城
+ (NSMutableDictionary*)BuilteBookStatusBaseUrlOne:(NSMutableDictionary*)bookinfor;
@end
