//
//  BLpageContrller.h
//  BLpageController
//
//  Created by BLapple on 13-1-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//
#import "SimpleTextBookReadingHelp.h"
#import "CustomPageViewControllerdelegate.h"
#import "BLviewhead.h"
#import <UIKit/UIKit.h>
#import "BLpage1.h"
//#import "BLpage2.h"
#import "customcontroller.h"
@interface BLpageContrller : customcontroller
{
    BOOL pageisdouble;
    id<BLviewdatasource>    datasource;
	id<BLMidclickdelegate>          midclickdelegate;
    id<CustomPageViewControllerdelegate>  CustomDataSourceDelegate;//delegate
    UIView* UIView1;
    UIView* UIView2;
    BLpage1*currentview;
    CGRect selfframe;
    
    int numberofchapterpage;
}
//@property(retain,nonatomic)UIColor*  rightbackgroundcolor;
@property(assign,nonatomic)id<BLviewdatasource> datasource;
@property(assign,nonatomic)id<BLMidclickdelegate> midclickdelegate;
@property(assign,nonatomic)id<CustomPageViewControllerdelegate>CustomDataSourceDelegate;
//@property(readwrite)int CurrenPageIndex;
-(id)initandsetpageisdouble:(BOOL)pageisdouble frame:(CGRect)frame  rightcolor:(UIColor*)rightcolor;
-(void)reload;
-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin;
-(unsigned  int)getCurrentPageNumber;
-(void)viewBackgroudChangedWithIndex:(NSInteger) index;//当用户阅读样式变成黑色图片时，会调用这个方法
@end
