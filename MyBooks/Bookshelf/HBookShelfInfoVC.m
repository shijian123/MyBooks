//
//  HBookShelfInfoVC.m
//  History
//
//  Created by 朝阳 on 14-7-8.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import "HBookShelfInfoVC.h"
#import "HRecomBLCollVCell.h"
#import "HRecomBLCollVCell+setupData.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "HBookInfoVC.h"
#import "SmalleEbookWindow.h"
#import "BooksDataHandle.h"
#import "NSString+HTML.h"
//#import "HCollectionDataSource.h"
#import "XMLDownLoad.h"
@interface HBookShelfInfoVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *dataArr;
}

@property (retain, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (retain, nonatomic) IBOutlet UIImageView *bookShelf_Main_botIV;
@property (retain, nonatomic) IBOutlet UIImageView *mainTopImage;
@property (retain, nonatomic) IBOutlet UILabel *mainTopTitle;

@end

@implementation HBookShelfInfoVC

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
    
    //注册单元格
    [self.mainCollectionView registerNib:[UINib nibWithNibName:iphone?@"HRecomBLCollVCell":@"HRecomBLCollVCell_ipad" bundle:nil] forCellWithReuseIdentifier:@"HRecomBLCollVCell"];
    
    self.mainDataArr = [NSMutableArray arrayWithArray:self.folderDic[@"booksArray"]];
    self.navMainTopTitle.text = self.folderDic[@"folderName"];
    //特殊设置更换专题主视图下控件
    [self setThemeControlAction];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    
}

#pragma mark -特殊设置更换专题主视图下控件
-(void)setThemeControlAction
{
    //判断当前专题是否为夜间模式
    if (isSunTheme) {
        self.view.backgroundColor = MAINTHEME_SUN_BGColor;
        self.mainCollectionView.backgroundColor = MAINTHEME_SUN_BGColor;
        self.navMainTopTitle.textColor = MAINTHEME_SUN_BookTitle;

    }else
    {
        self.view.backgroundColor = MAINTHEME_NIGHT_BGColor;
        self.mainCollectionView.backgroundColor = MAINTHEME_NIGHT_BGColor;
        self.navMainTopTitle.textColor = MAINTHEME_MOON_BookTitle;
        
    }
    // 专题重新加载设置
    if (iphone) {
        self.navMainImage.image = [UIImage imageNamed:@"nav_background_img@2x.png"];
        [self.navMainLeftBtn setImage:[UIImage imageNamed:@"base_back_btn@2x.png"] forState:UIControlStateNormal];

//        [self.navMainImage loadImage:@"nav_background_img@2x.png"];
//        [self.navMainLeftBtn loadImage:@"base_back_btn@2x.png"];
//
    }else
    {
        self.navMainImage.image = [UIImage imageNamed:@"nav_background_img_ipad.png"];
        [self.navMainLeftBtn setImage:[UIImage imageNamed:@"base_back_btn_ipad.png"] forState:UIControlStateNormal];

        //        [self.navMainImage loadImage:@"nav_background_img_ipad.png"];
//        [self.navMainLeftBtn loadImage:@"base_back_btn_ipad.png"];
        
    }
    
    
}

#pragma mark CollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRecomBLCollVCell *cell = (HRecomBLCollVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HRecomBLCollVCell" forIndexPath:indexPath];
    cell.hidden = NO;
    NSDictionary *dataDic = [self.mainDataArr objectAtIndex:indexPath.row];
    if ([[dataDic allKeys] containsObject:@"zuoze"]) {
        [cell.recommBookImg setImage:[UIImage imageNamed:[dataDic objectForKey:@"image"]]];
        cell.recBookTitle.text = dataDic[@"title"];
        cell.recBookAuthor.text = dataDic[@"zuoze"];
        cell.recommKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_bookout1_img.png":@"bookShelf_bookout1_img_ipad.png"];
        
    }else{
        [cell configureForCell:dataDic];
        
    }
    
    if (isSunTheme) {
        cell.recommBookImg.alpha = 1.0;
        cell.recBookTitle.textColor = MAINTHEME_SUN_BookTitle;
        cell.recBookAuthor.textColor = MAINTHEME_SUN_BookAuthor;
        cell.recBookContent.textColor = MAINTHEME_SUN_BookAuthor;
        cell.backgroundColor = MAINTHEME_SUN_BGColor;
        
    }else{
        cell.recommBookImg.alpha = 0.5;
        cell.recBookTitle.textColor = MAINTHEME_MOON_BookTitle;
        cell.recBookAuthor.textColor = MAINTHEME_MOON_BookAuthor;
        cell.recBookContent.textColor = MAINTHEME_MOON_BookAuthor;
        //            cell.backgroundColor = RGBCOLOR(22, 22, 22, 1.0);
        cell.backgroundColor = MAINTHEME_NIGHT_BGColor;
        
    }
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [BooksDataHandle willReadingBookMethod:[self.mainDataArr objectAtIndex:indexPath.row]];    
}


- (IBAction)gotoBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
