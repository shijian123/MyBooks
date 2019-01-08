//
//  FolderListViewController.h
//  OneWord
//
//  Created by wukai on 14-9-15.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThemeImgView.h"
//#import "ThemeButton.h"
//#import "ThemeLabel.h"
@protocol FolderListViewControllerDelegate <NSObject>

//选择了某本书
- (void)didselectBookToRead:(id)data;
//拖动了某本书
- (void)didDragBookWithData:(id)data;
//通知书架刷新数据
- (void)reloadyourViewba;
//更改密码
- (void)transWithNewpassword:(NSString *)newPassword;
//更改文件夹的名字
- (void)transWithNewFolderName:(NSString *)newFoldername;

- (void)tarnsFolderDeleteBookSWithArray:(NSMutableArray *)aarray;
@end

@interface FolderListViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bgTopImageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UILabel *folderName;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *lockImageView;
@property (nonatomic, weak) IBOutlet UIButton *passwdButton;
@property (nonatomic, strong) NSDictionary *folderDataDict;
@property (nonatomic, weak) IBOutlet UIImageView *middleLineView;
@property (nonatomic ,assign) id <FolderListViewControllerDelegate> delegate;
@end
