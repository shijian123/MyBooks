
//
//  ShelfViewController.m
//  BookStore
//
//  Created by Work on 14-7-1.
//  Copyright (c) 2014年 wukai. All rights reserved.
//

#import "ShelfViewController.h"
#import "BooksDataHandle.h"
#import "XMLDownLoad.h"
#import "CommonCollectionCell.h"
#import "CommonCollectionCell+ConfigureCommonCollectionCellData.h"
#import "JWFolders.h"
#import "FolderViewController.h"
#import "THPinViewController.h"
#import "TSPopoverController.h"
#import "CustomSheetView.h"
#import "FolderHeaderView.h"
#import "EditModelHeaderView.h"
#import "FolderListViewController.h"
#import "ShadowView.h"
#import "MBProgressHUD.h"
#import "HBookShelfInfoVC.h"
#import "CYBookListController.h"

#define shelfbooksavepath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"collectionData.data"]

#define allbooksavepath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"allBooks.data"]

typedef enum : NSUInteger {
    CREATRFOLDER,        //未打开文件夹
    ADDBOOKTOFOLDER,         //打开文件夹
    NORMALSTATE,
    MOVEFOLDER
} SHELFGESTURESTATE;

typedef enum : NSUInteger {
    BOOKFOLDERCLOSE,        //未打开文件夹
    BOOKFOLDEROPEN,         //打开文件夹
    BOOKFOLDERCLOSEWITHBOOK,//打开文件夹将图书移动至书架后关闭文件夹
} BOOKFOLDERSTATE;

typedef enum :NSUInteger{
    THEMEONE,
    THEMETWO,
    THEMETHREE,
    THEMENIGHT,
}THEME;

@interface ShelfViewController ()
<
    THPinViewControllerDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    FolderViewControllerDelegate,
    UIActionSheetDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    CustomSheetViewDelegate,
    FolderListViewControllerDelegate,
    UITextFieldDelegate,
    MBProgressHUDDelegate
>{
    NSMutableArray *array;
    SHELFGESTURESTATE SHELFSTATE;
    BOOKFOLDERSTATE FOLDERSTATE;
    THEME theme;
    CGFloat dotaY;

}

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, weak)  UIButton *bookStore;
@property (nonatomic, weak)  UIImageView *navigationBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *viewBgImageView;
//书城的底部导航控制器
//书架视图
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
//顶部导航栏normal
@property (nonatomic, weak)  UIView *navigationView;
//数据源数组
@property (nonatomic, strong) NSMutableArray *collectionDataArray;
//书架排序数组
@property (strong, nonatomic) NSMutableArray *collectionSortArray;
//删除数组
@property (strong, nonatomic) NSMutableArray *collectionDeleteArray;
@property (assign, nonatomic) BOOL isEdit;
//布局 yes为网格 no为列表
@property (assign, nonatomic) BOOL  isGridView;
//COLLECTION的headerview
//@property (strong, nonatomic) CollectionHeaderView *headerView;
//网格布局
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutGrid;
//列表布局
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutList;
//长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) FolderViewController *folderViewController;
@property (nonatomic, strong) NSIndexPath *folderIndexPath;
@property (nonatomic, strong) IBOutlet UIView *lowView;
@property (nonatomic, assign) BOOL folderIsOpen;
@property (nonatomic, strong) id bookFromFolder;
@property (nonatomic, assign) NSInteger remainingPinEntries;
@property (nonatomic, strong) NSIndexPath *menuselectIndexPath;
@property (nonatomic, strong) TSPopoverController *popover;
@property (nonatomic, strong) CustomSheetView *deleteAlertSheetView;
@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) FolderHeaderView *folderHeaderView;
@property (nonatomic, strong) EditModelHeaderView *editModelNavigationView;
//@property (nonatomic, strong) NSIndexPath *menuSelectededIndex;
@property (nonatomic, strong) NSMutableDictionary *deleteBooksDictionary;
@property (nonatomic, strong) ShadowView *shadowView;
/** 是否是搜索状态*/
@property (nonatomic, assign) BOOL isSearch;
/** 搜索数据*/
@property (nonatomic, strong) NSMutableArray* searchArr;
/** 正在阅读的书籍index*/
@property (nonatomic, assign) NSInteger bookReadedIndex;

@end

@implementation ShelfViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isSearch = NO;
    self.searchArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.titleLab.text = @"书架";
    self.titleLab.origin = CGPointMake((MainScreenWidth - self.titleLab.width)/2, self.titleLab.origin.y);
    
    //编辑状态的NavBtn
    [self.deleteSureBtn addTarget:self action:@selector(readyDeleteBooks:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.deleteCancelBtn addTarget:self action:@selector(cancelEdit:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self setupData];
    
    //标记菜单列表默认选择的是封面模式
    self.menuselectIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
//    //适配iOS7状态栏
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
        
    //标记文件夹打开或者关闭的状态
    self.folderIsOpen = NO;
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    
//    初始化collectionView
    [self setupCollectionView];
    
    [self.view bringSubviewToFront:self.navigationView];
    

    
    [self reloadShelfData];

    //添加通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];
    //进入书架的时候刷新书架数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshShelf)
                                                 name:@"RELOADFOLDER"
                                               object:nil];
    //获取读书完毕退出时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadReadingBook:) name:@"EndBookReadingNotification"
                                               object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
    [self reloadShelfData];
    self.remainingPinEntries = 4;
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self writeFileArray];
}

#pragma mark - custom method

- (void)refreshShelf{
    [self setupData];
    [self reloadShelfData];
}

- (void)setupData{
    //初始化数据源数组
    self.collectionDataArray = [NSMutableArray arrayWithCapacity:0];
    self.collectionSortArray = [NSMutableArray arrayWithCapacity:0];
    self.collectionDeleteArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *tagVersion=[[NSUserDefaults standardUserDefaults] objectForKey:@"tagVersion"];
    
    if ([self isFirstLaunch]) {
        //首次启动 加载引导页
        [self hidesCustomTabView];
        UIButton *introbuton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *imageNameString;
        if (iPhone5) {
            imageNameString = @"yindao_iphone5";
        } else if (isPad)
        {
            imageNameString = @"yindao_ipad";
        } else {
            imageNameString = @"yindao_iphone4";
        }
        [introbuton setBackgroundImage:[UIImage imageNamed:imageNameString] forState:UIControlStateNormal];
        introbuton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight+4);
        [introbuton addTarget:self action:@selector(introbutonDismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[UIApplication sharedApplication].delegate window] addSubview:introbuton];
        
    }
    
    //首次启动或者是版本更新 则重新加载数据
    if ([self isFirstLaunch] || !(tagVersion!=nil && [version isEqualToString:tagVersion])) {
        
        _collectionSortArray = [[self getAllBookAction] mutableCopy];
        _collectionDataArray = [[self getAllBookAction] mutableCopy];
        [self writeFileArray];
        
    }else{
        //没有更新
        [self readFileArray];
        NSArray *arrray = [self getAllBookAction];
        
        for (id book in arrray) {
            __block  BOOL ishave = NO;
            
             NSArray *tmparray  = [[NSArray alloc]initWithArray:[_collectionDataArray copy]];
            [tmparray enumerateObjectsUsingBlock:
             ^(id obj, NSUInteger idx, BOOL *stop) {
                 if ([obj[@"title"] isEqualToString:book[@"title"]]) {
                     *stop = YES;
                     ishave = YES;
                 }
             }];
            
            if (!ishave) {
                [_collectionDataArray addObject:book];
                [_collectionSortArray insertObject:book atIndex:0];
            }
        }
        [self writeFileArray];
    }
}

- (void)introbutonDismiss:(id)sender{
    __block UIButton *btn = (UIButton *)sender;
    [UIView animateWithDuration:0.4 animations:^{
        btn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
        [self showCustomTabViw];
        btn = nil;
    }];
}

- (void)setupCollectionView{
    //背景不透明
    self.collectionView.backgroundView.backgroundColor = RGBCOLOR(238, 238, 238, 1);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //网格
    [self.collectionView registerNib:[CommonCollectionCell nib]
          forCellWithReuseIdentifier:@"CommonCollectionCell"];
    //列表
    [self.collectionView registerNib:[CommonCollectionCell nibWithLand]
          forCellWithReuseIdentifier:@"CommonCollectionLandCell"];
    
    [self.collectionView registerNib:[CollectionHeaderView nib]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"CollectionHeaderView"];
    
    self.layoutGrid = [[UICollectionViewFlowLayout alloc]init];
    self.layoutList = [[UICollectionViewFlowLayout alloc]init];

    if (isPad){
        self.layoutGrid.itemSize = CGSizeMake(142, 250);
        self.layoutGrid.footerReferenceSize = CGSizeZero;
        self.layoutGrid.minimumLineSpacing = 5.0f;
        self.layoutGrid.minimumInteritemSpacing = 5.0f;
        self.layoutGrid.sectionInset = UIEdgeInsetsMake(5, 45, 5, 45);
        
        self.layoutList.itemSize = CGSizeMake(368, 180);
        self.layoutList.headerReferenceSize = CGSizeMake(768, 43);
        self.layoutList.footerReferenceSize = CGSizeZero;
        self.layoutList.minimumInteritemSpacing = 0;
        self.layoutList.minimumLineSpacing = 1;

    }else{
        self.layoutGrid.itemSize = CGSizeMake(93, 170);
        self.layoutGrid.footerReferenceSize = CGSizeZero;
        self.layoutGrid.minimumLineSpacing = 0.0f;
        self.layoutGrid.minimumInteritemSpacing = 0.0f;
        self.layoutGrid.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        self.layoutList.itemSize = CGSizeMake(MainScreenWidth, 118);
        self.layoutList.headerReferenceSize = CGSizeMake(MainScreenWidth, 43);
        self.layoutList.footerReferenceSize = CGSizeZero;
        self.layoutList.minimumInteritemSpacing = 0;
        self.layoutList.minimumLineSpacing = 1;

    
    }
    [self controlLatestReadingView];
    
    self.collectionView.collectionViewLayout = self.layoutGrid;
    self.isGridView = YES;
    [self useGestureOrNot:YES];
}

/**
 本次使用一个layout，如果使用两个layout，需要分开写
 */
- (void)controlLatestReadingView {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"LatestReadedBook"]) {
        self.layoutGrid.headerReferenceSize = isPad ? CGSizeMake(MainScreenWidth, 234) : CGSizeMake(MainScreenWidth, 117);
    } else {
        self.layoutGrid.headerReferenceSize = isPad ? CGSizeMake(MainScreenWidth, 0) : CGSizeMake(MainScreenWidth, 0);
    }
}

/**
 是否添加长按拖动创建文件夹功能

 @param isUse <#isUse description#>
 */
- (void)useGestureOrNot:(BOOL)isUse {
#warning 暂时注释长按文件夹
//    if (isUse) {
//        [self.lowView addGestureRecognizer:self.longPress];
//    } else {
//        [self.lowView removeGestureRecognizer:self.longPress];
//    }
}

/**
 拖动或者打开文件夹就禁用这些按钮
 */
- (void)enableAllBtnWithBool:(BOOL)onoff{
    self.bookStore.enabled = onoff;
}

#pragma mark 导航栏上的Action

- (IBAction)gotoBookStoreAction:(id)sender {

    CYBookListController *bookListVC = [[CYBookListController alloc] initWithNibName:@"CYBookListController" bundle:nil];
    [self.navigationController pushViewController:bookListVC animated:YES];
}

#pragma mark longPressGesture

- (void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longGesture = (UILongPressGestureRecognizer *)sender;
    
    CGPoint location;
    CGPoint locatitonInLow;
    NSIndexPath *indexPath;
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    static NSIndexPath *markfolderIndexPath = nil;
    
    CommonCollectionCell *cell = nil;
    if (FOLDERSTATE != BOOKFOLDEROPEN) {
        location = [longGesture locationInView:self.collectionView];
        indexPath = [self.collectionView indexPathForItemAtPoint:location];
        cell= (CommonCollectionCell*)[self.collectionView
                                                            cellForItemAtIndexPath:indexPath];
    }else{
        location = [longGesture locationInView:self.folderViewController.collectionView];
        indexPath = [self.folderViewController.collectionView indexPathForItemAtPoint:location];
        cell= (CommonCollectionCell*)[self.folderViewController.collectionView cellForItemAtIndexPath:indexPath];
    }

    locatitonInLow = [longGesture locationInView:self.lowView];
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                
            [self enableAllBtnWithBool:NO];
            
            if (FOLDERSTATE == BOOKFOLDERCLOSE) {
                if (indexPath) {
                        snapshot = [self customSnapshoFromView:cell.bookImageView];
                        //               保存之前的indexpath
                        sourceIndexPath = indexPath;
                        
                        snapshot.center = locatitonInLow;
                        [self.lowView addSubview:snapshot];
                        [self.lowView bringSubviewToFront:snapshot];
                        [UIView animateWithDuration:0.3 animations:^{
                            snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                        }];
                        cell.hidden = YES;
                        if ([self judgeCellisFolderWithIndexpath:indexPath]) {
                            SHELFSTATE = MOVEFOLDER;
                        } else {
                            SHELFSTATE = NORMALSTATE;
                        }
                    }
                } else if (FOLDERSTATE == BOOKFOLDEROPEN) {
                     if (indexPath) {
                        snapshot = [self customSnapshoFromView:cell.bookImageView];
                        snapshot.center = locatitonInLow;
                        [self.lowView addSubview:snapshot];
                        [UIView animateWithDuration:0.3 animations:^{
                            cell.hidden = YES;
                            snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                        }];
                        [self.folderViewController longPressGestureRecognized:sender];
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if(snapshot)
            {
                snapshot.center = locatitonInLow;
                
                NSIndexPath *targetIndexPath = [self getIndexPathWithPoint:location];
                //新的位置
                if (FOLDERSTATE == BOOKFOLDERCLOSE)
                {
                    //NSIndexPath *targetIndexPath = [self getIndexPathWithPoint:location];
                    //如果移动到一个cell中则执行创建文件夹的动作
                    if (CGRectContainsPoint(cell.frame, location) && ![sourceIndexPath isEqual:indexPath])
                    {
                        //在此判断cell是否为folder
                        if([self judgeCellisFolderWithIndexpath:indexPath] && SHELFSTATE != MOVEFOLDER)
                        {
                            //如果是文件夹 文件夹cell会放大
                            markfolderIndexPath = indexPath;
                            [UIView animateWithDuration:0.4 animations:^{
                                snapshot.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                cell.hidden = NO;
                                cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
                            } completion:nil];
                            SHELFSTATE = ADDBOOKTOFOLDER;
                        } else {
                            //创建文件夹那么底部cell保持原有尺寸
                            if (SHELFSTATE == MOVEFOLDER) {
                                [UIView animateWithDuration:0.4 animations:^{
                                    snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                } completion:nil];
                            } else {
                                [UIView animateWithDuration:0.4 animations:^{
                                    snapshot.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                } completion:nil];
                                SHELFSTATE = CREATRFOLDER;
                            }
                        }
                        
                    } else {
                        if (markfolderIndexPath) {
                            //将放大的cell缩小
                            CommonCollectionCell *celll= (CommonCollectionCell*)
                            [self.collectionView cellForItemAtIndexPath:markfolderIndexPath];
                            
                            [UIView animateWithDuration:0.2 animations:^{
                                celll.hidden = NO;
                                celll.transform = CGAffineTransformMakeScale(1.0, 1.0);
                            }];
                            markfolderIndexPath = nil;
                        }
                        if (targetIndexPath && ![sourceIndexPath isEqual:targetIndexPath])
                        {
                            //如果没有移动到一个cell上，并且有新的targetIndexpath则执行换位置的动作
                            [self moveBookFromIndex:sourceIndexPath toIndex:targetIndexPath];
                            sourceIndexPath = targetIndexPath;
                            NSLog(@"sourceIndexPath %ld, targetIndexPath %ld", (long)sourceIndexPath.item, (long)targetIndexPath.item);
                            if (SHELFSTATE == MOVEFOLDER) {
                                
                            } else {
                                SHELFSTATE = NORMALSTATE;
                            }
                        } else {
                            //这种情况为取消创建文件夹或者起始位置与终止位置相同则还原
                            [UIView animateWithDuration:0.25 animations:^{
                                snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            } completion:nil];
                            if (SHELFSTATE == MOVEFOLDER) {
                                
                            } else {
                                SHELFSTATE = NORMALSTATE;
                            }
                        }
                    }
                   
                    targetIndexPath = nil;
            } else if (FOLDERSTATE == BOOKFOLDEROPEN) {
                //打开文件夹拖动
                [self.folderViewController longPressGestureRecognized:sender];
                if (snapshot.frame.origin.y < self.folderViewController.view.frame.origin.y) {
                    [[JWFolders folder] closeCurrentFolder];
                    //[self hideFolderHeaderView];
                    //从文件夹中删除书
                    NSMutableArray *arrayy = [self dataAtIndexPath:self.folderIndexPath][@"booksArray"];
                    [arrayy removeObject:self.bookFromFolder];
                    if (arrayy.count == 0)
                    {
                        [_collectionSortArray removeObjectAtIndex:self.folderIndexPath.item];
                        [self writeFileArray];
                        
                    }
                    
                    FOLDERSTATE = BOOKFOLDERCLOSEWITHBOOK;
                    SHELFSTATE = NORMALSTATE;
                }

            } else if (FOLDERSTATE == BOOKFOLDERCLOSEWITHBOOK) {
                //从文件夹中拖出书
                //获取位置 将书直接插入到书架 同时将folder状态改为colse 书架状态改为movebook
                
                __block NSIndexPath *tmpindexpath = nil;
                if (self.bookFromFolder && ![self.collectionSortArray containsObject:self.bookFromFolder]) {
                    
                    //9.9修改
                    if (targetIndexPath) {
                        NSLog(@" 插入targetindexpath %ld", (long)targetIndexPath.item);
                        tmpindexpath = [targetIndexPath copy];
                        //sourceIndexPath = targetIndexPath;
                    } else if (indexPath) {
                        NSLog(@" 插入indexpath %ld", (long)indexPath.item);
                        tmpindexpath = [indexPath copy];
                        //sourceIndexPath = indexPath;
                    }
                    
                    if (!tmpindexpath) {
                        [self.collectionSortArray addObject:self.bookFromFolder];
                        tmpindexpath = [NSIndexPath indexPathForItem:self.collectionSortArray.count-1 inSection:0];
                        sourceIndexPath = tmpindexpath;
                    } else {
                        NSLog(@"cell 插入到collection中%ld",(long)tmpindexpath.item);
                        [self.collectionSortArray insertObject:[self.bookFromFolder mutableCopy] atIndex:tmpindexpath.item];
                        sourceIndexPath = tmpindexpath;
                    }
                    
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:sourceIndexPath]];
                        
                        NSLog(@"隐藏的是%ldcell",(long)sourceIndexPath.item);
                    } completion:^(BOOL finished) {
                        UICollectionViewCell *tmpcell = [self.collectionView
                                                         cellForItemAtIndexPath:sourceIndexPath];
                        tmpcell.hidden = YES;
                        NSLog(@"隐藏的是%ldcell", (long)sourceIndexPath.item);
                        tmpindexpath = nil;
                    }];
                    
                    FOLDERSTATE = BOOKFOLDERCLOSE;
                    SHELFSTATE = NORMALSTATE;
                    
                    self.bookFromFolder = nil;
                    //9.9修改end
                } else {
                    NSLog(@"书被释放了");
                }
            }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (snapshot) {
                
                if (FOLDERSTATE == BOOKFOLDERCLOSE){

                    if (SHELFSTATE == NORMALSTATE || SHELFSTATE == MOVEFOLDER) {
                        if (snapshot && sourceIndexPath) {
                            CommonCollectionCell *celll= (CommonCollectionCell*)
                            [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
                            snapshot.center = [self.lowView convertPoint: celll.center
                                                                fromView: self.collectionView];
                            [UIView animateWithDuration:0.3 animations:^{
                                snapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                celll.hidden = NO;
                                NSLog(@"显示的是%ld cell", (long)sourceIndexPath.item);
                                [snapshot removeFromSuperview];
                            }completion:^(BOOL finished) {
                                sourceIndexPath = nil;
                                snapshot = nil;
                            }];
                        } else{
                            NSLog(@"bugggg");
                        }
                    }else if(SHELFSTATE == CREATRFOLDER) {
                        //改变cell的背景图
                        //缩小cell的image
                        //添加新的image
                        [UIView animateWithDuration:0.4 animations:^{
                            snapshot.center = [self.lowView convertPoint: cell.center
                                                                fromView: self.collectionView];
                            snapshot.transform = CGAffineTransformMakeScale(0.8, 0.8);
                            [snapshot removeFromSuperview];
                            snapshot = nil;
                        } completion:nil];
                        NSMutableArray *mtArray = [NSMutableArray arrayWithCapacity:0];
                        [mtArray addObject:_collectionSortArray[indexPath.item]];
                        [mtArray insertObject:_collectionSortArray[sourceIndexPath.item] atIndex:0];
                        
                        NSMutableDictionary *folderDict = [NSMutableDictionary dictionaryWithCapacity:4];
                        folderDict = [@{
                                        @"isFolder" : @"yes",
                                        @"folderName" : @"未命名",
                                        @"password" : @"",
                                        @"folderImage" : @"",
                                        @"booksArray" : mtArray
                                        } mutableCopy];
                        
                        [_collectionSortArray replaceObjectAtIndex:indexPath.item withObject:folderDict];
                        [_collectionSortArray removeObjectAtIndex:sourceIndexPath.item];
                        [self.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                        
                        [cell configureCellWithData:folderDict];
                        
                        markfolderIndexPath = nil;
                        sourceIndexPath = nil;
                        
                    }else if(SHELFSTATE == ADDBOOKTOFOLDER) {
                        [UIView animateWithDuration:0.4 animations:^{
                            snapshot.center = [self.lowView convertPoint: cell.center fromView:self.collectionView];
                            snapshot.transform = CGAffineTransformMakeScale(0.8, 0.8);
                            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
                            [snapshot removeFromSuperview];
                            snapshot = nil;
                        } completion:nil];
                        id cellData = _collectionSortArray[indexPath.item];
                        NSMutableArray *arrayyyyy  = cellData[@"booksArray"];
                        [arrayyyyy insertObject:_collectionSortArray[sourceIndexPath.item] atIndex:0];
                        [_collectionSortArray removeObjectAtIndex:sourceIndexPath.item];
                        [self.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                        
                        [cell configureCellWithData:cellData];
                        markfolderIndexPath = nil;
                        sourceIndexPath = nil;
                    }
                    [self writeFileArray];
                } else if(FOLDERSTATE == BOOKFOLDEROPEN) {
                    [self.folderViewController longPressGestureRecognized:sender];
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }
            }
            [self enableAllBtnWithBool:YES];
            if (FOLDERSTATE == BOOKFOLDEROPEN) {
                
            }else{
                FOLDERSTATE = BOOKFOLDERCLOSE;
            }
            SHELFSTATE = NORMALSTATE;
            [snapshot removeFromSuperview];
            [self.collectionView reloadData];
        
            break;
        }
    
        default:
            break;
    }
    
}

#pragma mark 控制文件夹
//控制文件夹
- (void)controlFolderWithIndexPath:(NSIndexPath *)indexPath{
    [self configureFolderView];
    //   文件夹视图控制器
    __weak ShelfViewController *weakSelf = self;
    self.folderViewController = [[FolderViewController alloc]initWithNibName:isPad ?
                                 @"FolderViewController_iPad" : @"FolderViewController_phone"bundle:nil];
    self.folderViewController.delegate = self;
    self.folderIndexPath = indexPath;
    self.folderViewController.folderDataDict = [self dataAtIndexPath:indexPath];
    
    self.folderHeaderView.bookDict = [self dataAtIndexPath:indexPath];
    if (self.isEdit) {
        [self.folderViewController folderIsEditWithBool:YES];
        if ([[self.deleteBooksDictionary allKeys] containsObject:@(indexPath.item)]) {
            self.folderViewController.deleteArray = self.deleteBooksDictionary[@(indexPath.item)];
        }
    } else {
        [self.folderViewController folderIsEditWithBool:NO];
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGPoint openPoint = CGPointMake(1, cell.frame.origin.y + cell.height);
    openPoint.y = openPoint.y - self.collectionView.contentOffset.y ;
    
    __block CGRect startFrame = self.lowView.frame;
    __block CGPoint startOffset = self.collectionView.contentOffset;
    JWFolders *folder = [JWFolders folder];
    folder.contentView = self.folderViewController.view;
    folder.containerView = self.lowView;
    folder.position = openPoint;
    //    folder.direction = JWFoldersOpenDirectionUp;
    //    folder.contentBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]];
    //    folder.shadowsEnabled = YES;
    //    folder.showsNotch = YES;
    [folder open];
    folder.openBlock = ^(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
        [weakSelf enableAllBtnWithBool:NO];
        
        weakSelf.edit_compileBtn.hidden = YES;
        weakSelf.edit_deleteBtn.hidden = YES;
        //        weakSelf.edit_skinBtn.hidden = YES;
        
        CGRect tmpFrame = weakSelf.lowView.frame;
        CGFloat yOffset;
        if (isPad) {
            yOffset = cell.frame.origin.y - weakSelf.collectionView.contentOffset.y - 6;
        } else {
            yOffset = cell.frame.origin.y - weakSelf.collectionView.contentOffset.y + 28;
        }
        tmpFrame.origin.y -= yOffset;
        tmpFrame.size.height += yOffset;
        [UIView animateWithDuration:.6f animations:^{
            weakSelf.lowView.frame = tmpFrame;
        }];
        weakSelf.folderIsOpen = YES;
        self->FOLDERSTATE = BOOKFOLDEROPEN;
        [weakSelf hidesCustomTabView];
    };
    
    folder.closeBlock = ^(UIView *contentView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
        
        [weakSelf enableAllBtnWithBool:YES];
        weakSelf.edit_compileBtn.hidden = NO;
        weakSelf.edit_deleteBtn.hidden = YES;
        //        weakSelf.edit_skinBtn.hidden = YES;
        
        
        
        [UIView animateWithDuration:0.35 animations:^{
            weakSelf.lowView.frame = startFrame;
            weakSelf.collectionView.contentOffset = startOffset;
        }];
        weakSelf.folderIsOpen = NO;
        if (self->FOLDERSTATE == BOOKFOLDERCLOSEWITHBOOK) {
            
        }else {
            self->FOLDERSTATE = BOOKFOLDERCLOSE;
        }
        if (!self->_isEdit) {
            [weakSelf showCustomTabViw];
            
        }
        [weakSelf hideFolderHeaderView];
        [weakSelf.collectionView reloadData];
    };
    
    [self performSelector:@selector(showFolderView) withObject:self afterDelay:0.4];
}

/**
 *  进入编辑模式
 */
- (void)editBookShelf{
    //    弹出
    [self useGestureOrNot:NO];
    if (!self.isGridView) {
        [self transBetweenListAndGridWithBool:NO];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.layoutGrid.headerReferenceSize = CGSizeMake(ScreenWidth, 0);
    }];
    
    self.isEdit = YES;
    [self.collectionView reloadData];
}

- (BOOL)judgeDataIsBookWith:(id)aData{
    if ([[aData allKeys] containsObject:@"title"]) {
        return YES;
    }
    return NO;
}

- (void)cancelEdit{
    
    [self controlLatestReadingView];
    self.isEdit = NO;
    [self useGestureOrNot:YES];
    [self.collectionDeleteArray removeAllObjects];
    
}

#pragma mark 移动书籍到一个位置

/**
 阅读移动书籍
 */
- (void)moveReadedToFirst{
    [self readFileArray];
    //    如果阅读的第一本书就不需要进行移动
    if (_bookReadedIndex != 0) {
        
        id objectToMove = _collectionSortArray[_bookReadedIndex];
        [_collectionSortArray removeObjectAtIndex:_bookReadedIndex];
        [_collectionSortArray insertObject:objectToMove atIndex:0];
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *sourcepath = [NSIndexPath indexPathForItem:_bookReadedIndex inSection:0];
        [self.collectionView moveItemAtIndexPath:sourcepath toIndexPath:indexpath];
        
        [self writeFileArray];
        _bookReadedIndex = 0;
    }
    
    //    移除通知
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"EndBookReadingNotification"
     object:nil];
}

/**
 *  切换两种布局方式
 */
- (void)transBetweenListAndGridWithBool:(BOOL)avalue{
    if (avalue) {
        if (isPad) {
            self.layoutGrid.itemSize = CGSizeMake(768, 166);
            self.layoutGrid.footerReferenceSize = CGSizeZero;
            self.layoutGrid.minimumInteritemSpacing = 0;
            self.layoutGrid.minimumLineSpacing = 1;
            self.layoutGrid.sectionInset = UIEdgeInsetsMake(0, 0, 60, 0);
        } else {
            self.layoutGrid.itemSize = CGSizeMake(320, 105);
            self.layoutGrid.footerReferenceSize = CGSizeZero;
            self.layoutGrid.minimumInteritemSpacing = 0;
            self.layoutGrid.minimumLineSpacing = 0;
            self.layoutGrid.sectionInset = UIEdgeInsetsMake(0, 0, 60, 0);
        }
        self.isGridView = NO;
        [self useGestureOrNot:NO];
    } else {
        if (isPad) {
            self.layoutGrid.itemSize = CGSizeMake(123, 220);
            self.layoutGrid.footerReferenceSize = CGSizeZero;
            self.layoutGrid.minimumLineSpacing = 20.0f;
            self.layoutGrid.minimumInteritemSpacing = 58.0f;
            self.layoutGrid.sectionInset = UIEdgeInsetsMake(50, 51, 66, 51);
        } else {
            self.layoutGrid.itemSize = CGSizeMake(74, 140);
            self.layoutGrid.footerReferenceSize = CGSizeZero;
            self.layoutGrid.minimumLineSpacing = 18.0f;
            self.layoutGrid.minimumInteritemSpacing = 29.0f;
            self.layoutGrid.sectionInset = UIEdgeInsetsMake(21, 20, 60, 20);
        }
        self.isGridView = YES;
        [self useGestureOrNot:YES];
    }
    [self.collectionView setScrollsToTop:YES];
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark Help method

- (BOOL)judgeCellisFolderWithIndexpath:(NSIndexPath *)index{
    NSMutableDictionary *dic =  _collectionSortArray[index.item];
    if ([[dic allKeys] containsObject:@"isFolder"]) {
        return YES;
    }
    
    return NO;
}

- (void)moveBookFromIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex{
    //对数据源进行操作
    [self insertBookForIndex:fromIndex toIndex:toIndex];
    //对视图进行操作
    [self.collectionView moveItemAtIndexPath:fromIndex toIndexPath:toIndex];
}

- (void)insertBookForIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath*)toIndex{
    id objectToMove = _collectionSortArray[fromIndex.item];
    [_collectionSortArray removeObjectAtIndex:fromIndex.item];
    [_collectionSortArray insertObject:objectToMove atIndex:toIndex.item];
}

#pragma mark 编辑书籍Action

- (void)editBookShelfWithIndex:(NSInteger)index{
    if (_isEdit) {
        [self cancelEdit];
    }
    switch (index) {
        case 0://整理模式
            [self showEditModelNavigationViewWithBool:YES];
            [self hidesCustomTabView];
            [self editBookShelf];
            
            break;
        case 1://Wi-Fi模式
            [self showEditModelNavigationViewWithBool:NO];
            [self controlDeleteAlertSheetViewWithBool:NO];
            [self.collectionDeleteArray removeAllObjects];
            break;
        case 2://封面模式
            [self showEditModelNavigationViewWithBool:NO];
            [self controlLatestReadingView];
            [self controlDeleteAlertSheetViewWithBool:NO];
            [self.collectionDeleteArray removeAllObjects];
            [self showCustomTabViw];
            [self transBetweenListAndGridWithBool:NO];
            break;
        case 3://列表模式
            [self showEditModelNavigationViewWithBool:NO];
            [self controlLatestReadingView];
            [self controlDeleteAlertSheetViewWithBool:NO];
            [self.collectionDeleteArray removeAllObjects];
            [self showCustomTabViw];
            [self transBetweenListAndGridWithBool:YES];
            break;
        default:
            break;
    }
    [self.popover dismissPopoverAnimatd:YES];
}

/**
 控制编辑模式顶部菜单的创建、显示、隐藏
 */
- (void)showEditModelNavigationViewWithBool:(BOOL)isyes;{
    static bool  isReadyShow;
    CGFloat offsetFloat = isPad ? 120 : 66;
    if (!self.editModelNavigationView) {
        self.editModelNavigationView = [[[NSBundle mainBundle] loadNibNamed: isPad ? @"EditModelHeaderView_ipad" : @"EditModelHeaderView" owner:self options:nil] objectAtIndex:0];
        self.editModelNavigationView.bgImageView.image = [UIImage imageNamed:isPad ? @"top_bookshelf_img_ipad.png" : @"top_bookshelf_img.png"];
        CGFloat offsetFloat = isPad ? 120 : 66;
        self.editModelNavigationView.frame = CGRectMake(0, -offsetFloat, ScreenWidth, offsetFloat);
        [self.view addSubview:self.editModelNavigationView];
        
        __weak ShelfViewController *weakSelf = self;
        self.editModelNavigationView.buttonTappedBlock = ^(id sender) {
            UIButton *button = (UIButton *)sender;
            if (button.tag == 1) {
                //删除按钮
                if ([[weakSelf.deleteBooksDictionary allKeys] count]) {
                    [weakSelf showShadowViewWithBool:YES];
                    [weakSelf controlDeleteAlertSheetViewWithBool:YES];
                }
            } else {
                //取消删除
                [weakSelf.deleteBooksDictionary removeAllObjects];
                //返回到当前网格视图状态
                NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
                [weakSelf editBookShelfWithIndex:2];
                weakSelf.menuselectIndexPath = index;
            }
        };
    }
    if (isyes) {
        if (isReadyShow) {
            return;
        }
        isReadyShow = YES;
        
        __weak ShelfViewController *weakSelf = self;
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.editModelNavigationView.hidden = NO;
            weakSelf.editModelNavigationView.frame = CGRectOffset(weakSelf.editModelNavigationView.frame, 0, offsetFloat);
        }];
    } else if(isReadyShow){
        isReadyShow = NO;
        __weak ShelfViewController *weakSelf = self;
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.editModelNavigationView.hidden = YES;
            weakSelf.editModelNavigationView.frame = CGRectOffset(weakSelf.editModelNavigationView.frame, 0, -offsetFloat);
        }];
    }
}

/**
 隐藏导航栏
 */
- (void)hidesCustomTabView{
    [self.delegate viewController:self hideTabView:YES];
}

- (void)showCustomTabViw{
    [self.delegate viewController:self hideTabView:NO];
}

/**
 阅读书籍
 */
- (void)readbookWithData:(id)aBook;{
    
    [BooksDataHandle willReadingBookMethod:aBook];
}

#pragma mark 状态存取

/**
 *  保存书架图书信息
 
 */
- (void)writeFileArray {
    [_collectionSortArray writeToFile:shelfbooksavepath atomically:YES];
    [_collectionDataArray writeToFile:allbooksavepath atomically:YES];
}

/**
 *  读取书架图书信息
 */
- (void)readFileArray {
    _collectionSortArray = [[NSArray arrayWithContentsOfFile:shelfbooksavepath] mutableCopy];
    
    _collectionDataArray = [[NSArray arrayWithContentsOfFile:allbooksavepath] mutableCopy];
    
    if (!_collectionDataArray || _collectionDataArray.count == 0) {
        _collectionDataArray = [[self getAllBookAction] mutableCopy];
        [self writeFileArray];
    }
    
    if (!_collectionSortArray || _collectionSortArray.count == 0) {
        _collectionSortArray = [_collectionDataArray mutableCopy];
        [self writeFileArray];
    }
    
}

#pragma mark 文件夹加密锁

- (void)experimentalPassword{
    THPinViewController *pinViewController = [[THPinViewController alloc]
                                              initWithDelegate:self];
    pinViewController.promptTitle = @"请输入密码";
    pinViewController.promptColor = [UIColor darkTextColor];
    pinViewController.view.tintColor = [UIColor darkTextColor];
    pinViewController.hideLetters = YES;
    
    pinViewController.backgroundColor = [UIColor whiteColor];
    
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    
    [self.view.window.rootViewController
     presentViewController:pinViewController animated:YES completion:nil];
}

#pragma mark - touch event

/**
 编辑按钮Action
 */
- (IBAction)gotoCompileAction:(id)sender {
    
    //是否动画期间
    if (isAnimate) {
        return;
    }
    
    if (self.edit_deleteBtn.hidden == YES) {
        
        self.edit_deleteBtn.hidden = NO;
        //        self.edit_skinBtn.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self->isAnimate = YES;
            
            if (iphone) {
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y-50, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y-100, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }else{
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y-100, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y-200, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }
            
            
        } completion:^(BOOL finished) {
            self->isAnimate = NO;
            [self enableAllBtnWithBool:NO];
            [self startEditBookAction];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self->isAnimate = YES;
            if (iphone) {
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+50, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+100, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }else{
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+100, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+200, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }
        } completion:^(BOOL finished) {
            self->isAnimate = NO;
            [self enableAllBtnWithBool:YES];
            self.edit_deleteBtn.hidden = YES;
            //            self.edit_skinBtn.hidden = YES;
            [self stopEditBookAction];
        }];
    }
}

- (void)startEditBookAction{
    //全局收编辑
    self.mainEditV.hidden = NO;
    CGRect startFrame = self.lowView.frame;
    if (iphone) {
        startFrame.origin.y -= 50.0f;
        startFrame.size.height += 50.0f;
    }else{
        startFrame.origin.y -= 60.0f;
        startFrame.size.height += 60.0f;
    }
    
    CGRect frame = self.collectionView.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y+10, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.lowView.frame = startFrame;
        if (iphone) {
            self.collectionView.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.headerView.hidden = YES;
    }];
}

- (void)stopEditBookAction{
    //全局收编辑
    self.mainEditV.hidden = YES;
    //取消删除
    [self useGestureOrNot:YES];
    
    CGRect startFrame = self.lowView.frame;
    if (iphone) {
        startFrame.origin.y += 50;
        startFrame.size.height -= 50;
        
    }else{
        startFrame.origin.y += 60;
        startFrame.size.height -= 60;
    }
    
    CGRect frame = self.collectionView.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.isEdit = NO;
        self.headerView.hidden = NO;
        
        [self showDeleteBookBtn:NO];
        self.lowView.frame = startFrame;
        
        if (iphone) {
            self.collectionView.frame = frame;
        }
    } completion:^(BOOL finished) {
        [self useGestureOrNot:YES];
    }];
    [self.collectionView reloadData];
    [self.collectionDeleteArray removeAllObjects];
}

- (IBAction)closeDeleteTapAction:(id)sender {
    if (isAnimate) {
        return;
    }
    
    if (self.edit_deleteBtn.hidden == YES) {
        self.edit_deleteBtn.hidden = NO;
        //        self.edit_skinBtn.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self->isAnimate = YES;
            
            if (iphone) {
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y-50, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y-100, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }else{
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y-100, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y-200, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }
        } completion:^(BOOL finished) {
            self->isAnimate = NO;
            [self enableAllBtnWithBool:NO];
            [self startEditBookAction];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self->isAnimate = YES;
            if (iphone) {
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+50, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+100, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }else{
                self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+100, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
                
                //                self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+200, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
            }
        } completion:^(BOOL finished) {
            
            self->isAnimate = NO;
            [self enableAllBtnWithBool:YES];
            
            self.edit_deleteBtn.hidden = YES;
            //            self.edit_skinBtn.hidden = YES;
            
            [self stopEditBookAction];
        }];
        
    }
}

#pragma mark -进入编辑书籍Action

- (IBAction)gotoDeleteBookAction:(id)sender {
    
    //全局收编辑
    self.mainEditV.hidden = YES;
    
    self.edit_compileBtn.hidden = YES;
    self.edit_deleteBtn.hidden = YES;
    //    self.edit_skinBtn.hidden = YES;
    [self showDeleteBookBtn:YES];
    self.isEdit = YES;
    [self.collectionView reloadData];
    
}

-(void)showDeleteBookBtn:(BOOL)isShow{
    self.deleteSureBtn.hidden = !isShow;
    self.deleteCancelBtn.hidden = !isShow;
    self.bookStore.hidden = isShow;
    
}

- (void)readyDeleteBooks:(id)sender{
    
    //删除书
    if (self.collectionDeleteArray.count > 0){
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate =self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self deletebookfromDeleteArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                HUD.labelText = @"删除成功";
                [HUD hide:YES afterDelay:0.3];
                [self.collectionView reloadData];
            });
        });
    }else{
        [MBProgressHUD showText:@"温馨提示：未选择书籍"];
        
    }
    
}

- (void)deletebookfromDeleteArray{
    NSArray *arrayarray = [self.collectionDeleteArray copy];
    for (NSMutableDictionary *dict in arrayarray){
        if ([[dict allKeys]containsObject:@"isFolder"]){
            //如果是文件夹
            NSArray *folderarray = [dict[@"booksArray"] copy];
            __block id targetBook;
            for (id book in folderarray){
                [_collectionDataArray enumerateObjectsUsingBlock:
                 ^(id obj, NSUInteger idx, BOOL *stop) {
                     if ([obj[@"title"] isEqualToString:book[@"title"]]) {
                         targetBook = obj;
                         *stop = YES;
                     };
                 }];
                [_collectionDataArray removeObject:targetBook];
                [BooksDataHandle deleteBookFromDic:targetBook];
            }
            [self.collectionDeleteArray removeObject:dict];
            
            [_collectionSortArray removeObject:dict];
            folderarray = nil;
        }else{
            //如果不是文件夹
            [_collectionSortArray removeObject:dict];
            [_collectionDataArray removeObject:dict];
            [BooksDataHandle deleteBookFromDic:dict];
            [_collectionDeleteArray removeObject:dict];
        }
        //写入保存
        [self writeFileArray];
    }
    
    [self.collectionDeleteArray removeAllObjects];
    
}

/**
 取消编辑
 */
- (void)cancelEdit:(id)sender{
    //全局收编辑
    self.mainEditV.hidden = NO;
    
    self.isEdit = NO;
    [self showDeleteBookBtn:NO];
    self.edit_compileBtn.hidden = NO;
    self.edit_deleteBtn.hidden = NO;
    //    self.edit_skinBtn.hidden = NO;
    
    [self.collectionView reloadData];
    [self.collectionDeleteArray removeAllObjects];
    
    //收界面
    [self closeDeleteTapAction:nil];
    
}

#pragma mark -变肤色

- (IBAction)gotoChangeSkinBtnAction:(id)sender {
    
    //    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.delegate =self;
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //
    //        NSArray *themes = [[TheamManager shareInstance].themeConfig allKeys];
    //
    //        if (isSunTheme) {
    //            //取出选中的主题名称
    //            NSString *themeName = [themes objectAtIndex:1];
    //            [TheamManager shareInstance].themeNames = themeName;
    //            //发送通知
    //            [[NSNotificationCenter defaultCenter] postNotificationName:KThemeDidChangeNotifition object:themeName];
    //            //保存主题到本地
    //            [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:KThemeName];
    //            [self.themeSwitchBtn loadImage:(iphone)?@"nav_Day_btn@2x.png":@"nav_Day_btn_ipad.png"];
    //            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSunTheme"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //        }else
    //        {
    //            //取出选中的主题名称
    //            NSString *themeName = [themes objectAtIndex:0];
    //            [TheamManager shareInstance].themeNames = themeName;
    //            //发送通知
    //            [[NSNotificationCenter defaultCenter] postNotificationName:KThemeDidChangeNotifition object:themeName];
    //            //保存主题到本地
    //            [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:KThemeName];
    //            [self.themeSwitchBtn loadImage:(iphone)?@"nav_Day_btn@2x.png":@"nav_Day_btn_ipad.png"];
    //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSunTheme"];
    //            ;
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //
    //        }
    //
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //            HUD.labelText = @"设置成功";
    //            [HUD hide:YES afterDelay:0.4];
    //
    //            [self enableAllBtnWithBool:YES];
    //            [self setThemeControlAction];
    //            [self.collectionView reloadData];
    //
    //            [UIView animateWithDuration:0.5 animations:^{
    //                if (iphone) {
    //                    self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+50, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
    //
    //                    self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+100, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
    //
    //                }else
    //                {
    //                    self.edit_deleteBtn.frame = CGRectMake(self.edit_deleteBtn.frame.origin.x, self.edit_deleteBtn.frame.origin.y+100, self.edit_deleteBtn.frame.size.width, self.edit_deleteBtn.frame.size.height);
    //
    //                    self.edit_skinBtn.frame = CGRectMake(self.edit_skinBtn.frame.origin.x, self.edit_skinBtn.frame.origin.y+200, self.edit_skinBtn.frame.size.width, self.edit_skinBtn.frame.size.height);
    //
    //                }
    //
    //            } completion:^(BOOL finished) {
    //                self.edit_compileBtn.hidden = NO;
    //
    //                self.edit_deleteBtn.hidden = YES;
    //                self.edit_skinBtn.hidden = YES;
    //
    //                [self stopEditBookAction];
    //            }];
    //
    //        });
    //    });
    //
}

#pragma mark - delegate
#pragma mark UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    if (self.isSearch) {
        if ([self.searchArr count]>0) {
            return [self.searchArr count];
        }else{
            return 0;
        }
    }else{
        return [_collectionSortArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommonCollectionCell *cell;
    if (self.isGridView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonCollectionCell" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonCollectionLandCell" forIndexPath:indexPath];
    }
    cell.hidden = NO;
    [cell showEditModelImage:NO];
    [cell configureCellWithData:[self dataAtIndexPath:indexPath]];
    if (self.isEdit) {
        [cell showEditModelImage:YES];
        for (NSDictionary *bookDic1 in self.collectionDeleteArray) {
            [cell showSelect:NO];
            if ([[[self dataAtIndexPath:indexPath]objectForKey:@"title"]isEqualToString:bookDic1[@"title"]] ) {
                [cell showSelect:YES];
                break;
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //@TODO 在编辑状态下不可读书
    if (self.edit_deleteBtn.hidden == NO) {
        return;
    }
    //@TODO 在搜索状态下搜索的书籍为空时不可点击
    if (self.isSearch) {
        if ([self.searchArr count] ==0) {
            return;
        }else{
            //进入阅读页面
            [BooksDataHandle willReadingBookMethod:[self.searchArr objectAtIndex:indexPath.row]];
        }
        return;
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CommonCollectionCell *cell = (CommonCollectionCell *)
    [collectionView cellForItemAtIndexPath:indexPath];
//    解决cell不完全显示的情况下打开文件夹黑影问题
    cell.bookSelectedImage.image = [UIImage imageNamed:(iphone)?@"bookShelf_selected_btn.png":@"bookShelf_selected_btn_ipad.png"];
    
    CGFloat offsetFloat = isPad ? 67 : 49;
    CGPoint point = [self.view convertPoint:CGPointMake(0, ScreenHeight-offsetFloat) toView:self.collectionView];
    if (cell.frame.origin.y + cell.height > point.y) {;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:NO];
    }

    CGPoint topPoint = [self.view convertPoint:CGPointMake(0, 200) toView:self.collectionView];
    if (cell.frame.origin.y + cell.height < topPoint.y) {
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:NO];
    }
    
    if (self.isEdit){
        //如果是书那么就添加到数组或者移除到数组
        if (!self.deleteBooksDictionary) {
            self.deleteBooksDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        }
        
        if (cell.editBook){
            [cell showSelect:NO];
            [self.collectionDeleteArray removeObject:[self dataAtIndexPath:indexPath]];
            [self.deleteBooksDictionary removeObjectForKey:@(indexPath.item)];
            cell.bookSelectedImage.hidden = YES;
        }else{
            [cell showSelect:YES];
            [self.collectionDeleteArray addObject:[self dataAtIndexPath:indexPath]];
            [self.deleteBooksDictionary setObject:[self dataAtIndexPath:indexPath] forKey:@(indexPath.item)];
            cell.bookSelectedImage.hidden = NO;
        }
    }else{
        //打开文件夹
        if ([self judgeCellisFolderWithIndexpath:indexPath]) {

            [self.folderViewController folderIsEditWithBool:NO];
            self.folderIndexPath = indexPath;
            
            if (!self.isGridView) {
                NSLog(@"文件夹");
                if ([[[self dataAtIndexPath:self.folderIndexPath]
                      objectForKey:@"password"]
                     isEqualToString:@""]){
                    
                    HBookShelfInfoVC *bookInfo = [[HBookShelfInfoVC alloc]initWithNibName:(iphone)?@"HBookShelfInfoVC":@"HBookShelfInfoVC_ipad" bundle:nil];
                    bookInfo.folderDic = [self dataAtIndexPath:self.folderIndexPath];
                    [self.navigationController pushViewController:bookInfo animated:YES];
                    return;
                }else{
                    [self experimentalPassword];
                }
            }
            
            if ([[[self dataAtIndexPath:self.folderIndexPath]
                  objectForKey:@"password"]
                 isEqualToString:@""]){
                [self controlFolderWithIndexPath:indexPath];
            }else{
                [self experimentalPassword];
            }
        }else{
            [BooksDataHandle willReadingBookMethod:[self dataAtIndexPath:indexPath]];
            _bookReadedIndex = indexPath.item;
            [self moveReadedToFirst];

        }
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionHeaderView *reuseView = (CollectionHeaderView *)
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        [reuseView.rectangleButton addTarget:self action:@selector(transBetweenListAndGr1id:)
                            forControlEvents:UIControlEventTouchUpInside];
        [reuseView.listButton addTarget:self action:@selector(transBetweenListAndGr1id:)
                       forControlEvents:UIControlEventTouchUpInside];
        [reuseView.searchCancel addTarget:self action:@selector(searchCancelAction)
                         forControlEvents:UIControlEventTouchUpInside];
        
        reuseView.searchTextF.delegate = self;
        
//        if (isSunTheme) {
//            UIColor *color = [UIColor grayColor];
//            reuseView.searchTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索书籍" attributes:@{NSForegroundColorAttributeName: color}];
//            reuseView.searchTextF.textColor = color;
//            [reuseView.searchCancel setTitleColor:MAINTHEME_EDIT_BGColor forState:UIControlStateNormal];
//            reuseView.searchCancel.tintColor = MAINTHEME_EDIT_BGColor;
//
//        }else{
//            UIColor *color = RGBCOLOR(79, 79, 79, 1.0);
//            reuseView.searchTextF.textColor = color;
//
//            reuseView.searchTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索书籍" attributes:@{NSForegroundColorAttributeName: color}];
//            [reuseView.searchCancel setTitleColor:MAINTHEME_EDIT_NBGColor forState:UIControlStateNormal];
//            reuseView.searchCancel.tintColor = MAINTHEME_EDIT_NBGColor;
//
//        }
        
        if (iphone) {
            if (self.isGridView) {
                [reuseView.rectangleButton setImage:[UIImage imageNamed:@"bookShelf_rectangle1_btn.png"] forState:UIControlStateNormal];
                [reuseView.listButton setImage:[UIImage imageNamed:@"bookShelf_list2_btn.png"] forState:UIControlStateNormal];
            }else{
                [reuseView.rectangleButton setImage:[UIImage imageNamed:@"bookShelf_rectangle2_btn.png"] forState:UIControlStateNormal];
                [reuseView.listButton setImage:[UIImage imageNamed:@"bookShelf_list1_btn.png"] forState:UIControlStateNormal];
            }
            reuseView.searchKuangimage.image = [UIImage imageNamed:@"bookShelf_searchCase_img.png"];
            reuseView.searchTAgimage.image = [UIImage imageNamed:@"bookShelf_search_img.png"];

        }else{
            if (self.isGridView) {
                [reuseView.rectangleButton setImage:[UIImage imageNamed:@"bookShelf_rectangle1_btn_ipad.png"] forState:UIControlStateNormal];
                [reuseView.listButton setImage:[UIImage imageNamed:@"bookShelf_list2_btn_ipad.png"] forState:UIControlStateNormal];
            }else{
                [reuseView.rectangleButton setImage:[UIImage imageNamed:@"bookShelf_rectangle2_btn_ipad.png"] forState:UIControlStateNormal];
                [reuseView.listButton setImage:[UIImage imageNamed:@"bookShelf_list1_btn_ipad.png"] forState:UIControlStateNormal];
            }
            reuseView.searchKuangimage.image = [UIImage imageNamed:@"bookShelf_searchCase_img_ipad.png"];
            reuseView.searchTAgimage.image = [UIImage imageNamed:@"bookShelf_search_img_ipad.png"];
        }
        self.headerView = reuseView;
        return reuseView;
    }else{
        return nil;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (iphone) {
        return CGSizeMake(MainScreenWidth, 43);
    }else{
        return CGSizeMake(MainScreenWidth, 60);
    }
}

- (void)showShadowViewWithBool:(BOOL)isShow{
    if (!self.shadowView) {
        self.shadowView = [[[NSBundle mainBundle]loadNibNamed: isPad ? @"ShadowView_ipad" : @"ShadowView_ipad" owner:self options:nil] objectAtIndex:0];
    }
    
    if (isShow) {
        self.shadowView.alpha = 0;
        self.shadowView.frame = self.view.bounds;
        [self.view addSubview:self.shadowView];
        [UIView animateWithDuration:0.4 animations:^{
            self.shadowView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.shadowView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.shadowView removeFromSuperview];
                self.shadowView = nil;
            }
        }];
    }
}

/**
 控制alertview
 */
- (void)controlDeleteAlertSheetViewWithBool:(BOOL)isShow{
    static BOOL readyShow;
    
    CGRect startFrame = CGRectMake(0, ScreenHeight+self.deleteAlertSheetView.frame.size.height, ScreenWidth, self.deleteAlertSheetView.size.height);
    if (!self.deleteAlertSheetView) {
        self.deleteAlertSheetView = [[[NSBundle mainBundle] loadNibNamed:@"CustomSheetView" owner:self options:nil] objectAtIndex:0];
        startFrame = CGRectMake(0, ScreenHeight+self.deleteAlertSheetView.frame.size.height, self.deleteAlertSheetView.size.width, self.deleteAlertSheetView.size.height);
        self.deleteAlertSheetView.frame = startFrame;
        self.deleteAlertSheetView.delegate = self;
        
        [self.view addSubview:self.deleteAlertSheetView];
    }
    if(!isShow){
        [self showShadowViewWithBool:NO];
    }
    if (readyShow && isShow) {
        return;
    }else{
       
        CGRect showFrame = CGRectMake(0, ScreenHeight-self.deleteAlertSheetView.frame.size.height, self.deleteAlertSheetView.size.width, self.deleteAlertSheetView.size.height);
        
        CGRect lastFrame = isShow ? showFrame : startFrame;
        readyShow = (lastFrame.origin.y == showFrame.origin.y) ? YES : NO;
        __weak ShelfViewController *weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.deleteAlertSheetView.frame = lastFrame;
            [weakSelf.view bringSubviewToFront:weakSelf.deleteAlertSheetView];
        }];
    }
}

- (void)configureFolderView{
    if (!self.folderHeaderView) {
        self.folderHeaderView = [[[NSBundle mainBundle] loadNibNamed: isPad ? @"FolderHeaderView_ipad" : @"FolderHeaderView"
                                                               owner:self options:nil] objectAtIndex:0];
        CGFloat offsetFloat = isPad ? 344 : 210;
        if (self.isEdit) {
            offsetFloat = isPad ? 344 : (210-50);
        }
        self.folderHeaderView.frame = CGRectMake(0, 0, ScreenWidth, offsetFloat);
        self.folderHeaderView.alpha = 0;
        self.folderHeaderView.folderNameIV.image = [UIImage imageNamed:(iphone)?@"bookShelf_folder_search.png":@"bookShelf_folder_search_ipad.png"];
//        [self.folderHeaderView.folderNameIV loadImage:(iphone)?@"bookShelf_folder_search.png":@"bookShelf_folder_search_ipad.png"];
        __weak ShelfViewController *weakSelf = self;
        self.folderHeaderView.block = ^(id sender) {
            [[JWFolders folder] closeCurrentFolder];
            [weakSelf hideFolderHeaderView];
        };
    }
    
    if (isSunTheme) {
        self.folderHeaderView.bgImageView.alpha = 1.0;
        self.folderHeaderView.bgImageView.backgroundColor = RGBCOLOR(160, 160, 160, 1.0);
        self.folderHeaderView.backgroundColor = RGBCOLOR(160, 160, 160, 1.0);

        self.folderHeaderView.cancelButton.alpha = 1.0;
    }else{
        self.folderHeaderView.bgImageView.alpha = 0.4;
        self.folderHeaderView.bgImageView.backgroundColor = RGBCOLOR(150, 150, 150, 1.0);
        self.folderHeaderView.backgroundColor = RGBCOLOR(150, 150, 150, 1.0);

        self.folderHeaderView.cancelButton.alpha = 0.5;
    }

}

- (void)showFolderView{
    [self configureFolderView];
    
    [self.view addSubview:self.folderHeaderView];
    [UIView animateWithDuration:0.4 animations:^{
        self.folderHeaderView.alpha = 1.0;
    }];
}

- (void)hideFolderHeaderView{
    [UIView animateWithDuration:0.4 animations:^{
        self.folderHeaderView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.folderHeaderView removeFromSuperview];
    }];
}


- (NSIndexPath *)getIndexPathWithPoint:(CGPoint)point{
    CGPoint targetPoint;
    CGFloat rightbianjie ;
    CGFloat pianyiliang ;
    
    if (isPad){
        rightbianjie = 718.0f;
        pianyiliang = 66.0f;
    }else{
        rightbianjie = 300;
        pianyiliang = 29;
    }
    
    if (point.x < rightbianjie){
        targetPoint = CGPointMake(point.x + pianyiliang, point.y);
    }else{
        targetPoint = CGPointMake(point.x - pianyiliang, point.y);
    }
        //  计算此点相邻的indexPath
    NSIndexPath *targetIndexpath = [self.collectionView
                                    indexPathForItemAtPoint:targetPoint];
    return targetIndexpath;
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:NO];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowOpacity = 0.1;
    
    return snapshot;
}

/**
 刷新书架数据
 */
- (void)reloadShelfData{
    [self readFileArray];
    [self.collectionView reloadData];
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        if ([_searchArr count]>0) {
            return _searchArr[indexPath.item];
        }
    }
    return _collectionSortArray[indexPath.item];
}

/**
 *  是否首次使用
 *
 *  @return yes or no
 */
- (BOOL)isFirstLaunch{
//还未登录过
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]){
            //设置第二次使用的value值为yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            //设置第一次使用的value值为yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        return NO;
    }
}

#pragma mark UITableViewDataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell" forIndexPath:indexPath];
    if (!cell) {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIImageView *cellimageiew = [[UIImageView alloc] initWithFrame:cell.bounds];
    [cell.contentView addSubview:cellimageiew];
    NSString *nameString =  (indexPath.row == self.menuselectIndexPath.row) ? [self cellSelectedImageNameWith:indexPath.row]:[self cellImageNameWith:indexPath.row];
    cellimageiew.image = [UIImage imageNamed:nameString];
    
    return cell;
}

- (NSString *)cellImageNameWith:(NSInteger)tag{
    static NSDictionary *mapping = nil;
    
    if(!mapping) {
        if (isPad) {
            mapping = @{
                        @(0) : @"zhengli1_btn_ipad.png",
                        @(1) : @"wifi1_btn_ipad.png",
                        @(2) : @"fengmian1_btn_ipad.png",
                        @(3) : @"list1_btn_ipad.png",
                        };
        }else{
            mapping = @{
                        @(0) : @"shelf_edit_nromal@2x.png",
                        @(1) : @"shelf_wifi_nromal@2x.png",
                        @(2) : @"shelf_pace_normal@2x.png",
                        @(3) : @"shelf_list_normal@2x.png",
                        };
        }
    }
    
    return mapping[@(tag)] ?: @"";
}

- (NSString *)cellSelectedImageNameWith:(NSInteger)tag{
    static NSDictionary *mapping = nil;
    
    if(!mapping) {
        if (isPad) {
            mapping = @{
                        @(0) : @"zhengli2_btn_ipad.png",
                        @(1) : @"wifi2_btn_ipad.png",
                        @(2) : @"fengmian2_btn_ipad.png",
                        @(3) : @"list2_btn_ipad.png",
                        };
        } else {
            mapping = @{
                        @(0) : @"shelf_edit_select@2x.png",
                        @(1) : @"shelf_wifi_select@2x.png",
                        @(2) : @"shelf_pace_select@2x.png",
                        @(3) : @"shelf_list_select@2x.png",
                        };
        }
    }
    
    return mapping[@(tag)] ?: @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isPad ? 44 : 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imagevieww =   cell.contentView.subviews[0];
    NSString *imageNameString = [self cellSelectedImageNameWith:indexPath.row];
    [imagevieww setImage:[UIImage imageNamed:imageNameString]];

    
    if ([self.menuselectIndexPath isEqual:indexPath]) {
        return;
    }
    self.menuselectIndexPath = indexPath;
    
    
//    如果是0 整理书籍
//    如果是1打开Wi-Fi传书
//    如果是2封面模式
//    如果是3列表模式
    [self editBookShelfWithIndex:indexPath.item];
    
}

#pragma mark 密码锁Delegate

/**
 *  密码的长度
 */
- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController{
    return 4;
}

/**
 *  检测密码
 */
- (BOOL)pinViewController:(THPinViewController *)pinViewController
               isPinValid:(NSString *)pin{
    if ([pin isEqualToString:[[self dataAtIndexPath:self.folderIndexPath]objectForKey:@"password"]]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

//重新尝试输入
- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController{
    return (self.remainingPinEntries > 0);
}

//验证成功后退出验证界面然后打开文件夹
- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController{
    self.remainingPinEntries = 4;
    if (!self.isGridView) {
        HBookShelfInfoVC *bookInfo = [[HBookShelfInfoVC alloc]initWithNibName:(iphone)?@"HBookShelfInfoVC":@"HBookShelfInfoVC_ipad" bundle:nil];
        bookInfo.folderDic = [self dataAtIndexPath:self.folderIndexPath];
        [self.navigationController pushViewController:bookInfo animated:YES];

    } else {
        [self controlFolderWithIndexPath:self.folderIndexPath];
    }
}

#pragma mark FolderViewControllerDelegate

- (void)tarnsFolderDeleteBookSWithArray:(NSMutableArray *)aarray{
    NSArray *tempArray = [aarray mutableCopy];
    if(!self.deleteBooksDictionary){
        self.deleteBooksDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    [self.deleteBooksDictionary setObject:tempArray forKey:@(self.folderIndexPath.item)];
    
    if (tempArray.count == 0) {
        [self.deleteBooksDictionary removeObjectForKey:@(self.folderIndexPath.item)];
    }
}

//文件夹内选择阅读
- (void)didselectBookToRead:(id)data{
    [self readbookWithData:data];
}

//文件夹内移出的书
- (void)didDragBookWithData:(id)data{
    self.bookFromFolder = [data mutableCopy];
}

/**
 *  collecitonview刷新数据
 */
- (void)reloadyourViewba{
    [self.collectionView reloadData];
}

/**
 *  获取新的密码并修改保存
 */
- (void)transWithNewpassword:(NSString *)newPassword{
    _collectionSortArray[self.folderIndexPath.item][@"password"] = newPassword;
    [self writeFileArray];
}

/**
 *  获取新的文件夹名字并修改保存
 */
- (void)transWithNewFolderName:(NSString *)newFoldername{
    _collectionSortArray[self.folderIndexPath.item][@"folderName"] = newFoldername;
    [self writeFileArray];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isSearch = YES;
    [self enableAllBtnWithBool:NO];
    [self.headerView showSearchBtnMethod:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSArray *arrray = [NSArray arrayWithArray:[BooksDataHandle transferAllBookArr]];
    [_searchArr removeAllObjects];
    NSMutableArray *myArr1 = [_searchArr copy];
    for (id book in arrray) {
        __block  BOOL ishave = NO;
        [myArr1 enumerateObjectsUsingBlock:
         ^(id obj, NSUInteger idx, BOOL *stop) {
             if ([obj[@"title"] isEqualToString:book[@"title"]]) {
                 ishave = YES;
                 *stop = YES;
             };
         }];
        
        NSRange myRange = [book[@"title"] rangeOfString:textField.text];
        if (myRange.length != 0) {
            if (ishave == NO) {
                [_searchArr addObject:book];
            }
        }
    }
    [_collectionView reloadData];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self enableAllBtnWithBool:YES];
}

#pragma mark CustomSheetViewDelegate底部AlertView的Delegate

- (void)sheetView:(CustomSheetView *)view pressedButtonWithIndex:(NSInteger)index{
    NSInteger indexx = index;
    if (indexx == 0) {
        [self readyDeleteBooks:nil];
        [self controlDeleteAlertSheetViewWithBool:NO];
    } else{
        [self.deleteBooksDictionary removeAllObjects];
        [self.collectionView reloadData];
        [self controlDeleteAlertSheetViewWithBool:NO];
    }
}

/**
 退出阅读页面
 */
- (void)reloadReadingBook:(NSNotification *)notification{
    [self controlLatestReadingView];
}


- (IBAction)changetheme:(id)sender{

}

-(NSMutableArray*)getAllBookAction{
    NSMutableArray *bookArr = [NSMutableArray arrayWithArray:[BooksDataHandle transferAllBookArr]];
    return bookArr;
}

#pragma mark - collecHeadAction

- (void)transBetweenListAndGr1id:(id)sender{
    if (self.isGridView) {
        self.collectionView.collectionViewLayout = self.layoutList;
        self.isGridView = NO;
        [self useGestureOrNot:NO];
        self.edit_compileBtn.hidden = YES;
        self.edit_deleteBtn.hidden = YES;
    }else{
        self.collectionView.collectionViewLayout = self.layoutGrid;
        self.isGridView = YES;
        [self useGestureOrNot:YES];
        self.edit_compileBtn.hidden = NO;
        self.edit_deleteBtn.hidden = YES;
    }
    [self.collectionView setScrollsToTop:YES];
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)searchCancelAction{
    [self.headerView showSearchBtnMethod:NO];
    self.isSearch = NO;
    [_searchArr removeAllObjects];
    [self.headerView.searchTextF resignFirstResponder];
    [self.collectionView reloadData];
    
}

#pragma mark -下载完成时候刷新书架

- (void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification {

    [self writeFileArray];
    [self setupData];
    [self reloadShelfData];

}


@end
