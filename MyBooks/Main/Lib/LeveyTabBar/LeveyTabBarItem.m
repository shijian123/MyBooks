#import "LeveyTabBarItem.h"
@interface LeveyTabBarItem ()
-(CustomBadge*)customBadge;
@end
@implementation LeveyTabBarItem
-(void)setBadgeValue:(NSString *)InputbadgeValue{
    if (InputbadgeValue!=badgeValue){
        [InputbadgeValue retain];
        [badgeValue release];
        badgeValue=InputbadgeValue;
        if (![self isDescendantOfView:self.customBadge]) {
            [self addSubview: self.customBadge];
        }
        if ([badgeValue length]>0 ) {
            self.customBadge.hidden=NO;
            [self.customBadge autoBadgeSizeWithString:badgeValue];
        	[self.customBadge setFrame:CGRectMake(self.frame.size.width/2-self.customBadge.frame.size.width/2+self.customBadge.frame.size.width/2-3, 2, self.self.customBadge.frame.size.width, self.customBadge.frame.size.height)];
            self.customBadge.alpha=0.9;
            [UIView animateWithDuration:0.50
                                  delay:0
                                options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                             animations:^{	
                                 self.customBadge.alpha=1.0;
                             }
                             completion:^(BOOL finished){ 
                                   
                             }];
            
        }else {
            self.customBadge.hidden=YES; 
        }
    }
}
-(CustomBadge*)customBadge{
    if (_customBadge==nil) {
        _customBadge = [CustomBadge customBadgeWithString:@"" 
                                         withStringColor:[UIColor whiteColor] 
                                          withInsetColor:[UIColor redColor] 
                                          withBadgeFrame:YES 
                                     withBadgeFrameColor:[UIColor whiteColor] 
                                               withScale:1.0
                                             withShining:YES];
        _customBadge.hidden=YES;
        [_customBadge retain];
    }
    return  _customBadge;
}
-(NSString*)BadgeValue{
    return badgeValue;
}
- (void)dealloc
{
    [_customBadge release];
    [badgeValue release];
    [super dealloc];
}
@end
