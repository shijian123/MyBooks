//
//  CYConst.h
//  MyBooks
//
//  Created by zcy on 2018/5/3.
//  Copyright © 2018年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSString+Stringhttpfix.h"


#define MainScreenSize [UIScreen mainScreen].bounds.size
#define MainScreenWidth MainScreenSize.width
#define MainScreenHeight MainScreenSize.height
#define CYUserDefaults [NSUserDefaults  standardUserDefaults]
#define CYIphoneVersion [[UIDevice currentDevice] systemVersion].floatValue
//版本号
#define DeviceValue [UIDevice currentDevice].systemVersion.doubleValue
//存入沙盒
#define CYDefault [NSUserDefaults standardUserDefaults]


//IOS系统版本号
#define CST_DEVICE_VER [[UIDevice currentDevice].systemVersion floatValue]
#define CST_IOS7    (CST_DEVICE_VER >= 7.0 ? YES : NO)

#define kHarpyAppID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"]
#define listCellIpad_Color  RGBCOLOR(250, 250, 250, 1.0)

#define listCellAlreadyDownIpad_Color  RGBCOLOR(167, 167, 167, 1.0)

#define MAINTHEME_SUN_BGColor RGBCOLOR(245, 245, 245, 1.0)
#define MAINTHEME_NIGHT_BGColor RGBCOLOR(25, 25, 25, 1.0)
#define MAINTHEME_EDIT_BGColor RGBCOLOR(73, 117, 62, 1.0)
#define MAINTHEME_EDIT_NBGColor RGBCOLOR(27, 58, 30, 1.0)
#define MAINTHEME_SUN_LINEColor RGBCOLOR(189, 189, 189, 1.0)
#define MAINTHEME_MOON_LINEColor RGBCOLOR(35, 35, 35, 1.0)
#define MAINTHEME_SUN_TitleColor RGBCOLOR(172, 172, 172, 1.0)
#define MAINTHEME_MOON_TitleColor RGBCOLOR(170, 170, 170, 1.0)

#define MAINTHEME_SUN_BookTitle RGBCOLOR(70, 70, 70, 1.0)
#define MAINTHEME_MOON_BookTitle RGBCOLOR(74, 74, 74, 1.0)
#define MAINTHEME_SUN_BookAuthor RGBCOLOR(149, 149, 149, 1.0)
#define MAINTHEME_MOON_BookAuthor RGBCOLOR(60, 60, 60, 1.0)

#define MAINTHEME_SUN_WIFIMCol RGBCOLOR(64, 116, 52, 1.0)
#define MAINTHEME_MOON_WIFIMCol RGBCOLOR(45, 77, 38, 1.0)
//#define MAINTHEME_SUN_WIFIMCol RGBCOLOR(64, 116, 52, 1.0)


#define wifiColor RGBCOLOR(104, 74, 73, 1)
//当前为正常的专题
#define isSunTheme [[NSUserDefaults standardUserDefaults] boolForKey:@"isSunTheme"]


//是否首次启动
#define First_Launched @"firstLaunch"

//是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//是否iPhone
#define iphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//是否Iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//是否Retina
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)

//颜色RGB
#define RGBCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//get the x,y of the frame
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)

//get the size of the frame
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)

//屏幕宽高
#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define Image(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//背景为clearcolor
#define COLOR_CLEAR [UIColor clearColor]

//TTF字体 大小
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//NSUserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//文件管理
#define FILES [NSFileManager defaultManager]

//document文件目录
#define DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//caches文件目录
#define CACHES [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }
#define SAFE_RELEASE(x) [x release];x=nil

//定义一个地址
#define APIURL                @"http://xxxxx/"

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//ios6系统判断：
#define IsIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] <7.0 ? YES : NO)

//UIAlertView
#define AlertViewContent(content) [[[UIAlertView alloc] initWithTitle:@"提示:" message:content delegate:nil cancelButtonTitle:@"确  定" otherButtonTitles:nil] show]
//设置图片
#define YDIMG(__name) [UIImage imageNamed:__name]

#define WIFIFILEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Wifi"]

#define WIFIPLIST [localpath stringByAppendingPathComponent:@"Wifi.plist"]

#define localpath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"local"]
#define blregisted [localpath stringByAppendingPathComponent:@"bllocalregist.plist"]

#define BLbookdeleteNotification @"BLbookdeleteNotification"


#define BLuserRegistwrong @"BLuserbookRegistwrongNotification"
#define BLuserRegistfinish @"BLuserRegistfinishNotification"



#define BLlocalRegistwrong @"BLlocalbookRegistwrongNotification"
#define BLlocalRegistfinish @"BLlocalRegistfinishNotification"

#define useruploadpath  @"userupload"


#define localbook       @"localbook"
