#import <UIKit/UIKit.h>
#import "CustomBadge.h"
@interface LeveyTabBarItem : UIButton
{
    NSString *badgeValue;
    CustomBadge *_customBadge;
}
-(void)setBadgeValue:(NSString *)InputbadgeValue;
-(NSString*)BadgeValue;
@end
