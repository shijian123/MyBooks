//
//  SmalleBasebookViewController.m
//  Smallebook
//
//  Created by lzq on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SmalleBasebookViewController.h"
@interface SmalleBasebookViewController()
- (UIImageView*)TopImageView;
- (UIButton*)GoBackButton;
- (UILabel*)TopTitle;
- (UISegmentedControl*)seg;
@end
@implementation  SmalleBasebookViewController
@synthesize dldHelper,tableView,Rows;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_waitDataActivity==nil) {
        [self.view addSubview:self.WaitDataActivity];
        [self.view sendSubviewToBack:self.WaitDataActivity];
    }
}
- (void)loadView{
    [super loadView];
    if (self.tableView==nil) {
        //create view
        self.view=[[[UIView alloc] initWithFrame: CGRectZero] autorelease];
//        self.view.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
        self.view.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
            // create table
            self.tableView=[[[UITableView alloc ] initWithFrame:self.view.bounds  style: UITableViewStylePlain] autorelease];
             self.tableView.autoresizingMask= UIViewAutoresizingNone;
            self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            self.tableView.backgroundColor=[UIColor clearColor];
        
            self.tableView.delegate=self;
            self.tableView.dataSource=self;
        
            [self.view addSubview: self.tableView];
            [self.view addSubview:self.TopImageView];
            [self.view addSubview:self.TopTitle];
             self.TopTitle.text=self.title;
          self.Rows=[NSMutableArray arrayWithCapacity:0];

    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.WaitDataActivity.center=self.view.center;
    self.WaitDataActivity.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
//    self.WaitDataActivity.frame=CGRectMake((self.view.bounds.size.width-self.WaitDataActivity.frame.size.width)/2.0, (self.view.bounds.size.height-self.WaitDataActivity.frame.size.height)/2.0, self.WaitDataActivity.bounds.size.width, self.WaitDataActivity.bounds.size.height);
}
-(void)ShowwaitDataActivity{
    [self.view bringSubviewToFront:self.WaitDataActivity];
     self.WaitDataActivity.hidden=NO;
    [self.WaitDataActivity startAnimating];
}

-(void)HiddenwaitDataActivity{
self.WaitDataActivity.hidden=YES;
[self.view sendSubviewToBack:self.WaitDataActivity];
[self.WaitDataActivity stopAnimating];
}
- (UIImageView*)TopImageView{
    if (_TopImageView==nil) {
        _TopImageView = [[UIImageView alloc] init];
        
        
        
        
    }
    return _TopImageView;
}










- (UIButton*)GoBackButton{
    if (_GoBackButton==nil) {
        _GoBackButton= [UIButton buttonWithType:UIButtonTypeCustom];
//        _GoBackButton.showsTouchWhenHighlighted = NO;
//        _GoBackButton.frame = CGRectMake(5, 0, 61, 36);
//        [_GoBackButton setBackgroundImage: [UIImage imageNamed:@"EbookManagerImage2.bundle/iPad_v/iPad_v_returnBtn"] forState:UIControlStateNormal];
//        [_GoBackButton setTitleColor:[UIColor colorWithRed:57.0/255.0 green:42.0/255.0 blue:14.0/255.0 alpha:1.0]  forState:0];
//        _GoBackButton.font=[UIFont systemFontOfSize:15];
        [_GoBackButton retain];
        [_GoBackButton setExclusiveTouch:YES];
    }
    return _GoBackButton;
}
- (UILabel*)TopTitle{
    if (_TopTitle==nil) {
        _TopTitle=[[UILabel alloc] init];
        _TopTitle.textAlignment = NSTextAlignmentCenter;
//        _TopTitle.textColor=[UIColor colorWithRed:57.0/255.0 green:42.0/255.0 blue:14.0/255.0 alpha:1.0];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
             _TopTitle.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        }
        else
        {
         _TopTitle.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:17];
        }
        
       
        
        
        
        
        
        _TopTitle.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
        _TopTitle.backgroundColor=[UIColor clearColor];
        
    }
    return _TopTitle;
}
//- (UISegmentedControl*)seg{
//    if (_seg==nil) {
//        _seg=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"最热",@"最新", nil]]; 
//        self.seg.segmentedControlStyle=UISegmentedControlStyleBar;
//        self.seg.tintColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.67];
//        self.seg.selectedSegmentIndex=0;
//        [self.seg addTarget:self action:@selector(switchindexClick:) forControlEvents: UIControlEventValueChanged];
//    }
//    return _seg;
//}
- (UIActivityIndicatorView*)WaitDataActivity{
    if (_waitDataActivity==nil) {
        _waitDataActivity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _waitDataActivity.color=[UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
        _waitDataActivity.hidden=YES;
        [_waitDataActivity stopAnimating];
    }
    return _waitDataActivity;
}
-(void)Tongji:(NSString*)bookid{
    [[[[DownloadHelper alloc] init] autorelease] download:[NSString stringWithFormat:@"%@/Default.aspx?type=1&id=%@",SearchBaseUrl2,bookid]];
}
-(void)RemoveAllEventsAndObjects{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.Rows=nil;
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
    
    [self.dldHelper cancel];
    self.dldHelper.delegate=nil;
    self.dldHelper=nil;
}
-(void)dealloc{
    [self RemoveAllEventsAndObjects];
    [tableView release];
    [Rows release];
    [dldHelper release];
    [_TopImageView release];
    [_GoBackButton release];
    [_TopTitle release];
//    [_seg release];
    [_waitDataActivity release];
 
    [super dealloc];
}

@end
