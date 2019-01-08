

#import "BLLeave1.h"
@interface BLLeave1()
-(CGImageRef)getimagRef:(UIView*)view;
-(void)moveto0;
-(void)moveto1 ;
@end



@implementation BLLeave1
@synthesize datasource,midclickdelegate;
-(void)dealloc
{
	[bl1 release];
	[bl0 release];
	[toremove release];

    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        bl1=  [[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0];
        bl0=  [[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0];
		toremove=[[NSMutableArray alloc]init];
        self.userInteractionEnabled=YES;
        movelock=YES;
        currentpage=0; 
        nextcount=0;
		movingcount=0;
        currentpagetomove=nil;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            movejudge=7;
        }
        else
        {
            movejudge=10;
        }
        lockdevice=NO;
        locked=NO;
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad&&[UIScreen mainScreen].scale==2)
//        {
//            lockdevice=YES;
//        }
        
    }
    return self;
}

-(void)moveto0     //移动当前页上方的页面
{
	movingcount++;

    [toremove addObject:currentpagetomove];

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
		movingcount--;
        [((BLLeaveview1*)[toremove objectAtIndex:0] ) removeFromSuperview];
        [toremove removeObjectAtIndex:0];
locked=NO;
    } ];
    if(lockdevice)locked=YES;
    currentpagetomove.MovePoint=0.0;
    [CATransaction commit];
}

-(void)moveto1         //移动当前页面
{
	movingcount++;
    [toremove addObject:(abs(currentpage%2)==1?bl0:bl1)];
	
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
		movingcount--;
        [(BLLeaveview1*)[toremove objectAtIndex:0] removeFromSuperview];
        [toremove removeObjectAtIndex:0];
locked=NO;
    } ];
    if(lockdevice)locked=YES;
    currentpagetomove.MovePoint=1.0;
    [CATransaction commit];
}


-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin
{
    [(abs(currentpage%2)==1?bl0:bl1) removeFromSuperview];
    currentpagetomove=abs(currentpage%2)==1?bl1:bl0;
	imag=[self getimagRef:UIView1];
    currentpagetomove.content=imag;
	currentpagetomove.MovePoint=1.0;
    [self addSubview:currentpagetomove];
    [bl0 setcolorsss];
    [bl1 setcolorsss];
    [currentpagetomove setcolorsss];
    [temppage setcolorsss];
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(locked)return;
    
    
    
    movelock=YES;
    isClick=YES;
    touchkeymid=NO;
    isload=NO;
    limitload=NO;
    UITouch *touch = [event.allTouches anyObject];
	touchBeganPoint = [touch locationInView:self];
    
    
//    if (touchBeganPoint.x>(self.bounds.size.width/4.0) && touchBeganPoint.x<=3*(self.bounds.size.width/4.0) && touchBeganPoint.y>=(self.bounds.size.height/4.0)&& touchBeganPoint.y<=(self.bounds.size.height/4.0)*3 ){
//        touchkeymid=NO;
//        movelock=YES;
//        return;
//        
//    }
    
    
//    if((touchBeganPoint.y>self.bounds.size.height/6.0 )&& (touchBeganPoint.y<self.bounds.size.height*5/6.0) && (touchBeganPoint.x>self.bounds.size.width/4.0)&& (touchBeganPoint.x<self.bounds.size.width*3/4.0))
//    {
//        touchkeymid=YES;
//    }
	if(touchBeganPoint.x>=0 &&touchBeganPoint.x<self.bounds.size.width/2.0)
	{
		touchkeypre=YES;

		//
	}
	else
	{
		touchkeypre=NO;
		
		//
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(locked)return;
    UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
    
    if(limitload){
        return;
    }
    if(!isload)
    {
        if(!touchkeypre)
        {
        if(touchPoint.x-touchBeganPoint.x<-movejudge)
        {
            [self loadright];
            isload=YES;
            return;
        }
        }else
        {
            if(touchPoint.x-touchBeganPoint.x>movejudge)
            {
                [self loadleft];
                isload=YES;
                return;
            }
        }
        
    }
    
    if(!isload)
    {
        if(touchkeypre)
        {
            if(touchBeganPoint.x-touchPoint.x>60)
            {
                [self loadright];
                isload=YES;
                limitload=YES;
                touchkeypre=NO;
            }
            
        }else
        {
            if(touchPoint.x-touchBeganPoint.x>60)
            {
                [self loadleft];
                isload=YES;
                limitload=YES;
                touchkeypre=YES;
            }
        }
        return;
    }

    if(movelock)return;
	
    if(fabs(touchPoint.x-touchBeganPoint.x)>10)isClick=NO;
    float x=touchPoint.x / self.bounds.size.width;
    
    if(x<0 || x>1)
    {
        return;
    }
    
    [CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.07]
					 forKey:kCATransactionAnimationDuration];
    currentpagetomove.MovePoint=x;
	[CATransaction commit];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(locked)return;
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
    
    
    
    
	float key=touchPoint.x-touchBeganPoint.x;
    if(fabsf(key)>10)isClick=NO;
	if(isClick){
          if (touchBeganPoint.x>(self.bounds.size.width/4.0) && touchBeganPoint.x<=3*(self.bounds.size.width/4.0) && touchBeganPoint.y>=(self.bounds.size.height/4.0)&& touchBeganPoint.y<=(self.bounds.size.height/4.0)*3 ){
              touchkeymid=NO;
              movelock=YES;
              return;
              
          }
          if(!isload)
          {
          if(touchkeypre)
          {
              [self loadleft];
              
          }else
          {
              [self loadright];
          }
              
          }
          
          isload=YES;
          
          
	     if(touchkeymid)
	    {
			if(!movelock)
			{
			if(touchkeypre)
			{
				[self moveto0];
				currentpage++;
				[datasource BLviewdatasourceCurrentPageChangedBy:1];
			}
			else
			{
				[self moveto1];
			}
			}else
			{
				movelock=YES;
			}
			[midclickdelegate  BLMidclicked];
	    }
		  else
		  {
			  
			  if(!movelock)
			  {
			   if(touchkeypre)
			    {
				   [self moveto1];
			    }
			   else
			    {
				  [self moveto0];
				  currentpage++;
				  [datasource BLviewdatasourceCurrentPageChangedBy:1];
			    }
			  }
			  else
			  {
				  movelock=YES;
			  }
              return;
		  }
	  }
	else
	{
		
	if(!movelock)
	{
	  if(touchkeypre)
	 {
	     if(key>50)
    	  {
			  [self moveto1];
	      }
     	else
	     {
			 [self moveto0];
			 currentpage++;
			 [datasource BLviewdatasourceCurrentPageChangedBy:1];
	     }
	 }else
	 {
		 if(key<-50)
		 {
			 [self moveto0];
			 currentpage++;
			 [datasource BLviewdatasourceCurrentPageChangedBy:1];
		 }
		 else
	     {
			 [self moveto1];
	     }
	 }
	}
		else
		{
			movelock=YES;
		}
	}
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(locked)return;
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	float key=touchPoint.x-touchBeganPoint.x;
    if(fabsf(key)>10)isClick=NO;
	if(isClick)
    {
        if (touchBeganPoint.x>(self.bounds.size.width/4.0) && touchBeganPoint.x<=3*(self.bounds.size.width/4.0) && touchBeganPoint.y>=(self.bounds.size.height/4.0)&& touchBeganPoint.y<=(self.bounds.size.height/4.0)*3 ){
            touchkeymid=NO;
            movelock=YES;
            return;
            
        }
        if(!isload)
        {
            if(touchkeypre)
            {
                [self loadleft];
                
            }else
            {
                [self loadright];
            }
            
        }
        
        isload=YES;

        
        
        if(touchkeymid)
	    {
			if(!movelock)
			{
                if(touchkeypre)
                {
                    [self moveto0];
                    currentpage++;
                    [datasource BLviewdatasourceCurrentPageChangedBy:1];
                }
                else
                {
                    [self moveto1];
                }
			}else
			{
				movelock=YES;
			}
			[midclickdelegate  BLMidclicked];
	    }
        else
        {
            
            
            if(!movelock)
            {
                if(touchkeypre)
			    {
                    [self moveto1];
			    }
                else
			    {
                    [self moveto0];
                    currentpage++;
                    [datasource BLviewdatasourceCurrentPageChangedBy:1];
			    }
            }
            else
            {
                movelock=YES;
            }
        }
    }
	else
	{
		
        if(!movelock)
        {
            if(touchkeypre)
            {
                if(key>50)
                {
                    [self moveto1];
                }
                else
                {
                    [self moveto0];
                    currentpage++;
                    [datasource BLviewdatasourceCurrentPageChangedBy:1];
                }
            }else
            {
                if(key<-50)
                {
                    [self moveto0];
                    currentpage++;
                    [datasource BLviewdatasourceCurrentPageChangedBy:1];
                }
                else
                {
                    [self moveto1];
                }
            }
        }
		else
		{
			movelock=YES;
		}
	}
}


-(void)loadleft
{

    temp=[datasource  BLviewdatasourceViewForPrePage:self];
    if(temp==nil)
    {
        movelock=YES;
		[datasource  BLviewdatasourceViewReachBegain:self];
		
		return;
    }
    movelock=NO;
    currentpage--;
    [datasource  BLviewdatasourceCurrentPageChangedBy:-1];
    if(abs(currentpage%2)==1)
    {
        if(movingcount!=0)
        {
            [bl1 autorelease];
            bl1=[[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0];
        }
        currentpagetomove=bl1;
    }
    else
    {
        if(movingcount!=0)
        {
            [bl0 autorelease];
            
            bl0=[[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0];
        }
		currentpagetomove=bl0;
    }
    imag=[self getimagRef:temp];
    currentpagetomove.content=imag;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    currentpagetomove.MovePoint=0;
    [CATransaction commit];
    [self addSubview:currentpagetomove];
    [self bringSubviewToFront:currentpagetomove];
}

-(void)loadright
{
    temp=[datasource  BLviewdatasourceViewForNextPage:self];
    if(temp==nil)
    {
        [datasource  BLviewdatasourceViewReachEnd:self];
        movelock=YES;
        return;
    }
    movelock=NO;
    if((abs(currentpage%2)==1))
    {
        if(movingcount!=0)
        {
            [bl0 autorelease];
            bl0=[[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0] ;
        }
        temppage=bl0;
        currentpagetomove=bl1;
    }
    else
    {
        if(movingcount!=0)
        {
            [bl1 autorelease];
            bl1=[[BLLeaveview1 alloc]initWithFrame:self.bounds point:1.0];
        }
        temppage=bl1;
        currentpagetomove=bl0;
    }
    imag=[self getimagRef:temp];
    temppage.content=imag;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    temppage.MovePoint=1;
    [CATransaction commit];
    [self addSubview:temppage];
    [self sendSubviewToBack:temppage];


}


-(CGImageRef)getimagRef:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image.CGImage;
}
@end
