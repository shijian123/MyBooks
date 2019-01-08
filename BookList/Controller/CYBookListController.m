//
//  CYBookListController.m
//  MyBooks
//
//  Created by zcy on 2018/5/9.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "CYBookListController.h"
#import "CYBookListCell.h"
#import "EBookLocalStore.h"
#import "epubtextdataengine.h"
#import "SmalleEbookWindow.h"
#import "EBookLocalStore.h"
#import "HBookInfoVC.h"

//每次请求的个数
#define BookLimit 10

@interface CYBookListController ()<UITableViewDelegate, UITableViewDataSource>{
}

@property (nonatomic) NSInteger num;
@property (nonatomic, strong) NSMutableArray *bookListArr;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *myTableV;

@end

@implementation CYBookListController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLab.text = @"精选";
    self.titleLab.origin = CGPointMake((MainScreenWidth - self.titleLab.width)/2, self.titleLab.origin.y);

    self.myTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    self.myTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
    [self.myTableV.mj_header beginRefreshing];
}

#pragma mark - touch event

- (IBAction)gotoBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYBookListCell *cell = [CYBookListCell cellWithTaleView:tableView];
    cell.model = self.bookListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobObject *bookObj = self.bookListArr[indexPath.row];

    HBookInfoVC *bookInfo = [[HBookInfoVC alloc]initWithNibName:(iphone)?@"HBookInfoVC":@"HBookInfoVC_ipad" bundle:nil];
    bookInfo.bookObj = bookObj;
    [self.navigationController pushViewController:bookInfo animated:YES];
    
}

/**
 下拉刷新
 */
- (void)refreshHeaderAction{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.num = 0;
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"BookInfo"];
    bquery.limit = BookLimit;
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [hub hide:YES afterDelay:0.3];
        [self.myTableV.mj_header endRefreshing];
        [self.myTableV.mj_footer endRefreshing];
        if (error) {
            [MBProgressHUD showError:@"网络请求失败，请稍后再试"];
        }else{
            self.num++;
           self.bookListArr = [NSMutableArray arrayWithArray:array];
            [self.myTableV reloadData];
        }
    }];
}

/**
 上拉请求更多
 */
- (void)refreshFooterAction{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"BookInfo"];
    bquery.skip = BookLimit*self.num;
    bquery.limit = BookLimit;
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [hub hide:YES afterDelay:0.3];
        if (error) {
            [MBProgressHUD showError:@"网络请求失败，请稍后再试"];
        }else{
            self.num++;
            if (array.count < BookLimit) {//没有更多数据
                [self.myTableV.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.myTableV.mj_footer resetNoMoreData];
            }
            [self.bookListArr addObjectsFromArray:array];
            [self.myTableV reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
