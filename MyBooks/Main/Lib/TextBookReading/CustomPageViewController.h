//
//  CustomPageViewController.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageViewControllerdelegate.h"
@interface CustomPageViewController : UIPageViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    id<CustomPageViewControllerdelegate>  CustomDataSourceDelegate;//delegate
     NSInteger CurrenPageIndex;//当前页面索引   
    int  state;
    int  statecount;
}
@property(assign,nonatomic)id<CustomPageViewControllerdelegate>  CustomDataSourceDelegate;
 @property  NSInteger CurrenPageIndex;
-(void)JunpToshowNewPage:(UIPageViewControllerNavigationDirection)direction   jumpIndex:(NSInteger)pageIndex animated:(BOOL)animated;
@end

