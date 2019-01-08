//
//  customcontroller.h
//  OfficerEye
//
//  Created by BLapple on 13-1-25.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTextBookReadingHelp.h"
@interface customcontroller : UIViewController
{
    NSInteger CurrenPageIndex;
    UIColor*  rightbackgroundcolor;
}

@property(readwrite)NSInteger CurrenPageIndex;
@property(retain,nonatomic)UIColor*  rightbackgroundcolor;

-(NSInteger)getCurrentPageNumber;
-(BOOL)reload;
-(BOOL)reloaddate:(unsigned  int)startWith;
-(void)JunpToshowNewPage:(UIPageViewControllerNavigationDirection)direction jumpIndex:(NSInteger)pageIndex animated:(BOOL)animated;
-(void)JunpToshowNewPage:(NSInteger)pageIndex;
//-(UIView*)dequeueReusablePage;

@end
