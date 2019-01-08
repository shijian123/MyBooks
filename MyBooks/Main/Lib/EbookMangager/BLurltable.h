//
//  BLurltable.h
//  OfficerEye
//
//  Created by BLapple on 13-3-20.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//
#import "XmlDataSet1.h"
#import "DownloadHelper.h"
#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@protocol BLurltabledelegate<NSObject>
- (void)choose:(NSInteger)index;
@end

@interface BLurltable : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView*mytableview;
    NSString* url;
    DownloadHelper*down;
    NSMutableArray *Rows;
    id delegate;
    UIActivityIndicatorView *_waitDataActivity;
    UIImageView* left;
    UIImageView* right;
    NSInteger chooseindex;
    NSInteger deletekey;
}
@property(retain,nonatomic)NSString* url;
@property(assign,nonatomic)id delegate;
@property(retain,nonatomic)NSMutableArray *Rows;
@property(readwrite)NSInteger chooseindex;
@property(assign)UITableView*mytableview;

- (id)initWithFrame:(CGRect)frame url:(NSString*)_url;

-(void)reloadvi;

@end
