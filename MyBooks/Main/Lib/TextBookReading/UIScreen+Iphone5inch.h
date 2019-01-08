//
//  UIScreen+Iphone5inch.h
//  TodayWordNews
//
//  Created by lzq on 12-9-24.
//
//

#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@interface UIScreen (Iphone5inch)
+(BOOL)isIphone5inch;
+(NSString*)ImagePathToIphone5inch:(NSString*)path;
+(UIImage*)ImageToIphone5inch:(NSString*)path;

@end
