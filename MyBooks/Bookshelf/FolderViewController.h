/*
 *文件夹视图控制器
 */

#import <UIKit/UIKit.h>
//#import "TheamManager.h"

@protocol FolderViewControllerDelegate <NSObject>

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

@interface FolderViewController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
//文件夹数据
@property (nonatomic, strong) NSMutableDictionary *folderDataDict;
//书本数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id <FolderViewControllerDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

- (void)longPressGestureRecognized:(id)sender;
- (void)folderIsEditWithBool:(BOOL) isedit;
@end
