#import <UIKit/UIKit.h>
#import "LeveyTabBar.h"
#import "SmalleBasebookViewController.h"
#import "bookOnlineViewController.h"
@class UITabBarController;
@protocol LeveyTabBarControllerDelegate;
@interface LeveyTabBarController : UIViewController <LeveyTabBarDelegate>{
	LeveyTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	id<LeveyTabBarControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
	NSUInteger _selectedIndex;
	BOOL _tabBarTransparent;
	BOOL _tabBarHidden;
    int TabBarHeight;
    
    NSString* device;
    NSString* fangxiang;
    BOOL ischange;
    
    UIButton* sousuo;
    
    
}

@property(nonatomic, retain) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) LeveyTabBar *tabBar;
@property(nonatomic,assign) id<LeveyTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

- (id)initWithViewControllers:(NSMutableArray *)vcs imageArray:(NSArray *)arr;
- (id)initWithViewControllers:(NSMutableArray *)vcs imageArray:(NSArray *)arr TabBarHeight:(int)tabBarHeight;

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

-(void)setdeviceandfangxiang;


-(void)setbarandviewsize:(NSString*)horv  deviece:(NSString*)device;



-(NSArray*)createtopbarpic:(NSString*)device fangxiang:(NSString*)horv;

-(void)loadpicdevice:(NSString*)device fangxiang:(NSString*)horv;

-(void)dissousuo;


@end


@protocol LeveyTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, retain, readonly) LeveyTabBarController *leveyTabBarController;
@end

