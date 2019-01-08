//
//  ShelfViewController.h
//  BookStore
//
//  Created by Work on 14-7-1.
//  Copyright (c) 2014年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThemeButton.h"
#import "CollectionHeaderView.h"

@class ShelfViewController;
@protocol  ShelfViewControllerDelegate <NSObject>

- (void)viewController:(UIViewController *)vc hideTabView:(BOOL)isHiden;

@end

@interface ShelfViewController : UIViewController{
    NSArray *_themes;
    BOOL isAnimate;/**< 菜单状态是否正在进行动画*/
    
}
@property (nonatomic, assign) id<ShelfViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *bookShelf_navLineIV;
@property (retain, nonatomic) IBOutlet UIButton *edit_compileBtn;
//@property (retain, nonatomic) IBOutlet UIButton *edit_skinBtn;
@property (retain, nonatomic) IBOutlet UIButton *edit_deleteBtn;
@property (retain, nonatomic) IBOutlet UIButton *deleteSureBtn;
@property (retain, nonatomic) IBOutlet UIButton *deleteCancelBtn;
@property (retain, nonatomic) IBOutlet UIView *mainEditV;
@property (strong, nonatomic) CollectionHeaderView *headerView;

@end
