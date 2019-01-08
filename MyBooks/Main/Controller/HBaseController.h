//
//  HBaseController.h
//  History
//
//  Created by 朝阳 on 14-6-12.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MONActivityIndicatorView.h"
//#import "TheamManager.h"

@interface HBaseController : UIViewController<MONActivityIndicatorViewDelegate>
{
    MONActivityIndicatorView *indicatorView;

}

//@property (nonatomic, strong) MONActivityIndicatorView *indicatorView; //网络加载视图
/**
 *  开始网络加载视图
 **/
-(void)startBaseIndiAnimating;
/**
 *  停止网络加载视图
 **/
-(void)stopBaseIndiAnimating;

/**
 *  设置导航左按钮的图片及处理方法
 *  @param image 按钮图片
 *  @param navEvent 按钮事件
 **/
- (void) setNavLeftButton:(UIImage *)image sel:(SEL)navEvent;
/**
 *  设置导航右按钮的图片及处理方法
 *  @param image 按钮图片
 *  @param navEvent 按钮事件
 **/
- (void) setNavRightButton:(UIImage *)image sel:(SEL)navEvent;

/**
 *  根据字典获得书籍的尺寸大小
 **/

-(NSString *)getBookInfoSizeWithDic:(NSDictionary *)dic;


@end
