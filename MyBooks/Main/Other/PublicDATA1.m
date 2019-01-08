#import "PublicDATA1.h"
//#import "CloudReview.h"
//#include "ipAddress.h"
#import "ASIHTTPRequest.h"
#import "XMLDownLoad.h"
#import "EBookLocalStore.h"
#import <CoreLocation/CoreLocation.h>

#define kAdViewPortraitRect CGRectMake(0, ScreenHeight, kBaiduAdViewSizeDefaultWidth, kBaiduAdViewSizeDefaultHeight)
@implementation NSString (ExAdditions)
- (NSDate * )NSStringToNSDate
{   
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss ZZZ"];
	NSDate  *date = [formatter dateFromString :self ];
	[formatter release];
	return date;
}
+ (NSDate * )NSStringToNSDate: (NSString * )string
{   
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss ZZZ"];
	NSDate  *date = [formatter dateFromString :string ];
	[formatter release];
	return date;
}
@end
@implementation PublicDATA
static PublicDATA * sharedPublicDATAInstance = nil;
@synthesize dldHelper;
//@synthesize dictionary,reach;
//@synthesize adsView;
//@synthesize iphoneFullAdView,ipadFullAdView;
-(BOOL)ReadyShowAdsInShelf{
    BOOL re=YES;
    NSDate *selectDate=[@"2014-09-23  00:00:00 +0000"  NSStringToNSDate];
    if ([[NSDate date] compare: selectDate] ==NSOrderedAscending){
        re=NO;
    }
    return re;
}

-(void)setStars{
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * _path = [NSString stringWithFormat:@"%@%@",documentPath, @"hasPingjia.removeAdsViewMethodplist"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mark"] || [[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        return;
    }
    if ([self GetApplicationConfig:showEvaluateTimes].length>4) {
        [self getDate];
    }else{
        [self isLocal];
    }
}
-(void)isLocal{
    //判断是否开启定位
    if ([[[self GetApplicationConfig:showEvaluateAreasControl] lowercaseString] isEqualToString:@"yes"]) {
        [self performSelectorOnMainThread:@selector(startLocalMethod) withObject:nil waitUntilDone:YES];
    }else{
        [self showEvaluateMethod];
    }
}
-(void)startLocalMethod{
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorized) {
        [self showEvaluateMethod];
        return;
    }
//开始定位
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//初始化定位器
    [locationManager setDelegate: self];//设置代理
    [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];//设置精确度
    [locationManager startUpdatingLocation];//开启位置更新
    CLLocationDegrees latitude = locationManager.location.coordinate.latitude; //float也行，获得当前位置的纬度.location属性获
    CLLocationDegrees longitude = locationManager.location.coordinate.longitude;
    CLLocationCoordinate2D mylocation;
    mylocation.latitude=latitude;
    mylocation.longitude=longitude;
    [self showWithlocation:mylocation];
}
- (void)showWithlocation:(CLLocationCoordinate2D)location {
    
    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];
    
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
        
        for (CLPlacemark *placemark in place) {
            
            NSString *State=[placemark.addressDictionary objectForKey:@"State"];
            BOOL hasCity=NO;
            if ([self closeCityArr]!=nil) {
                for (int i=0; i<[self closeCityArr].count; i++) {
                    if ([State hasPrefix:[[self closeCityArr] objectAtIndex:i]]) {
                        hasCity=YES;
                        break;
                    }
                }
            }
            if (!hasCity) {
                [self showEvaluateMethod];
            }
            
            break;
            
        }
    };
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
}
-(void)showEvaluateMethod{
    
//    [[CloudReview sharedReview] reviewFor:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"] intValue]];
    
}
-(NSArray *)closeCityArr{
    
    NSString *closeStr=[self GetApplicationConfig:evaluateAreas];
    if (closeStr.length>1) {
        return [closeStr componentsSeparatedByString:@","];
    }
    return nil;
}
-(void)getDate{
   
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSString *showEvalueTimes=[NSString stringWithFormat:@"%d-%d-%d %@",year,month,day,[self GetApplicationConfig:showEvaluateTimes]];
    
    comps =[calendar components:(NSHourCalendarUnit |NSMinuteCalendarUnit)fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute=[comps minute];
    NSString *currentTime=[NSString stringWithFormat:@"%d-%d-%d %d:%d",year,month,day,hour,minute];//当前时间
    NSArray *timesArr=[[self GetApplicationConfig:showEvaluateTimes] componentsSeparatedByString:@":"];
    NSInteger showhour=[[timesArr objectAtIndex:0] intValue];
    NSInteger showMinute=[[timesArr objectAtIndex:1] intValue];
    if (hour>showhour ) {
        return;
    }else if (hour==showhour){
        if (minute>showMinute) {
            return;
        }
    }
    NSDateFormatter *dates=[[[NSDateFormatter alloc] init] autorelease];
    [dates setTimeStyle:NSDateFormatterMediumStyle];
    [dates setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *d=[dates dateFromString:showEvalueTimes];
    showTimes=[d timeIntervalSince1970]*1;
    NSDate *dat=[dates dateFromString:currentTime];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=showTimes-now;
    if (cha>0) {
        NSTimer* timer=[[[NSTimer alloc] initWithFireDate:d interval:cha target:self selector:@selector(dohaoping) userInfo:nil repeats:NO] autorelease];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes ];
    }

}

-(void)dohaoping{
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit)fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute=[comps minute];
    NSString *currentTime=[NSString stringWithFormat:@"%d-%d-%d %d:%d",year,month,day,hour,minute];//当前时间

    NSDateFormatter *dates=[[[NSDateFormatter alloc] init] autorelease];
    [dates setTimeStyle:NSDateFormatterMediumStyle];
    [dates setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *d=[dates dateFromString:currentTime];
    NSTimeInterval now=[d timeIntervalSince1970]*1;
    NSTimeInterval cha=now-showTimes;
    if (cha<600) {
        [self isLocal];
    }
}
//位置更新，重新定位时候调用
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    // 停止位置更新
    [manager stopUpdatingLocation];
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"error:%@",error);
}

+ (PublicDATA *)sharedPublicDATA {
    //用于单线程
    @synchronized(self) {
        if (sharedPublicDATAInstance == nil) {
            sharedPublicDATAInstance=[[self alloc] init]; // assignment not done here
            
        }
    }
    return sharedPublicDATAInstance;
}
//广告部分开始
//移除广告
-(void)removeAdsViewMethod{
    if (adsView!=nil) {
        adsView=nil;
    }
}
//请求广告
-(UIView*)loadadview
{
//    if (adsView!=nil&&showBaiduAds&&usControlBaidu) {
//        [self startBaduRequest];
//    }
//
//    if (adsView==nil && hasNet) {
//        if (showBaiduAds) {
//
//            //使用嵌入广告的方法实例。
//            BaiduMobAdView *sharedAdView = [[BaiduMobAdView alloc] init];
////            sharedAdView.AdUnitTag = [self GetApplicationConfig:AdsIdBaidu];
//            //此处为广告位id，可以不进行设置，如需设置，在百度移动联盟上设置广告位id，然后将得到的id填写到此处。
//            sharedAdView.AdType = BaiduMobAdViewTypeBanner;
//            sharedAdView.delegate = self;
//            [sharedAdView start];
//
//            if (usControlBaidu) {
//                sharedAdView.autoplayEnabled=NO;
//                [self startBaduRequest];
//            }
//            adsView=sharedAdView;
//
//        }else{
//            AdMoGoView *ad= [[AdMoGoView alloc] initWithAppKey:[[PublicDATA sharedPublicDATA]GetApplicationConfig:0] adType:AdViewTypeNormalBanner  adMoGoViewDelegate:self];
//            ad.adWebBrowswerDelegate=self;
////            ad.frame = CGRectMake(0.0, ScreenHeight, 320.0, 50.0);
//            adsView=ad;
//        }
//        adsView.frame=kAdViewPortraitRect;
//    }

    return adsView;
}
-(void)startBaduRequest{
    if (usControlBaidu && hasNet) {
        
        [self stopTimer];
        baduAdsRequestTimer=[NSTimer scheduledTimerWithTimeInterval:times target:self selector:@selector(requestBaiDuMethod) userInfo:nil repeats:YES];
    }
}
-(void)requestBaiDuMethod{
    if (!hasNet) {
        [self stopTimer];
        [self removeAdsViewMethod];
        return;
    }
    [self performSelector:@selector(requestBaiduOtherThread) withObject:nil afterDelay:NO];
}
-(void)requestBaiduOtherThread{
//    if (adsView!=nil) {
//        BaiduMobAdView *baiduView=(BaiduMobAdView *)adsView;
//        [baiduView request];
//    }
}
#pragma mark -百度 delegate
- (NSString *)publisherId
{
    return  [self GetApplicationConfig:AdsIdBaidu]; //@"your_own_app_id";
}
- (NSString*) appSpec {
    //注意：该计费名为测试用途，不会产生计费，请测试广告展示无误以后，替换为您的应用计费名，然后提交AppStore.
    return [self GetApplicationConfig:AdsIdBaidu];
}
-(BOOL) enableLocation
{
//@TODO Xcode6 暂时使用no
    
    //启用location会有一次alert提示
    return NO;
    
}
//-(void) willDisplayAd:(BaiduMobAdView*) adview
//{
//    adview.hidden = NO;
//    //广告成功展示时调用
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"adsdidreceivead" object:nil];
//}
/**
 *  广告载入失败
 */
//-(void) failedDisplayAd:(BaiduMobFailReason) reason{
//
//}

/**
 *  本次广告展示被用户点击时的回调
 */
-(void) didAdClicked{
    [self stopTimer];
}

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
-(void) didDismissLandingPage{
    [self restartTimer];
}
-(void)stopTimer{
    adsView=nil;
    [baduAdsRequestTimer invalidate];//暂停
    baduAdsRequestTimer=nil;
}
-(void)restartTimer{
    [self startBaduRequest];
}
#pragma mark -芒果聚合delegate
#pragma mark AdMoGoDelegate delegate
//- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView {
//    //广告成功展示时调用
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"adsdidreceivead" object:nil];
//}
//- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
//
//}
//- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error {
//
//}
//- (UIViewController *)viewControllerForPresentingModalView {
//    return ((UIWindow*)((BaseCommonAppDelegate*)[[UIApplication sharedApplication].delegate MainWindow])).rootViewController;
//}
////广告部分结束
//- init {
//    if (self = [super init])
//    {
//        self.simplebookisopen=NO;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDictionary:) name:@"zhuanti-999.xml" object:nil];
//        [self judgeNetConnect];
//        [self performSelector:@selector(getNetDictionary) withObject:nil afterDelay:NO];
//
//        [self performSelector:@selector(startShowEvalueMethod) withObject:nil afterDelay:2];
//        if ([[[self GetApplicationConfig:isShowBaiduAds] lowercaseString] isEqualToString:@"yes"]) {
//            showBaiduAds=YES;
//        }else{
//            showBaiduAds=NO;
//        }
//        times=[[self GetApplicationConfig:baiduRequestTimer]intValue];
//        if (times==0) {
//            usControlBaidu=NO;
//        }else{
//            usControlBaidu=YES;
//        }
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"EndBookReadingNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netchangeMethod) name:kReachabilityChangedNotificationss object:nil];
//    }
//    return self;
//}

-(BOOL)ReadyShowAdword{
//    return  YES;
    BOOL re=YES;
   
    if ([[[self GetApplicationConfig:isShowAds] lowercaseString] isEqualToString:@"yes"]) {
        re=YES;
        
    }else{
        re=NO;
    }
    return  re;
}
//开始启动评价
-(void)startShowEvalueMethod{
    @synchronized(self) {
        if ([[[self GetApplicationConfig:showEvaluate] lowercaseString] isEqualToString:@"yes"]) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"mark"]) {
                [NSTimer scheduledTimerWithTimeInterval: 5*60 target: self selector:@selector(setStars) userInfo: nil repeats: NO];
            }
        }
    }
}
#pragma mark - 得到广告ID
-(NSString*)GetApplicationConfig:(ApplicationConfig)AppConfig{
	/*
	 AdsId = 0, //广告id
     showVipAndIntegralWall = 1,  //是否显示vip和积分墙广告 int  0，1
     kaipingid = 2, //开屏ID
     showEvaluate = 3, //是否显示两个入口的广告
     recommendID = 4,  //荐id string
     screenOpen = 5, //开屏广告开关 int 0,1
     punchID = 6, //果盟积分墙广告的ID
     AdsIdIpad=7,//iPad广告（主要针对一号书城）
     
     iphoneWallId=8,//iPhone积分墙的id
     ipadWallId=9,//ipad积分墙的id
     showEvaluatePoint=10,//是否显示评价送积分
     youmiId=11,//有米积分墙id
     vipOpenDays=12,//vip用户启动的天数
     vipToAllUser=13,//是否对全部用户开启Vip
     spendPoint=14,//阅读VIp章节需要消耗的积分数量
     givePoint=15,//评论要送的积分数量
     AdsWallscount=16,//积分墙显示的个数
     AdsWallstouch=17,//点击对应的积分墙触发的事件
     limeiAdsWallId=18;//力美积分墙的ID
     mobiSageWallId=19,//艾德思齐积分墙ID
     showMoreRecommend=20,//是否打开更多精彩推荐（针对更多推荐按钮的隐藏）
     isShowAds=21,//是否打开广告
     
     alwardsShowEvaluate=22,//如果不评价是否一直提醒
     showEvaluateTimes=23,//评价显示的时间
     showEvaluateAreasControl=24,//是否开启评价地域限制
     evaluateAreas=25,//不显示评价的地区
     
     gamesBannerOpen=26,//游戏的banner广告开关
     gamesScreenOpen=27,//游戏的插屏广告开关
     evaluateWords=28,//评价语言
     isShowBaiduAds=29,//是否显示百度广告
     AdsIdBaidu=30,//百度广告ID
   
     baiduRequestTimer=31,//百度请求时间控制
	 */
	NSString *str = nil;
	switch (AppConfig) {
		case AdsId:{
			NSString *iphoneIdStr=[dictionary objectForKey:@"AdsId"];
			str = [iphoneIdStr stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
                str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AdsId"];
            }
		}
			break;
        case showVipAndIntegralWall:{
            
            NSString *VipAndWall= [dictionary objectForKey:@"ishowVipAndIntegralWall"];
            str=[VipAndWall stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (str==nil||str.length<2) {
                str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showVipAndIntegralWall"];
            }
           
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"blappopenfirsttime"]==nil)
            {
                [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"blappopenfirsttime"];
            }
            
            NSDate*selectDate=  [[NSUserDefaults standardUserDefaults]objectForKey: @"blappopenfirsttime"];
            NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:selectDate];
            int days=((int)time)/(3600*24);
            
            int vipshowdays=[[self GetApplicationConfig:12] intValue];
            //
            if ([[[self GetApplicationConfig:13] lowercaseString] isEqualToString:@"yes"]) {
                str=@"yes";
            }else{
                if([self isolduser]||days>=vipshowdays){
                    str=@"NO";
                }
            }
            
            
		}
			break;
		case kaipingid:{
            NSString *baiduStr= [dictionary objectForKey:@"kaipingid"];
			str=[baiduStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (str==nil||str.length<2) {
                str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"kaipingid"];
            }
		}
			break;
		case showEvaluate:{
            NSString *is91Str= [dictionary objectForKey:@"showEvaluate"];
			str=[is91Str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (str==nil||str.length<2) {
                str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showEvaluate"];
            }
		}
			break;
		case recommendID:{
			NSString *softIphone= [dictionary objectForKey:@"recommendID"];
			str=[softIphone stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil ||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"recommendID"];
			}
		}
			break;
		case screenOpen:{
			NSString *screen= [dictionary objectForKey:@"screenOpen"];
			str=[screen stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil ||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"screenOpen"];
			}
		}
			break;
		case punchID:{
			NSString *softIpad= [dictionary objectForKey:@"guomobID"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"punchID"];
			}
		}
			break;
        case AdsIdIpad:{
			NSString *softIpad= [dictionary objectForKey:@"AdsIdIpad"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AdsIdIpad"];
			}
		}
			break;
            /////////////////////////////////////////////////////////
            
        case iphoneWallId:{
			NSString *softIpad= [dictionary objectForKey:@"iphoneWallId"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"iphoneWallId"];
			}
		}
			break;
        case ipadWallId:{
			NSString *softIpad= [dictionary objectForKey:@"ipadWallId"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ipadWallId"];
			}
		}
			break;
        case showEvaluatePoint:{
			NSString *softIpad= [dictionary objectForKey:@"showEvaluatePoint"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showEvaluatePoint"];
			}
		}
			break;
        case youmiId:{
			NSString *softIpad= [dictionary objectForKey:@"youmiId"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"youmiId"];
			}
		}
			break;
        case vipOpenDays:{
            NSString *softIpad= [dictionary objectForKey:@"vipOpenDays"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"vipOpenDays"];
			}
        }
            break;
        case vipToAllUser:{
            NSString *softIpad= [dictionary objectForKey:@"vipToAllUser"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"vipToAllUser"];
			}
        }
            break;
        case spendPoint:{
            NSString *softIpad= [dictionary objectForKey:@"spendPoint"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"spendPoint"];
			}
        }
            break;
        case givePoint:{
            NSString *softIpad= [dictionary objectForKey:@"givePoint"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"givePoint"];
			}
        }
            break;
        case AdsWallscount:{
            NSString *softIpad= [dictionary objectForKey:@"AdsWallscount"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AdsWallscount"];
			}
        }
            break;
        case AdsWallstouch:{
            NSString *softIpad= [dictionary objectForKey:@"AdsWallstouch"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AdsWallstouch"];
			}
        }
            break;
        case limeiAdsWallId:{
            NSString *softIpad= [dictionary objectForKey:@"limeiAdsWallId"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"limeiAdsWallId"];
			}
        }
            break;
        case mobiSageWallId:{
            NSString *softIpad= [dictionary objectForKey:@"mobiSageWallId"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"mobiSageWallId"];
			}
        }
            break;
        case showMoreRecommend:{
            NSString *softIpad= [dictionary objectForKey:@"showMoreRecommend"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showMoreRecommend"];
			}
        }
            break;
        case isShowAds:{
            NSString *softIpad= [dictionary objectForKey:@"isShowAds"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"isShowAds"];
			}
        }
            break;
            
        case alwardsShowEvaluate:{
            NSString *softIpad= [dictionary objectForKey:@"alwardsShowEvaluate"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"alwardsShowEvaluate"];
			}
        }
            break;
        case showEvaluateTimes:{
            NSString *softIpad= [dictionary objectForKey:@"showEvaluateTimes"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showEvaluateTimes"];
			}
        }
            break;
        case showEvaluateAreasControl:{
            NSString *softIpad= [dictionary objectForKey:@"showEvaluateAreasControl"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"showEvaluateAreasControl"];
			}
        }
            break;
        case evaluateAreas:{
            NSString *softIpad= [dictionary objectForKey:@"evaluateAreas"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"evaluateAreas"];
			}
        }
            break;
        case gamesBannerOpen:{
            NSString *softIpad= [dictionary objectForKey:@"gamesBannerOpen"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"gamesBannerOpen"];
			}
        }
            break;
        case gamesScreenOpen:{
            NSString *softIpad= [dictionary objectForKey:@"gamesScreenOpen"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"gamesScreenOpen"];
			}
        }
            break;
        case evaluateWords:{
            NSString *softIpad= [dictionary objectForKey:@"evaluateWords"];
			str=[softIpad stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"evaluateWords"];
			}
        }
            break;
        case isShowBaiduAds:{
            NSString *isShowBaidu= [dictionary objectForKey:@"isShowBaiduAds"];
			str=[isShowBaidu stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"isShowBaiduAds"];
			}
        }
            break;
        case AdsIdBaidu:{
            NSString *baiduId= [dictionary objectForKey:@"AdsIdBaidu"];
			str=[baiduId stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AdsIdBaidu"];
			}
        }
            break;
        case baiduRequestTimer:{
            NSString *baiduId= [dictionary objectForKey:@"baiduRequestTimer"];
			str=[baiduId stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (str==nil||str.length<2) {
				str=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"baiduRequestTimer"];
			}
        }
            break;

    }
        
    return str;
}
#pragma mark - 判断是否为老用户
-(BOOL)isolduser{
   
    BOOL isolduser=NO;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userisolduser"]!=nil&&[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"softuserversion"]])
    {
        isolduser=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userisolduser"] boolValue];
    }else
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"localBookRead"]!=nil)
        {
            isolduser=YES;
        }
        
        if([[NSMutableArray arrayWithArray: [[EBookLocalStore defaultEBookLocalStore] SearchBookListWithKeyWord:[NSPredicate predicateWithFormat:@"name !=''"]]] count]>0)
        {
         isolduser=YES;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isolduser] forKey:@"userisolduser"];
        if([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]!=nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"softuserversion"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isolduser;
}
#pragma mark - 得到后台配置
-(void)getNetDictionary{
    NSString *bundStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"];
    NSString *urlStr=[NSString stringWithFormat:@"http://42.121.119.146/ZY_Part_1_V1/iosFile/softwareConfig/%@/ads2_%@.xml",bundStr,bundStr];
    
    [XMLDownLoad startDown:urlStr downLoadTag:-999];
}
-(void)getDictionary:(NSNotification *)note{
    NSMutableArray *arr=[note object];
    if (arr.count==1) {
        self.dictionary=[arr objectAtIndex:0];
    }else{
        self.dictionary=nil;
    }
}

#pragma mark implement DownloadHelper methods

-(BOOL)OpenAppWithProductID:(NSString*)itunesUrl referenceViewController:(UIViewController*)presentViewControlle{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesUrl]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesUrl] options:nil completionHandler:nil];
    return YES;
}
- (void)productViewControllerDidFinish:(id)viewController {
//    [viewController dismissModalViewControllerAnimated:YES];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
//    [dldHelper release];
    [dldHelper cancel];
    dldHelper.delegate=nil;
    self.dldHelper=nil;
	[dictionary release];
    adsView=nil;
    [baduAdsRequestTimer invalidate];
    [baduAdsRequestTimer release];
//    [reach release];
    [super dealloc];
}
//判断网络状态
-(BOOL)judgeNetConnect{
    hasNet = YES;
    //调试
//    self.reach=[PMReachability reachabilityForInternetConnection] ;
//    int state=[self.reach currentReachabilityStatus];
//    [self.reach startNotifier];
//
//    switch (state) {
//        case 0:
//            hasNet=NO;
//            //   NSLog(@"没有网络");
//            break;
//        case 1:
//            hasNet=YES;
//            //   NSLog(@"正在使用3G网络");
//            break;
//        case 2:
//            hasNet=YES;
//            //  NSLog(@"正在使用wifi网络");
//            break;
//    }
  
    return hasNet;
}
-(void)netchangeMethod{
    [self judgeNetConnect];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"netConnectChanged" object:nil];
}
-(BOOL)hasNetConnect{
    return hasNet;
}
@end
