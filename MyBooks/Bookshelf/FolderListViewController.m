//
//  FolderListViewController.m
//  OneWord
//
//  Created by wukai on 14-9-15.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import "FolderListViewController.h"
#import "WIKIDataSource.h"
#import "CommonCell.h"
#import "CommonCell+ConfigureCommonCellData.h"
#import "CommonCollectionCell.h"
#import "CommonCollectionCell+ConfigureCommonCollectionCellData.h"
#import "BooksDataHandle.h"
#import "THPinViewController.h"

@interface FolderListViewController () <UITableViewDelegate, UICollectionViewDelegate,THPinViewControllerDelegate>
@property (nonatomic, strong) WIKIDataSource *tableViewDataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation FolderListViewController

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
    [super viewDidLoad];
    if (self.folderDataDict) {
        self.dataArray = self.folderDataDict[@"booksArray"];
        self.folderName.text = self.folderDataDict[@"folderName"];
    }
    if (isPad) {
        [self setupCollectionView];
    } else {
        [self setUpTableView];
    }
    
    self.bgImageView.image = [UIImage imageNamed:isPad ? @"bg_bookshelf_img_ipad.png" : @"bg_bookshelf_img@2x.png"];
    self.bgTopImageView.image = [UIImage imageNamed:isPad ? @"top_img_ipad.png" : @"top_bookshelf_img@2x.png"];
    [self.backButton setImage:[UIImage imageNamed:isPad ? @"back_btn_ipad.png" : @"back_btn@2x.png"] forState:UIControlStateNormal];
    self.folderName.text = @"kNavigationbarTitleLabel";
    self.middleLineView.image = [UIImage imageNamed:@"line2_lise_img_ipad.png"];
//    [self.bgImageView loadImage: isPad ? @"bg_bookshelf_img_ipad.png" : @"bg_bookshelf_img@2x.png"];
//    [self.bgTopImageView loadImage: isPad ? @"top_img_ipad.png" : @"top_bookshelf_img@2x.png"];
//    [self.backButton loadImage:isPad ? @"back_btn_ipad.png" : @"back_btn@2x.png"];
//    [self.folderName loadLabel:@"kNavigationbarTitleLabel"];
//    [self.middleLineView loadImage:@"line2_lise_img_ipad.png"];
    
    if ([self.folderDataDict[@"password"] isEqualToString:@""])
    {
        self.lockImageView.image = [UIImage imageNamed:@"list_unlock_iphone@2x.png"];
//        [self.lockImageView loadImage:@"list_unlock_iphone@2x.png"];
    } else {
        self.lockImageView.image = [UIImage imageNamed:@"list_lock_iphone@2x.png"];

//        [self.lockImageView loadImage:@"list_lock_iphone@2x.png"];
    }

    NSString *passwordLength = self.folderDataDict[@"password"];
    NSString *buttontitle = passwordLength.length ? @"取消密码" : @"添加密码";
    
    [self.passwdButton setTitle:buttontitle forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *themename = [[NSUserDefaults standardUserDefaults] objectForKey:KThemeName];
//    if ([themename isEqualToString:@"theme3"])
//    {
//        [self.passwdButton setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
//    }  else  if ([themename isEqualToString:@"theme2"]){
//        [self.passwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    } else {
//        [self.passwdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
}

- (IBAction)configurePassword:(id)sender
{
    //    添加密码
    if ([self.passwdButton.titleLabel.text isEqualToString:@"取消密码"]) {
        [self deletePassword];
        [self.lockImageView setImage:[UIImage imageNamed:@"list_unlock_iphone@2x.png"]];
        [self.passwdButton setTitle:@"添加密码" forState:UIControlStateNormal];
    } else {
        [self addPassword];
//        [self.lockImageView setImage:[UIImage imageNamed:@"list_lock_iphone@2x.png"]];
    }
}


- (void)addPassword
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



- (void)deletePassword
{
    [self.delegate transWithNewpassword:@""];
    

}

- (void)setupCollectionView{
    CellConfigureBlock cellConfigureBlock = ^(CommonCollectionCell *cell, id aData, NSIndexPath *index) {
        [cell configureCellWithDataInPadListModel:aData];
    };
    
   UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
//    collectionLayout.itemSize = CGSizeMake(384, 159);
    collectionLayout.minimumLineSpacing = 0;
    collectionLayout.minimumInteritemSpacing = 0;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.collectionView registerNib:[CommonCollectionCell nibWithFolderListModel] forCellWithReuseIdentifier:@"CommonCollectionLandCell"];
    
    self.tableViewDataSource = [[WIKIDataSource alloc] initWithItems:self.dataArray cellIdentifier:@"CommonCollectionLandCell" configureCellBlock:cellConfigureBlock];
    self.collectionView.dataSource = self.tableViewDataSource;
    self.collectionView.delegate = self;
    self.collectionView.collectionViewLayout = collectionLayout;
//    self.collectionView.backgroundColor = [UIColor grayColor];
}

- (void)setUpTableView
{
    CellConfigureBlock cellConfigureblock = ^(CommonCell *cell, id data, NSIndexPath *index){
        [cell configureCellInFolderWithData:data];
    };
    
    [self.tableView registerNib:[CommonCell nibWithFolder] forCellReuseIdentifier:@"CommonCell"];
    
    self.tableViewDataSource = [[WIKIDataSource alloc] initWithItems:self.dataArray cellIdentifier:@"CommonCell" configureCellBlock:cellConfigureblock];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.delegate = self;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [BooksDataHandle willReadingBookMethod:self.dataArray[indexPath.row]];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [BooksDataHandle willReadingBookMethod:self.dataArray[indexPath.item]];
}

//密码设置delegate
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
//    [self.delegate reloadyourViewba];
    self.lockImageView.image = [UIImage imageNamed:@"list_lock_iphone@2x.png"];
//    [self.lockImageView loadImage:@"list_lock_iphone@2x.png"];
    [self.passwdButton setTitle:@"取消密码" forState:UIControlStateNormal];
    
}

- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    self.lockImageView.image = [UIImage imageNamed:@"list_unlock_iphone@2x.png"];

//    [self.lockImageView loadImage:@"list_unlock_iphone@2x.png"];
}



- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
