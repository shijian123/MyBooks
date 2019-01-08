//
//  FolderViewController.m
//  BookStore
//
//  Created by Work on 14-7-18.
//  Copyright (c) 2014年 wukai. All rights reserved.
//

#import "FolderViewController.h"
#import "CommonCollectionCell.h"
#import "CommonCollectionCell+ConfigureCommonCollectionCellData.h"
#import "THPinViewController.h"

@interface FolderViewController ()
<UITextFieldDelegate,UICollectionViewDataSource,
UICollectionViewDelegate,THPinViewControllerDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutGrid;
@property (nonatomic, strong) NSString *foldertitleString;
@property (nonatomic, assign, readwrite) BOOL isEditModel;
@end

@implementation FolderViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
//    默认为非编辑模式
    
    [super viewDidLoad];
    [self setupData];
    [self setupCollectionView];
    [self setThemeControlAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPassword:) name:@"changePassword" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePassword:) name:@"cancelPassword" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFolderName:) name:@"NewFolderName" object:nil];
    
//    [self.bgImageView loadImage:isPad ? @"bg_booushelf_img_ipad@2x.png" : @"bg_booushelf_img@2x.png"];
    
    
}

- (void)setThemeControlAction
{
    if (isSunTheme) {
        
        self.view.backgroundColor = MAINTHEME_SUN_BGColor;
    }else
    {
        self.view.backgroundColor = RGBCOLOR(22, 22, 22, 1.0);

//        self.view.backgroundColor = MAINTHEME_NIGHT_BGColor;

    }
}

- (void)folderIsEditWithBool:(BOOL) isedit
{
    self.isEditModel = isedit;
}

- (void)setupData
{
    self.dataArray = self.folderDataDict[@"booksArray"];
    self.foldertitleString = self.folderDataDict[@"folderName"];
}

- (void)setupCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //    网格
    [self.collectionView registerNib:[CommonCollectionCell nib]
          forCellWithReuseIdentifier:@"CommonCollectionCell"];
    self.layoutGrid = [[UICollectionViewFlowLayout alloc]init];
    
    if (isPad) {
        self.layoutGrid.itemSize = CGSizeMake(123, 220);
        self.layoutGrid.headerReferenceSize = CGSizeZero;
        self.layoutGrid.footerReferenceSize = CGSizeZero;
        self.layoutGrid.minimumLineSpacing = 10.0f;
        self.layoutGrid.minimumInteritemSpacing = 58.0f;
        self.layoutGrid.sectionInset = UIEdgeInsetsMake(26, 51, 20, 51);
    } else {
        self.layoutGrid.itemSize = CGSizeMake(83, 146);
        self.layoutGrid.headerReferenceSize = CGSizeZero;
        self.layoutGrid.footerReferenceSize = CGSizeZero;
        self.layoutGrid.minimumLineSpacing = 10.0f;
        self.layoutGrid.minimumInteritemSpacing = 22.0f;
        self.layoutGrid.sectionInset = UIEdgeInsetsMake(13, 13, 20, 13);
    }
    self.collectionView.collectionViewLayout = self.layoutGrid;
}


- (IBAction)addPassword:(id)sender
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"请输入新密码";
    pinViewController.promptColor = [UIColor darkTextColor];
    pinViewController.view.tintColor = [UIColor darkTextColor];
    pinViewController.hideLetters = YES;
    
    // for a solid color background, use this:
    pinViewController.backgroundColor = [UIColor whiteColor];
    
    // for a translucent background, use this:
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    
    [self.view.window.rootViewController
     presentViewController:pinViewController animated:YES completion:nil];
}



- (IBAction)deletePassword:(id)sender
{
    [self.delegate transWithNewpassword:@""];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"passwordchange" object:nil userInfo:nil];
}

#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCollectionCell *cell = (CommonCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CommonCollectionCell"
                                                                           forIndexPath:indexPath];
    [cell configureCellWithData:self.dataArray[indexPath.item]];
    
    if (self.isEditModel) {
        [cell showEditModelImage:YES];
        if ([self.deleteArray  containsObject:@(indexPath.item)]) {
            

            [cell showSelect:YES];
        } else {

            [cell showSelect:NO];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCollectionCell *cell = (CommonCollectionCell *)
    [collectionView cellForItemAtIndexPath:indexPath];
    cell.bookSelectedImage.image = [UIImage imageNamed:(iphone)?@"bookShelf_selected_btn.png":@"bookShelf_selected_btn_ipad.png"];
    
    if (self.isEditModel) {
        if (!self.deleteArray) {
            self.deleteArray = [NSMutableArray arrayWithCapacity:0];
        }
        if (cell.editBook) {

            [cell showSelect:NO];
            [self.deleteArray removeObject:@(indexPath.item)];
        } else {

            [cell showSelect:YES];
            [self.deleteArray addObject:@(indexPath.item)];
        }

        [self.delegate tarnsFolderDeleteBookSWithArray:self.deleteArray];
        
    } else {
        [self.delegate didselectBookToRead:self.dataArray[indexPath.item]];
    }
}

#pragma mark  - longPressGesture
- (void)longPressGestureRecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    //    获取点击位置
    CGPoint location = [longPress locationInView:self.collectionView];
    
    //    点击位置对应的indexpath
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            
            //            touch begin
            if (indexPath) {
                sourceIndexPath = indexPath;
                [self.delegate didDragBookWithData:self.dataArray[indexPath.item]];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            NSIndexPath *targetIndexPath = [self getIndexPathWithPoint:location];
            if (indexPath && ![sourceIndexPath isEqual:indexPath]) {
                [self moveBookFromIndex:sourceIndexPath toIndex:indexPath];
                sourceIndexPath = indexPath;
            } else if(targetIndexPath && ![sourceIndexPath isEqual:targetIndexPath]){
                [self moveBookFromIndex:sourceIndexPath toIndex:targetIndexPath];
                sourceIndexPath = targetIndexPath;
            }
            break;
        }
        default: {
            // Clean up.
            if (sourceIndexPath) {
                CommonCollectionCell *cell = (CommonCollectionCell *)[self.collectionView cellForItemAtIndexPath:sourceIndexPath];
                cell.hidden = NO;
                sourceIndexPath = nil;
            }
            break;
        }
    }

}

- (void)moveBookFromIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex
{
    //        对数据源进行操作
    [self insertBookForIndex:fromIndex toIndex:toIndex];
    //        对视图进行操作
    [self.collectionView moveItemAtIndexPath:fromIndex toIndexPath:toIndex];
}
- (void)insertBookForIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath*)toIndex
{
    id objectToMove = _dataArray[fromIndex.item];
    [self.dataArray removeObjectAtIndex:fromIndex.item];
    [self.dataArray insertObject:objectToMove atIndex:toIndex.item];
}

- (NSIndexPath *)getIndexPathWithPoint:(CGPoint)point
{
    CGPoint targetPoint;
    CGFloat rightbianjie ;
    CGFloat pianyiliang ;
    
    if (isPad)
    {
        rightbianjie = 718.0f;
        pianyiliang = 66.0f;
    } else {
        rightbianjie = 307;
        pianyiliang = 22;
    }
    
    if (point.x < rightbianjie)
    {
        targetPoint = CGPointMake(point.x + pianyiliang, point.y);
    } else {
        targetPoint = CGPointMake(point.x - pianyiliang, point.y);
    }
    //  计算此点相邻的indexPath
    NSIndexPath *targetIndexpath = [self.collectionView
                                    indexPathForItemAtPoint:targetPoint];
    return targetIndexpath;
}



#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn_%@", textField.text);
    
    [self.delegate transWithNewFolderName:[textField.text copy]];
    
    [self.delegate reloadyourViewba];
    
    return YES;
}

- (void)changeFolderName:(NSNotification *)notification
{
    NSString *string = [notification object];
    [self.delegate transWithNewFolderName:string];
    
    [self.delegate reloadyourViewba];
}


- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    [self.delegate transWithNewpassword:[pin copy]];
    return YES;
}


- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    //    只需要输入一次就可以重新设置密码
    return NO;
}

- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController {
    [self.delegate reloadyourViewba];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passwordchange" object:nil userInfo:nil];
}

- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passwordchange" object:nil userInfo:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
