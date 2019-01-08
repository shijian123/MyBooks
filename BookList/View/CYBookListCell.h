//
//  CYBookListCell.h
//  MyBooks
//
//  Created by zcy on 2018/5/10.
//  Copyright © 2018年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYBookListCell : UITableViewCell

@property (nonatomic, strong) BmobObject *model;

+ (instancetype)cellWithTaleView:(UITableView *)tableView;

@end
