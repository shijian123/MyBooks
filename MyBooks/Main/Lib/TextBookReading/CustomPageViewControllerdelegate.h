//
//  CustomPageViewControllerdelegate.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
@class   BLpageScrollview,CustomPageViewController;

@protocol CustomPageViewControllerdelegate <NSObject>
@required
- (UIView *)CustomPageView:(BLpageScrollview*)pageViewController viewForPageAtIndex:(NSInteger)index;     //请求页面requested page of index
- (UIViewController *)CustomPageViewController:(CustomPageViewController*)pageViewController  viewForPageAtIndex:(unsigned  int)index;     //请求页面requested page of index

-(unsigned  int)numberOfPages:(id)pageViewController;
-(NSInteger)NextChapter;
-(NSInteger)PrevChapter;
-(NSInteger)GetMainCurrentPageIndex:(BLpageScrollview*)pageViewController;


//请求页面总数  Total number of page

@optional
-(void)CustomPageViewReachEnd:(id)pageViewController; //到达末页,产生事件 To reach the last page, that generated the event

-(void)CustomPageViewReachBegain:(id)pageViewController;//到达起始，产生事件 Arrive at the start, that generated the event
@end
