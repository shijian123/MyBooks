//
//  HBookInfoVC.m
//  History
//
//  Created by 朝阳 on 14-6-13.
//  Copyright (c) 2014年 Work. All rights reserved.
//

//@TODO mutilogo 高清图

#import "HBookInfoVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BooksDataHandle.h"
#import "SmalleEbookWindow.h"
#import "XMLDownLoad.h"
#import "NSString+HTML.h"
#import "HBaseFunction.h"
#import "NSString+CY.h"

#define bookInfoCentLabW ScreenWidth-40

@interface HBookInfoVC ()<UIScrollViewDelegate,UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int _lastPosition;              //记录拖动的位置
    CGSize  size1;                  //获得书籍简介的size
    NSString *bID;
}

@property (retain, nonatomic) IBOutlet UIView *navMainView;
@property (retain, nonatomic) IBOutlet UIView *bookInfoTopView;
@property (retain, nonatomic) IBOutlet UIImageView *bookInfoTopLine;
@property (retain, nonatomic) IBOutlet UIImageView *bookInfoBotLine;
@property (weak, nonatomic) IBOutlet UIImageView *bookIV;
@property (retain, nonatomic) IBOutlet UIImageView *bookOutIV;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UIButton *bookDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookReadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *bookProgressV;
//修改后
@property (retain, nonatomic) IBOutlet UIScrollView *bookInfoMainScr;
@property (retain, nonatomic) IBOutlet UIView *bookInfoRecommendView;
@property (retain, nonatomic) IBOutlet UILabel *bookInfoRecCentLab;
@property (retain, nonatomic) IBOutlet UITextView *bookInfoRecCentTV;

/** 书籍详情*/
@property (nonatomic, strong) NSDictionary *bookInfo;
/** viewNum 为1时，推荐上部的书籍 为2时，书架上面的书籍*/
@property (nonatomic) NSInteger viewNum;
/** 推荐上部的书的Custom；*/
@property (nonatomic, strong) NSString *bookInfoCustom;
/** imageStyle为1时：为1号书城数据，为2时为2号书城数据 为3时为3号书城*/
@property (nonatomic) NSInteger imageStyley;
/** goBackStyley  为0时为pop,为1时为dis*/
@property (nonatomic)NSInteger goBackStyley;

@property (retain, nonatomic) IBOutlet UIButton *bookInfoMoreBtn;
@property (retain, nonatomic) IBOutlet UIImageView *navMainImage;
@property (retain, nonatomic) IBOutlet UIButton *navMainLeftBtn;
@property (retain, nonatomic) IBOutlet UIButton *navMainRightBtn;
@property (retain, nonatomic) IBOutlet UILabel *navMainTopTitle;
@property (retain, nonatomic) IBOutlet UIImageView *mainBtoTitleImage;

@end

@implementation HBookInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
#warning 测试
//    bID = @"50901";
    
//    [self requestServerGetBookById:bID];
    
//    NSDictionary *dic = @{@"url":[self.bookObj objectForKey:@"bookUrl"],@"bookStyle":@"3",@"name":[self.bookObj objectForKey:@"title"],@"imgUrl":[self.bookObj objectForKey:@"imgUrl"],@"title":[self.bookObj objectForKey:@"title"],@"source":[self.bookObj objectForKey:@"bookUrl"]};
//
    NSDictionary *dic = @{@"url":@"http://allbooks.oss.aliyuncs.com/bookstore2/upload/book/book/2018/7/23/1532345665175.zip",@"bookStyle":@"1",@"name":@"乐蜀",@"imgUrl":@"http://allbooks.oss.aliyuncs.com/bookstore2/upload/book/images/2018/7/23/1532345665106.jpeg",@"title":@"七零吃货军嫂",@"source":@"http://allbooks.oss.aliyuncs.com/bookstore2/upload/book/book/2018/7/23/1532345665175.zip"};
    
    self.bookInfo = dic;
    
    if (isPad) {
        self.bookInfoMainScr.contentSize = CGSizeMake(ScreenWidth, 940);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStoreProgressUpdateFunction:) name:EBookLocalStoreProgressUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EBookLocalStorRequestError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestErrorFunction:) name:EBookLocalStorRequestError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRepeatDownFunction:) name:EBookLocalStorRepeatDown object:nil];
    
    //判断是否已经下载
    int isDownload = [[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:self.bookInfo];
    if (isDownload == 1) {
        self.bookDownBtn.hidden = YES;
        self.bookReadBtn.hidden = NO;
    }else{
        self.bookDownBtn.hidden = NO;
        self.bookReadBtn.hidden = YES;
    }
    
    [self makeBookInfoData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)makeBookInfoData{
    
    NSString *imageUrl = [self.bookObj objectForKey:@"imgUrl"];
    [self.bookIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"bookInfo_bookOut1_img@2x.png"]];
    NSString *contentStr = [self.bookObj objectForKey:@"intro"];
    self.bookTitle.text = [self.bookObj objectForKey:@"title"];
    self.bookAuthor.text = [NSString stringWithFormat:@"作者：%@",[self.bookObj objectForKey:@"author"]];
    
    NSString *sumStr = [[contentStr stringByConvertingHTMLToPlainText] stringByReplacingOccurrencesOfString:@" " withString:@"\r\n    "];
    
    NSString *summaryStr = [NSString stringWithFormat:@"    %@",sumStr];
    
    if (iphone) {
        self.bookInfoRecCentLab.text = summaryStr;
        self.bookInfoRecCentLab.font = 0;
        
       size1 = [summaryStr boundingRectWithSize:CGSizeMake(bookInfoCentLabW, 900) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f ]} context:nil].size;
//        size1 = [summaryStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(bookInfoCentLabW, 900)];
        self.bookInfoRecCentLab.font = [UIFont systemFontOfSize:15];
        if (size1.height >=130) {
            
            self.bookInfoMoreBtn.hidden = NO;
            self.bookInfoRecCentLab.size = CGSizeMake(bookInfoCentLabW, 130);
            
        }else{
            self.bookInfoMoreBtn.hidden = YES;
            self.bookInfoRecCentLab.size = CGSizeMake(bookInfoCentLabW, size1.height);
            
        }
        
        self.bookTitle.font = [UIFont fontWithName:@"FZLTHK--GBK1-0" size:17];
        self.bookAuthor.font = [UIFont fontWithName:@"FZLTHK--GBK1-0" size:15];
        //主视图的位置设置
        if (isSunTheme) {
            self.bookInfoRecCentLab.textColor = MAINTHEME_SUN_BookAuthor;
            
        }else{
            self.bookInfoRecCentLab.textColor = MAINTHEME_MOON_BookAuthor;
        }
        [self makeBookInfoMainViewAction];
    }else{
        self.bookInfoRecCentTV.text = summaryStr;
        self.bookInfoRecCentTV.font = [UIFont systemFontOfSize:16];

        if (isSunTheme) {
            self.bookInfoRecCentTV.textColor = MAINTHEME_SUN_BookAuthor;

        }else{
            self.bookInfoRecCentTV.textColor = MAINTHEME_MOON_BookAuthor;
        }
    }
}

/**
 下载书籍
 */
- (IBAction)downloadBookAction:(id)sender {
//    [self requestServerGetBookHash:bID];
    [EBookLocalStore AddNewBookToDownload:self.bookInfo];
}

- (IBAction)startReadBookAction:(id)sender {
    
    [BooksDataHandle willReadingBookMethod:self.bookInfo];

}

- (void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification{
    NSDictionary *bookInf=[notification userInfo];
    if ([[bookInf objectForKey:@"title"]isEqualToString:[self.bookInfo objectForKey:@"title"]]) {
        self.bookProgressV.hidden=NO;
        [self.bookProgressV setProgress:[[bookInf objectForKey:@"percent"] floatValue]];
        self.bookDownBtn.enabled = NO;
    }
}

- (void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification{
    NSDictionary *bookInf=[notification userInfo];
        if ([[bookInf objectForKey:@"title"]isEqualToString:[self.bookInfo objectForKey:@"title"]]) {
        self.bookReadBtn.hidden = NO;
        self.bookDownBtn.hidden = YES;
        self.bookProgressV.hidden=YES;
        self.bookDownBtn.enabled = YES;
        [self.bookProgressV setProgress:[[bookInf objectForKey:@"percent"] floatValue]];
    }
}

- (void)EBookLocalStorRepeatDownFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"重复下载《%@》",[bookInfor objectForKey:@"title"]]  message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertContr addAction:action1];
    [self presentViewController:alertContr animated:YES completion:nil];

}

- (void)EBookLocalStorRequestErrorFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
    
    if ([[bookInfor objectForKey:@"id"] isEqualToString:[self.bookInfo objectForKey:@"id"]]){
        self.bookDownBtn.hidden = NO;
        self.bookReadBtn.hidden = YES;
        self.bookDownBtn.enabled = YES;

        [MBProgressHUD showError:@"网络不太给力，请稍后再试或者查看网络"];

    }
}
 
#pragma mark -导航栏左右按钮的action

- (IBAction)gotoBAckAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
 
- (IBAction)gotoBookShelfAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark -动态显示tabbar
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 15) {
//        if (currentPostion > 0) {
//            _lastPosition = currentPostion;
//        }
//        [UIView animateWithDuration:0.5 animations:^{
//            if (iphone) {
//                self.tabBarMainView.frame = CGRectMake(0, ScreenHeight+48, 320, 48);
//            }else
//            {
//                self.tabBarMainView.frame = CGRectMake(0, ScreenHeight+50, 768, 50);
//            }
//        }];
//    }
//    else if(_lastPosition - currentPostion > 45){
//        if (currentPostion > 0) {
//            _lastPosition = currentPostion;
//        }
//
//        [UIView animateWithDuration:0.5 animations:^{
//            if (iphone) {
//                self.tabBarMainView.frame = CGRectMake(0, ScreenHeight-48, 320, 48);
//            }else
//            {
//                self.tabBarMainView.frame = CGRectMake(0, ScreenHeight-50, 768, 50);
//            }
//        }];
//
//    }
    
}

- (IBAction)getMoreTitleAction:(id)sender {
    
    //已经展开
    if (self.bookInfoRecCentLab.frame.size.height>130) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bookInfoRecCentLab.size = CGSizeMake(bookInfoCentLabW, 130);
            [self.bookInfoMoreBtn setImage:[UIImage imageNamed:@"bookInfo_xiala_img.png"] forState:UIControlStateNormal];
            [self makeBookInfoMainViewAction];
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.bookInfoRecCentLab.size = CGSizeMake(bookInfoCentLabW, self->size1.height);
            [self.bookInfoMoreBtn setImage:[UIImage imageNamed:@"bookInfo_shouqi_img.png"] forState:UIControlStateNormal];
            [self makeBookInfoMainViewAction];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark -主视图的位置设置
-(void)makeBookInfoMainViewAction{
    if (iphone) {
        self.navMainView.frame = CGRectMake(0, 20, ScreenWidth, 44);
        self.navMainImage.frame = CGRectMake(0, 0, ScreenWidth, 64);
        self.navMainTopTitle.frame = CGRectMake(0, 11, ScreenWidth, 21);
        self.bookInfoMainScr.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        self.bookInfoMoreBtn.frame = CGRectMake(ScreenWidth-50, 60, 30, 30);
        
        self.bookInfoTopView.frame = CGRectMake(0, 1, ScreenWidth, 160);
        
        self.bookInfoTopLine.frame = CGRectMake(8, 23, ScreenWidth-16, 1);
        self.bookInfoRecommendView.frame = CGRectMake(0, 165, ScreenWidth, 160);
        
        self.bookInfoRecCentLab.frame = CGRectMake(25, self.bookInfoRecCentLab.frame.origin.y,bookInfoCentLabW, self.bookInfoRecCentLab.frame.size.height);
        
        self.bookInfoMoreBtn.frame = CGRectMake(self.bookInfoMoreBtn.frame.origin.x, self.bookInfoRecCentLab.frame.origin.y+self.bookInfoRecCentLab.frame.size.height+10, self.bookInfoMoreBtn.frame.size.width, self.bookInfoMoreBtn.frame.size.height);
    
        self.bookInfoMainScr.size = CGSizeMake(ScreenWidth, ScreenHeight - self.navMainImage.frame.size.height);
        
        self.bookInfoMainScr.contentSize = CGSizeMake(ScreenWidth, self.bookInfoRecommendView.frame.origin.y+self.bookInfoRecommendView.frame.size.height);
  
    }
    
}

#pragma mark - requestServer

- (void)requestServerGetBookById:(NSString *)bookID{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"token"] = [DKDAccountTool token];
    param[@"bid"] = bookID;
    param[@"userId"] = @"";
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CYHttpTool get:[NSString stringWithFormat:@"%@getBookById",CYBASEURL] params:param success:^(id json) {
        if (![json[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]){
            [hub hide:YES];
            [MBProgressHUD showError:json[@"msg"]];
            return ;
        }
        [hub hide:YES];

    } failure:^(NSError *error) {
        [hub hide:YES afterDelay:0.3];
    }];
}

- (void)requestServerGetBookHash:(NSString *)bookID{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"bid"] = bookID;
    NSArray *arr = [NSArray arrayWithObject:@"bid"];
    NSString *bkid = [NSString stringWithFormat:@"bid=%@",bookID];
    
    NSString *token = @"";
    NSString *url = [NSString stringWithFormat:@"%@/bsis/getBookHash/%@?token=%@&timestamp=%@", @"http://book-apiv2.hotbook.wang", bkid, token, [NSString currentTimeStamp]];
    //获取不同的token
    param[@"token"] = @"eb25ae4715333d325ddc07a11e491bb28ac45861";
    param[@"timestamp"] = [NSString currentTimeStamp];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CYHttpTool get:[NSString stringWithFormat:@"%@getBookHash",CYBASEURL] params:param success:^(id json) {
        if (![json[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]){
            [hub hide:YES];
            [MBProgressHUD showError:json[@"msg"]];
            return ;
        }
        [hub hide:YES];
        //下载书籍
        [EBookLocalStore AddNewBookToDownload:self.bookInfo];
    } failure:^(NSError *error) {
        [hub hide:YES afterDelay:0.3];
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
