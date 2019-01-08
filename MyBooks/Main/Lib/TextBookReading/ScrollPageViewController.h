//
//  ScrollPageViewController.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "SimpleTextBookReadingHelp.h"
#import <UIKit/UIKit.h>
#import "BLpageScrollview.h"
#import "CustomPageViewControllerdelegate.h"
#import "customcontroller.h"
#import "BLviewhead.h"

@interface ScrollPageViewController : customcontroller<BLpageScrollviewdelegate>
{
    BLpageScrollview*  BLpageTest;
    id<CustomPageViewControllerdelegate> CustomDataSourceDelegate;//delegate
//    NSInteger CurrenPageIndex;//当前页面索引
    
    BOOL  pageisdouble;
    CGRect selfframe;
    id<BLviewdatasource>    datasource;
	id<BLMidclickdelegate>          midclickdelegate;
    UIView* view1;
    UIView* view2;
    BOOL  starsin;
    BOOL  endsin;
    BOOL  CureentisnoCurrent;
    int  currenpa;
}
@property(assign,nonatomic)id<BLviewdatasource> datasource;
@property(assign,nonatomic)id<BLMidclickdelegate>          midclickdelegate;
@property(retain,nonatomic)BLpageScrollview*  BLpageTest;
@property(assign,nonatomic)id<CustomPageViewControllerdelegate>  CustomDataSourceDelegate;//delegate
//@property  NSInteger CurrenPageIndex;
-(void)JunpToshowNewPage:(NSInteger)pageIndex;
-(unsigned  int)getCurrentPageNumber;
-(id)initandsetpageisdouble:(BOOL)pageisdouble frame:(CGRect)frame  rightcolor:(UIColor*)rightcolor;


@end
