

#import "BLLeavesController.h"

@implementation BLLeavesController
@synthesize datasource,midclickdelegate,CustomDataSourceDelegate;

-(void)dealloc
{
    [currentview release];
    [super dealloc];
}


-(id)initandsetpageisdouble:(BOOL)_pageisdouble frame:(CGRect)frame  rightcolor:(UIColor*)rightcolor
{
if(self=[super init])
{
    UIView1=nil;
    UIView2=nil;
    pageisdouble=_pageisdouble;
    selfframe=frame;
    self.rightbackgroundcolor=rightcolor;
}
    return self;
}



#pragma mark - View lifecycle




-(void)BLviewSetUIView1:(UIView*)_UIView1  UIView2:(UIView*)_UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin;
{
    UIView1=[_UIView1 retain];
    UIView2=[_UIView2 retain];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame=selfframe;
    UIView2.backgroundColor=rightbackgroundcolor;
    if(pageisdouble)
    {
        currentview=[[BLLeave1 alloc]initWithFrame:self.view.bounds];
       [self.view addSubview:currentview];
        if([UIView1 isKindOfClass: [SimpleTextBookView class]])
        {
            ((SimpleTextBookView*)UIView1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
        }
        
        
        
       [currentview  BLviewSetUIView1:UIView1 UIView2:UIView2 animation:NO DirectionToNext:NO]; 
        currentview.datasource=self;
		currentview.midclickdelegate=midclickdelegate;
    }
    else
    {
        currentview=[[BLLeave1 alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:currentview];
       [currentview  BLviewSetUIView1:UIView1 UIView2:UIView2 animation:NO DirectionToNext:NO]; 
        currentview.datasource=self;
		currentview.midclickdelegate=midclickdelegate;
    }
    [UIView1 release];
    [UIView2 release];
}


-(void)JunpToshowNewPage:(NSInteger)pageIndex
{
    UIView* v1=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:pageIndex];
    if(pageisdouble)
    {
        if([v1 isKindOfClass: [SimpleTextBookView class]])
        {
            ((SimpleTextBookView*)v1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
        }
    }
    
    [currentview BLviewSetUIView1:v1 UIView2:nil animation:NO DirectionToNext:NO];
}
  
-(void)JunpToshowNewPage:(UIPageViewControllerNavigationDirection)direction   jumpIndex:(NSInteger)pageIndex animated:(BOOL)animated{
    self.CurrenPageIndex=pageIndex;
    UIView* v1=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:pageIndex];
    if(pageisdouble)
    {
    if([v1 isKindOfClass: [SimpleTextBookView class]])
    {
        ((SimpleTextBookView*)v1).ChapterFootView.textAlignment=NSTextAlignmentLeft;
    }
    }
     [currentview BLviewSetUIView1:v1 UIView2:nil animation:NO DirectionToNext:NO];
}


-(UIView*)dequeueReusablePage
{
    return nil;
}
-(unsigned  int)getCurrentPageNumber
{
    return CurrenPageIndex;
}

- (BOOL)reload
{
    [self  JunpToshowNewPage:CurrenPageIndex];
    return YES;
}

-(BOOL)reloaddate:(unsigned  int)startWith
{
    CurrenPageIndex=startWith;
    [self  JunpToshowNewPage:startWith];
    return YES;
}


-(UIView*)BLviewdatasourceViewForNextPage:(id)BLview     //请求后页
{

    if ( (CurrenPageIndex+1)<[self.CustomDataSourceDelegate numberOfPages:self]) {
        
    }else {
        if((BOOL)[CustomDataSourceDelegate useraskfornextchapter])
        {
            return nil;
        }
        
        NSInteger temppages=[self.CustomDataSourceDelegate NextChapter];
        if (temppages==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
            
            return nil;
        }else {
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:0];
            
            [self.CustomDataSourceDelegate PrevChapter];
            
            return  vi;
        }
    }
    
    
    
    return  [CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex+1];
}

-(UIView*)BLviewdatasourceViewForPrePage:(id)BLview      //请求前页
{
    if ( (CurrenPageIndex-1)>=0) {
    }else {
        NSInteger temppages=[self.CustomDataSourceDelegate PrevChapter];
        
        if (temppages==-1 ) {
            //已经是第一页
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
            return nil;
        }else {
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:[CustomDataSourceDelegate  numberOfPages:self]-1];
            [self.CustomDataSourceDelegate NextChapter];
            
            return vi;
        }
    }
    return  [CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex-1];
}

-(void)BLviewdatasourceViewReachBegain:(id)BLview
{
    
    [self.CustomDataSourceDelegate  CustomPageViewReachBegain:self];
}


-(void)BLviewdatasourceViewReachEnd:(id)BLview
{
    [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
}

-(void)BLviewdatasourceCurrentPageChangedBy:(int)indexChangeCount
{
    CurrenPageIndex+=indexChangeCount;
    if(CurrenPageIndex<0  )
    {
        if([self.CustomDataSourceDelegate PrevChapter]==-1)
        {
            CurrenPageIndex=0;
            return;
        }
        CurrenPageIndex=[CustomDataSourceDelegate numberOfPages:self]-1;
        }
    else
    {
    if(!((CurrenPageIndex)<[self.CustomDataSourceDelegate numberOfPages:self]))
       {
        if([self.CustomDataSourceDelegate NextChapter]!=-1)
        {CurrenPageIndex=0;}
       }
    }
    
    
}
//双叶

-(UIView*)BLviewdatasourceViewNullAtleft:(id)BLview//返回用于双倍页的空内容页
{
    UIView* one=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex];
    UIView* two=[[[UIView alloc]initWithFrame:one.frame] autorelease];
    two.backgroundColor=one.backgroundColor;
    return two;
}

-(UIView*)BLviewdatasourceViewNullAtright:(id)BLview//返回用于双倍页的空内容页
{
    UIView* one=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex+1];
    UIView* two=[[[UIView alloc]initWithFrame:one.frame] autorelease];
    two.backgroundColor=rightbackgroundcolor;
    return one;
}

-(UIView*)BLviewdatasourceViewForNextPageAtleft:(id)BLview     //请求在左页的后一页
{
    if ( (CurrenPageIndex+1)<[self.CustomDataSourceDelegate numberOfPages:self]) {
        
    }else {
        
        NSInteger temppages=[self.CustomDataSourceDelegate NextChapter];
        if (temppages==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
            
            return nil;
        }else {
            
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:0];
            
            [self.CustomDataSourceDelegate PrevChapter];
            
            if([vi isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentLeft;
            }

            return  vi;
        }
        
        
        
        
    }
    

    
    UIView* vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex+1];
    if([vi isKindOfClass: [SimpleTextBookView class]])
    {
        ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentLeft;
    }

    return  vi;

}

-(UIView*)BLviewdatasourceViewForNextPageAtright:(id)BLview     //请求在右页的后一页
{
    if ( (CurrenPageIndex+1)<[self.CustomDataSourceDelegate numberOfPages:self]) {
    }else {
        
        NSInteger temppages=[self.CustomDataSourceDelegate NextChapter];
        if (temppages==-1 ) {
            //已经是最后一页
            [self.CustomDataSourceDelegate CustomPageViewReachEnd:self];
            return nil;
        }else {
            
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:0];
            
            [self.CustomDataSourceDelegate PrevChapter];
            vi.backgroundColor=rightbackgroundcolor;
            

            if([vi isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentRight;
            }
            return  vi;
        }
    }
   UIView*vi= [CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex+1];
    
    vi.backgroundColor=rightbackgroundcolor;

    if([vi isKindOfClass: [SimpleTextBookView class]])
    {
        ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentRight;
    }
    return  vi;

}


-(UIView*)BLviewdatasourceViewForPrePageAtleft:(id)BLview     //请求在左页的前一页
{

    if ( (CurrenPageIndex-1)>=0) {
        
        
    }else {
        NSInteger temppages=[self.CustomDataSourceDelegate PrevChapter];
        
        if (temppages==-1 ) {
            //已经是第一页
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
            return nil;
        }else {
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:[CustomDataSourceDelegate  numberOfPages:self]-1];
            [self.CustomDataSourceDelegate NextChapter];
            
            if([vi isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentLeft;
            }

            
            return vi;
            
            
        }
    }
    UIView*vi= [CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex-1];
    if([vi isKindOfClass: [SimpleTextBookView class]])
    {
        ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentLeft;
    }

    return  vi;
}


-(UIView*)BLviewdatasourceViewForPrePageAtright:(id)BLview    //请求在右页的前一页
{
    if ( (CurrenPageIndex-1)>=0) {
        
        
    }else {
        NSInteger temppages=[self.CustomDataSourceDelegate PrevChapter];
        
        if (temppages==-1 ) {
            //已经是第一页
            [self.CustomDataSourceDelegate CustomPageViewReachBegain:self];
            return nil;
        }else {
            
            UIView*vi=[CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:[CustomDataSourceDelegate  numberOfPages:self]-1];
            [self.CustomDataSourceDelegate NextChapter];
            vi.backgroundColor=rightbackgroundcolor;
 
            if([vi isKindOfClass: [SimpleTextBookView class]])
            {
                ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentRight;
            }
            
            return vi;
            
            
        }
    }
    UIView*vi= [CustomDataSourceDelegate  CustomPageView:self viewForPageAtIndex:CurrenPageIndex-1];
    
    vi.backgroundColor=rightbackgroundcolor;
    
    
    if([vi isKindOfClass: [SimpleTextBookView class]])
    {
        ((SimpleTextBookView*)vi).ChapterFootView.textAlignment=NSTextAlignmentRight;
    }
    return  vi;
    

}



@end
