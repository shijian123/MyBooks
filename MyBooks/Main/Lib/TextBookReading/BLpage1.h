//
//  BLpage1.h
//  BLpageController
//
//  Created by BLapple on 13-1-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//
//#import "BLUIpageviewcontroller.h"
#import <UIKit/UIKit.h>
#import "BLviewhead.h"
#import "OpenGLView.h"
@interface BLpage1 : UIViewController<BLMidclickdelegate,BLviewdatasource,GLKViewDelegate>
{
    UIPageViewController* custom;
    id<BLviewdatasource>    datasource;
	id<BLMidclickdelegate>  midclickdelegate;
    CGRect  selfrect;
    int CurrenPageIndex;
    UIView* view;
    UIView* backshadow;
    UIViewController* con;
    
    //czk修改，李润成3d翻页嵌入
    BOOL isPingBi;
    OpenGLView*opglview;
    int currentIndex;//当前是章节中的第几页
    int currentViewTag;//当前view视图的tag//如果为
    int lastViewTag;//上一页view的tag
    int nextViewTag;//下一页view的tag
    bool noPreFlag;//没有上一页的标识
    bool noNextFlag;//没有上一页的标识
    CGPoint TouchBeginPoint;//touchbegin事件捕获到的最新坐标
    int viewSkinIndex;//小说背景皮肤，跟simpletextbookreadinghelp的style。skinindex对应。
    
    //lrc专区，for 3d翻页
    bool fingerstart;
    bool needsetimage;
    bool renderover;
    bool righttoleft;
    bool goonorback;
    bool isDianAN;//判断是否是点按
    bool m_locks_lock;
    
    NSLock *m_lock;
    NSThread *animateThread;
}
@property(assign,nonatomic)id<BLviewdatasource> datasource;
@property(assign,nonatomic)id<BLMidclickdelegate> midclickdelegate;
@property(retain,nonatomic)UIPageViewController* custom;
-(id)initWithframe:(CGRect)frame;
-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin;

-(void)settouchdele:(UIView*)touchview;
-(void)removetouchdle:(UIView*)touchview;
-(void)setRightOrLeft : (bool)on;
-(UIViewController*)Createcontrollerwithview:(UIView*)view;
-(void)viewBackgroudChangedWithIndex:(NSNumber*)num;
@end
