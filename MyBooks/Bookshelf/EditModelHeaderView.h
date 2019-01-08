//
//  EditModelHeaderView.h
//  OneWord
//
//  Created by wukai on 14-8-28.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThemeImgView.h"
//#import "ThemeLabel.h"
//#import "ThemeButton.h"
typedef void(^ButtonTappedBlock)(id sender);

@interface EditModelHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (nonatomic, copy) ButtonTappedBlock buttonTappedBlock;
@property (nonatomic, weak) IBOutlet UILabel *deletedBooksCount;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


@end
