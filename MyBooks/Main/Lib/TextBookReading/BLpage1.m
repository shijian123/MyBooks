//
//  BLpage1.m
//  BLpageController
//
//  Created by BLapple on 13-1-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLpage1.h"


@implementation BLpage1{
    bool m_fingerStart;
    bool m_fingerStartOne;
    bool m_needTextureExchange;
    bool m_rightToLeft;
    bool m_goonOrBack;
    bool m_lastFingerStart;
    float m_fingerLengthPosition_x;
    float m_fingerPositionBeforeFingerStart_x;
	float m_fingerPositionBeforeFingerStart_y;
    
    float mWidth, mHeight;
    
    bool threadneedCancel;
    bool needFingerPosition;
    
    
    NSLock *m_texLock;
    
}
@synthesize datasource,midclickdelegate,custom;
-(void)dealloc
{
  
    custom.dataSource=nil;
    custom.delegate=nil;
    [custom removeFromParentViewController];
    [custom release];
    
    
    if (![animateThread isCancelled]) {
        [animateThread cancel];
        
    }
    [animateThread release];
    animateThread=nil;
    //    [opglview delinit_page];
    [opglview removeFromSuperview];
    [opglview release];
    
    opglview.context=nil;
    opglview.delegate=nil;
    //
    [m_lock release];
    [m_texLock release];
    
    
    [super dealloc];
}


-(id)initWithframe:(CGRect)frame
{
    if(self=[super init])
    {
        self.view.frame=frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber
      numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    UIPageViewController*temPageVC=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.custom=temPageVC;
    [temPageVC release];
    //    custom.MidAreaClickdelegate=self;
    custom.delegate=self;
    custom.dataSource=self;
    custom.doubleSided=YES;
    custom.view.frame=self.view.bounds;
    
    
    //初始化默认皮肤索引
    viewSkinIndex=-1;
    m_lock = [[NSLock alloc] init];
    m_texLock=[[NSLock alloc] init];
    m_locks_lock = true;
    needFingerPosition = false;
    [self GLviewDisplay];
    [opglview setNeedsDisplay];
    //    [self.view addSubview:custom.view];
    //    [self addChildViewController:custom];
}
#pragma mark-opengl专区
-(void)initOpenglView//初始化3d翻页管理view。
{
    
    //获得当前页，下一页，上一页图片
    UIView*oneView=[datasource BLviewdatasourceViewForCurrentPage:self];
    CGRect curViewFrame=oneView.frame;
    //    oneView.frame=[UIScreen mainScreen].bounds;
    
    
    
    
    
    if (opglview.superview!=nil) {
        [opglview removeFromSuperview];
    }
    if (opglview!=nil) {//这样写纯粹是为了留着注释
    }
    else
    {
        
        EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        opglview = [[OpenGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        opglview.frame=self.view.bounds;
        //        opglview = [[OpenGLView alloc] initWithFrame:[[UIWindow ] bounds]];
        opglview.context = context;
        opglview.delegate = self;
        //opglview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        
        opglview.drawableColorFormat = GLKViewDrawableColorFormatRGB565;
        opglview.drawableDepthFormat = GLKViewDrawableDepthFormat16;
        [EAGLContext setCurrentContext:context];
        [opglview setupContext];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGFloat scale_screen=[UIScreen mainScreen].scale;
        CGSize size = rect.size;
        mWidth = size.width * scale_screen;
        mHeight = size.height * scale_screen;
        
        
        m_lastFingerStart = false;
        
        
    }
    
    UIImage* zhizhenss[1];
    zhizhenss[0] = [self getImageFromView:oneView];
    [self textursExchange];
    [self setNowimage:zhizhenss[0]];
    [self setimage:zhizhenss[0]];
    //    oneView=[self getNextView];
    //    zhizhenss[0] = [self getImageFromView:oneView];
    //    [self setimage:zhizhenss[0]];
    
    if (viewSkinIndex==505) {
        [opglview setNight:YES];
    }
}

- (void)glkView:(GLKView *)aview drawInRect:(CGRect)rect {
    [opglview render];
    
}
- (void)GLviewDisplay
{
    [m_lock lock];
    [opglview display];
    [m_lock unlock];
}
- (void)startAnimations
{
    //    if ([[NSThread currentThread] isCancelled])
    //    {
    //        [NSThread exit];
    //    }
    while ([opglview getRenderOver] || threadneedCancel) {
        //        [self performSelectorOnMainThread:@selector(GLviewDisplay) withObject:nil waitUntilDone:YES];
        if([opglview getRenderOver])
        {
            [self performSelectorOnMainThread:@selector(GLviewDisplay) withObject:nil waitUntilDone:YES];
        }else if(needFingerPosition){
            [self performSelectorOnMainThread:@selector(GLviewDisplay) withObject:nil waitUntilDone:YES];
            needFingerPosition =false;
        }
    }
    [self textursExchange];
}
- (void)textursExchange{
    if(m_needTextureExchange){
        [opglview texturesExchange];
        m_needTextureExchange = false;
        [opglview resetPageTurnEndPositionParamter];
        [self GLviewDisplay];
    }
}

-(void)setNowimage : (UIImage*) image
{
    //[self performSelectorOnMainThread:@selector(UIimageToTexture : 0 : image) withObject:nil waitUntilDone:YES];
    [self UIimageToTexture : 0 : image];
}
-(void)setimage : (UIImage*) image
{
    [self UIimageToTexture : 1 : image];
}
-(void)UIimageToTexture : (unsigned) index : (UIImage*) image
{
    [m_texLock lock];
    [opglview UIimageTotexture : index : image];
    [m_texLock unlock];
}
-(void)setRightOrLeft : (bool)on
{
    float x;
    x = on ? self.view.bounds.size.width-20.0f : 20.f;
    [opglview setFingerPosition : x : (self.view.bounds.size.height / 2.0f)];
    if(!threadneedCancel)
    {
        animateThread = [[NSThread alloc] initWithTarget:self selector:@selector(startAnimations) object:nil];
        [animateThread start];
        [opglview setfingerOn:false];
        threadneedCancel = true;
    }
    needFingerPosition = true;
    [self textursExchange];
    if (on){
        m_fingerStart = true;
        m_rightToLeft = true;
        [opglview setRightToLeft : m_rightToLeft];
        m_fingerLengthPosition_x = x;
        [opglview texturesExchange];
        [opglview resetPageTurnBeginPositionParamter];
        
        UIView*oneView=[self getNextView];
        
        if (oneView==nil) {
            m_fingerStartOne = false;
            return;
        }
        noPreFlag=false;
        //                    [self updateCurrentView:oneView];
        UIImage*img=[self getImageFromView:oneView];
        
        //                    [self performSelectorOnMainThread:@selector(setNowimage:) withObject:img waitUntilDone:YES];
        [self setNowimage: img];
        [datasource BLviewdatasourceCurrentPageChangedBy:1];
    } else {
        m_fingerStart = true;
        m_rightToLeft = false;
        [opglview setRightToLeft : m_rightToLeft];
        m_fingerLengthPosition_x = x;
        [opglview resetPageTurnEndPositionParamter];
        
        UIView*oneView=[self getPreView];
        
        UIImage*img=[self getImageFromView:oneView];
        if (oneView==nil) {
            m_fingerStartOne = false;
            return;
        }
        noNextFlag=false;
        //                    [self updateCurrentView:oneView];
        //                    [self performSelectorOnMainThread:@selector(setimage:) withObject:img waitUntilDone:YES];
        [self setimage:img];
        [datasource BLviewdatasourceCurrentPageChangedBy:-1];
    }
    
    if(on){
        m_goonOrBack = true;
    }else{
        m_goonOrBack = true;
        m_needTextureExchange = true;
    }
    [opglview setGoonOrBack:m_goonOrBack];
    m_lastFingerStart = m_fingerStart;
    [self computePage];
    [opglview setfingerOn:m_fingerStart];
    threadneedCancel = false;
    m_fingerStart = false;
    
    m_fingerStartOne = false;
}
#pragma mark-黑夜模式调整
-(void)viewBackgroudChangedWithIndex:(NSNumber*)num
{
    int n=[num intValue];
    viewSkinIndex=n ;
    if (opglview!=nil) {
        if (n==505) {
            [opglview setNight:YES];
            [self GLviewDisplay];
        }
        else
        {
            [opglview setNight:false];
            [self GLviewDisplay];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if ([datasource respondsToSelector:@selector(startOrPauseAutoScrollPage:)]) {
    //        id tempId=datasource;
    //        [tempId performSelectorOnMainThread:@selector(startOrPauseAutoScrollPage:) withObject:false waitUntilDone:YES];
    //    }
    //    id tempSource=datasource;
    //    tempSource performSelectorOnMainThread:@selector(start) withObject:<#(id)#> waitUntilDone:<#(BOOL)#>
    UITouch*touch=[touches anyObject];
    CGPoint touchpoint=[touch locationInView:self.view];
    TouchBeginPoint=touchpoint;
    [self GLviewDisplay];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isPingBi) {
        return;
    }
    UITouch*touch=[touches anyObject];
    CGPoint touchpoint=[touch locationInView:self.view];
    CGFloat scale_screen=[UIScreen mainScreen].scale;
    
    
    
    if (noPreFlag&&(touchpoint.x>TouchBeginPoint.x)) {
        [datasource BLviewdatasourceViewReachBegain:self];
        return;
    }
    if (noNextFlag&&(touchpoint.x<TouchBeginPoint.x)) {//最大页码数还没有想好，最后要测直接在最后一页进入3d翻页
        [datasource BLviewdatasourceViewReachEnd:self];
        return;
    }
    float x = touchpoint.x * scale_screen;
    float y = touchpoint.y * scale_screen;
    
    if(m_fingerStart){
        if(m_rightToLeft){
            m_fingerLengthPosition_x = m_fingerLengthPosition_x > x ? x : m_fingerLengthPosition_x;
        }else{
            m_fingerLengthPosition_x = m_fingerLengthPosition_x < x ? x : m_fingerLengthPosition_x;
        }
        [opglview setFingerPosition : x : y ];
        [self GLviewDisplay];
        
    }else{
        if(m_fingerStartOne){
            float length = (m_fingerPositionBeforeFingerStart_x - x) * (m_fingerPositionBeforeFingerStart_x - x)
            + (m_fingerPositionBeforeFingerStart_y - y) * (m_fingerPositionBeforeFingerStart_y - y);
            //            [opglview setFingerPosition : x : y ];
            
            if(length >= 25.0){
                //                [opglview setFingerPosition : x : y ];//2014年07月29日
                if( [opglview getRenderOver])
                {
                    if(threadneedCancel)
                    {
                        [animateThread cancel];
                        [animateThread release];
                        threadneedCancel = false;
                    }
                    [opglview setfingerOn:false];
                }else{
                    //m_threadAux = false;
                    //[GLview setfingerOn:false];
                }
                
                m_rightToLeft = (m_fingerPositionBeforeFingerStart_x > x);
                m_fingerLengthPosition_x = m_rightToLeft ? mWidth : 0;
                
                [opglview setRightToLeft:m_rightToLeft];
                
                [self textursExchange];
                
                if(m_rightToLeft)
                {
                    
                    [opglview texturesExchange];
                    [opglview resetPageTurnBeginPositionParamter];
                    
                    UIView*oneView=[self getNextView];
                    
                    if (oneView==nil) {
                        m_fingerStartOne = false;
                        return;
                    }
                    noPreFlag=false;
                    //                    [self updateCurrentView:oneView];
                    UIImage*img=[self getImageFromView:oneView];
                    
                    //                    [self performSelectorOnMainThread:@selector(setNowimage:) withObject:img waitUntilDone:YES];
                    [self setNowimage: img];
                    [datasource BLviewdatasourceCurrentPageChangedBy:1];
                }else{
                    
                    [opglview resetPageTurnEndPositionParamter];
                    
                    UIView*oneView=[self getPreView];
                    
                    UIImage*img=[self getImageFromView:oneView];
                    if (oneView==nil) {
                        m_fingerStartOne = false;
                        return;
                    }
                    noNextFlag=false;
                    //                    [self updateCurrentView:oneView];
                    //                    [self performSelectorOnMainThread:@selector(setimage:) withObject:img waitUntilDone:YES];
                    [self setimage:img];
                    [datasource BLviewdatasourceCurrentPageChangedBy:-1];
                }
                
                m_fingerStart = true;
            }
        }else{
            m_fingerPositionBeforeFingerStart_x = x;
            m_fingerPositionBeforeFingerStart_y = y;
            m_fingerStartOne = true;
        }
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //     NSAutoreleasePool*tempARP=[[NSAutoreleasePool alloc]init];
    if (isPingBi) {
        return;
    }
    //----------------------------------------李润成原味开始----------------------------------------
    UITouch*touch=[touches anyObject];
    CGPoint touchpoint=[touch locationInView:self.view];
    CGFloat scale_screen=[UIScreen mainScreen].scale;
    float x = touchpoint.x * scale_screen;
    
    if(!m_fingerStart){
        UITouch*touch=[touches anyObject];
        CGPoint touchpoint=[touch locationInView:self.view];
        if ((touchpoint.x<=40)||touchpoint.x>=(self.view.bounds.size.width-40)){
            if( [opglview getRenderOver])
            {
                if(threadneedCancel)
                {
                    [animateThread cancel];
                    [animateThread release];
                    threadneedCancel = false;
                }
                [opglview setfingerOn:false];
            }else{
                //m_threadAux = false;
                //[GLview setfingerOn:false];
            }
            if (touchpoint.x>=(self.view.bounds.size.width-40)&&touchpoint.x<=self.view.bounds.size.width){
                m_fingerStart = true;
                m_rightToLeft = true;
                [opglview setRightToLeft : m_rightToLeft];
                m_fingerLengthPosition_x = x;
                [opglview texturesExchange];
                [opglview resetPageTurnBeginPositionParamter];
                
                UIView*oneView=[self getNextView];
                
                if (oneView==nil) {
                    m_fingerStartOne = false;
                    return;
                }
                noPreFlag=false;
                UIImage*img=[self getImageFromView:oneView];
                
                //                    [self performSelectorOnMainThread:@selector(setNowimage:) withObject:img waitUntilDone:YES];
                [self setNowimage: img];
                [datasource BLviewdatasourceCurrentPageChangedBy:1];
            } else if (touchpoint.x>=0&&touchpoint.x<=40)  {
                m_fingerStart = true;
                m_rightToLeft = false;
                [opglview setRightToLeft : m_rightToLeft];
                m_fingerLengthPosition_x = x;
                [opglview resetPageTurnEndPositionParamter];
                
                UIView*oneView=[self getPreView];
                
                UIImage*img=[self getImageFromView:oneView];
                if (oneView==nil) {
                    m_fingerStartOne = false;
                    return;
                }
                noNextFlag=false;
                //                    [self updateCurrentView:oneView];
                //                    [self performSelectorOnMainThread:@selector(setimage:) withObject:img waitUntilDone:YES];
                [self setimage:img];
                [datasource BLviewdatasourceCurrentPageChangedBy:-1];
            }
        }
    }
    
    if(m_fingerStart){
        if(m_rightToLeft){
            if(x <= (m_fingerLengthPosition_x + 10.0)){
                m_goonOrBack = true;
            }else{
                m_goonOrBack = false;
                m_needTextureExchange = true;
            }
        }else{
            if(x >= (m_fingerLengthPosition_x - 10.0)){
                m_goonOrBack = true;
                m_needTextureExchange = true;
            }else{
                m_goonOrBack = false;
            }
        }
        
        [opglview setGoonOrBack:m_goonOrBack];
        m_lastFingerStart = m_fingerStart;
        [self computePage];
        [opglview setfingerOn:m_fingerStart];
        m_fingerStart = false;
    }
    m_fingerStartOne = false;
    
    if(!animateThread)
    {
        animateThread = [[NSThread alloc] initWithTarget:self selector:@selector(startAnimations) object:nil];
        [animateThread start];
    }
    else
    {
        if(threadneedCancel)
        {
            [animateThread cancel];
            [animateThread release];
            threadneedCancel = false;
        }
        animateThread = [[NSThread alloc] initWithTarget:self selector:@selector(startAnimations) object:nil];
        [animateThread start];
    }
    
    
}
#pragma mark-数据源更新
- (void)computePage
{
    
    if(m_lastFingerStart)
    {
        if(!m_goonOrBack){
            if(m_rightToLeft){
                
                //UIView*oneView=[self getNextView];
                
                //                currentIndex++;
                [datasource BLviewdatasourceCurrentPageChangedBy:-1];
                
            }else{
                
                
                //                currentIndex--;
                [datasource BLviewdatasourceCurrentPageChangedBy:1];
                
                
            }
        }
        m_lastFingerStart = false;
    }
}
#pragma mark-小说内容view数据源系统
-(UIView *)getPreView
{
    view=[datasource  BLviewdatasourceViewForPrePage:self];
    if(view==nil)
    {
        noPreFlag=YES;
        return nil;
    }
    //    view.frame=[UIScreen mainScreen].bounds;
    return view;
}
-(UIView *)getNextView
{
    view=[datasource  BLviewdatasourceViewForNextPage:self];
    if(view==nil){
        //        [datasource BLviewdatasourceViewReachEnd:self];
        noNextFlag=YES;
        return nil;}
    //    view.frame=[UIScreen mainScreen].bounds;
    return view;
}

-(UIImage *)getImageFromView:(UIView *)theView

{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
-(void)settouchdele:(UIView*)touchview
{
    
}
-(void)removetouchdle:(UIView*)touchview
{
    
}
-(UIView*)BLviewdatasourceViewForNextPage:(id)BLview
{
    return nil;
}
-(UIView*)BLviewdatasourceViewForPrePage:(id)BLview
{
    return nil;
}
-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin
{
    //    con=[self Createcontrollerwithview:UIView1];
    //    con.view.tag=0;
    //    [custom setViewControllers:[NSArray  arrayWithObjects:con,nil, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion: ^(BOOL finished){
    //
    //    }];
    if (UIView1==nil) {
        return;
    }
    [self initOpenglView];
    if (opglview.superview==nil) {
        [self.view addSubview:opglview];
    }
    //    [opglview render];
    [self GLviewDisplay];
    needsetimage=false;
}





- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    switch (viewController.view.tag) {
        case 0:
            view=[datasource  BLviewdatasourceViewForNextPage:self];
            if(view==nil){
                [datasource BLviewdatasourceViewReachEnd:self];
                return nil;}
            view=[datasource BLviewdatasourceViewForCurrentPage:self];
            backshadow=[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            [datasource BLviewdatasourceCurrentPageChangedBy:1];
            viewController.view.tag=-2;
            con= [self Createcontrollerwithview:view];
            con.view.tag=-1;
            return con;
            break;
        case 1:
            view=[datasource BLviewdatasourceViewForNextPage:self];
            if(view==nil)
            {
                [datasource BLviewdatasourceViewReachEnd:self];
                return nil;}
            con= [self Createcontrollerwithview:view];
            [datasource BLviewdatasourceCurrentPageChangedBy:1];
            con.view.tag=0;
            viewController.view.tag=-1;
            return con;
            break;
        case 2:
            [datasource BLviewdatasourceCurrentPageChangedBy:1];
            viewController.view.tag=0;
            view=[datasource BLviewdatasourceViewForNextPage:self];
            if(view==nil)
            {
                [datasource BLviewdatasourceViewReachEnd:self];
                return nil;
            }
            view=[datasource BLviewdatasourceViewForCurrentPage:self];
            [datasource BLviewdatasourceCurrentPageChangedBy:1];
            backshadow=[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            con= [self Createcontrollerwithview:view];
            con.view.tag=-1;
            viewController.view.tag=-2;
            return con;
            break;
        case -1:
            view=[datasource BLviewdatasourceViewForCurrentPage:self];
            con= [self Createcontrollerwithview:view];
            con.view.tag=0;
            return con;
            break;
        case -2:
            view=[datasource BLviewdatasourceViewForPrePage:self];
            backshadow=[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            con= [self Createcontrollerwithview:view];
            con.view.tag=-1;
            return con;
            break;
        default:
            return nil;
            break;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    switch (viewController.view.tag) {
        case 0:
            view=[datasource  BLviewdatasourceViewForPrePage:self];
            if(view==nil)
            {
                [datasource BLviewdatasourceViewReachBegain:self];
                return nil;
            }
            backshadow=[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            [datasource BLviewdatasourceCurrentPageChangedBy:-1];
            viewController.view.tag=2;
            con= [self Createcontrollerwithview:view];
            con.view.tag=1;
            return con;
            break;
        case 1:
            view=[datasource  BLviewdatasourceViewForCurrentPage:self];
            con= [self Createcontrollerwithview:view];
            con.view.tag=0;
            return con;
            break;
        case 2:
            view=[datasource BLviewdatasourceViewForCurrentPage:self];
            backshadow=[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            con= [self Createcontrollerwithview:view];
            con.view.tag=1;
            return con;
            break;
        case -1:
            [datasource  BLviewdatasourceCurrentPageChangedBy:-1];
            viewController.view.tag=1;
            view=[datasource BLviewdatasourceViewForCurrentPage:self];
            con= [self Createcontrollerwithview:view];
            con.view.tag=0;
            return con;
            break;
        case -2:
            [datasource  BLviewdatasourceCurrentPageChangedBy:-1];
            viewController.view.tag=0;
            view=[datasource BLviewdatasourceViewForPrePage:self];
            if(view==nil)
            {
                [datasource BLviewdatasourceViewReachBegain:self];
                return nil;
            }
            backshadow =[[[UIView alloc]initWithFrame:self.view.bounds]autorelease];
            backshadow.backgroundColor=[[UIColor  blackColor] colorWithAlphaComponent:0.3];
            [view addSubview:backshadow];
            view.transform=CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            [datasource  BLviewdatasourceCurrentPageChangedBy:-1];
            viewController.view.tag=2;
            con= [self Createcontrollerwithview:view];
            con.view.tag=1;
            return con;
            break;
        default:
            return nil;
            break;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if(!completed)
    {
        for(UIViewController* contro  in previousViewControllers)
        {
            if(contro.view.tag==2)
            {
                [datasource BLviewdatasourceCurrentPageChangedBy:1];
            }
            if(contro.view.tag==-2)
            {
                [datasource BLviewdatasourceCurrentPageChangedBy:-1];
            }
            contro.view.tag=0;
        }
    }
    
}





-(void)BLMidclicked
{
    [midclickdelegate BLMidclicked];
}
-(UIViewController*)Createcontrollerwithview:(UIView*)oneview
{
    UIViewController* onecon=   [[[UIViewController alloc]init]autorelease ];
    onecon.view.frame=oneview.frame;
    oneview.frame=onecon.view.bounds;
    [onecon.view addSubview:oneview];
    return onecon;
}
@end
