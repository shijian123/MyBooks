//
//  AppDelegate.m
//  MyBooks
//
//  Created by zcy on 2018/5/3.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "AppDelegate.h"
#import "ShelfViewController.h"
#import "CYBookListController.h"
#import "SmalleEbookWindow.h"
#import <Bugly/Bugly.h>

#ifdef DEBUG
#import <DoraemonKit/DoraemonManager.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ShelfViewController *bookShelfVC = [[ShelfViewController alloc]initWithNibName:@"ShelfViewController_phone" bundle:nil];
    UINavigationController *bsNav = [[UINavigationController alloc]initWithRootViewController:bookShelfVC];
    self.window.rootViewController = bsNav;
    
    [self checkMethod];

    //开启书城
    [self SetupBookReadNotificatioKeyword:@"StartBookReadingNotification"];
    //小图书需要这个属性
    self.MainViewController = bsNav;
    self.MainWindow=self.window;
    //开启BOMB服务器
    [Bmob registerWithAppKey:@"41e16b6d95636fabe6a027ad8efb557a"];
    //开启bug监控
    [Bugly startWithAppId:@"4bd834b8d8"];
    
#ifdef EBUG
    [[DoraemonManager shareInstance] install];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    NSLog(@"点击：%@",shortcutItem.type);
    if ([shortcutItem.type isEqualToString:@"item2"]) {//分享
        
        NSString *textToShare = @"要分享的文本内容";
//        UIImage *imageToShare = [UIImage imageNamed:@"海贼路飞.jpg"];
        NSURL *urlToShare = [NSURL URLWithString:@"http://blog.csdn.net/hitwhylz"];
        NSArray *activityItems = @[textToShare, urlToShare];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePostToTwitter];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
        
        activityVC.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){            
        };
    }
}

- (void)checkMethod{
    NSString *cachesPath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ebookdown"];
    NSString *supportPath=[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ebookdown"];
    NSString *support=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *file=[NSFileManager defaultManager];
    if ([file fileExistsAtPath:supportPath]) {
        return;
    }else{
        if (![file fileExistsAtPath:cachesPath]) {
            return;
        }else{
            if (![file fileExistsAtPath:support]) {
                [file createDirectoryAtPath:support withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [file moveItemAtPath:cachesPath toPath:supportPath error:nil];
            NSURL *usl=[NSURL fileURLWithPath:support];
            [self addSkipBackupAttributeToItemAtURL:usl];
            
            [self moveReadingData];
        }
    }
}

-(void)moveReadingData{
    
    NSString* diskpath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray* fileList=  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:diskpath error:nil ];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    
    for (NSString *file in fileList) {
        NSString *path = [diskpath stringByAppendingPathComponent:file];
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [arr addObject:file];
        }
        else
        {
            
        }
        isDir = NO;
    }
    BOOL match=NO;
    NSString* versionstr=nil;
    for(int i=60;i>=10;i--)
    {
        versionstr=[NSString stringWithFormat:@"%d.%d",i/10,i%10];
        for(NSString* file in arr)
        {
            if([versionstr isEqualToString:file])
            {
                match=YES;
                break;
            }
        }
        if(match)
        {
            break;
        }
    }
    
    if (match) {
        NSString *dataPath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:versionstr];
        NSString *support=[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:versionstr];
        NSFileManager *file=[NSFileManager defaultManager];
        [file moveItemAtPath:dataPath toPath:support error:nil];
        NSURL *usl=[NSURL fileURLWithPath:support];
        [self addSkipBackupAttributeToItemAtURL:usl];
        
    }
    
}

//@TODO 为文件添加不可上传属性
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    return success;
}

@end
