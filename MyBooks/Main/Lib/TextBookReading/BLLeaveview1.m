

#import "BLLeaveview1.h"

@implementation BLLeaveview1
@synthesize shadecolor;
-(void)dealloc
{
    [shadecolor release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame point:(float)point
{
    self = [super initWithFrame:frame];
    if (self) {
        MovePoint=point;
        pageSize=CGSizeMake(frame.size.width, frame.size.height);
        self.userInteractionEnabled=NO;
        self.layer.masksToBounds=YES;
        shadewidth=[[[NSUserDefaults standardUserDefaults] objectForKey:@"leavesshadewidth"] intValue];
        
        
        
        [self  setUpLayers];
        [self setcolorsss];
    }
    return self;
}


- (void) setUpLayers {
    
	contentLayer = [[[CALayer alloc] init] autorelease] ;
	contentLayer.contentsGravity = kCAGravityBottomLeft;
    contentLayer.masksToBounds = YES;
    contentLayer.frame=self.bounds;
    contentLayercontent = [[[CALayer alloc] init] autorelease];
    contentLayercontent.frame=self.bounds;
    [contentLayer addSublayer:contentLayercontent];
    backLayer=[[[CALayer alloc]init]autorelease];
    backLayer.frame=self.bounds;
	backLayer.contentsGravity = kCAGravityTopRight;
    backLayer.masksToBounds = YES;
    backcontentLayer = [[[CALayer alloc] init] autorelease];
    backcontentLayer.frame=self.bounds;
    backcontentLayer.transform=CATransform3DMakeScale(-1, 1, 1);
    [backLayer addSublayer:backcontentLayer];
    
    backcontentshadow=[[[CALayer alloc]init ]autorelease];
    backcontentshadow.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.15].CGColor ;
    backcontentshadow.frame=self.bounds;
    [backLayer addSublayer:backcontentshadow];
    
    contentLayerShadow = [[[CAGradientLayer alloc] init] autorelease];
    //	contentLayerShadow.colors = [NSArray arrayWithObjects:
    //                                 (id)[shadecolor CGColor],
    //                                 (id)[[UIColor clearColor] CGColor],
    //                                 nil];
    backshadow = [[[CAGradientLayer alloc] init] autorelease];
    //	backshadow.colors = [NSArray arrayWithObjects:
    //                                         (id)[shadecolor CGColor],
    //                                         (id)[[UIColor clearColor]CGColor],
    //                                         nil];
    bottomPageShadow = [[[CAGradientLayer alloc] init] autorelease];
    //	bottomPageShadow.colors = [NSArray arrayWithObjects:
    //							   (id)[shadecolor CGColor],
    //							   (id)[[UIColor clearColor] CGColor],
    //							   nil];
    
    //    contentLayerShadow.startPoint = CGPointMake(1,0.5);
    //    contentLayerShadow.endPoint = CGPointMake(0,0.5);
    //    backshadow.startPoint = CGPointMake(1,0.5);
    //    backshadow.endPoint = CGPointMake(0,0.5);
    //    bottomPageShadow.startPoint = CGPointMake(0,0.5);
    //    bottomPageShadow.endPoint = CGPointMake(1,0.5);
    
    
    
	[self.layer addSublayer:contentLayer];
    [self.layer addSublayer:backLayer];
    [self.layer addSublayer:contentLayerShadow];
    [self.layer addSublayer:bottomPageShadow];
    [self.layer addSublayer:backshadow];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [self setLayerFrames];
    [CATransaction commit];
}

-(void)setcolorsss
{
    shadewidth=[[[NSUserDefaults standardUserDefaults] objectForKey:@"leavesshadewidth"] intValue];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        topshadewith=shadewidth+8;
    }
    else
    {
        topshadewith=shadewidth;
    }
    
    NSString*  shadecolorstring=[[NSUserDefaults standardUserDefaults] objectForKey:@"leavesshadecolor"];
    
    NSArray*colorarr=[shadecolorstring componentsSeparatedByString:@","];
    self.shadecolor=[UIColor colorWithRed:[[colorarr objectAtIndex:0] intValue]/255.0 green:[[colorarr objectAtIndex:1] intValue]/255.0 blue:[[colorarr objectAtIndex:2] intValue]/255.0 alpha:[[colorarr objectAtIndex:3] floatValue]];
    //    self.shadecolor=[UIColor redColor];
    //    0.46
    
    
	bottomPageShadow.colors = [NSArray arrayWithObjects:
							   (id)[shadecolor CGColor],
                               (id)[[shadecolor colorWithAlphaComponent:0.8]CGColor],
                               (id)[[shadecolor colorWithAlphaComponent:0.5]CGColor],
                               (id)[[shadecolor colorWithAlphaComponent:0.4]CGColor],
							   (id)[[shadecolor colorWithAlphaComponent:0]CGColor],
							   nil];
    bottomPageShadow.locations=
    [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:0.1],
     [NSNumber numberWithFloat:0.4],
     [NSNumber numberWithFloat:0.5],
     [NSNumber numberWithFloat:1.0],
     nil];
    
    
    
    backshadow.colors = [NSArray arrayWithObjects:
                         (id)[shadecolor CGColor],
                         (id)[[shadecolor colorWithAlphaComponent:0.7]CGColor],
                         (id)[[shadecolor colorWithAlphaComponent:0.4]CGColor],
                         (id)[[shadecolor colorWithAlphaComponent:0]CGColor],
                         nil];
    
    backshadow.locations=
    [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:0.25],
     [NSNumber numberWithFloat:0.45],
     [NSNumber numberWithFloat:1.0],
     nil];
    
    contentLayerShadow.colors = [NSArray arrayWithObjects:
                                 (id)[shadecolor CGColor],
                                 (id)[[shadecolor colorWithAlphaComponent:0.7]CGColor],
                                 (id)[[shadecolor colorWithAlphaComponent:0.4]CGColor],
                                 (id)[[shadecolor colorWithAlphaComponent:0]CGColor],
                                 nil];
    contentLayerShadow.locations=
    [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:0.05],
     [NSNumber numberWithFloat:0.20],
     [NSNumber numberWithFloat:1.0],
     nil];
    
    contentLayerShadow.startPoint = CGPointMake(1,0.5);
    contentLayerShadow.endPoint = CGPointMake(0,0.5);
    backshadow.startPoint = CGPointMake(1,0.5);
    backshadow.endPoint = CGPointMake(0,0.5);
    bottomPageShadow.startPoint = CGPointMake(0,0.5);
    bottomPageShadow.endPoint = CGPointMake(1,0.5);
    
    
}

-(void)setContent:(CGImageRef)_content
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    contentLayercontent.contents=(id)_content;
	backcontentLayer.contents = (id)_content;
    //    contentLayer.contents = (id)_content;
    [CATransaction commit];
}




-(CGFloat)MovePoint
{
    return MovePoint;
}
-(void)setMovePoint:(CGFloat)_MovePoint
{
    MovePoint=_MovePoint;
    [self setLayerFrames];
}




- (void) setLayerFrames {
    contentLayer.frame = CGRectMake(0, 0, MovePoint * pageSize.width,
                                    pageSize.height);
    backLayer.frame = CGRectMake((2*MovePoint-1) * pageSize.width,
                                 0,
                                 (1-MovePoint) * pageSize.width,
                                 pageSize.height);
    
    contentLayerShadow.frame= CGRectMake(backLayer.frame.origin.x-topshadewith/2, 0,topshadewith/2, pageSize.height);
    
    backshadow.frame=CGRectMake(backLayer.frame.origin.x+backLayer.frame.size.width-3*shadewidth/2, 0, 3*shadewidth/2, pageSize.height);
    bottomPageShadow.frame=CGRectMake(backLayer.frame.origin.x+backLayer.frame.size.width, 0, 3*shadewidth/2, pageSize.height);
    
    contentLayerShadow.opacity = MIN(1.0, 4*(1-MovePoint));
    bottomPageShadow.opacity = MIN(1.0, 4*MovePoint);
    backshadow.opacity= MIN(0.5, 4*(1-MovePoint));
    
    
}






@end
