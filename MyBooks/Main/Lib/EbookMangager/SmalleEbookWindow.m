#import "SmalleEbookWindow.h"
#import "LeveyTabBarController.h"
#import "bookOnlineViewController.h"
#import "bookTableViewController.h"



void SmalleEbookUncaughtExceptionHandler(NSException *exception) {
    NSString *ExceptionMessages = [NSString stringWithFormat:@"ExceptionMessages=异常崩溃报告\nCFBundleDisplayName:%@ \nitunesconnectappleid:%@ \nCFBundleVersion:%@ \nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"],
                                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                                   [exception name],
                                   [exception reason],
                                   [[exception callStackSymbols] componentsJoinedByString:@"\n"]];
    
    DownloadHelper *postdldHelper = [[[DownloadHelper alloc] init] autorelease];
    [postdldHelper post:ExceptionMessages  url: @"http://www.iosteam.com/newsxml/ExceptionMessagesPost.aspx"];
    [NSThread sleepForTimeInterval:0.5];
  
}

@implementation EbookWindowReader
@synthesize MainWindow,leveshade;
@synthesize MainViewController;
-(void)SetupUncaughtExceptionHandler{
    NSSetUncaughtExceptionHandler(&SmalleEbookUncaughtExceptionHandler);
}
-(void)SetupBookReadNotificatioKeyword:(NSString*)NotificatioKeyword {
    //StartBookReadingNotification
    //@"SmalleEbook-StartBookReadingNotification"
    
    //开始阅读书籍
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartBookReadingNotificationFunction:) name:NotificatioKeyword object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndBookReadingNotificationFunction:) name:@"EndBookReadingNotification" object:nil];
    
}
-(void)LoadALLSpecilRowsOnline:(NSArray*)SpecilIDArray{
    //@TODO
    //    CreateEBookListPath;
    if (![[NSFileManager  defaultManager] fileExistsAtPath:EBookSaveRootPath]) {
        [[NSFileManager  defaultManager] createDirectoryAtPath:EBookSaveRootPath  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (int i=0; i<[SpecilIDArray count]; i++) {
        DownloadHelper *http= [[[DownloadHelper alloc] init] autorelease];
        http.delegate=self;
        http.tag=[[SpecilIDArray objectAtIndex:i] intValue];
        NSString *url=[NSString stringWithFormat:@"%@/upload/xml/zhuanti_%d.xml",EbookWebXmlServiceBaseUrl,http.tag];
        [http download:url];   
    }
}
- (void)didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData{
    NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithCapacity:2];
    [dir setValue:[NSNumber numberWithInt: sender.tag]  forKey:@"tag"];
    [dir setValue:theData  forKey:@"theData"];
    [NSThread detachNewThreadSelector:@selector(DataPareInNewThread:) toTarget:self withObject: dir];
}

-(void)DataPareInNewThread:(NSMutableDictionary*)DirObject{
    @autoreleasepool {
        int tag=[[DirObject objectForKey:@"tag"] intValue];
        NSData*theData=[DirObject objectForKey:@"theData"];
        XmlDataSet *data=[[XmlDataSet alloc] init];
        NSMutableArray *pp =[NSMutableArray arrayWithObject:@"item"];
        [data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
        [SmalleEbookWindow SaveSpecialRowsOnCache:[NSString stringWithFormat:@"%d", tag] row:data.Rows];
        [data release];   
    }
}
- (void)EndBookReadingNotificationFunction:(NSNotification *)notification{
    [[EBookLocalStore defaultEBookLocalStore] SaveAllBook];
//    if ([self respondsToSelector:@selector(BeginEndBookReadingNotification:)]) {
//        [self performSelector:@selector(BeginEndBookReadingNotification:) withObject:[notification userInfo] ];
//    }
//
//    if ([self respondsToSelector:@selector(DidEndBookReadingNotification:)]) {
//        [self performSelector:@selector(DidEndBookReadingNotification:) withObject:[notification userInfo] ];
//    }
}
- (void)StartBookReadingNotificationFunction:(NSNotification *)notification{
    //加载图书引擎
    NSDictionary *dir=[notification userInfo];
//    if ([self respondsToSelector:@selector(BeginStartBookReadingNotification:)]) {
//        [self performSelector:@selector(BeginStartBookReadingNotification:) withObject:dir];
//    }
    EbookMangagerTextBookDataEnqin*TextData=nil;
    
    if([[dir objectForKey:@"iswifibook"] boolValue]){//是WiFi图书
        TextData=[[[epubtextdataengine alloc] init] autorelease];
        TextData.bookInfor=dir;
        
        NSArray *paths=
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *bookdisk=[paths objectAtIndex:0];
        
        if([dir objectForKey:localbook]==nil)
        {
            bookdisk=[bookdisk stringByAppendingPathComponent:useruploadpath];
        }
        else
        {
            bookdisk=[bookdisk stringByAppendingPathComponent:localbook];
        }

        bookdisk=[bookdisk stringByAppendingPathComponent:[dir objectForKey:@"name"]];
        //书籍的路径获取章节
        TextData.bookChapterlist=[(epubtextdataengine*)TextData makebookChapterlist:bookdisk ];

    }else{//是网络书籍
    
        if([[dir objectForKey:@"isepub"]boolValue]){
            
            TextData=[[[epubtextdataengine alloc] init] autorelease];
            TextData.bookInfor=dir;
            TextData.bookChapterlist=[(epubtextdataengine*)TextData makebookChapterlist:[[NSString stringWithFormat:@"%@.zip", [[EBookLocalStore defaultEBookLocalStore] GetBookRootPath:dir ]] stringByDeletingPathExtension] ];
            
        }else{
            TextData=[[[EbookMangagerTextBookDataEnqin alloc] init] autorelease];
            TextData.bookInfor=dir;
            TextData.bookChapterlist=[[EBookLocalStore defaultEBookLocalStore] ObtainBookChapterList:dir];
        }

    }

    if ([TextData.bookChapterlist count]>0) {
 
        if([dir objectForKey:@"blbookisreaded"]==nil&& [dir isKindOfClass:[NSMutableDictionary class]]&& [dir respondsToSelector:@selector(setObject:forKey:)]){
            [(NSMutableDictionary*)dir setObject:@"readed" forKey:@"blbookisreaded" ];
            
            NSMutableDictionary*samedic= [[EBookLocalStore defaultEBookLocalStore] samefordic:dir];
            if([samedic objectForKey:@"blbookisreaded"]==nil&& [samedic isKindOfClass:[NSMutableDictionary class]]&& [samedic respondsToSelector:@selector(setObject:forKey:)]){
                
                [samedic setObject:@"readed" forKey:@"blbookisreaded" ];
            }
            [[EBookLocalStore defaultEBookLocalStore] SaveAllBook];
        }
        
        [SimpleTextBookReading ShowSimpleTextBookReadingWithDataEnqin:TextData adsDelegate:self chapterIndexDelegate:nil ParentWindow:self.MainWindow];
        if ([self respondsToSelector:@selector(DidStartBookReadingNotification:)]) {
            [self performSelector:@selector(DidStartBookReadingNotification:) withObject:dir];
        }
        /*百度事件统计,传入的数据为:eventId,eventLabel
         1=其他
         100004=小书城启动次数
         100003=热门推荐点击次数
         100002=强制营销点击次数
         100001=图书阅读次数
         100000=图书下载次数
         */
        if([dir objectForKey:@"name"]!=nil)
        {
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BaiduMobStat-CustomEventNotification"  object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"100001",[dir objectForKey:@"name"], nil]  forKeys:[NSArray arrayWithObjects:@"eventId",@"eventLabel", nil] ]];
        }
    }else{
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                      message:[NSString stringWithFormat:@"《%@》请稍后！",[dir objectForKey:@"name"]]
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil] autorelease];
        [av show];
    }
}

-(void)DidStartBookReadingNotification:(NSDictionary *)dic{
    
    
    if ([dic objectForKey:@"id"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@-%@",@"-100",[dic objectForKey:@"title"]]];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"id"],[dic objectForKey:@"title"]]];
    }
    if([dic objectForKey:@"title"]!=nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"title"] forKey:@"thebookisreading"];
    }
    if ([dic objectForKey:@"title"]!=nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"title"] forKey:@"isReading"];
    }
    
    
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"id"],[dic objectForKey:@"title"]]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"local"];
	[[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"netDic"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloades" object:Nil];
}

- (void)dealloc{
    self.MainViewController=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.leveshade=nil;
    [super dealloc];
}

@end
@implementation SmalleEbookWindow
@synthesize leveyTabBarController,EbookWindow;
+(void)ShowSmallEBook{
     @synchronized(self) {
     @autoreleasepool {
     @try {
    SmalleEbookWindow *NewsView=  [[[SmalleEbookWindow alloc] init] autorelease];
     [NewsView LoadNewWindows];
     }@catch (NSException *exception){}@finally{
         /*百度事件统计,传入的数据为:eventId,eventLabel
          1=其他
          100004=小书城启动次数
          100003=热门推荐点击次数
          100002=强制营销点击次数
          100001=图书阅读次数
          100000=图书下载次数
          */
         [[NSNotificationCenter defaultCenter]  postNotificationName:@"BaiduMobStat-CustomEventNotification"  object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"100004",@"小书城启动", nil]  forKeys:[NSArray arrayWithObjects:@"eventId",@"eventLabel", nil] ]];
     
     }}}
}
-(void)CloseEbookWindow:(NSNotification *)notification{
    [self dismissThisWindows];
}
-(void)LeveyTabBarControllerSelectChangedFunction:(NSNotification *)notification{
    [self ChangebadgeValue];
}
-(void)DidBookReadingNotification{
    [self ChangebadgeValue];
}
-(int)ChangebadgeValue{
    LeveyTabBarItem *barItem=[leveyTabBarController.tabBar BarItemAtIndex:3];
    NSDictionary*dir= [[EBookLocalStore defaultEBookLocalStore] ObtainEBookLocalStoreInfor];
    NSString *badgeValue=[NSString stringWithFormat:@"%d",[[dir objectForKey:@"downcount"] intValue]-[[dir objectForKey:@"reandcount"] intValue]];
    if ([badgeValue intValue]>0) {
        barItem.BadgeValue=badgeValue;  
    }else {
        barItem.BadgeValue=@"";
    }
    return [badgeValue intValue];
}
-(void)LoadNewWindows{
    @autoreleasepool {
    [self retain];
        
        preStatusbarstate=[UIApplication sharedApplication].statusBarHidden;
        [UIApplication sharedApplication].statusBarHidden=YES;
        
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseEbookWindow:) name:@"CloseEbookWindowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeveyTabBarControllerSelectChangedFunction:) name:@"LeveyTabBarControllerSelectChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeveyTabBarControllerSelectChangedFunction:) name:@"EndBookReadingNotification" object:nil];
        
        NSString* device;
        NSString*fangxiang = nil;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            device=@"iPad";
        }
        else
        {
            device=@"iPhone";
        }
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                fangxiang=@"v";
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                fangxiang=@"v";
                break;
            case UIInterfaceOrientationLandscapeLeft:
                fangxiang=@"h";
                break;
            case UIInterfaceOrientationLandscapeRight:
                fangxiang=@"h";
                break;
                
            default:
                
                break;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:device forKey:@"device"];
        [[NSUserDefaults standardUserDefaults]setObject:fangxiang forKey:@"fangxiang"];

    self.EbookWindow =  ((EbookWindowReader*)[UIApplication sharedApplication].delegate).MainWindow ;
    self.MainWindow = EbookWindow;
    [self SetupBookReadNotificatioKeyword:@"SmalleEbook-StartBookReadingNotification"];
    NSMutableArray *TabController=[NSMutableArray arrayWithCapacity:5];

    //1:@"精品推荐"
    bookOnlineViewController *GoodBookPageViewController=  [[[bookOnlineViewController alloc] init] autorelease];
    UINavigationController *GoodBookPageNavigationController = [[UINavigationController alloc] initWithRootViewController:GoodBookPageViewController];
    GoodBookPageNavigationController.navigationBarHidden=YES;
    GoodBookPageViewController.title=@"精品推荐";
    GoodBookPageNavigationController.delegate=self;
    GoodBookPageViewController.TypeID=GoodBookPage;
    [TabController addObject: [GoodBookPageNavigationController  autorelease]]; 


 
        //2:@"热门排行榜"
            bookOnlineViewController *BookPageViewController=  [[[bookOnlineViewController alloc] init] autorelease];
        BookPageViewController.TypeID=PaihangBookPage;
        

        BookPageViewController.TagName=@"paihang.xml";
        BookPageViewController.title=@"热门排行榜";

        UINavigationController *PaihangBookPageNavigationController = [[UINavigationController alloc] initWithRootViewController:BookPageViewController];
        
        PaihangBookPageNavigationController.navigationBarHidden=YES;
        
        [TabController addObject: [PaihangBookPageNavigationController  autorelease]];

        
        //3:@"书库分类"
        bookOnlineViewController *BookPageViewController2=  [[[bookOnlineViewController alloc] init] autorelease];
        BookPageViewController2.TypeID=basepage;
    BookPageViewController2.TagName=@"newpaihang";
        BookPageViewController2.title=nil;
        
        UINavigationController *PaihangBookPageNavigationController2 = [[UINavigationController alloc] initWithRootViewController:BookPageViewController2];
        PaihangBookPageNavigationController2.navigationBarHidden=YES;
        
        
        [TabController addObject: [PaihangBookPageNavigationController2  autorelease]];
        //4:@"下载管理"
        bookTableViewController *DownloadNewsView=  [[[bookTableViewController alloc] init] autorelease];
        UINavigationController *DownloadNavigationController = [[UINavigationController alloc] initWithRootViewController:DownloadNewsView];
        DownloadNavigationController.navigationBarHidden=YES;
        DownloadNavigationController.delegate=self;
        DownloadNewsView.title=@"下载管理";
        [TabController addObject: [DownloadNavigationController autorelease]];
        
//    //5:@"搜索"
    bookOnlineViewController *SearchBookPageController=  [[[bookOnlineViewController alloc] init] autorelease];
    UINavigationController *SearchBookPageNavigationController = [[UINavigationController alloc] initWithRootViewController:SearchBookPageController];
    SearchBookPageNavigationController.navigationBarHidden=YES;
    SearchBookPageNavigationController.delegate=self;
    SearchBookPageController.title=@"搜索";
    SearchBookPageController.TypeID=SearchBookPage;
    
    [TabController addObject:[ SearchBookPageNavigationController  autorelease]]; 
    
 
    self.leveyTabBarController = [[[LeveyTabBarController alloc] initWithViewControllers:TabController imageArray:nil] autorelease];
        self.leveshade=[[[UIView alloc] initWithFrame:EbookWindow.rootViewController.view.bounds] autorelease];
        self.leveshade.backgroundColor=[UIColor clearColor];
        leveyTabBarController.view.frame=CGRectMake(0, EbookWindow.rootViewController.view.bounds.size.height, EbookWindow.rootViewController.view.bounds.size.width, EbookWindow.rootViewController.view.bounds.size.height);
        leveshade.opaque=YES;
        [self.EbookWindow.rootViewController.view addSubview:self.leveshade];
        [self.leveshade addSubview:leveyTabBarController.view];
        

        [UIView animateWithDuration:0.75 animations:^{
            leveyTabBarController.view.frame=CGRectMake(0, 0, EbookWindow.rootViewController.view.bounds.size.width, EbookWindow.rootViewController.view.bounds.size.height);
        }];
        

//    if ([self ChangebadgeValue]>0 ) {
//        self.leveyTabBarController.selectedIndex=3;
//     }
        [self ChangebadgeValue];
    }
}

-(NSMutableArray*)CreateTab{
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
 
}
- (void)dismissThisWindows{
    @autoreleasepool {
        for (UINavigationController *vtc in self.leveyTabBarController.viewControllers) {
            SmalleBasebookViewController *bookView=(SmalleBasebookViewController *)vtc.visibleViewController;
            if ([bookView respondsToSelector:@selector(RemoveAllEventsAndObjects )] ) {
                [bookView RemoveAllEventsAndObjects];
            }
        }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
        [UIApplication sharedApplication].statusBarHidden=preStatusbarstate;
        [UIView animateWithDuration:0.75 animations:^{
            
           leveyTabBarController.view.frame=CGRectMake(0, EbookWindow.rootViewController.view.bounds.size.height, EbookWindow.rootViewController.view.bounds.size.width, EbookWindow.rootViewController.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            [self.leveshade removeFromSuperview];
            [leveyTabBarController.view removeFromSuperview];
            [self release];
        }];
        

        

    }
}
+ (NSMutableDictionary*)BuilteBookStatus:(NSDictionary*)bookinfor{
    
    //@TODO iOS8
    bookinfor = [NSMutableDictionary dictionaryWithDictionary:bookinfor];
    
    if([bookinfor objectForKey:@"url"]==nil&&[bookinfor objectForKey:@"source"]!=nil){
        NSString *tempurl=[bookinfor objectForKey:@"source"];
        if ([tempurl hasPrefix:@"http://"]) {
            [bookinfor setValue:tempurl forKey:@"url"];
        }else{
            [bookinfor setValue:[NSString stringWithFormat:@"%@%@",EbookWebXmlServiceBaseUrl,[bookinfor objectForKey:@"source"]] forKey:@"url"];
        }
    }
    
    if([bookinfor objectForKey:@"name"]==nil&&[bookinfor objectForKey:@"title"]!=nil ){
        [bookinfor setValue:[bookinfor objectForKey:@"title"] forKey:@"name"];
    }
    
    return (NSMutableDictionary *)bookinfor;
}

//使用3号epub书城处理书籍字典的方法：吕
+ (NSMutableDictionary*)BuilteEpubBookStatus:(NSMutableDictionary*)bookinfor{
    
    if([bookinfor objectForKey:@"url"]==nil&&[bookinfor objectForKey:@"source"]!=nil)
    {
        NSString *tempurl=[bookinfor objectForKey:@"source"];
        if ([tempurl hasPrefix:@"http://"]) {
            [bookinfor setValue:tempurl forKey:@"url"];
        }else{
            [bookinfor setValue:[NSString stringWithFormat:@"%@%@",epubWebXmlServiceBaseUrl,[bookinfor objectForKey:@"source"]] forKey:@"url"];
        }
    }
    
    if([bookinfor objectForKey:@"name"]==nil&&[bookinfor objectForKey:@"title"]!=nil )
    {
        [bookinfor setValue:[bookinfor objectForKey:@"title"] forKey:@"name"];
    }
    return bookinfor;
}

+ (NSMutableDictionary*)BuilteBookStatusBaseUrlOne:(NSMutableDictionary*)bookinfor{
    if([bookinfor objectForKey:@"url"]==nil&&[bookinfor objectForKey:@"source"]!=nil)
    {
        NSString *tempurl=[bookinfor objectForKey:@"source"];
        if ([tempurl hasPrefix:@"http://"]) {
            [bookinfor setValue:tempurl forKey:@"url"];
        }else{
            [bookinfor setValue:[NSString stringWithFormat:@"%@%@",EbookWebXmlServiceBaseUrlOne,[bookinfor objectForKey:@"source"]] forKey:@"url"];
        }
    }
    
    if([bookinfor objectForKey:@"name"]==nil&&[bookinfor objectForKey:@"title"]!=nil )
    {
        [bookinfor setValue:[bookinfor objectForKey:@"title"] forKey:@"name"];
    }
    return bookinfor;
}

+(void)Tongji:(NSString*)bookid{
  [[[[DownloadHelper alloc] init] autorelease] download:[NSString stringWithFormat:@"%@/Default.aspx?type=1&id=%@",SearchBaseUrl2,bookid]];
}

+(void)LoadSpecilRowsOnline:(NSString*)SpecilID  delegateTarget:(id<DownloadHelperDelegate>)target{
    DownloadHelper *http= [[[DownloadHelper alloc] init] autorelease];
    http.delegate=target;
    [http download:  [NSString stringWithFormat:@"%@/upload/xml/zhuanti_%@.xml",EbookWebXmlServiceBaseUrl,SpecilID]];
}
+(NSMutableArray*)LoadSpecialRowsOnlocal:(NSString*)SpecilID{
     NSFileManager *fm= [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[NSString stringWithFormat:EBookSpecialListPath,SpecilID]] && [fm fileExistsAtPath:[NSString stringWithFormat:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ebookspeciallist_%@.plist"],SpecilID]]) {
        [fm copyItemAtPath:[NSString stringWithFormat:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ebookspeciallist_%@.plist"],SpecilID]  toPath:[NSString stringWithFormat:EBookSpecialListPath,SpecilID]  error:nil];
    }
   return  [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:EBookSpecialListPath,SpecilID]];
}
+(void)SaveSpecialRowsOnCache:(NSString*)SpecilID row:(NSMutableArray*)Rows{
    if (Rows!=nil && [Rows count]>0) {
     
    [Rows writeToFile:[NSString stringWithFormat:EBookSpecialListPath,SpecilID]  atomically:YES];   
    }
}
- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.leveyTabBarController=nil;
    self.EbookWindow=nil;
    [super dealloc];
}
@end
