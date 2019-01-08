#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#define KTabBarHeight 62.0f

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
	return leveyTabBarController;
}

@end

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
-(void)CustomLoad:(NSMutableArray *)vcs imageArray:(NSArray *)arr;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;

#pragma mark -
#pragma mark lifecycle

-(void)setdeviceandfangxiang
{
    
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationLandscapeLeft:
            fangxiang=@"h";
            break;
        case UIInterfaceOrientationLandscapeRight:
            fangxiang=@"h";
            break;
        default:
            break;
    }
   
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        device=@"iPad";
    }
    else
    {
        device=@"iPhone";
    
    }
}


-(NSArray*)createtopbarpic:(NSString*)_device fangxiang:(NSString*)horv
{
    int kk;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        kk=5;
    }
    else
    {
        kk=5;
    }
    
    
    NSMutableArray *TabArray=[NSMutableArray arrayWithCapacity:kk];
    for (int i=1; i<=kk; i++) {
        NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        UIImage *tempimg=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_icon%d",_device,_device,i] ];
        [imgDic setObject:tempimg forKey:@"Highlighted"];
        [imgDic setObject:tempimg forKey:@"Seleted"];
        [TabArray addObject: imgDic];
    }
    return TabArray;

    

}


-(void)loadpicdevice:(NSString*)_device fangxiang:(NSString*)horv
{
    _tabBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_buttomBare",_device,horv,_device,horv]]];
//    for(UINavigationController*navi in _viewControllers)
//    {
//        SmalleBasebookViewController* con= navi.topViewController;
//        con.view.backgroundColor=[UIColor grayColor];
////        con._TopImageView.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_topBar",_device,horv,_device,horv]];
//    }
    
}

- (instancetype)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
{
 	self = [super init];
	if (self != nil)
	{
        [self setdeviceandfangxiang];
        NSArray*arr2=[self createtopbarpic:device fangxiang:fangxiang];
        [self CustomLoad:[NSMutableArray arrayWithArray:vcs] imageArray:arr2];
        [self setbarandviewsize:fangxiang deviece:device] ;
	}
	return self;
}

- (instancetype)initWithViewControllers:(NSMutableArray *)vcs imageArray:(NSArray *)arr TabBarHeight:(int)tabBarHeight{
	self = [super init];
	if (self != nil)
	{
        TabBarHeight=tabBarHeight;
        [self CustomLoad:vcs  imageArray:arr];
	}
	return self;

}
-(void)CustomLoad:(NSMutableArray *)vcs imageArray:(NSArray *)arr{
   // _viewControllers = [[NSMutableArray arrayWithArray:vcs] retain];
    self.viewControllers=vcs;
    
    _containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _containerView.frame.size.height - TabBarHeight)];
    _transitionView.backgroundColor =  [UIColor clearColor];
    
//    _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - TabBarHeight, [[UIScreen mainScreen] bounds].size.width, TabBarHeight) buttonImages:arr];
    
    
//     _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - TabBarHeight, [[UIScreen mainScreen] bounds].size.width, TabBarHeight) buttonImages:arr];
    
    
//    _tabBar.delegate = self;

    
    leveyTabBarController = self;
}

-(void)setbarandviewsize:(NSString*)horv  deviece:(NSString*)_device
{
    TabBarHeight=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_Buttombar",_device,horv,_device,horv]].size.height;
    
    if([horv isEqualToString:@"h"])
    {
        
        
        _transitionView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-TabBarHeight);
        
        
        
        [_tabBar removeFromSuperview];
        
        _tabBar = [[[LeveyTabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width - TabBarHeight,[UIScreen mainScreen].bounds.size.height, TabBarHeight) buttonImages:[self createtopbarpic:_device fangxiang:horv]] autorelease];
        _tabBar.delegate = self;
        [_tabBar selectTabAtIndex:_selectedIndex];
        [_containerView addSubview:_tabBar];
        
        
    }
    else
    {
        
        
        
        _transitionView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-TabBarHeight);
        [_tabBar removeFromSuperview];
        _tabBar = [[[LeveyTabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TabBarHeight,[UIScreen mainScreen].bounds.size.width, TabBarHeight) buttonImages:[self createtopbarpic:_device fangxiang:horv]] autorelease];
        _tabBar.delegate = self;
         [_tabBar selectTabAtIndex:_selectedIndex];
        [_containerView addSubview:_tabBar];
        
//        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
//        {
//            
//            [sousuo removeFromSuperview];
//            sousuo=[[[UIButton alloc]init] autorelease];
//            
//            UIImage*iii=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_icon5"];
//            
//            [sousuo setImage:iii forState:UIControlStateNormal];
//            sousuo.tag=5;
//            [sousuo addTarget:self action:@selector(dissousuo) forControlEvents:UIControlEventTouchUpInside];
//            
//            sousuo.frame=CGRectMake(258, 13, iii.size.width, iii.size.height);
//            
//            [self.view addSubview:sousuo];
//            
//            
//        }
    }
        _tabBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_Buttombar",_device,horv,_device,horv]]];
    
}


- (void)loadView
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
//    [self.view addSubview:_containerView];
	self.view = _containerView;
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
    self.selectedIndex = 0;
}

- (void)dealloc 
{
    _tabBar.delegate = nil;
    _tabBar = nil;
    self.viewControllers = nil;
    [_containerView release];
    [_transitionView release];
	[_viewControllers release];
    [super dealloc];
}

#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
	return _tabBar;
}
- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}
- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _containerView.frame.size.height - TabBarHeight);
	}

}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - TabBarHeight)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + TabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - TabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + TabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - TabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}

- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before changing index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];



   
    if(_selectedIndex==2&&index==2&& !ischange)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            
            if(((bookOnlineViewController*)(((UINavigationController*)targetViewController).topViewController)).TypeID!=basepage)
            {
                ((bookOnlineViewController*)(((UINavigationController*)targetViewController).topViewController)).TypeID=basepage;
                ((bookOnlineViewController*)(((UINavigationController*)targetViewController).topViewController)).tablechooseindex=0;
                [((bookOnlineViewController*)(((UINavigationController*)targetViewController).topViewController))
                 backtobase];
            }
            
        }
    }
    if(index==0 || index==1 )
{
    if ([targetViewController isKindOfClass:[UINavigationController class]]) {

        [((bookOnlineViewController*)(((UINavigationController*)targetViewController).topViewController))
         backtobase];
    }

}
    
    
     _selectedIndex = index;
	[_transitionView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:(id)YES];
    targetViewController.view.hidden = NO;
	targetViewController.view.frame = _transitionView.frame;

	if ([targetViewController.view isDescendantOfView:_transitionView]) 
	{
		[_transitionView bringSubviewToFront:targetViewController.view];
	}
	else
	{
		[_transitionView addSubview:targetViewController.view];
	}
    [targetViewController viewWillAppear:YES];

    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) 
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
     [targetViewController viewDidAppear:YES];
}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    sousuo.hidden=NO;
	[self displayViewAtIndex:index];
}

-(void)dissousuo
{
    [_tabBar setnoselect];
    
    sousuo.hidden=YES;
    
[self displayViewAtIndex:4];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return toInterfaceOrientation==UIInterfaceOrientationPortrait;
        
    }
    

    
    return toInterfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationLandscapeLeft:
            fangxiang=@"h";
            break;
        case UIInterfaceOrientationLandscapeRight:
            fangxiang=@"h";
            break;
        default:
            break;
    }   
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        device=@"iPad";
    }else{
        device=@"iPhone";
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:device forKey:@"device"];
    [[NSUserDefaults standardUserDefaults]setObject:fangxiang forKey:@"fangxiang"];
    
    ischange=YES;
    [self setbarandviewsize:fangxiang deviece:device];
    ischange=NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"derectchanggexx" object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:device,fangxiang, nil] forKeys:[NSArray arrayWithObjects:@"device",@"fangxiang", nil]]];

//    [self loadpicdevice:device fangxiang:fangxiang];
}

- (BOOL)shouldAutorotate
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return NO;
    }
    
    return YES;

}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}






@end
