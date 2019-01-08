//
//  HBookShelfInfoVC.h
//  History
//
//  Created by 朝阳 on 14-7-8.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import "HBaseController.h"

@interface HBookShelfInfoVC : HBaseController
@property (nonatomic, strong) NSDictionary *folderDic;
@property (nonatomic, strong) NSMutableArray *mainDataArr;      //主视图的数据

//*****************+更换专题+********************
@property (retain, nonatomic) IBOutlet UIImageView *navMainImage;
@property (retain, nonatomic) IBOutlet UIButton *navMainLeftBtn;
@property (retain, nonatomic) IBOutlet UIButton *navMainRightBtn;
@property (retain, nonatomic) IBOutlet UILabel *navMainTopTitle;
@property (retain, nonatomic) IBOutlet UIView *mainThemeBGV;

@end
