
#import "SimpleTextBookReading.h"
#import "BookChapterMangeViewController.h"
#import "UIScreen+Iphone5inch.h"

@implementation Bookreadingcontroller


- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

@end

@implementation SimpleTextBookReading
@synthesize backview;
@synthesize ChapterEnqin,ScrollHPageViewController,CurrentViewController,pageInforView,SettingView,ADSdelegate,BLleavescontrller,rootview,BLpagecontroller,BLpagecontroller2,rightcolor,BLmidsetting,toppic,endpic,AdvanceAds,rootcon;

#pragma mark- 初始化并弹出视图
static bool isopen=NO;
+ (void)ShowSimpleTextBookReadingWithDataEnqin:(id<TextBookReadingDataSourse>)DataEnqinDataSourse adsDelegate:(id<BookReadingADSDelegate>)AdsDelegate chapterIndexDelegate:(id<ChapterIndexChangedDelegate>)ChapterIndexDelegate;{
    UIWindow* window=[[UIApplication sharedApplication].delegate window];
    [SimpleTextBookReading ShowSimpleTextBookReadingWithDataEnqin:DataEnqinDataSourse adsDelegate:AdsDelegate chapterIndexDelegate:ChapterIndexDelegate ParentWindow:window];
}

+ (void)ShowSimpleTextBookReadingWithDataEnqin:(id<TextBookReadingDataSourse>)DataEnqinDataSourse adsDelegate:(id<BookReadingADSDelegate>)AdsDelegate chapterIndexDelegate:(id<ChapterIndexChangedDelegate>)ChapterIndexDelegate ParentWindow:(UIWindow *)parentWindow{
    if(isopen){
        return;
    }
    @synchronized(self) {
    @autoreleasepool {
    @try {
        SimpleTextBookReading *bookreading= [[SimpleTextBookReading alloc] init] ;
        bookreading.ADSdelegate=AdsDelegate;
        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
        //创建页面分析器
        SimpleTextBookReadingForChapter *chapter=[[[SimpleTextBookReadingForChapter alloc] init] autorelease];
    
        chapter.DataSourse=DataEnqinDataSourse;
        chapter.chapterIndexChangedDelegate=ChapterIndexDelegate;
        if (chapter.chapterIndexChangedDelegate &&[(NSObject*)ChapterIndexDelegate respondsToSelector:@selector(DefualtChapterIndex:)]) {
            chapter.CurrenChapterIndex=[chapter.chapterIndexChangedDelegate DefualtChapterIndex: chapter];
        }
        if (chapter.chapterIndexChangedDelegate &&[(NSObject*)ChapterIndexDelegate respondsToSelector:@selector(DefualtPageIndex:)]) {
            chapter.CurrenPageIndex=[chapter.chapterIndexChangedDelegate DefualtPageIndex: chapter];
        }
        bookreading.ChapterEnqin=chapter;
       
        Bookreadingcontroller* rootcontrol=[[[Bookreadingcontroller alloc]init] autorelease] ;
        rootcontrol.view.backgroundColor=[UIColor grayColor];
        bookreading.rootcon=rootcontrol;
        rootcontrol.view.frame= [UIScreen mainScreen].bounds;
        UIView* rootview=[[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds]autorelease ];
        rootview.userInteractionEnabled=YES;
        
        
        if([SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].autofollow==YES)
        {
            BOOL pre=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                switch ([UIApplication sharedApplication].statusBarOrientation) {
                    case UIInterfaceOrientationPortrait:
                        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble=NO;
                        rootview.transform=CGAffineTransformIdentity;
                        rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                        
                        break;
                    case UIInterfaceOrientationPortraitUpsideDown:
                        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble=NO;
                        
                        rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
                        rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                        
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble=YES;
                        rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI/2);
                        rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                        
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble=YES;
                        rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
                        rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                        
                        break;
                    default:
                        break;
                }
                if(pre!=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble)
                {
                    [chapter.AllPageViewArray removeAllObjects];
                    [SimpleTextBookReadingForChapter ClearAllPagesFile];
                }
            }
            else
            {
                if([SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble)
                {
                    rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
                    rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
                }
            }
 
        }else{
            //不自动支持设备方向
            
            if([SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble)
            {
                rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
                rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            }
            
        }
        rootview.backgroundColor=[UIColor grayColor];
        bookreading.rootview=rootview;
        [rootview addSubview:bookreading.view];
        [rootcontrol.view addSubview:rootview];
        UIView *backview=[[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        bookreading.backview=backview;
        UIViewController* windowscontroller=parentWindow.rootViewController;
        [windowscontroller.view addSubview:backview];
        
        [windowscontroller.view addSubview:rootcontrol.view];
        rootcontrol.view.frame=CGRectMake(0, windowscontroller.view.frame.size.height, windowscontroller.view.frame.size.width, windowscontroller.view.frame.size.height);
        rootcontrol.view.opaque=YES;
        [windowscontroller addChildViewController:rootcontrol];
        
        [rootcontrol addChildViewController:bookreading];
        [UIView animateWithDuration:0.5 animations:^{
            rootcontrol.view.frame=CGRectMake(0, 0, windowscontroller.view.frame.size.width, windowscontroller.view.frame.size.height);
        }];
         isopen=YES;
    }
    @catch (NSException *exception) {
        [SimpleTextBookReadingForChapter ClearAllPagesFile];
    }
    @finally {}}}
}



-(id)init{
    if (self=[super init]) {
   
    }
    return self;
}

#pragma mark- 释放
-(void)dealloc{
 
    [rootview release];
    [toppic release];
    [endpic release];
//    [[PublicDATA sharedPublicDATA].iphoneAdView removeFromSuperview];
//    [PublicDATA sharedPublicDATA].iphoneAdView=nil;
    [self.AdvanceAds removeFromSuperview];
    self.AdvanceAds=nil;
    [adshade release];
    [self SafeExit];
    self.CurrentViewController=nil;
    self.BLleavescontrller=nil;
    self.BLpagecontroller=nil;
    self.BLpagecontroller2=nil;
    self.ScrollHPageViewController=nil;
    self.rootcon=nil;
    self.ADSdelegate=nil;
    self.BLmidsetting=nil;
    self.ChapterEnqin=nil;
    [super dealloc];
}
#pragma mark- 安全退出

-(void)exit
{
    [self GotoMainForm:YES];
    
}


- (void)GotoMainForm:(BOOL)isGoMainForm{
    
    [self dismissThisWindow];
}

- (void)dismissThisWindow{
    [UIApplication sharedApplication].statusBarHidden=StatusBarIsHidden;
    [UIView animateWithDuration:0.5 animations:^{
        rootcon.view.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        [rootcon removeFromParentViewController];
        [rootcon.view removeFromSuperview];
        [backview removeFromSuperview];
        [self.ChapterEnqin stopcucu];
        [self SafeExit];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EndBookReadingNotification" object:nil];
        self.BLmidsetting.style=nil;
        self.BLmidsetting.delegate=nil;
        self.BLmidsetting.ChapterEnqin=nil;
        self.BLmidsetting=nil;
         isopen=NO;
        [self release];
     
    }];
}

-(void)SafeExit{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (ChapterEnqin) {
        
        
        
        [self SaveALLData];

        self.ChapterEnqin=nil;

        self.CurrentViewController=nil;

        self.pageInforView=nil;
        self.SettingView=nil;
        
        [paramsDir release];paramsDir=nil;

        self.ScrollHPageViewController=nil;
        
        [self BookReadingExit];
    }
}
-(void)BookReadingExit{
    if (self.ADSdelegate&&[(NSObject*)ADSdelegate respondsToSelector:@selector(BookReadingExit:)]) { 
        self.AdvanceAds=[self.ADSdelegate BookReadingExit:self];
    }
}


-(void)SaveALLData{
    self.ChapterEnqin.CurrenPageIndex=[CurrentViewController getCurrentPageNumber];
    [self.ChapterEnqin SaveAll];
    [[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle] SaveAllSettings];
}
#pragma mark- 显示

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasNet=YES;
    [self loadviewsss];
    
    wallkey=arc4random()%1000;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivewallvip) name:[NSString stringWithFormat:@"reading%d",wallkey] object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointnotenough) name:@"wallvippointnogou" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netConnectChanged) name:@"netConnectChanged" object:nil];//网络连接中断--吕
    
}

- (void)netConnectChanged{
    //网络连接变换--吕
    hasNet=[[PublicDATA sharedPublicDATA] hasNetConnect];
}

- (void)loadviewsss{
    
    StatusBarIsHidden = [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden=YES;
    
    receivead=NO;
    
    style=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
    
    if(style.pageisdouble){
        self.view.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
        pagesi = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));

    }else{
        self.view.frame = [UIScreen mainScreen].bounds;
        pagesi = [UIScreen mainScreen].bounds;

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SaveALLData)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settopandendpic)
                                                 name:@"dayandnightchange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveadd)
                                                 name:@"adsdidreceivead"
                                               object:nil];
    [self settopandendpic];
    
    paramsDir=[[NSMutableDictionary alloc] initWithCapacity:0];
    
    [self judegeuserisvip];
    
    [self loadmidsetview];
    [self ChangeCss];
    self.ChapterEnqin.style=style;
    [self.ChapterEnqin ReloadData];

//    [self setima];
    SimpleTextBookReading* bookread=self;
    
    [style.OperationQueu addOperationWithBlock:^{
        [bookread RebuiltAllPage: [NSNumber numberWithBool:YES]];
    }];
    
    if([self.ChapterEnqin.BookHistory  objectForKey:@"currentstring"]!=nil){
        self.ChapterEnqin.CurrenPageIndex= [self.ChapterEnqin StringIndexToPageIndex: [[self.ChapterEnqin.BookHistory  objectForKey:@"currentstring"] integerValue]];
    }
    
    [self SwitchView:[[style StaticSettinsForKey:@"pagetypeindex"] intValue]];
    [self performSelector:@selector(LazyLoadAds) withObject:nil afterDelay:3.0];
    
}

- (void)judegeuserisvip{
    userisvip=YES;
    return;
//    if([ChapterEnqin.BookHistory objectForKey:@"userisvip"]!=nil ||![[[PublicDATA sharedPublicDATA] GetApplicationConfig:showVipAndIntegralWall] boolValue])
//    {
//        userisvip=YES;
//    }
    
//    if([self.ChapterEnqin.DataSourse respondsToSelector:@selector(bookInfor)]){
//        NSMutableDictionary* bookinfo = [self.ChapterEnqin.DataSourse  bookInfor];
//
//        if([bookinfo isKindOfClass:[NSDictionary class]]&& [[bookinfo objectForKey:@"iswifibook"] boolValue]){
//            userisvip=YES;
//        }
//        if([bookinfo isKindOfClass:[NSMutableArray class]]){
//            userisvip=YES;
//        }
//    }
    
//    [ChapterEnqin savehistory];
}


- (void)settopandendpic{
    NSString* day=@"b";
    if(style.SkinIndex==5){
        day=@"d";
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.toppic=[[[UIImageView alloc]initWithImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iPad_%@_v&h_Alert_1",day]]] autorelease];
        self.endpic=[[[UIImageView alloc]initWithImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iPad_%@_v&h_Alert_2",day]]] autorelease];
    }else{
        self.toppic=[[[UIImageView alloc]initWithImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iPhone_%@_v&h_Alert_1",day]]] autorelease];
        self.endpic=[[[UIImageView alloc]initWithImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iPhone_%@_v&h_Alert_2",day]]] autorelease];
    }
    toppic.center=self.view.center;
    endpic.center=self.view.center;
}


#pragma mark- 加载广告

- (void)LazyLoadAds{
    [self netConnectChanged];
    [self performSelectorOnMainThread:@selector(loadadinmain) withObject:nil waitUntilDone:[NSThread isMainThread]];
}

- (void)loadadinmain{
    [self startAdsMethod];
    if (AdvanceAds) {
        [self.view addSubview:AdvanceAds];
        [self.view insertSubview:AdvanceAds aboveSubview:CurrentViewController.view];
        [self ShowAds];
    }
}

- (void)startAdsMethod{
    if (AdvanceAds==nil && hasNet) {
        [self.AdvanceAds removeFromSuperview];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAdsMethod) object:nil];
        self.AdvanceAds=nil;
        if ([[PublicDATA sharedPublicDATA] ReadyShowAdword]) {
            self.AdvanceAds=[[PublicDATA sharedPublicDATA]loadadview];
            
            [self.view addSubview:AdvanceAds];
            [self.view insertSubview:AdvanceAds aboveSubview:CurrentViewController.view];
        }
    }
}

- (void)ShowAds{
    if (!hasNet) {
        [self.AdvanceAds removeFromSuperview];
        self.AdvanceAds=nil;
        [[PublicDATA sharedPublicDATA] removeAdsViewMethod];

        return;
    }else if (AdvanceAds==nil){
        [self performSelector:@selector(startAdsMethod) withObject:nil afterDelay:NO];
        
    }
    if (AdvanceAds && AdvanceAds.frame.size.width>20) {
        AdvanceAds.frame=CGRectMake((self.view.width-AdvanceAds.frame.size.width)/2.0,  self.view.frame.size.height-AdvanceAds.frame.size.height, AdvanceAds.frame.size.width, AdvanceAds.frame.size.height );
        [self.view addSubview:AdvanceAds];
        [self.view insertSubview:AdvanceAds aboveSubview:CurrentViewController.view];
     
        [self setadshade];
        if(BLmidsetting.showed)
        {
            AdvanceAds.hidden=YES;
            adshade.hidden=YES;
        }
        else {
            AdvanceAds.hidden=NO;
            adshade.hidden=NO;
        }
    }
}

- (void)receiveadd{
    receivead=YES;
    [self setadshade];
}

- (void)setadshade{
    [self performSelectorOnMainThread:@selector(setadshadeinmain) withObject:nil waitUntilDone:[NSThread isMainThread]];
}

- (void)setadshadeinmain{
    if(AdvanceAds!=nil&& receivead){
        AdvanceAds.frame=CGRectMake((self.view.width-AdvanceAds.frame.size.width)/2.0,  self.view.frame.size.height-AdvanceAds.frame.size.height, AdvanceAds.frame.size.width, AdvanceAds.frame.size.height );
        if(adshade==nil){
            adshade=[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-330)/2, self.view.frame.size.height-50, 330, 50)];
            adshade.userInteractionEnabled=NO;
            adshade.backgroundColor=[UIColor blackColor];
            adshade.alpha=0.85;
        }
        
        if(style.SkinIndex==5){
            adshade.frame=CGRectMake((self.view.bounds.size.width-330)/2, self.view.frame.size.height-51, 330, 51);
            [self.view addSubview:adshade];
            [self.view bringSubviewToFront:adshade];
        }else{
            [adshade removeFromSuperview];
        }
    }
    [self.view bringSubviewToFront:BLmidsetting.view];
}

#pragma mark- 加载设置视图

- (void)loadmidsetview{
    if(self.BLmidsetting!=nil){
        [self.BLmidsetting.view removeFromSuperview];
    }
    
    self.BLmidsetting=[[[BLMidSettingView alloc]init] autorelease];
    self.BLmidsetting.view.frame=self.view.bounds;
    self.BLmidsetting.delegate=self;
    self.BLmidsetting.style=style;
	self.BLmidsetting.backgroundview=rootima;
    self.BLmidsetting.showvip=!userisvip;
    BLmidsetting.ChapterEnqin=self.ChapterEnqin;
    [BLmidsetting loadselfview];
}

#pragma mark-设置样式

- (void)ChangeCss{
   
    style.SkinIndex=[[style StaticSettinsForKey:@"skinindex"] intValue];
    RectBounds=[[style StaticSettinsForKey:@"bookBounds"] RangeFromString];
    RectBounds = CGRectMake(RectBounds.origin.x, RectBounds.origin.y, RectBounds.size.width,  [[UIScreen mainScreen] bounds].size.height-RectBounds.size.height-RectBounds.origin.y);

    self.view.autoresizingMask= UIViewAutoresizingNone;
    [self setbookbackground];
    self.BLmidsetting.backgroundview=rootima;
    AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
    self.ChapterEnqin.bookBounds=RectBounds;
    self.ChapterEnqin.textFont=textFont;
    [self ChangedViewControllerCSS];
    UIColor*tmpcolor=[paramsDir objectForKey:@"pageviewbackgroung"] ;
    if (tmpcolor==nil) {
        [self setima];
    }
    if (self.CurrentViewController==self.ScrollHPageViewController) {
        self.ScrollHPageViewController.view.backgroundColor=tmpcolor;
    }
    
}

- (void)setbookbackground{
    return;
//    [rootima removeFromSuperview];
//    rootima=[[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
//
//    if(style.SkinIndex==5)
//    {
//        rootima.backgroundColor=[UIColor blackColor];
//    }
//    else
//    {
//
//    if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
//        if([UIScreen mainScreen].bounds.size.height>490)
//        {
//        rootima.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iphone5/bgimg_%d_h568",style.SkinIndex+1]];
//        }
//        else
//        {
//        rootima.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iphone_h/iphone_h%d_bgimg",style.SkinIndex+1]];
//        }
//    }else {
//        if(style.pageisdouble)
//        {
//            rootima.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/ipad_v/ipad_v%d_bgimg",style.SkinIndex+1]];
//        }
//        else
//        {
//            rootima.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/iPad_h/iPad_h%d_bgimg",style.SkinIndex+1]];
//        }
//    }
//    }
//
//    [self.rootview addSubview:rootima];
//    [self.rootview sendSubviewToBack:rootima];
}

-(void)ChangedViewControllerCSS{
    
if ([[style StaticSettinsForKey:@"pagetypeindex"] intValue]==2) {
        
        if ([self.ScrollHPageViewController.BLpageTest.subviews count]>0 ) {
            for (UIView *tempview in self.ScrollHPageViewController.BLpageTest.subviews) {
                if ([tempview isKindOfClass:[SimpleTextBookView class]]) {
                    [self ApplyNewStyle:(SimpleTextBookView*)tempview PageIndex:self.ChapterEnqin.CurrenPageIndex];
                }
            }
        }
    }
    [self setima];
    CurrentViewController.rightbackgroundcolor=self.rightcolor;
    [CurrentViewController  reload];
}

#pragma mark-slider

-(void)valueChanged:(UISlider*)sender{

}

-(NSRange)GetbuttonSliderValue{
    return NSMakeRange(0, 0);
}


#pragma mark-样式变化

-(void)ButtonClick:(UIButton*)sender{
    
    ischange=YES;
    if (sender.tag>=100 && sender.tag<=102 ) {
        //字体变化
        currentstringpoint= [self CurrenStringIndex];
        NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
        [self.ChapterEnqin.AllPageViewArray removeAllObjects];
        [SimpleTextBookReadingForChapter ClearAllPagesFile];
        [self Changeengine];
        

        AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
        self.ChapterEnqin.bookBounds=RectBounds;
        self.ChapterEnqin.textFont=textFont;
        self.ChapterEnqin.CurrenChapterIndex=currentchap;
        if (currentstringpoint<0) {
            currentstringpoint= self.CurrenStringIndex;
        }
        
        [self.ChapterEnqin ReloadData];
        NSInteger newpageindex=[self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
        self.ChapterEnqin.CurrenPageIndex=newpageindex;
        SimpleTextBookReading* bookread=self;
        
        [style.OperationQueu addOperationWithBlock:^{
            [bookread RebuiltAllPage: [NSNumber numberWithBool:NO]];
        }];
        [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
        
    }  if(sender.tag>=200 && sender.tag<=201 ) {
        //字体大小变化
        NSArray *arr=[[style PublickSettingsForKey:@"textFont"]  componentsSeparatedByString:@"|"];
        int fontsize=17;
        NSArray *fontarr=[[arr objectAtIndex:1] componentsSeparatedByString:@","];
         if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
            fontsize=[[fontarr objectAtIndex:0] intValue];
        }else {
            fontsize=[[fontarr objectAtIndex:1] intValue];
        }
        int num=sender.tag==200?-2:2;
        if ((fontsize+num)<=45 && (fontsize+num)>=10 ) {
            fontsize= fontsize+num;
            if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
                [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],fontsize,[[fontarr objectAtIndex:1] intValue]]];
            }else {
                [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],[[fontarr objectAtIndex:0] intValue],fontsize]];

            }
            
            currentstringpoint= [self CurrenStringIndex];
            NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
            [self.ChapterEnqin.AllPageViewArray removeAllObjects];
            [SimpleTextBookReadingForChapter ClearAllPagesFile];
            [self Changeengine];
            [self.ChapterEnqin.AllPageViewArray removeAllObjects];
            AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
            self.ChapterEnqin.bookBounds=RectBounds;
            self.ChapterEnqin.textFont=textFont;
            self.ChapterEnqin.CurrenChapterIndex=currentchap;
            if (currentstringpoint<0) {
                currentstringpoint= self.CurrenStringIndex;
            }
            
            [self.ChapterEnqin ReloadData];
            NSInteger newpageindex=[self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
            self.ChapterEnqin.CurrenPageIndex=newpageindex;
            SimpleTextBookReading* bookreading=self;
            
            [style.OperationQueu addOperationWithBlock:^{
                [bookreading RebuiltAllPage: [NSNumber numberWithBool:NO]];
            }];

            [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
        }
    }if (sender.tag>=300 && sender.tag<=303 ) {
        //翻页方式变化
        int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
        [self SwitchView: pagetypeindex];
        
        [self.view bringSubviewToFront:BLmidsetting.view];
        
        
    } if (sender.tag>=500 && sender.tag<=505 ) {
        //皮肤方式变化
        [paramsDir removeAllObjects];
        if(YES)
        {
            AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
            
            self.ChapterEnqin.textFont=textFont;
            [self.ChapterEnqin ReloadData];
            
        }
        [self ChangeCss];
        [self setadshade];
        if (self.CurrentViewController==self.BLpagecontroller) {//czk添加，如果是3d翻页，需要传递黑夜模式
            [self.BLpagecontroller viewBackgroudChangedWithIndex:sender.tag];
        }
        
    }if (sender.tag==400 ) {
        NSArray *arr=[[style PublickSettingsForKey:@"textFont"]  componentsSeparatedByString:@"|"];
        [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],19,23]];
        int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
        [self SwitchView: pagetypeindex];
        [paramsDir removeAllObjects];
        [self ChangeCss];
        if (currentstringpoint<0) {
            currentstringpoint= self.CurrenStringIndex;
        }
        [self.ChapterEnqin.AllPageViewArray removeAllObjects];
        [self.ChapterEnqin ReloadData];
        NSInteger newpageindex=[self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
        self.ChapterEnqin.CurrenPageIndex=newpageindex;
        [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
    }
    [self setbookmark];
    ischange=NO;
}


/**
 阅读器修改设置
 */
-(void)changesetting:(int)key{
    
    ischange=YES;
    if (key>=100 && key<=102 ) {
        //字体变化
        currentstringpoint= [self CurrenStringIndex];
        NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
        [self.ChapterEnqin.AllPageViewArray removeAllObjects];
        [SimpleTextBookReadingForChapter ClearAllPagesFile];
        [self Changeengine];
        
        AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
        self.ChapterEnqin.bookBounds=RectBounds;
        self.ChapterEnqin.textFont=textFont;
        self.ChapterEnqin.CurrenChapterIndex=currentchap;
        if (currentstringpoint<0) {
            currentstringpoint= self.CurrenStringIndex;
        }
        
        [self.ChapterEnqin ReloadData];
        NSInteger newpageindex=[self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
        self.ChapterEnqin.CurrenPageIndex=newpageindex;
        SimpleTextBookReading* bookread=self;
        
        [style.OperationQueu addOperationWithBlock:^{
            [bookread RebuiltAllPage: [NSNumber numberWithBool:NO]];
        }];
        [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
        
    }  if(key>=200 && key<=201 ) {
        //字体大小字号变化
        NSArray *arr=[[style PublickSettingsForKey:@"textFont"]  componentsSeparatedByString:@"|"];
        int fontsize=17;
        NSArray *fontarr=[[arr objectAtIndex:1] componentsSeparatedByString:@","];
        if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
            fontsize=[[fontarr objectAtIndex:0] intValue];
        }else {
            fontsize=[[fontarr objectAtIndex:1] intValue];
        }
        int num=key==200?-2:2;
        if ((fontsize+num)<=40 && (fontsize+num)>=10 ) {
            fontsize= fontsize+num;
            if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
                [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],fontsize,[[fontarr objectAtIndex:1] intValue]]];
            }else {
                [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],[[fontarr objectAtIndex:0] intValue],fontsize]];
            }
            
            currentstringpoint= [self CurrenStringIndex];
            NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
            [self.ChapterEnqin.AllPageViewArray removeAllObjects];
            [SimpleTextBookReadingForChapter ClearAllPagesFile];
            [self Changeengine];
            [self.ChapterEnqin.AllPageViewArray removeAllObjects];
            AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
            self.ChapterEnqin.bookBounds=RectBounds;
            self.ChapterEnqin.textFont=textFont;
            self.ChapterEnqin.CurrenChapterIndex=currentchap;
            if (currentstringpoint < 0) {
                currentstringpoint = self.CurrenStringIndex;
            }
            
            [self.ChapterEnqin ReloadData];
            NSInteger newpageindex = [self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
            self.ChapterEnqin.CurrenPageIndex=newpageindex;
            SimpleTextBookReading* bookreading=self;
            
            [style.OperationQueu addOperationWithBlock:^{
                [bookreading RebuiltAllPage: [NSNumber numberWithBool:NO]];
            }];
            
            [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
        }
    }if (key>=300 && key<=303 ) {
        //翻页方式变化
        int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
        [self SwitchView: pagetypeindex];
        
        [self.view bringSubviewToFront:BLmidsetting.view];
        
        
    } if (key>=500 && key<=505 ) {
        //皮肤方式变化
        [paramsDir removeAllObjects];
        if(YES)
        {
            AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
            
            self.ChapterEnqin.textFont=textFont;
            [self.ChapterEnqin ReloadData];
            
        }
        [self ChangeCss];
        [self setadshade];
        if (self.CurrentViewController==self.BLpagecontroller) {//czk添加，如果是3d翻页，需要传递黑夜模式
            [self.BLpagecontroller viewBackgroudChangedWithIndex:key];
        }
        
    }if (key==400 ) {
        NSArray *arr=[[style PublickSettingsForKey:@"textFont"]  componentsSeparatedByString:@"|"];
        [style ChangedPublicksettingsSettinsForKey:@"textFont"  Value:[NSString stringWithFormat:  @"%@|%d,%d",[arr objectAtIndex:0],17,20]];
        int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
        [self SwitchView: pagetypeindex];
        [paramsDir removeAllObjects];
        [self ChangeCss];
        if (currentstringpoint<0) {
            currentstringpoint= self.CurrenStringIndex;
        }
        [self.ChapterEnqin.AllPageViewArray removeAllObjects];
        [self.ChapterEnqin ReloadData];
        NSInteger newpageindex=[self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
        self.ChapterEnqin.CurrenPageIndex=newpageindex;
        [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
    }
    [self setbookmark];
    ischange=NO;
}

#pragma mark-数据刷新

-(void)RebuiltAllPage:(NSNumber*)isfirst{
   BOOL ex;
    @autoreleasepool {
       ex= [self.ChapterEnqin AllData:[isfirst boolValue]];
    }
    if(ex)
    {
    [self performSelector:@selector(RebuiltAllPagemainThread)  onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    }
}


-(void)RebuiltAllPagemainThread{
    {
//        int CurrentPageInAllPageCount=0; 6号 CurrentPageInAllPageCount nerver read
        for (int i=0; i<self.ChapterEnqin.CurrenChapterIndex; i++) {
            if ([self.ChapterEnqin.AllPageViewArray count]>i) {
//                CurrentPageInAllPageCount+=[[self.ChapterEnqin.AllPageViewArray objectAtIndex:i] count];  6号 CurrentPageInAllPageCount nerver read
            }
        }
//        CurrentPageInAllPageCount+=[CurrentViewController getCurrentPageNumber];  6号 CurrentPageInAllPageCount nerver read
    }

}



-(void)Changeengine
{
    NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
    NSMutableArray *bookmark=[[NSMutableArray alloc]initWithArray:[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"] ];
    if (bookmark==nil ) {
        bookmark=[[NSMutableArray alloc ]init];
    }
    [self.ChapterEnqin stopcucu];
    SimpleTextBookReadingForChapter *chapter=[[SimpleTextBookReadingForChapter alloc] init];
    
    
    chapter.DataSourse=self.ChapterEnqin.DataSourse;
    chapter.chapterIndexChangedDelegate=self.ChapterEnqin.chapterIndexChangedDelegate;
    if (chapter.chapterIndexChangedDelegate &&[(NSObject*)self.ChapterEnqin.chapterIndexChangedDelegate respondsToSelector:@selector(DefualtChapterIndex:)]) {
        chapter.CurrenChapterIndex=[chapter.chapterIndexChangedDelegate DefualtChapterIndex: chapter];
    }
    if (chapter.chapterIndexChangedDelegate &&[(NSObject*)chapter.chapterIndexChangedDelegate respondsToSelector:@selector(DefualtPageIndex:)]) {
        chapter.CurrenPageIndex=[chapter.chapterIndexChangedDelegate DefualtPageIndex: chapter];
    }
    [chapter.BookHistory setObject: bookmark forKey:@"bookmark"];
    chapter.CurrenChapterIndex=currentchap;
    self.ChapterEnqin=chapter;
    self.ChapterEnqin.style=style;
    BLmidsetting.ChapterEnqin=self.ChapterEnqin;
    [chapter release];
    [bookmark release];
}


#pragma mark-书签设置

-(void)settingClick:(UIButton*)sender{
    ischange=YES;
    currentstringpoint=-1;
    if(sender.tag==3){
        if (self.SettingView==nil) {
            self.SettingView=[[[NSBundle mainBundle] loadNibNamed:@"BookReadingSetting" owner:self options:nil] objectAtIndex:0];
            self.SettingView.delegate=self;
            //iPad code
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIView *ipadview=[[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
                ipadview.backgroundColor=[UIColor clearColor];
                ipadview.alpha=0.0;
                self.SettingView.left=53;
                [self.view addSubview:ipadview];   
                [ipadview addSubview:self.SettingView];
            } else 
            {
                self.SettingView.alpha = 0.0;
                [self.view addSubview:self.SettingView];   
            }
        }
        self.SettingView.fontischanged=NO;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.view bringSubviewToFront: self.SettingView.superview];
        }else 
        {
            [self.view bringSubviewToFront: self.SettingView];
        }
        [UIView animateWithDuration:0.5 animations:^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.SettingView.superview.alpha = 1.0; 
            } else {
                self.SettingView.alpha = 1.0;  
            }
            
        }];
    }else if(sender.tag==4){
        //书签
        if (havemark ) {
            
            
            havemark=NO;
            
            [self.ChapterEnqin RemoveBookMark:[self.CurrentViewController getCurrentPageNumber]];
            while  ([self.ChapterEnqin BookMarkForPageIndex:[CurrentViewController getCurrentPageNumber]] ){
                
                [self.ChapterEnqin RemoveBookMark:[self.CurrentViewController getCurrentPageNumber]];
                
            }
            
            if([SimpleTextBookReadingStytle  sharedSimpleTextBookReadingStytle].pageisdouble)
            {
            if(self.ChapterEnqin.CurrenPageIndex+1<self.ChapterEnqin.PageCount)
            {
            [self.ChapterEnqin RemoveBookMark:[self.CurrentViewController getCurrentPageNumber]+1];
            
                
                while  ([self.ChapterEnqin BookMarkForPageIndex:[CurrentViewController getCurrentPageNumber]+1] ){
                    
                    [self.ChapterEnqin RemoveBookMark:[self.CurrentViewController getCurrentPageNumber]+1];
                    
                }
            }
            }

           [self.BLmidsetting setbookmark:havemark];

        }else {
            havemark=YES;
            [self.ChapterEnqin AddBookMark:self.CurrenStringIndex];
           [self.BLmidsetting setbookmark:havemark];
        }
    }else if(sender.tag==2){

    }else if(sender.tag==1){
//        [self GotoMainForm:YES];
        [self exit];
    }
    
    ischange=NO;
}
- (void)ChapterIndexChanged:(NSUInteger)index{
    ischange=YES;

    BOOL direc= self.ChapterEnqin.CurrenChapterIndex<index?YES:NO;
    self.ChapterEnqin.CurrenChapterIndex=index;
    [self.ChapterEnqin ReloadData:[NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection: self.ChapterEnqin.CurrenFormalsIndex]];
    self.ChapterEnqin.CurrenPageIndex=0;
    [self JunpToshowNewPage:direc?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES];
//    [self setbookmark];
    ischange=NO;
}

- (void)pageIndexChanged:(NSUInteger)index{
    ischange=YES;
    
    BOOL direc= self.ChapterEnqin.CurrenChapterIndex<index?YES:NO;

    self.ChapterEnqin.CurrenPageIndex=index;
    [self JunpToshowNewPage:direc?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES];
//    [self setbookmark];
    ischange=NO;
}

- (void)BookMarkIndexChanged:(NSDictionary*)bookmarkdir{
    ischange=YES;

    NSInteger tempchapterindex=[[bookmarkdir objectForKey:@"chapterindex"] intValue];
    NSInteger tempstringpoint=[[bookmarkdir objectForKey:@"stringpoint"] intValue];
    BOOL direc= self.ChapterEnqin.CurrenChapterIndex<tempchapterindex?YES:NO;
    self.ChapterEnqin.CurrenChapterIndex=tempchapterindex;
    [self.ChapterEnqin ReloadData:[NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection: self.ChapterEnqin.CurrenFormalsIndex]];
    ChapterEnqin.CurrenPageIndex=[self.ChapterEnqin StringIndexToPageIndex:tempstringpoint];
    [self.ChapterEnqin ReloadData:[NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection: self.ChapterEnqin.CurrenFormalsIndex]];
    [self JunpToshowNewPage:direc?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES];
    [self setbookmark];
    ischange=NO;
}

-(void)BLMidclicked
{
    

}


- (void)Changedirection{
    
     BOOL pre=style.pageisdouble;
    
    CGRect  rec=[UIScreen mainScreen] .bounds;
    float  width=rec.size.width;
    float  height=rec.size.height;
    
    if([self isdefaultchange]){
        [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble=![SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble;
        if([SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble){
            rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
            rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
           
            
            self.view.frame=CGRectMake(0, 0, height, width);
        }else{
            rootview.transform=CGAffineTransformIdentity;
            rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            self.view.frame=CGRectMake(0, 0, width, height);
        }
    }else{
        if([UIDevice currentDevice].orientation==UIDeviceOrientationPortraitUpsideDown||[UIDevice currentDevice].orientation==UIDeviceOrientationPortrait){
            style.pageisdouble=NO;
            
        }else{
            style.pageisdouble=YES;
        }
        
        
        if([SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle].pageisdouble){
            int ket=1;
            if([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
                ket=-1;
            }
        
            rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, ket*M_PI/2);
            rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            self.view.frame=CGRectMake(0, 0, height, width);
        }else{
            int ket=0;
            if([UIDevice currentDevice].orientation==UIDeviceOrientationPortraitUpsideDown)
            {
                ket=1;
            }
            rootview.transform=CGAffineTransformRotate(CGAffineTransformIdentity, ket*M_PI);
            rootview.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            self.view.frame=CGRectMake(0, 0, width, height);
        }
    }

    if(pre==style.pageisdouble){
        return;
    } 
    UIViewController* cat=self.BLmidsetting;
    [cat retain];
    [self loadmidsetview];
    [self.pageInforView removeFromSuperview];
    
    if(style.pageisdouble){
        pagesi = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
    }else{
        pagesi = [UIScreen mainScreen].bounds;
    }
    
    self.pageInforView=nil;
    toppic.center=self.view.center;
    endpic.center=self.view.center;
    
    currentstringpoint= [self CurrenStringIndex];
    NSInteger currentchap=self.ChapterEnqin.CurrenChapterIndex;
    [paramsDir removeAllObjects];
    
    [self.ChapterEnqin.AllPageViewArray removeAllObjects];
    [SimpleTextBookReadingForChapter ClearAllPagesFile];
    [self Changeengine];
    [self ChangeCss];
//    [self setima];
    self.ChapterEnqin.CurrenChapterIndex=currentchap;
    [self.ChapterEnqin ReloadData];
    NSInteger newpageindex = [self.ChapterEnqin StringIndexToPageIndex: currentstringpoint];
    self.ChapterEnqin.CurrenPageIndex=newpageindex;
    SimpleTextBookReading* bookread=self;
    
    [style.OperationQueu addOperationWithBlock:^{
        [bookread RebuiltAllPage: [NSNumber numberWithBool:NO]];
    }];
    [self SwitchView:[[style StaticSettinsForKey:@"pagetypeindex"] intValue]];
    AdvanceAds.frame=CGRectMake(AdvanceAds.frame.origin.x, self.view.frame.size.height-110, AdvanceAds.frame.size.width, AdvanceAds.frame.size.height);
    [cat.view removeFromSuperview];
    [cat autorelease];
    [self  handleSingleTap:nil];
    [self setadshade];
}

#pragma mark-更换阅读样式

-(void)SwitchView:(int)viewType{
    if (viewType<0 ||viewType>3) {
        return;
    }
    currentstringpoint=-1;
    UITapGestureRecognizer* singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)] autorelease];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired=1;
    singleTap.cancelsTouchesInView = NO;
    
    [CurrentViewController.view removeFromSuperview];
    switch (viewType) {
        case 0:
        {
            [self.BLpagecontroller.view removeFromSuperview];
            [self.BLpagecontroller removeFromParentViewController];
            self.BLpagecontroller=[[[ BLpageContrller  alloc]initandsetpageisdouble:NO frame:pagesi rightcolor:self.rightcolor]  autorelease];
            self.BLpagecontroller.CustomDataSourceDelegate = self;
            self.BLpagecontroller.midclickdelegate=self;
            self.BLpagecontroller.view.frame=pagesi;
            
            [self.view addSubview:BLpagecontroller.view];
            [BLpagecontroller.view addGestureRecognizer:singleTap];
            [self addChildViewController:self.BLpagecontroller];
            [self.BLpagecontroller viewBackgroudChangedWithIndex:style.SkinIndex+500];
            if (!isfisrt) {
                [self.view insertSubview:self.BLpagecontroller.view  aboveSubview:self.view];
            }
            [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward animated:NO];
            
                    
                    [self.ScrollHPageViewController removeFromParentViewController];
                    [self.ScrollHPageViewController.view removeFromSuperview];
                    self.ScrollHPageViewController=nil;
                    [self.BLpagecontroller2 removeFromParentViewController];
                    [self.BLpagecontroller2.view removeFromSuperview];
                    self.BLpagecontroller2=nil;
 
            self.CurrentViewController= self.BLpagecontroller;
        }
            break;
        case 2:{
            [self.ScrollHPageViewController.view removeFromSuperview];
            [self.ScrollHPageViewController removeFromParentViewController];
            
                self.ScrollHPageViewController=[[[ScrollPageViewController alloc] initandsetpageisdouble:NO frame:pagesi rightcolor:self.rightcolor] autorelease];
            self.ScrollHPageViewController.CustomDataSourceDelegate = self;
            self.ScrollHPageViewController.midclickdelegate=self;
                self.ScrollHPageViewController.view.frame=pagesi;
            self.ScrollHPageViewController.rightbackgroundcolor=self.rightcolor;
            [self.view addSubview:self.ScrollHPageViewController.view];
            ScrollHPageViewController.view.clipsToBounds=YES;
            [ScrollHPageViewController.view addGestureRecognizer:singleTap];
                [self addChildViewController:self.ScrollHPageViewController];
                if (!isfisrt) {
                    [self.view insertSubview:self.ScrollHPageViewController.view  aboveSubview:self.view];}
                [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward  animated:NO];
            
            
                    [self.BLleavescontrller removeFromParentViewController];
                    [self.BLleavescontrller.view removeFromSuperview];
                    self.BLleavescontrller=nil;
                    
                    [self.BLpagecontroller2 removeFromParentViewController];
                    [self.BLpagecontroller2.view removeFromSuperview];
                    self.BLpagecontroller2=nil;
                    
                    [self.BLpagecontroller removeFromParentViewController];
                    [self.BLpagecontroller.view removeFromSuperview];
                    self.BLpagecontroller=nil;
            self.CurrentViewController= self.ScrollHPageViewController;
            //@TODO 左右快滑动bug修复
            if (rootima==nil) {
                [self setima];
                UIColor*col=  [paramsDir objectForKey:@"pageviewbackgroung"] ;
                self.CurrentViewController.view.backgroundColor=col;
            }

        }
            break;
        case 1:
            [self.BLleavescontrller.view removeFromSuperview];
            [self.BLleavescontrller removeFromParentViewController];
            
            self.BLleavescontrller=[[[ BLLeavesController  alloc]initandsetpageisdouble:NO frame:pagesi rightcolor:self.rightcolor]  autorelease];
            self.BLleavescontrller.CustomDataSourceDelegate = self;
            self.BLleavescontrller.midclickdelegate=self;
            self.BLleavescontrller.view.frame=pagesi;
            self.BLleavescontrller.rightbackgroundcolor=self.rightcolor;
            [self.view addSubview:BLleavescontrller.view];
            [BLleavescontrller.view addGestureRecognizer:singleTap];
            [self addChildViewController:self.BLleavescontrller];
            if (!isfisrt) {
                [self.view insertSubview:self.BLleavescontrller.view  aboveSubview:self.view];
            }
            [self JunpToshowNewPage:UIPageViewControllerNavigationDirectionForward animated:NO];
            
                    [self.ScrollHPageViewController removeFromParentViewController];
                    [self.ScrollHPageViewController.view removeFromSuperview];
                    self.ScrollHPageViewController=nil;
                    
                    [self.BLpagecontroller2 removeFromParentViewController];
                    [self.BLpagecontroller2.view removeFromSuperview];
                    self.BLpagecontroller2=nil;
                    
                    [self.BLpagecontroller removeFromParentViewController];
                    [self.BLpagecontroller.view removeFromSuperview];
                    self.BLpagecontroller=nil;
            self.CurrentViewController= self.BLleavescontrller;
            break;
        default:
            break;
    }    
    [self setbookmark];
    isfisrt=YES;

    BLmidsetting.background2=CurrentViewController.view;
    [self performSelector:@selector(bringSubviewToFront) withObject:nil afterDelay:0.25];
}
-(void)bringSubviewToFront{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.SettingView.superview.alpha==1.0) {
            [self.view bringSubviewToFront:self.SettingView.superview]; 
        }
    }else {
        if (self.SettingView.alpha==1.0) {
            [self.view bringSubviewToFront:self.SettingView]; 
        }
    }
    
}




-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    adshade.hidden=YES;
    AdvanceAds.hidden=YES;
    self.ChapterEnqin.CurrenPageIndex=[CurrentViewController getCurrentPageNumber];
    BLmidsetting.background2=CurrentViewController.view;
    @try {
        [self.view addSubview:BLmidsetting.view];
        [self.view bringSubviewToFront:BLmidsetting.view];
        [BLmidsetting show];
        [self setbookmark];
    if (self.ChapterEnqin.isStop) {
            NSInteger CurrentPageInAllPageCount = 0;
            for (int i=0; i<self.ChapterEnqin.CurrenChapterIndex; i++) {
                if ([self.ChapterEnqin.AllPageViewArray count]>i) {
                    CurrentPageInAllPageCount += [(NSArray* )[self.ChapterEnqin.AllPageViewArray objectAtIndex:i] count];
                }
            }
            CurrentPageInAllPageCount+=[CurrentViewController getCurrentPageNumber];
        

    }
    [self ShowAds];
    }
    @catch (NSException *exception) {
       
    }
    @finally {
        
    }
}




-(void)setbookmark
{
    if ([self.ChapterEnqin BookMarkForPageIndex:[CurrentViewController getCurrentPageNumber]] ){
        havemark=YES;
    }else {
        havemark=NO;

    }
[self.BLmidsetting setbookmark:havemark];
}

-(void)JunpToshowNewPage:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated{
    
    
    //    [self.CurrentViewController JunpToshowNewPage:direction jumpIndex:self.ChapterEnqin.CurrenPageIndex animated:animated];
    
    if ([[style StaticSettinsForKey:@"pagetypeindex"] intValue]==0) {
        [self.BLpagecontroller JunpToshowNewPage: direction jumpIndex:self.ChapterEnqin.CurrenPageIndex animated: animated];
        
    }
    if ([[style StaticSettinsForKey:@"pagetypeindex"] intValue]==1) {
        [self.BLleavescontrller JunpToshowNewPage: direction jumpIndex:self.ChapterEnqin.CurrenPageIndex animated: animated];
    }
    if ([[style StaticSettinsForKey:@"pagetypeindex"] intValue]==2) {
        [self.ScrollHPageViewController JunpToshowNewPage:self.ChapterEnqin.CurrenPageIndex];
    }
    if ([[style StaticSettinsForKey:@"pagetypeindex"] intValue]==3) {
        
        [self.BLleavescontrller JunpToshowNewPage: direction jumpIndex:self.ChapterEnqin.CurrenPageIndex animated: animated];
    }
    
    
}

#pragma mark-创建页面

-(void)ApplyNewStyle:(SimpleTextBookView *)AfterView  PageIndex:(NSInteger)pageIndex{
    
    
    if(BLmidsetting.showed && !ischange)
    {
        [self.BLmidsetting anidisappear];
    }
    self.pageInforView.hidden=YES;
    [self.view sendSubviewToBack:self.pageInforView];
    [self ShowAds];
    
    
    if ([paramsDir objectForKey:@"pageviewbackgroung"]==nil)
    {
        [self setima];
    }
    if ([paramsDir objectForKey:@"titleFont"]==nil) {
        [paramsDir setObject:[[style PublickSettingsForKey:@"titleFont"] AdvanceFontFromString:style.SkinIndex]  forKey:@"titleFont"] ;
    }
    if ([paramsDir objectForKey:@"footFont"]==nil) {
        [paramsDir setObject:[[style PublickSettingsForKey:@"footFont"] AdvanceFontFromString:style.SkinIndex]  forKey:@"footFont"] ;
    }
    AdvanceFont *titleFont=[paramsDir objectForKey:@"titleFont"] ;
    AdvanceFont *footFont = [paramsDir objectForKey:@"footFont"];
    AfterView.ChapterTitleView.font=titleFont.textFont;
    AfterView.ChapterTitleView.textColor=titleFont.textColor ;
    
    
    AfterView.ChapterFootView.font=footFont.textFont;
    AfterView.ChapterFootView.textColor=footFont.textColor ;
    
    if(self.ChapterEnqin.isepub){
        
        [self.ChapterEnqin setbookconntent:AfterView forpage:pageIndex];
        
    }else{
        [self.ChapterEnqin setCustomebookconntent:AfterView forpage:pageIndex];
        
    }
    
    AfterView.backgroundColor=[paramsDir objectForKey:@"pageviewbackgroung"];
    
    [AfterView.ChapterTitleView setText:[self.ChapterEnqin TitleForChapterIndex:  self.ChapterEnqin.CurrenChapterIndex]];
    
    if(self.ChapterEnqin.AllPageCount!=0 &&self.ChapterEnqin.isStop)
    {
        float one=((float)(pageIndex+1+[self ChaptersToPages:self.ChapterEnqin.CurrenChapterIndex] ));
        float two=((float)self.ChapterEnqin.AllPageCount);
        
        float key=one/two;
        
        [AfterView.ChapterFootView setText: [NSString stringWithFormat:@"%3.0f%%",key*100 ]];
    }
    else
    {
        [AfterView.ChapterFootView setText:nil];
    }
    
    
}
-(SimpleTextBookView*)CreateTextBookView:(NSInteger)pageIndex{
    SimpleTextBookView *AfterView;
    
    AfterView=[[SimpleTextBookView alloc] initWithFrame:CGRectMake(0, 0, pagesi.size.width ,pagesi.size.height)] ;
    
    [AfterView setBookBounds:RectBounds];
    
    
    [self ApplyNewStyle:AfterView PageIndex: pageIndex];
    
    return   [AfterView autorelease];
    
    
}
-(UIViewController*)CreateUIViewController:(SimpleTextBookView*)AfterView{
    
    
    UIViewController *AfterViewController= [[[UIViewController alloc] init] autorelease];
    AfterViewController.view=AfterView;
    return   AfterViewController;
}
#pragma mark - CustomPageViewControllerdelegate

- (BOOL)useraskfornextchapter{
    listjump=NO;
    
    if(userisvip)
    {
        userlocked=NO;
        return NO;
    }
    
    if(self.ChapterEnqin.CurrenChapterIndex+1> [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:0]*novippercent)
    {
        userlocked=YES;
        [self showvipask];
        return YES;
    }
    
    return NO;
}

-(BOOL)useraskforchapter:(int)index
{
    listjump=YES;
    jumplist=index;
    //取消积分墙 -吕
    userlocked=NO;
    return NO;
    //////////////
    /*
     //最初小白的写法
     if(userisvip)
     {
     userlocked=NO;
     return NO;
     }
     if(index> [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:0]*novippercent)
     {
     userlocked=YES;
     [self showvipask];
     return YES;
     }
     return NO;
     */
}
//-(void)didReceiveMogoWallConfig
//{
//    receivewall=YES;
//
//}

-(void)showvipask
{
    
    
    //    [AdsWall readingSpend:wallkey];
    
}

-(void)receivewallvip
{
    userisvip=YES;
    userlocked=NO;
    [ChapterEnqin.BookHistory setObject:@"dd" forKey:@"userisvip"];
    userisvip=YES;
    [ChapterEnqin savehistory];
    
    //    [ChapterEnqin savehistory];
    
    BLmidsetting.showvip=NO;
    [BLmidsetting reloadbooklist];
    if(listjump)
    {
        [self ChapterIndexChanged:jumplist];
        
        [BLmidsetting chooselistaction];
        
    }
    
}

-(void)pointnotenough
{
    
    //    LeftViewController *leftViewCon;
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //        leftViewCon=[[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    //    }else{
    //        leftViewCon=[[LeftViewController alloc] initWithNibName:@"LeftViewController_ipad" bundle:nil];
    //    }
    //
    //    UIWindow* window=[[UIApplication sharedApplication].delegate window];
    //
    //
    //    [window.rootViewController presentModalViewController:leftViewCon animated:YES];
    //    [leftViewCon startShow];
    //    [leftViewCon release];
}

//-(id)adsWallNeedController
//{
//    return self;
//}//您需要将一个viewcontroller作为返回值
//-(void)didGetThePoint:(int)aPoint
//{
//    NSLog(@"point:%d",aPoint);
//}//取积分操作回调,返回总积分
//-(void)didRefreshThePoint:(int)aPoint
//{
//NSLog(@"fresh point:%d",aPoint);
//}//刷新积分操作回调,返回总积分
//-(void)didChangedThePoint:(int)aPoint andChangedPoint:(int)aCpoint
//{
//    NSLog(@"change : %d  %d",aPoint,aCpoint);
//}
//加减积分回调,返回总积分并且返回改变的积分,如果加 10 分则返回 10,减 10 分则返回 20。

-(UIView*)CustomPageView:(BLpageScrollview*)pageViewController  viewForPageAtIndex:(NSInteger)index{
    
    SimpleTextBookView *AfterView;
    if(style.pageisdouble){
        AfterView=[self CreateTextBookView:index];
    }else{
        AfterView=( SimpleTextBookView *)[pageViewController  dequeueReusablePage];
        if(AfterView==nil || ![AfterView isKindOfClass:[SimpleTextBookView class]])
        {
            AfterView=[self CreateTextBookView:index];
        }else {
            
            [self ApplyNewStyle:AfterView PageIndex: index] ;
        }
    }
    return AfterView ;
}

- (UIViewController*)CustomPageViewController:(CustomPageViewController*)pageViewController  viewForPageAtIndex:(unsigned  int)index{
    
    return [self CreateUIViewController:[self CreateTextBookView:index]];
}

- (NSInteger)GetMainCurrentPageIndex:(BLpageScrollview*)pageViewController{
    return [CurrentViewController getCurrentPageNumber];
}

- (NSInteger)numberOfPages:(id)pageViewController{
    return self.ChapterEnqin.PageCount;
}

-(void)CustomPageViewReachEnd:(id)pageViewController{
    if(userlocked){return;}
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disappertopendpic) object:nil];
    
    [self.view addSubview:endpic];
    [self performSelector:@selector(disappertopendpic) withObject:nil afterDelay:0.5];
    
    
    
    
}

-(void)CustomPageViewReachBegain:(id)pageViewController{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disappertopendpic) object:nil];
    
    [self.view addSubview:toppic];
    [self performSelector:@selector(disappertopendpic) withObject:nil afterDelay:0.5];
    
    
}

-(void)disappertopendpic
{
    [toppic removeFromSuperview];
    [endpic removeFromSuperview];
}

-(NSInteger)NextChapter{
    if ((self.ChapterEnqin.CurrenChapterIndex+1)<self.ChapterEnqin.ChapterCount) {
        self.ChapterEnqin.CurrenChapterIndex++;
        [self.ChapterEnqin ReloadData:[NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection: self.ChapterEnqin.CurrenFormalsIndex]];
        return [self numberOfPages:self];
    }
    return -1;
}

-(NSInteger)PrevChapter{
    if ((self.ChapterEnqin.CurrenChapterIndex-1)>=0) {
        self.ChapterEnqin.CurrenChapterIndex--;
        [self.ChapterEnqin ReloadData:[NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection: self.ChapterEnqin.CurrenFormalsIndex]];
        return [self numberOfPages:self];
    }
    return -1;
}






-(CGImageRef)getimagRef:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image.CGImage;
}


-(void)setima
{
    //   NSString* basepath= [NSBundle mainBundle].resourcePath;  //7. 7号   basepath nerver read
    
    
    
    
    if(style.SkinIndex==5)
    {
        [paramsDir setObject:[UIColor colorWithRed:14/255.0 green:14/255.0 blue:14/255.0 alpha:1.0]  forKey:@"pageviewbackgroung"] ;
        return;
    }
    if(style.SkinIndex==4)
    {
        [paramsDir setObject:[UIColor whiteColor]  forKey:@"pageviewbackgroung"] ;
        return;
    }
    
    NSString*device=nil;
    NSString*devicemode=nil;
    
    if(style.pageisdouble)
    {
        devicemode=@"h";
    }
    else
    {
        devicemode=@"v";
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        device=@"iPad";
    }
    else
    {
        device=@"iPhone";
    }
    BOOL  is5=NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height>490)
    {
        is5=YES;
    }
    UIColor* cor=nil;
    
    
    
    
    if(is5)
    {
        cor=  [UIColor colorWithPatternImage:[UIImage catchimagenamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pagecor%d_568",device,devicemode,style.SkinIndex ]]];
    }
    else
    {
        cor=  [UIColor colorWithPatternImage:[UIImage catchimagenamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pagecor%d",device,devicemode,style.SkinIndex ]]];
    }
    
    
    if(cor==nil)
    {
        cor=[UIColor grayColor];
    }
    
    [paramsDir setObject:cor  forKey:@"pageviewbackgroung"] ;
    
}

#pragma mark- 手势管理



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(MidAreaClick) object:nil];
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.x>(self.view.bounds.size.width/4.0) && touchPoint.x<=3*(self.view.bounds.size.width/4.0) && touchPoint.y>=(self.view.bounds.size.height/4.0)&& touchPoint.y<=(self.view.bounds.size.height/4.0)*3 ){
            
            return YES;
        }
    }
    
    return NO;
}
#pragma mark- 辅助功能

-(NSInteger)ChaptersToPages:(NSInteger)chapterindex{
    NSInteger allpage=0;
    for (int i=0; i<chapterindex; i++) {
        if ([self.ChapterEnqin.AllPageViewArray count]>chapterindex) {
            NSArray *arr=[self.ChapterEnqin.AllPageViewArray objectAtIndex:i];
            allpage+=[arr count];
        }
    }
    return allpage;
}

-(NSInteger)CurrenStringIndex{
    NSInteger stringpoint=0;
    
    stringpoint= [self.ChapterEnqin CurrenStringIndex:[self.CurrentViewController getCurrentPageNumber]];
    return stringpoint;
}


-(float)transformtopi:(CGAffineTransform)tran
{
    if(tran.a==1.0 && tran.b==0 && tran.c==0 && tran.d ==1)
    {
        return 0;
    }
    else
        if(tran.a==-1.0 && tran.b==0 && tran.c==0 && tran.d ==-1)
        {
            return M_PI;
        }
        else
            if(tran.a==0 && tran.b==1 && tran.c==-1 && tran.d ==0)
            {
                return M_PI/2;
            }
            else
                if(tran.a==0 && tran.b==-1 && tran.c==1 && tran.d ==0)
                {
                    return -M_PI/2;
                }
    return 0;
    
}
-(CGAffineTransform)getcurrenttrans
{
    UIInterfaceOrientation inta=    [UIApplication  sharedApplication].statusBarOrientation;
    
    if (inta == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI/2);
    } else if(inta == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if(inta == UIInterfaceOrientationPortraitUpsideDown){
        return CGAffineTransformMakeRotation(M_PI);
    } else{
        return CGAffineTransformIdentity;
    }
    
    
}
-(CGAffineTransform)getcurrentdevicetrans
{
    UIInterfaceOrientation inta=    [UIDevice currentDevice].orientation;
    
    if (inta == UIDeviceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(-M_PI/2);
    } else if(inta == UIDeviceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if(inta == UIDeviceOrientationPortraitUpsideDown){
        return CGAffineTransformMakeRotation(M_PI);
    } else{
        return CGAffineTransformIdentity;
    }
    
    
}

-(BOOL)isdefaultchange
{
    if( [UIDevice currentDevice].orientation== UIDeviceOrientationFaceUp ||
       [UIDevice currentDevice].orientation==UIDeviceOrientationFaceDown || [UIDevice currentDevice].orientation==UIDeviceOrientationUnknown)
    {
        return YES;
    }
    
    
    if([self transformtopi:rootview.transform]==[self transformtopi:[self getcurrentdevicetrans]])
    {
        return YES;
    }
    return NO;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end;


