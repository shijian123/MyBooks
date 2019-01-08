//
//  HBaseController.m
//  History
//
//  Created by 朝阳 on 14-6-12.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import "HBaseController.h"
#import "HBaseFunction.h"
@interface HBaseController ()
@property (nonatomic, retain) UIButton *bs_navLeftBn;
@property (nonatomic, retain) UIButton *bs_navRightBn;

@end

@implementation HBaseController

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
    //设置布局
    if(CST_DEVICE_VER >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 5;
    indicatorView.radius = 8;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  设置导航左按钮的图片及处理方法
 *  @param image 按钮图片
 *  @param navEvent 按钮事件
 **/
- (void) setNavLeftButton:(UIImage *)image sel:(SEL)navEvent
{
    if(_bs_navLeftBn == nil)
        _bs_navLeftBn = nil;
    if(navEvent == NULL)
        navEvent = @selector(backToNavPreView);
    
    self.bs_navLeftBn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bs_navLeftBn setFrame:CGRectMake(0, 5, 44, 44)];
    [_bs_navLeftBn setImage:image forState:UIControlStateNormal];
    [_bs_navLeftBn addTarget:self action:navEvent forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barBn = [[UIBarButtonItem alloc] initWithCustomView:_bs_navLeftBn];
    barBn.width = 40;
    self.navigationItem.leftBarButtonItem = barBn;
}

/**
 *  后退
 **/
- (void) backToNavPreView
{
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  设置导航右按钮的图片及处理方法
 *  @param image 按钮图片
 *  @param navEvent 按钮事件
 **/
- (void) setNavRightButton:(UIImage *)image sel:(SEL)navEvent
{
    float x = 320 - 50;
    if(_bs_navRightBn != nil)
        _bs_navRightBn = nil;
    
    self.bs_navRightBn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bs_navRightBn setFrame:CGRectMake(x, 5, 30, 30)];
    [_bs_navRightBn setImage:image forState:UIControlStateNormal];
    [_bs_navRightBn addTarget:self action:navEvent forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barBn = [[UIBarButtonItem alloc] initWithCustomView:_bs_navRightBn];
    barBn.width = 40;
    self.navigationItem.rightBarButtonItem = barBn;
}

/**
 *  开始网络加载视图
 **/

-(void)startBaseIndiAnimating
{
    [indicatorView startAnimating];
//    self.view.userInteractionEnabled = NO;

}

/**
 *  停止网络加载视图
 **/
-(void)stopBaseIndiAnimating
{
    [indicatorView stopAnimating];
//    self.view.userInteractionEnabled = YES;

}
#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


/**
 *  根据字典获得书籍的尺寸大小
 **/

-(NSString *)getBookInfoSizeWithDic:(NSDictionary *)dic
{

    //书籍的尺寸大小
    if (dic[@"size"] == nil||[dic[@"size"]isEqualToString:@""]) {
        
        return @"";
    }else if ([dic[@"size"] floatValue]<1024) {
        return [NSString stringWithFormat:@"%0.0fB",[dic[@"size"] floatValue]];
    }else if ([dic[@"size"]floatValue]<1024*1024)
    {
        return [NSString stringWithFormat:@"%0.1fKb",[dic[@"size"] floatValue]/1024];
    }else
    {
        return [NSString stringWithFormat:@"%0.1fM",[dic[@"size"] floatValue]/(1024*1024)];
    }

}



-(void)viewDidDisappear:(BOOL)animated
{
    indicatorView.delegate = nil;
    [indicatorView removeFromSuperview];
    indicatorView = nil;

}
-(void)dealloc
{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
