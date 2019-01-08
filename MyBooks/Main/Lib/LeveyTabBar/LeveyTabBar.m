#import "LeveyTabBar.h"
#import "LeveyTabBarItem.h"
@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;
@synthesize myimagearr;
- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
        
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
		[self addSubview:self.backgroundView];
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		LeveyTabBarItem *btn;
		
        
       self.myimagearr=imageArray;
        
        

        
//        CGFloat width = ((UIImage*)([[imageArray objectAtIndex:0] objectForKey:@"Highlighted"])).size.width;
        //书城3x图片不对处理专区--开始
        CGFloat width = [UIScreen mainScreen].bounds.size.width/5;//原来的
        //书城3x图片不对处理专区--结束
        CGFloat Xstart=(frame.size.width-width*[imageArray count])/2;
        
		for (int i = 0; i < [imageArray count]; i++)
		{
			btn = [LeveyTabBarItem buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = NO;
			btn.tag = i;
           ;
			btn.frame = CGRectMake(Xstart+width * i, 1, width, frame.size.height);
			[btn setImage:nil forState:UIControlStateNormal];
			[btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];

            [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setExclusiveTouch:YES];
			[self.buttons addObject:btn];
			[self addSubview:btn];
        }
           
		
    
        
    
    }
    return self;
}







- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
}
- (LeveyTabBarItem*)BarItemAtIndex:(NSInteger)index{
    return [self.buttons objectAtIndex:index];
}

-(void)setnoselect
{
    for (int i = 0; i < [self.buttons count]; i++){
        if(i==index){continue;}
		UIButton *b = [self.buttons objectAtIndex:i];
        //        [b setImage:nil forState:UIControlStateHighlighted];
        [b setImage:nil forState:UIControlStateNormal];
        //        [b setImage:nil forState:UIControlEventTouchDown];
        //        b.selected=NO;
	}

}


- (void)selectTabAtIndex:(NSInteger)indexNum
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
        if(i==indexNum){continue;}
		UIButton *b = [self.buttons objectAtIndex:i];
        
//        [b setImage:nil forState:UIControlStateHighlighted];
        [b setImage:nil forState:UIControlStateNormal];
//        [b setImage:nil forState:UIControlEventTouchDown];
//        b.selected=NO;
	}
    

	UIButton *btn = [self.buttons objectAtIndex:indexNum];
//    [btn setImage:[[myimagearr objectAtIndex:index] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[[myimagearr objectAtIndex:indexNum] objectForKey:@"Highlighted"] forState:UIControlStateNormal];
    [btn setImage:[[myimagearr objectAtIndex:indexNum] objectForKey:@"Highlighted"] forState:UIControlStateSelected];
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
 }




- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = [[UIScreen mainScreen] bounds].size.width / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    LeveyTabBarItem *btn = [LeveyTabBarItem buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)dealloc
{
    self.myimagearr=nil;
    self.backgroundView=nil;
    self.buttons=nil;

    [super dealloc];
}

@end
