//
//  ScrollPageViewController.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollPageViewController.h"
@interface ScrollPageViewController ()
-(UIView*)createNullleft;
-(UIView*)createNullright;
-(UIView*)Createwith:(UIView*)vi1  vi2:(UIView*)vi2;
@end

@implementation ScrollPageViewController
@synthesize  BLpageTest,CustomDataSourceDelegate,datasource,midclickdelegate;
-(void)dealloc{
    self.BLpageTest=nil;
    [super dealloc];
}
-(id)init{
    if (self=[super init]) {
//        self.BLpageTest=[[[BLpageScrollview  alloc]initWithFrame:self.view.bounds Directionstyle:horizontalDirectionForBLpageScrollview] autorelease];
//        BLpageTest.showsHorizontalScrollIndicator= NO;
//        BLpageTest.showsVerticalScrollIndicator=NO;
//        BLpageTest.delegate=self;    
//        BLpageTest.pagingEnabled=YES;
//        [self.view  addSubview:BLpageTest];
//        [self.view  sendSubviewToBack:BLpageTest];
//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [BLpageTest addGestureRecognizer:singleTap];
//        singleTap.delegate = self;
//        singleTap.numberOfTapsRequired=1;
//        singleTap.cancelsTouchesInView = NO;
//        [singleTap release]; 
    }
    return self;
}
 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.x>(self.view.bounds.size.width/4.0) && touchPoint.x<=3*(self.view.bounds.size.width/4.0) && touchPoint.y>=(self.view.bounds.size.height/4.0)&& touchPoint.y<=(self.view.bounds.size.height/4.0)*3 ){
            return NO;
        }
    }
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self.view];
    if (touchPoint.x<=(self.view.bounds.size.width/3.0) && touchPoint.x>=0){
        [BLpageTest  prePage];
    }else {
        [BLpageTest  nextPage];
    }

    
}
 -(UIView*)BLpageScrollview:(BLpageScrollview*)myBLpageScrollview  viewForPageAtIndex:(NSInteger)index
{
    if(pageisdouble)
    {
        if(CureentisnoCurrent)
        {
            CureentisnoCurrent=NO;
            [CustomDataSourceDelegate  NextChapter];
        }
        
        if(starsin)
        {
        if(index==0)
        {
             NSInteger key= [CustomDataSourceDelegate  PrevChapter];
             if(key==-1)
             {
                 view1=[self createNullleft];
             }else
             {
                 view1=[CustomDataSourceDelegate  CustomPageView:nil viewForPageAtIndex:[CustomDataSourceDelegate numberOfPages:self]-1];
                 [CustomDataSourceDelegate NextChapter];
             }
            view2=[CustomDataSourceDelegate  CustomPageView:nil viewForPageAtIndex:0];
            view2.backgroundColor=rightbackgroundcolor;
            
            if([view1 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
            }
            if([view2 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view2).ChapterFootView.textAlignment=NSTextAlignmentRight;
            }

            
            return [self Createwith:view1 vi2:view2];
        }
//            self.CurrenPageIndex=[myBLpageScrollview getCurrentPageNumber];
            view1=[self.CustomDataSourceDelegate CustomPageView:nil viewForPageAtIndex:index*2-1];
            if(index*2>=[CustomDataSourceDelegate  numberOfPages:self])
            {
                view2=[self createNullright];
            }
            else
            {
            view2=[self.CustomDataSourceDelegate CustomPageView:nil viewForPageAtIndex:index*2];
            }
            view2.backgroundColor=rightbackgroundcolor;
            
            if([view1 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
            }
            if([view2 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view2).ChapterFootView.textAlignment=NSTextAlignmentRight;
            }
            
            return [self Createwith:view1 vi2:view2];
        }
        else
        {
//            self.CurrenPageIndex=[myBLpageScrollview getCurrentPageNumber];
            view1=[self.CustomDataSourceDelegate CustomPageView:nil viewForPageAtIndex:index*2];
            if(index*2+1>=[CustomDataSourceDelegate  numberOfPages:self])
            {
                view2=[self createNullright];
            }
            else
            {
                view2=[self.CustomDataSourceDelegate CustomPageView:myBLpageScrollview viewForPageAtIndex:index*2+1];
            }
            view2.backgroundColor=rightbackgroundcolor;
            
            if([view1 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
            }
            if([view2 isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)view2).ChapterFootView.textAlignment=NSTextAlignmentRight;
            }
            
            return [self Createwith:view1 vi2:view2];
        }
        
    
    }
    else
    {
    
    self.CurrenPageIndex=[myBLpageScrollview getCurrentPageNumber];
        UIView*vi=[self.CustomDataSourceDelegate CustomPageView:BLpageTest viewForPageAtIndex:index];

    return vi;
    }

}

-(BOOL)reload
{
    [BLpageTest reload];
    return YES;
}

-(unsigned int)getCurrentPageNumber
{
    if(pageisdouble)
    {
        if(CureentisnoCurrent)
        {
            CureentisnoCurrent=NO;
            [CustomDataSourceDelegate  NextChapter];
        }
        int key=[BLpageTest  getCurrentPageNumber];
        if(starsin)
        {
            if(key==0)
            {
                key=[CustomDataSourceDelegate  PrevChapter];
                if(key==-1)
                {
                    return 0;
                }
                CureentisnoCurrent=YES;
                
                return  [CustomDataSourceDelegate  numberOfPages:self]-1;
                
            }
            CurrenPageIndex=key*2-1;
            return key*2-1;
        }
        else
        {
            CurrenPageIndex=key*2;
            return key*2;
        }
    }
    else
    {
        return [BLpageTest getCurrentPageNumber];
    }

}

//请求页面个数，小于2页无法滑动 The number of requests a page, less than 2 can not slide
-(unsigned  int)numberOfPagesInBLpageScrollview:(BLpageScrollview*)myBLpageScrollview{
    
    if(pageisdouble){
        if(CureentisnoCurrent){
            CureentisnoCurrent=NO;
            [CustomDataSourceDelegate  NextChapter];
        }
        
        if([CustomDataSourceDelegate NextChapter]==-1){
            int key=[CustomDataSourceDelegate numberOfPages:self];
            int num;
            if(starsin)
            {
              if(key%2==0)
              {
                  num=key/2+1;
              }
                else
                {
                    num=key/2+1;
                }
                
            }
            else
            {
                if(key%2==0)
                {
                    num=key/2;
                }
                else
                {
                    num=key/2+1;
                }
            }
            
            return num;
        }
        else
        {
            [CustomDataSourceDelegate  PrevChapter];
        }
        
        
        int key=[self.CustomDataSourceDelegate numberOfPages:self];
        if(starsin)
        {
            if(key%2==0)
            {
            return key/2;
            }
            else
            {
                return key/2+1;
            }
            
            
        }
        else
        {
            return key/2;
        }
    }else{
        return [self.CustomDataSourceDelegate numberOfPages:self];
    }
}

- (void)BLpageScrollviewReachEnd:(BLpageScrollview*)myBLpageScrollview {
    if((BOOL)[CustomDataSourceDelegate useraskfornextchapter]){
        return ;
    }
    
    if(CureentisnoCurrent){
        CureentisnoCurrent=NO;
        [CustomDataSourceDelegate  NextChapter];
    }
    
    if(pageisdouble)
    {
        int prekey=[CustomDataSourceDelegate numberOfPages:self];
        int key=[self.CustomDataSourceDelegate NextChapter];
        if (key==-1 ) {
            //已经是最后一页
//            [BLpageTest stopEndPageEvent];
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
            return;
        }else {
            //NextChapter
            //        [myBLpageScrollview  jumpToPage:0];
          if(prekey%2==0){
              if(starsin)
              {
                  starsin=YES;
              }
              else
              {
                  starsin=NO;
              }
          
          }else{
                if(starsin)
                {
                    starsin=NO;
                }
                else
                {
                    starsin=YES;
                }
            }
            
            if(starsin==NO)
            {
            if([CustomDataSourceDelegate numberOfPages:self]==1)
            {
                starsin=YES;
               int ne= [CustomDataSourceDelegate NextChapter];
                
                if(ne==-1)
                {
                    starsin=NO;
                
                }
                
            }
        }
            
            [myBLpageScrollview gotoNext];
        }
    }
    else
    {
        CurrenPageIndex=[self.CustomDataSourceDelegate NextChapter];
        if (CurrenPageIndex==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
        }else {
            //NextChapter
            //        [myBLpageScrollview  jumpToPage:0];
            [myBLpageScrollview gotoNext];
        }
    
    }
    
   
}
-(void)BLpageScrollviewReachBegain:(BLpageScrollview*)myBLpageScrollview{
    if(CureentisnoCurrent)
    {
        CureentisnoCurrent=NO;
        [CustomDataSourceDelegate  NextChapter];
    }
    
    if(pageisdouble)
    {
        int key2=[self.CustomDataSourceDelegate PrevChapter];
        if (key2==-1 ) {
            //已经是最后一页
//            [BLpageTest  stopEndPageEvent];
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
        }else {
            int key=[CustomDataSourceDelegate  numberOfPages:self];
            if(starsin)
            {
                if(key==1)
                {
                    int k=[self.CustomDataSourceDelegate PrevChapter];
                    if(k!=-1)
                    {
                        int kk=[CustomDataSourceDelegate numberOfPages:self];
                        if(kk%2==0)
                        {
                            starsin=NO;
                        }
                        else
                        {
                            starsin=YES;
                        }
                        
                    [BLpageTest gotoPre:[CustomDataSourceDelegate numberOfPages:self]/2-1+1*starsin];
                        return;
                    }
                    else
                    {
                        [CustomDataSourceDelegate NextChapter];
//                        [BLpageTest  stopEndPageEvent];
                        [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
                        return;
                    }
                }
                if(CureentisnoCurrent)
                {
                    CureentisnoCurrent=NO;
                    [CustomDataSourceDelegate  NextChapter];
                }
                
                
                if(key%2==0)
                {
                    starsin=YES;
                [myBLpageScrollview gotoPre:key/2-1];
                }
               else
               {
                   starsin=NO;
                   [myBLpageScrollview gotoPre:key/2-1];
               }
                
           
            }
            else
            {
                
                if(CureentisnoCurrent)
                {
                    CureentisnoCurrent=NO;
                    [CustomDataSourceDelegate  NextChapter];
                }
                if(key%2==0)
                {
                    starsin=NO;
                    [myBLpageScrollview gotoPre:key/2-1];
                }
                else
                {
                    starsin=YES;
                    [myBLpageScrollview gotoPre:key/2];
                }
            }
        }
    
    }
    else
    {
        CurrenPageIndex=[self.CustomDataSourceDelegate PrevChapter];
        if (CurrenPageIndex==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
        }else {
            //PrevChapter
            [myBLpageScrollview gotoPre:[self.CustomDataSourceDelegate numberOfPages:self ]-1];
            
        }
    }
}
-(void)JunpToshowNewPage:(NSInteger)pageIndex
{
    CureentisnoCurrent=NO;
    if(pageisdouble)
    {
        int key=[CustomDataSourceDelegate numberOfPages:self];
        if(key==1)
        {
            key=[CustomDataSourceDelegate NextChapter];
            if(key==-1)
            {
                [BLpageTest reloaddate:0];
            }
            else
            {
                [BLpageTest reloaddate:0];
            }
            //
            starsin=NO;
            //
            return;
        
        }
        
        
        
        if(pageIndex==(key-1))
        {
           if([CustomDataSourceDelegate NextChapter]==-1)
           {
               
               if(key%2==0)
               {
                   starsin=YES;
               }
               else
               {
                   starsin=NO;
               }
               [BLpageTest  reloaddate:[CustomDataSourceDelegate numberOfPages:self]/2];
               return;
           }
            starsin=YES;
            [BLpageTest reloaddate:0];
            return;
        }
     if((pageIndex%2)==0)
     {
         starsin=NO;
         [BLpageTest reloaddate:pageIndex/2];
     }else
     {
         starsin=YES;
     [BLpageTest reloaddate:(pageIndex+1)/2];
     }
    }
    else
    {
        [BLpageTest  reloaddate:pageIndex];
    }
    
}

-(int)CurrenPageIndex
{
  if(pageisdouble)
  {
      if(CureentisnoCurrent)
      {
          CureentisnoCurrent=NO;
          [CustomDataSourceDelegate  NextChapter];
      }
      
      
      
      int key=[BLpageTest  getCurrentPageNumber];
      if(starsin)
      {
          if(key==0)
          {
             key=[CustomDataSourceDelegate  PrevChapter];
              if(key==-1)
              {
                  return 0;
              }
              CureentisnoCurrent=YES;
              
             return  [CustomDataSourceDelegate  numberOfPages:self]-1;
              
          }
          CurrenPageIndex=key*2-1;
          return key*2-1;
      }
      else
      {
          CurrenPageIndex=key*2;
          return key*2;
      }
  }
    else
    {
    return [BLpageTest getCurrentPageNumber];
    }
        
    
}
-(void)setCurrenPageIndex:(int)_CurrenPageIndex
{
    CurrenPageIndex=_CurrenPageIndex;

}




-(UIView*)createNullleft
{
    UIView* view=[CustomDataSourceDelegate  CustomPageView:nil viewForPageAtIndex:0];
    UIView* vi=[[[UIView alloc]initWithFrame:view.frame]autorelease ];
    vi.backgroundColor=view.backgroundColor;
    return vi;
}

-(UIView*)createNullright
{
    UIView* view=[CustomDataSourceDelegate  CustomPageView:nil viewForPageAtIndex:0];
    UIView* vi=[[[UIView alloc]initWithFrame:CGRectMake(view.bounds.size.width, 0, view.bounds.size.width, view.bounds.size.height)] autorelease];
    vi.backgroundColor=rightbackgroundcolor;
    return vi;
}

-(UIView*)Createwith:(UIView*)vi1  vi2:(UIView*)vi2
{
    UIView* vi=[[[UIView alloc]initWithFrame:self.view.bounds] autorelease];
    vi2.frame=CGRectMake(vi2.bounds.size.width, 0, vi2.bounds.size.width, vi2.bounds.size.height);
    [vi addSubview:vi1];
    [vi addSubview:vi2];
    return vi;
}
 
-(id)initandsetpageisdouble:(BOOL)_pageisdouble frame:(CGRect)frame  rightcolor:(UIColor*)rightcolor
{
    self=[super init];
    selfframe=frame;
    CureentisnoCurrent=NO;
    pageisdouble=_pageisdouble;
    self.rightbackgroundcolor=rightcolor;
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame=selfframe;
    self.BLpageTest=[[[BLpageScrollview  alloc]initWithFrame:self.view.bounds Directionstyle:horizontalDirectionForBLpageScrollview] autorelease];
    BLpageTest.showsHorizontalScrollIndicator= NO;
    BLpageTest.showsVerticalScrollIndicator=NO;
    BLpageTest.delegate=self;
    
    BLpageTest.pagingEnabled=YES;
    [self.view addSubview:BLpageTest];
    [self.view sendSubviewToBack:BLpageTest];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [BLpageTest addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired=1;
    singleTap.cancelsTouchesInView = NO;
    [singleTap release];
    
}



@end
