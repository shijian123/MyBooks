//
//  CollectionHeaderView.h
//  BookStore
//
//  Created by Work on 14-7-7.
//  Copyright (c) 2014年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TheamManager.h"
@interface CollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *rectangleButton;
@property (retain, nonatomic) IBOutlet UIButton *listButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextF;
@property (retain, nonatomic) IBOutlet UIImageView *searchKuangimage;
@property (retain, nonatomic) IBOutlet UIImageView *searchTAgimage;
@property (retain, nonatomic) IBOutlet UIButton *searchCancel;

+ (UINib *)nib;

/**
 是否显示搜索功能
 
 @param isShow 是否显示
 */
- (void)showSearchBtnMethod:(BOOL)isShow;

@end
