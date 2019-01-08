#import "BaseCommonAppDelegate.h"
//#import "GCDiscreetNotificationView.h"
//#import "SVModalWebViewController.h"
//#import "SVWebViewController.h"
#import "EBookDownloaderNotifyView.h"
//#import "BaiduMobStat.h"
//#import "APService.h"


@implementation BaseCommonAppDelegate

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [_messageClickRows release];
//    [_messageRows release];
//    [_notificationView release];
//    [super dealloc];
//}
#pragma mark - NotificationFunctioin
//-(NSMutableDictionary*)MessageClickRows{
//    if (_messageClickRows==nil) {
//        _messageClickRows=[NSMutableDictionary dictionaryWithContentsOfFile:EbookManagerMessageClickRowsDirpath];
//        [_messageClickRows retain];
//    }
//    if (_messageClickRows==nil) {
//        _messageClickRows=[NSMutableDictionary dictionary];
//        [_messageClickRows retain];
//    }
//    return  _messageClickRows;
//}
//-(NSMutableArray*)MessageRows{
//    if (_messageRows==nil) {
//        _messageRows=[NSMutableArray array];
//        [_messageRows retain];
//    }
//    return  _messageRows;
//}
//-(void)setMessageRows:(NSMutableArray*)messagerows{
//    if (_messageRows!=messagerows ) {
//        [messagerows retain];
//        [_messageRows release];
//        _messageRows=messagerows;
//    }
//}
//-(GCDiscreetNotificationView*)notificationView{
//    return  _notificationView;
//}
//-(void)setNotificationView:(GCDiscreetNotificationView*)notificationview{
//    if (_notificationView!=notificationview ) {
//        [notificationview retain];
//        [_notificationView release];
//        _notificationView=notificationview;
//    }
//}
//-(void)SaveClickData{
//    [_messageClickRows writeToFile:EbookManagerMessageClickRowsDirpath  atomically:YES];
//}
#pragma mark - 极光推送start
/* 加载极光推送的代码 */
//-(void)startJuPush:(NSDictionary *)launchOptions{
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    [APService setupWithOption:launchOptions];
//    // Required
//    [APService setupWithOption:launchOptions];
    
//}

//- (void)networkDidSetup:(NSNotification *)notification {
//    //    [_infoLabel setText:@"已连接"];
//    // NSLog(@"已连接");
//}
//
//- (void)networkDidClose:(NSNotification *)notification {
//    //    [_infoLabel setText:@"未连接。。。"];
//    // NSLog(@"wei连接");
//}
//
//- (void)networkDidRegister:(NSNotification *)notification {
//    //    [_infoLabel setText:@"已注册"];
//    // NSLog(@"已zhuce");
//}
//
//- (void)networkDidLogin:(NSNotification *)notification {
//    //    [_infoLabel setText:@"已登录"];
//    // NSLog(@"已denglu");
//}
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
////    [APService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
//    //    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
////    [APService handleRemoteNotification:userInfo];
//}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    //    NSString *title = [userInfo valueForKey:@"title"];
    //    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *bookDic=[userInfo valueForKey:@"extras"];
    if (bookDic!=nil) {
        [self handleDictionary:bookDic];
    }
    
    
}
-(void)handleDictionary:(NSDictionary *)bookDictionary{
  if ( [bookDictionary objectForKey:@"bookid"]==nil ||[bookDictionary objectForKey:@"bookname"]==nil||[bookDictionary objectForKey:@"url"]==nil) {
        return;
    }
    NSString *bookparas=[bookDictionary objectForKey:@"bookid"];
    NSMutableDictionary *handleDic=[NSMutableDictionary dictionary];
    NSArray *Params=[bookparas componentsSeparatedByString:@"|"];
    if ([Params count]==2) {
        [handleDic setObject:[Params objectAtIndex:0] forKey:@"messageID"];
        [handleDic setObject:[Params objectAtIndex:1] forKey:@"logo"];
    }else {
        [handleDic setObject:bookparas forKey:@"messageID"];
    }
    NSString *bookName=[bookDictionary objectForKey:@"bookname"];
    NSString *bookUrl=[bookDictionary objectForKey:@"url"];
    if (![bookUrl hasPrefix:@"http://"]) {
        bookUrl=[bookUrl absoluteorRelative];
    }
    
    [handleDic setObject:@"5" forKey:@"messageType"];
    [handleDic setObject:bookName forKey:@"messageTitle"];
    [handleDic setObject:bookUrl forKey:@"messageUrl"];
    if (handleDic!=nil) {
        [self AddLocalBookList:handleDic];
    }
    
}
#pragma mark - 极光推送end
//添加来自远程通知的书籍，并显示
//dir:{name,url,bookid}
-(void)AddLocalBookList:(NSDictionary*)booklist{
//    NSInteger arrindex=[self.MessageRows indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//        return [[obj objectForKey:@"messageID"] isEqualToString:[booklist objectForKey:@"messageID"]];
//    }];
//    if (arrindex==NSNotFound) {
//        [self.MessageRows insertObject:booklist  atIndex:0];
//        [self performSelector:@selector(ShowNotification)  withObject:nil afterDelay:2.0];
//    }
}
//
//-(void)ShowNotification{
//    if ([self.MessageRows count]>0) {
//        if (self.notificationView==nil) {
//            [self CreateNotification:nil showActivity:NO inPresentationMode:YES];
//        }
//        for (int i=0; i<[self.MessageRows count]; i++) {
//            NSMutableDictionary *dir=[self.MessageRows objectAtIndex:i];
//            if ([self.MessageClickRows objectForKey:[NSString stringWithFormat:@"messageID%d",[[dir  objectForKey:@"messageID"] intValue]]]==nil ) {
//                self.notificationView.infor=dir;
//                [self.notificationView setTextLabel:[dir objectForKey:@"messageTitle"] animated:YES];
//                NSInteger messageType=[[dir objectForKey:@"messageType"] intValue];
//                if (messageType!=5) {
//                    [self.notificationView  performSelector:@selector(showAnimated) withObject:nil afterDelay:ShowAnimatedAfterDelay];
//
//                }else{
//                    [self.notificationView  performSelector:@selector(showAnimated) withObject:nil afterDelay:0.25];
//                }
//                i=[self.MessageRows count];
//            }
//        }
//    }
//}
//-(void)CreateNotificationXML{
//    DownloadHelper *dldHelper = [[[DownloadHelper alloc] init] autorelease];
//    dldHelper.delegate = self;
//    NSString *url=[NSString stringWithFormat:@"%@%d-message.xml",HotAppsBaseURL,[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"] intValue]];
//    [dldHelper download:url];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:  UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(SaveClickData)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//}
//- (void)didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData
//{
//    if ( sender.tag>0 && [super respondsToSelector:@selector(didReceiveData:Data:)]) {
//        [super didReceiveData: sender Data:theData];
//        return;
//    }
//    XmlDataSet *data=[[XmlDataSet alloc] init];
//    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"item"];
//    [data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
//    self.MessageRows=data.Rows;
//    [data release];
//    [self ShowNotification];
//}
//-(void)CreateNotification:(NSString*)title showActivity:(BOOL)showActivity inPresentationMode:(BOOL)inPresentationMode{
//    self.notificationView = [[[GCDiscreetNotificationView alloc] initWithText:title
//                                                                 showActivity:showActivity
//                                                           inPresentationMode:inPresentationMode ?  GCDiscreetNotificationViewPresentationModeTop : GCDiscreetNotificationViewPresentationModeBottom
//                                                                       inView:self.MainViewController.view] autorelease];
//    self.notificationView.FillColor= NotificationViewFillColor;
//    self.notificationView.StrokeColor= NotificationViewStrokeColor;
//    self.notificationView.delegate=self;
//    [self.notificationView hide:YES];
//}
//- (void)GCDiscreetNotificationViewClick:(GCDiscreetNotificationView*)DelegateNotificationView{
//    if (self.notificationView.infor!=nil) {
//        NSInteger messageType=[[DelegateNotificationView.infor objectForKey:@"messageType"] intValue];
//           NSURL *URL = [NSURL URLWithString:[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[DelegateNotificationView.infor objectForKey:@"messageUrl"], NULL, NULL, kCFStringEncodingUTF8) autorelease]];
//
//        [self.MessageClickRows  setValue:[NSDate date] forKey:[NSString stringWithFormat:@"messageID%d",[[DelegateNotificationView.infor objectForKey:@"messageID"] intValue]]];
//        NSString* eventLabel=[DelegateNotificationView.infor objectForKey:@"messageTitle"];
//        switch (messageType) {
//            case 0:
//            {//跳转到APP STORE
//                [[UIApplication sharedApplication]  openURL:URL];
//            }
//                break;
//            case 1:
//            {//打开内置浏览器
//                SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
//                webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//                webViewController.title=[DelegateNotificationView.infor objectForKey:@"messageTitle"];
//                webViewController.availableActions = SVWebViewControllerAvailableActionsNone ;
//                [self.MainViewController presentModalViewController:webViewController animated:YES];
//                [webViewController release];
//            }
//                break;
//            case 2:
//            {//下载图书资源
//
//                //ebook
//                NSString *bookurl=[URL absoluteString];
//                NSArray *bookarr=[bookurl componentsSeparatedByString:@"?"];
//                NSString *bookname=@"书籍";
//                if ([bookarr count]==2) {
//                    bookname=[bookarr objectAtIndex:1];
//                    bookname= [bookname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    bookurl=[bookarr objectAtIndex:0];
//                    bookurl=[bookurl stringByReplacingOccurrencesOfString:@"ebook://" withString:@"http://"];
//                    NSDictionary *bookInfor=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:bookname ,bookurl, nil]
//                                                                        forKeys:[NSArray arrayWithObjects:@"name" ,@"url", nil] ];
//
//                    eventLabel=bookname;
//                    [EBookDownloaderNotifyView   ShowEBookDownloaderNotifyViewWithBookInfor:bookInfor];
//                }
//            }
//                break;
//            case 4:
//            {//内置APP STORE
//                [[PublicDATA sharedPublicDATA] OpenAppWithProductID: [URL absoluteString] referenceViewController:MainViewController];
//            }
//                break;
//
//            case 5:
//            {//推送类书籍下载
//
//                if ([URL absoluteString] ==nil ||[URL absoluteString].length==0||eventLabel ==nil ||eventLabel.length==0) {
//                    return ;
//                }
//                NSString *logo=[DelegateNotificationView.infor objectForKey:@"logo"];
//                if (logo==nil) {
//                    logo=@"";
//
//                }
//                NSDictionary *bookInfor=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:eventLabel ,[URL absoluteString],[DelegateNotificationView.infor objectForKey:@"messageID"],eventLabel,logo,nil] forKeys:[NSArray arrayWithObjects:@"name" ,@"url", @"id",@"title",@"logo",nil] ];
//                [EBookDownloaderNotifyView   ShowEBookDownloaderNotifyViewWithBookInfor:bookInfor];
//                [UIApplication sharedApplication].applicationIconBadgeNumber=0;
//
//            }
//                break;
//            default:
//                break;
//        }
//        /*百度事件统计,传入的数据为:eventId,eventLabel
//         1=其他
//         100004=小书城启动次数
//         100003=热门推荐点击次数
//         100002=强制营销点击次数
//         100001=图书阅读次数
//         100000=图书下载次数
//         */
//        if(eventLabel!=nil)
//        {
//            [[NSNotificationCenter defaultCenter]  postNotificationName:@"BaiduMobStat-CustomEventNotification"  object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"100002",eventLabel, nil]  forKeys:[NSArray arrayWithObjects:@"eventId",@"eventLabel", nil] ]];
//        }
//    }
//    [self.notificationView hideAnimated];
//    [self.notificationView removeFromSuperview];
//    self.notificationView=nil;
//    [self performSelector:@selector(ShowNotification)  withObject:nil afterDelay:1.0];
//}

//
////启动百度统计
//-(void)StartBaiduMobStat{
//    //百度统计代码
//    BaiduMobStat *statTracker=[BaiduMobStat defaultStat];
//    statTracker.enableExceptionLog=YES;// 是否允许截获并发送崩溃信息，请设置YES或者NO
//    statTracker.channelId=[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"is91"] boolValue]?@"91":@"app store";//设置您的app的发布渠道
//    statTracker.logStrategy=BaiduMobStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
//    statTracker.logSendInterval=1;//为1时表示发送日志的时间间隔为1小时
//    statTracker.logSendWifiOnly=YES;//是否仅在WIfi情况下发送日志数据
//    statTracker.sessionResumeInterval=60;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
//    [statTracker startWithAppId:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"baiduappkey"] ];//设置您在mtj网站上添加的app的appkey
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiduMobStatPageviewStartWithNameNotificationFunction:) name:BaiduMobStatPageviewStartWithNameNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiduMobStatPageviewEndWithNameNotificationFunction:) name:BaiduMobStatPageviewEndWithNameNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BaiduMobStatCustomEventNotificationFunction:) name:BaiduMobStatCustomEventNotification object:nil];
//}
//-(void)BaiduMobStatPageviewStartWithNameNotificationFunction:(NSNotification *)notification{
//    NSDictionary *baiduInfor=[notification userInfo];
//    if ([[baiduInfor objectForKey:@"pageName"] length]>0) {
//        [[BaiduMobStat defaultStat] pageviewStartWithName:[baiduInfor objectForKey:@"pageName"]];
//    }
//}
//-(void)BaiduMobStatPageviewEndWithNameNotificationFunction:(NSNotification *)notification{
//    NSDictionary *baiduInfor=[notification userInfo];
//    if ([[baiduInfor objectForKey:@"pageName"] length]>0) {
//        [[BaiduMobStat defaultStat] pageviewEndWithName:[baiduInfor objectForKey:@"pageName"]];
//    }
//}
//-(void)BaiduMobStatCustomEventNotificationFunction:(NSNotification *)notification{
//    NSDictionary *baiduInfor=[notification userInfo];
//    if ([[baiduInfor objectForKey:@"eventId"] length]>0 && [[baiduInfor objectForKey:@"eventLabel"] length]>0) {
//        [[BaiduMobStat defaultStat] logEvent:[baiduInfor objectForKey:@"eventId"]  eventLabel: [baiduInfor objectForKey:@"eventLabel"]];
//    }
//}

@end
