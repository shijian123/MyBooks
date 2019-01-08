//  Created by 3G 北邮 on 12-8-6.@bai
//  Copyright (c) 2012年 北邮3G. All rights reserved.
//
//支持多页面，单页面和无页面;支持pageing;
//使用复用技术，使用两个页面将内存使用降到最低,数据请求降到最低;即使不使用复用页面，内存也只占用两个页面！！
//可使用任意view作为页面！！
//需具备2个delegate方法，返回页面个数和将要显示的视图
//使用方法和scrollview相同，无需设置contentview大小,注意单页无法滑动

// Supports multi-page, single page and no page; support pageing;
//use of multiplexing, the use of two pages to the memory usage to a minimum，Data requests to a minimum！Even without using complex page memory only takes up two pages! !
//can use any view as a page! !
// View need to have two delegate methods to return the page number and to be displayed page of index
// Use and scrollview without set contentview size, pay attention to a single page can not slide

#import <UIKit/UIKit.h>
@class BLpageScrollview;
@protocol   BLpageScrollviewdelegate;

typedef enum {
    horizontalDirectionForBLpageScrollview=0,
    verticalDirectionForBLpageScrollview=1
} BLpageScrollviewDirectionStyle;

@interface BLpageScrollview : UIScrollView<UIScrollViewDelegate>{
@private
    UIView*      singularPage;    //单数页面 Singular page
    UIView*      pluralPage;      //复数页面 Plural page
    unsigned  int  pageCount;    //总页数，按需要可以调节  page number，Can be adjusted as needed
    BOOL         reset;           //是否立即还原尾页事件 Restore Now the events of the Last
    id<BLpageScrollviewdelegate>  realDelegate;//delegate
}

-(id)initWithDirectionStyle:(BLpageScrollviewDirectionStyle)directionStyle;//推荐的初始化 Recommended initialization
-(id)initWithFrame:(CGRect)frame  Directionstyle:(BLpageScrollviewDirectionStyle)directionStyle;
-(id<BLpageScrollviewdelegate>)getDelegate;//获取代理  Access to agent
//@property (nonatomic, assign) BLpageScrollview* delegate;
-(BLpageScrollviewDirectionStyle)getDirectionStyle;//获取当前滑动方向 Get the current sliding direction
-(UIView*)dequeueReusablePage;     //复用页面请求  Reuse the page request
-(unsigned  int)getCurrentPageNumber;  //获取当前页面数 Get the current page number
-(BOOL)jumpToPage:(unsigned  int)index;//跳转页面  Jump to page
-(BOOL)reload;                     //重新加载当前页面  Reload current page
-(BOOL)reloaddate:(unsigned  int)startWith;                 //重新加载所有数据，并跳转 reload all date and jump 
-(BOOL)nextPage;                   //下一页 nextPage
-(BOOL)prePage;                    //上一页 prePage
-(void)stopEndPageEvent;           //停止尾页事件 Stop END event
-(void)DirectionStyleChangeTo:(BLpageScrollviewDirectionStyle)DirectionStyle;//改变视图方向
-(void)gotoNext;
-(void)gotoPre:(NSUInteger)prenumber;
@end


@protocol BLpageScrollviewdelegate <NSObject>

@required

/**
 请求页面requested page of index
 */
-(UIView*)BLpageScrollview:(BLpageScrollview*)myBLpageScrollview  viewForPageAtIndex:(unsigned  int)index;

/**
 请求页面总数  Total number of page
 */
-(unsigned  int)numberOfPagesInBLpageScrollview:(BLpageScrollview*)myBLpageScrollview;


@optional

/**
 到达末页,产生事件 To reach the last page, that generated the event
 */
-(void)BLpageScrollviewReachEnd:(BLpageScrollview*)myBLpageScrollview;

/**
 到达起始，产生事件 Arrive at the start, that generated the event
 */
-(void)BLpageScrollviewReachBegain:(BLpageScrollview*)myBLpageScrollview;
 
@end

