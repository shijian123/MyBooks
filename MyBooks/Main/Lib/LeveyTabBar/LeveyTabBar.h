#import <UIKit/UIKit.h>
#import "LeveyTabBarItem.h"
@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView
{
	UIImageView *_backgroundView;
	id<LeveyTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
    NSArray*myimagearr;
    
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property(nonatomic,retain)NSArray*myimagearr;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;


- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;
- (LeveyTabBarItem*)BarItemAtIndex:(NSInteger)index;

-(void)setnoselect;
@end
@protocol LeveyTabBarDelegate<NSObject>
@optional
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index;


@end
