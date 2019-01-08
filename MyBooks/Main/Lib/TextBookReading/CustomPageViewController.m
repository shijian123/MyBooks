//
//  CustomPageViewController.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomPageViewController.h"

@interface CustomPageViewController ()
@end

@implementation CustomPageViewController
@synthesize CustomDataSourceDelegate,CurrenPageIndex;
-(id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options{
    if (self=[super initWithTransitionStyle:style  navigationOrientation: navigationOrientation options:options]) {
        self.delegate = self;
        self.dataSource = self; 
        self.CurrenPageIndex=0;
    }
    return self;
}
 
- (UIViewController *)pageViewController:(id)pageViewController 
       viewControllerAfterViewController:(id)viewController{  
    if ( (self.CurrenPageIndex+1)<[self.CustomDataSourceDelegate numberOfPages:self]) {
        state=1;
        self.CurrenPageIndex++;
    }else {
        
       NSInteger temppages=[self.CustomDataSourceDelegate NextChapter];
        if (temppages==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
    
            return nil;
        }else {
            self.CurrenPageIndex=temppages;
        }
    }
    return [self.CustomDataSourceDelegate CustomPageViewController:self viewForPageAtIndex:self.CurrenPageIndex];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController{
    if ( (self.CurrenPageIndex-1)>=0) {
        state=-1;
        self.CurrenPageIndex--;
    }else {
        NSInteger temppages=[self.CustomDataSourceDelegate PrevChapter];

         if (temppages==-1 ) {
            //已经是第一页
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
            return nil;
         }else {
            self.CurrenPageIndex=temppages;   
         }
    }
    return [self.CustomDataSourceDelegate CustomPageViewController:self viewForPageAtIndex:self.CurrenPageIndex];
}
-(void)JunpToshowNewPage:(UIPageViewControllerNavigationDirection)direction   jumpIndex:(NSInteger)pageIndex animated:(BOOL)animated{
    self.CurrenPageIndex=pageIndex;
    [self setViewControllers:[NSArray arrayWithObject:[self.CustomDataSourceDelegate CustomPageViewController:self viewForPageAtIndex:self.CurrenPageIndex]] direction:direction animated:animated completion:NULL];
}
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = [pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(!completed){self.CurrenPageIndex-=state;}
}


@end
