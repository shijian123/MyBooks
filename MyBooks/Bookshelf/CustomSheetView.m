//
//  CustomSheetView.m
//  OneWord
//
//  Created by wukai on 14-8-13.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import "CustomSheetView.h"
//#import "TheamManager.h"
@interface CustomSheetView()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@end
@implementation CustomSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self configureTheme];
}

- (void)configureTheme
{
//    [self.bgImageView loadImage:@"bg_delete_img@2x.png"];
    self.bgImageView.image = [UIImage imageNamed:@"bg_delete_img@2x.png"];
}


- (IBAction)presed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self.delegate sheetView:self pressedButtonWithIndex:button.tag];
}

@end
