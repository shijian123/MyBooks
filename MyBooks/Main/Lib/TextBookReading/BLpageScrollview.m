//  Created by 3G 北邮 on 12-8-6.@bai
//  Copyright (c) 2012年 北邮3G. All rights reserved.
//

#import "BLpageScrollview.h"
static  BOOL isJumping;
static  BOOL isVertical;
static  BOOL isLoad;
static  BOOL reach;
static  unsigned     int selfWidth;
static  unsigned     int selfHeight;
static  unsigned     int currentPage;
unsigned  int  nextPage;
UIView*      tempview;
@interface BLpageScrollview ()
-(void)showPage;
-(void)DefaultInit;
-(void)setContentOffset:(CGPoint)contentOffset;
-(void)setDelegate:(id<BLpageScrollviewdelegate>)delegate;
-(void)setPagingEnabled:(BOOL)pagingEnabled;
@end
@implementation BLpageScrollview
-(void)dealloc{
    [super dealloc];
}
-(id)init{
    if(self = [super init]){
        [self DefaultInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self DefaultInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Directionstyle:(BLpageScrollviewDirectionStyle)directionStyle{
    if(self = [super initWithFrame:frame]){
        [self DefaultInit];
        isVertical=(directionStyle==horizontalDirectionForBLpageScrollview)?NO:YES;
    }
    return self;
}
-(id)initWithDirectionStyle:(BLpageScrollviewDirectionStyle)directionStyle{
    if(self = [super init]){
        [self DefaultInit];
        isVertical=(directionStyle==horizontalDirectionForBLpageScrollview)?NO:YES;
    }
    return self;
}
-(void)setPagingEnabled:(BOOL)pagingEnabled
{
    [super setPagingEnabled:pagingEnabled];
}
-(void)setDelegate:(id<BLpageScrollviewdelegate>)delegate{
    if (delegate != nil) {
        [super setDelegate:self];
        realDelegate=delegate;
    }
}
-(void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
}
-(id<BLpageScrollviewdelegate>)getDelegate
{
    return  realDelegate;
}
-(BLpageScrollviewDirectionStyle)getDirectionStyle
{
    return isVertical?verticalDirectionForBLpageScrollview:horizontalDirectionForBLpageScrollview;
}
-(void)DefaultInit{
    reach=NO;
    isVertical=NO;
    isLoad=NO;
    reset=YES;
    pageCount=0;
    currentPage=0;
    nextPage=0;
    selfWidth=0;
    selfHeight=0;
    isJumping=0;
    singularPage=nil;
    pluralPage=nil;
    realDelegate=nil;
    
    
}
-(unsigned  int)getCurrentPageNumber{
    return currentPage;
}
-(void)stopEndPageEvent{
    reach=YES;
    reset=NO;
}
//复用page  Complex with page
-(UIView*)dequeueReusablePage{
    if( nextPage%2==1)
    { return singularPage;}
    else
    {return pluralPage;}
}



-(void)layoutSubviews{//在layout中加载有好处 Loaded in the layout is good.
    if(!isLoad)//判断是否加载过   Determine whether the loading
    {
        //        self.bounces=NO;
        isLoad=YES;
        selfWidth=self.frame.size.width;
        selfHeight=self.frame.size.height;
        //获取BLpageScrollview属性  Get BLpageScrollview property
        if (realDelegate!=nil) {
            //获取PAGE个数 Get PAGE number
            if([(NSObject*)realDelegate   respondsToSelector:@selector(numberOfPagesInBLpageScrollview:)])
            {
                pageCount= [realDelegate  numberOfPagesInBLpageScrollview:self];
            }
            //加载复用page Loading complex using page
            isJumping=YES;
            [self setContentSize:CGSizeMake(selfWidth*isVertical+selfWidth*pageCount*(!isVertical)+1,pageCount*selfHeight*isVertical+selfHeight*(!isVertical))];
            isJumping=NO;
            [self  jumpToPage:currentPage];
        }
    }
    
    [super  layoutSubviews];
}

//判断滑动事件 To determine the sliding event
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float key;
    static float pagelevel;
    if(isJumping){return;}
    else
    {
        key=self.contentOffset.x*(!isVertical)+self.contentOffset.y*isVertical;
        pagelevel=currentPage*selfWidth*(!isVertical)+currentPage*selfHeight*isVertical;
        if(key >pagelevel  )   //判断右滑 To judge the right slip
        {
            if(currentPage!=pageCount-1)//最后一页不加载下一页  The last page does not load the next page
            {
                
                if((currentPage+1)!=nextPage)//判断是否已经做过移位  Determine whether they've done to shift
                {
                    nextPage=currentPage+1;
                    [self  showPage];
                }
            }else
            {//到达页尾 Reach the footer
                if (!reach && [(NSObject*)(realDelegate) respondsToSelector:@selector(BLpageScrollviewReachEnd:)]  &&  self.isTracking)
                {
                    
                    [realDelegate  BLpageScrollviewReachEnd:self];//通知到达页尾 Notice reaches the footer
                    
                }
            }
        }
        if(key<pagelevel  )//判断左滑 Judge left slip
        {
            if(currentPage!=0)//第一页不加载上一页 First page does not load the previous page
            {
                if((currentPage-1)!=nextPage)//判断是否已经做过移位  Determine whether they've done to shift
                    
                {
                    nextPage=currentPage-1;
                    [self showPage];
                }
            }else
            {//到达起始  Reach the starting
                if (!reach && [(NSObject*)(realDelegate) respondsToSelector:@selector(BLpageScrollviewReachBegain:)] &&  self.tracking)
                {
                    [realDelegate  BLpageScrollviewReachBegain:self];  //通知到达起始 Notice to reach the starting
                    
                }
            }
        }
        //判断当前页  Judgment which current page
        if(fabsf(key-pagelevel)>((selfWidth*(!isVertical)+selfHeight*isVertical)/2))//当前页改变 This page change
        {
            nextPage=currentPage;
            if(key<0)
            {
                currentPage=0;
            }
            else
            {
                currentPage=(key+(selfWidth*(!isVertical)+selfHeight*isVertical)/2)/(selfWidth*(!isVertical)+selfHeight*isVertical);
            }
            reach=NO;
            reset=YES;
            
        }
    }
}

//滑动显示页面Slide Show page
-(void)showPage;
{
    if([(NSObject*)realDelegate  respondsToSelector:@selector(BLpageScrollview:viewForPageAtIndex:)])
    {
        tempview=[realDelegate  BLpageScrollview:self viewForPageAtIndex:nextPage];
        if(tempview==nil){return;}
        [tempview  setFrame:CGRectMake(nextPage*selfWidth*(!isVertical),nextPage*selfHeight*isVertical, selfWidth, selfHeight)];
        if(tempview.superview!=self  )
        {
            if(nextPage%2==1)
            {
                [singularPage removeFromSuperview];
            }else
            {
                [pluralPage removeFromSuperview];
            }
            [self  addSubview:tempview];
        }
        if(nextPage%2==1)
        {
            singularPage=tempview;
        }else
        {
            pluralPage=tempview;
        }
    }
}

//跳转页面 Jump to page
-(BOOL)jumpToPage:(unsigned  int)index
{
    if(!isLoad){
        currentPage=index;
        nextPage=index;
        return  YES;
    } else
        if(pageCount <= 0 || index>=pageCount || index < 0 )
        {
            return NO;
        }else{
            reset=YES;
            reach=NO;
            int k=0;
            if(currentPage<index)
            {
                k=1;
            }
            else
            {
                if(currentPage>index)
                {
                    k=-1;
                }
            }
            isJumping=YES;
            [self  setContentOffset:CGPointMake(index*selfWidth*(!isVertical), index*selfHeight*isVertical) ];
            nextPage=currentPage+1;  //防止复用问题
            tempview=[realDelegate   BLpageScrollview:self viewForPageAtIndex:index];
            if(tempview==nil){return  NO;}
            if(tempview.superview!=self)
            {
                if(currentPage%2==1)
                {
                    [pluralPage removeFromSuperview];
                    pluralPage=tempview;
                }
                else
                {
                    [singularPage removeFromSuperview];
                    singularPage=tempview;
                }
                [self addSubview:tempview];
            }
            if(currentPage%2==1)
            {
                [singularPage setFrame:CGRectMake(index*selfWidth*(!isVertical), index*selfHeight*isVertical, selfWidth, selfHeight)];
                [UIView beginAnimations:@"jump" context:nil];
                [UIView setAnimationDuration:0];
                [singularPage setFrame:CGRectMake(-100, -100, selfWidth, selfHeight)];
                [UIView commitAnimations];
                
                [singularPage setFrame:CGRectMake(index*selfWidth*(!isVertical), index*selfHeight*isVertical, selfWidth, selfHeight)];
                [self sendSubviewToBack:singularPage];
            }
            else
            {
                [pluralPage setFrame:CGRectMake(index*selfWidth*(!isVertical), index*selfHeight*isVertical, selfWidth, selfHeight)];
                
                [UIView beginAnimations:@"jump" context:nil];
                [UIView setAnimationDuration:0];
                [pluralPage setFrame:CGRectMake(-100, -100, selfWidth, selfHeight)];
                [UIView commitAnimations];
                
                [pluralPage setFrame:CGRectMake(index*selfWidth*(!isVertical), index*selfHeight*isVertical, selfWidth, selfHeight)];
                [self sendSubviewToBack:pluralPage];
            }
            [tempview setFrame:CGRectMake(((int)(index+k)*selfWidth*(!isVertical)),((int)(index+k)*selfHeight*isVertical), selfWidth, selfHeight)];
            
            if(currentPage%2==1)
            {
                if(index%2==1)
                {
                    pluralPage=singularPage;
                    singularPage=tempview;
                }
            }
            else
            {
                if(index%2==0)
                {
                    singularPage=pluralPage;
                    pluralPage=tempview;
                }
            }
            currentPage=index;
            nextPage=index;
            [UIView beginAnimations:@"jump" context:nil];
            [UIView setAnimationDuration:0.25];
            [tempview setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
            [UIView commitAnimations];
            isJumping=NO;
            return YES;
        }
}
//下一页 nextPage
-(BOOL)nextPage
{
    if(currentPage==pageCount-1  || currentPage>pageCount || currentPage<0 || isLoad==NO)
    {
        if (!reach && [(NSObject*)(realDelegate) respondsToSelector:@selector(BLpageScrollviewReachBegain:)])
        {
            [realDelegate  BLpageScrollviewReachEnd:self];
        }
        return NO;
    }
    isJumping=YES;
    reach=NO;
    if((currentPage+1)!=nextPage || singularPage==nil ||  pluralPage==nil)
    {
        nextPage=currentPage+1;
        tempview=[realDelegate   BLpageScrollview:self viewForPageAtIndex:nextPage];
        if(tempview==nil){return NO;}
        if(tempview.superview!=self)
        {
            if((currentPage+1)%2==1)
            {
                [singularPage removeFromSuperview];
                singularPage=tempview;
                [self  addSubview:singularPage];
            }else
            {
                [pluralPage removeFromSuperview];
                pluralPage=tempview;
                [self  addSubview:pluralPage];
            }
        }
    }
    currentPage=currentPage+1;
    nextPage=currentPage-1;
    if(currentPage%2==1)
    {
        [singularPage  setFrame:CGRectMake((currentPage+1)*selfWidth*(!isVertical), (currentPage+1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [pluralPage  setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    else
    {
        [pluralPage  setFrame:CGRectMake((currentPage+1)*selfWidth*(!isVertical), (currentPage+1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [singularPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    [UIView beginAnimations:@"next" context:nil];
    [UIView setAnimationDuration:0.25];
    if(currentPage%2==1)
    {
        [pluralPage  setFrame:CGRectMake((currentPage-1)*selfWidth*(!isVertical), (currentPage-1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [singularPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    else
    {
        [singularPage  setFrame:CGRectMake((currentPage-1)*selfWidth*(!isVertical), (currentPage-1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [pluralPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    
    [UIView commitAnimations];
    [self  setContentOffset:CGPointMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical)  ];
    isJumping=NO;
    return  YES;
}
//上一页 prePage
-(BOOL)prePage
{
    if(currentPage==0  ||  currentPage>pageCount || currentPage<0 || isLoad==NO)
    {
        if (!reach && [(NSObject*)(realDelegate) respondsToSelector:@selector(BLpageScrollviewReachBegain:)] )
        {
            [realDelegate  BLpageScrollviewReachBegain:self];  //通知到达起始 Notice to reach the starting
        }
        return NO;
    }
    isJumping=YES;
    reach=NO;
    if((currentPage-1)!=nextPage || singularPage==nil ||  pluralPage==nil){
        nextPage=currentPage-1;
        tempview=[realDelegate   BLpageScrollview:self viewForPageAtIndex:nextPage];
        if(tempview==nil){return NO;}
        if(tempview.superview!=self){
            if((currentPage-1)%2==1){
                [singularPage removeFromSuperview];
                singularPage=tempview;
                [self  addSubview:singularPage];
            }else{
                [pluralPage removeFromSuperview];
                pluralPage=tempview;
                [self  addSubview:pluralPage];
            }
        }
    }
    currentPage=currentPage-1;
    nextPage=currentPage+1;
    if(currentPage%2==1){
        [singularPage setFrame:singularPage.frame=CGRectMake((currentPage-1)*selfWidth*(!isVertical), (currentPage-1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [pluralPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }else{
        [pluralPage setFrame:CGRectMake((int)((currentPage-1)*selfWidth*(!isVertical)), (int)((currentPage-1)*selfHeight*isVertical), selfWidth, selfHeight)];
        [singularPage  setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    [UIView beginAnimations:@"pre" context:nil];
    [UIView setAnimationDuration:0.25];
    if(currentPage%2==1){
        [pluralPage  setFrame:CGRectMake((currentPage+1)*selfWidth*(!isVertical), (currentPage+1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [singularPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }else{
        [singularPage setFrame:CGRectMake((currentPage+1)*selfWidth*(!isVertical), (currentPage+1)*selfHeight*isVertical, selfWidth, selfHeight)];
        [pluralPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    [UIView commitAnimations];
    [self  setContentOffset:CGPointMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical)  ];
    isJumping=NO;
    return  NO;
}
////改变视图方向
-(void)DirectionStyleChangeTo:(BLpageScrollviewDirectionStyle)DirectionStyle
{
    isJumping=YES;
    isVertical=(DirectionStyle==verticalDirectionForBLpageScrollview)?YES:NO;
    [self  setContentSize:CGSizeMake(selfWidth*isVertical+selfWidth*pageCount*(!isVertical)+1,pageCount*selfHeight*isVertical+selfHeight*(!isVertical))];
    [self  setContentOffset:CGPointMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical)  ];
    if(currentPage%2==1){
        [singularPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }else{
        [pluralPage setFrame:CGRectMake(currentPage*selfWidth*(!isVertical), currentPage*selfHeight*isVertical, selfWidth, selfHeight)];
    }
    nextPage=currentPage;
    isJumping=NO;
}
//重载 Overloaded
-(BOOL)reload
{
    if(realDelegate)
    {
        [self  jumpToPage:currentPage];
        return YES;
    }
    else return NO;
}
//重新加载所有数据，并跳转 reload all date and jump
-(BOOL)reloaddate:(unsigned  int)startWith
{
    if(realDelegate)
    {isLoad=NO;
        currentPage=startWith;
        nextPage=startWith;
        [self layoutSubviews];
        return YES;
    }
    else
        return NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(reset)
    {
        reach=NO;
    }
}
-(void)gotoNext
{
    reset=YES;
    reach=NO;
    isJumping=YES;
    self.scrollEnabled=NO;
    if(currentPage%2==0)
    {
        tempview=singularPage;
        singularPage=pluralPage;
        pluralPage=tempview;
    }
    nextPage=0;
    if([(NSObject*)realDelegate   respondsToSelector:@selector(numberOfPagesInBLpageScrollview:)])
    {
        pageCount= [realDelegate  numberOfPagesInBLpageScrollview:self];
    }
    
    [self setContentSize:CGSizeMake(selfWidth*isVertical+selfWidth*pageCount*(!isVertical)+1,pageCount*selfHeight*isVertical+selfHeight*(!isVertical))];
    
    
    
    [self setContentOffset:CGPointMake(0, 0)];
    
    [self  setContentOffset:CGPointMake(0, 0) ];
    tempview=[realDelegate   BLpageScrollview:self viewForPageAtIndex:0];
    
    
    
    if(tempview==nil){return  ;}
    if(tempview.superview!=self)
    {
        [pluralPage removeFromSuperview];
        pluralPage=tempview;
        [self addSubview:tempview];
    }
    
    [singularPage setFrame:CGRectMake(0,0,selfWidth,selfHeight)];
    [UIView beginAnimations:@"nextbook" context:nil];
    [UIView setAnimationDuration:0];
    [singularPage setFrame:CGRectMake(-100, -100, selfWidth, selfHeight)];
    [UIView commitAnimations];
    
    [singularPage setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
    [self sendSubviewToBack:singularPage];
    
    [tempview setFrame:CGRectMake((selfWidth*(!isVertical)),(selfHeight*isVertical), selfWidth, selfHeight)];
    
    currentPage=0;
    nextPage=0;
//    [UIView beginAnimations:@"nextbook" context:nil];
//    [UIView setAnimationDuration:0.25];
//    [tempview setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
//    [UIView commitAnimations];
//    isJumping=NO;
//    self.scrollEnabled=YES;
    
    [UIView animateWithDuration:0.35 animations:^{
        [tempview setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
    } completion:^(BOOL finished) {
        isJumping=NO;
        self.scrollEnabled=YES;
    }];
    
}
-(void)gotoPre:(NSUInteger)prenumber;
{
    reset=YES;
    reach=NO;
    self.scrollEnabled=NO;
    nextPage=1;
    if([(NSObject*)realDelegate   respondsToSelector:@selector(numberOfPagesInBLpageScrollview:)])
    {
        pageCount= [realDelegate  numberOfPagesInBLpageScrollview:self];
    }
    isJumping=YES;
    [self setContentSize:CGSizeMake(selfWidth*isVertical+selfWidth*pageCount*(!isVertical)+1,pageCount*selfHeight*isVertical+selfHeight*(!isVertical))];
    [self setContentOffset:CGPointMake(selfWidth*(!isVertical)*prenumber, selfHeight*isVertical*prenumber)];
    tempview=[realDelegate   BLpageScrollview:self viewForPageAtIndex:prenumber];
    if(tempview==nil){return  ;}
    if(tempview.superview!=self)
    {
        [singularPage removeFromSuperview];
        singularPage=tempview;
        [self addSubview:tempview];
    }
    [pluralPage setFrame:CGRectMake(selfWidth*(!isVertical)*prenumber,selfHeight*isVertical*prenumber ,selfWidth,selfHeight)];
    [UIView beginAnimations:@"prebook" context:nil];
    [UIView setAnimationDuration:0];
    [pluralPage setFrame:CGRectMake(-100, -100, selfWidth, selfHeight)];
    [UIView commitAnimations];
    [pluralPage setFrame:CGRectMake(selfWidth*(!isVertical)*prenumber,selfHeight*isVertical*prenumber ,selfWidth,selfHeight)];
    [self sendSubviewToBack:pluralPage];
    
    [tempview setFrame:CGRectMake((selfWidth*(!isVertical)*(prenumber-1)),(selfHeight*isVertical*(prenumber-1)), selfWidth, selfHeight)];
    
    currentPage=prenumber;
    nextPage=prenumber;
//    [UIView beginAnimations:@"prebook" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [tempview setFrame:CGRectMake(selfWidth*(!isVertical)*prenumber,selfHeight*isVertical*prenumber ,selfWidth,selfHeight)];
//    [UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        [tempview setFrame:CGRectMake(selfWidth*(!isVertical)*prenumber,selfHeight*isVertical*prenumber ,selfWidth,selfHeight)];
    } completion:^(BOOL finished) {
        self.scrollEnabled=YES;
        isJumping=NO;
    }];
    if(prenumber%2==0)
    {    singularPage=pluralPage;
        pluralPage=tempview;
    }
//    isJumping=NO;
//    self.scrollEnabled=YES;
}
@end
