//
//  EditModelHeaderView.m
//  OneWord
//
//  Created by wukai on 14-8-28.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import "EditModelHeaderView.h"

@implementation EditModelHeaderView

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
    self.titleLabel.text = @"kNavigationbarTitleLabel";
    [self.leftButton setTitle:@"kNavigationbarTitleLabel" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"kNavigationbarTitleLabel" forState:UIControlStateNormal];

//    [self.titleLabel loadLabel:@"kNavigationbarTitleLabel"];
//    [self.leftButton loadColor:@"kNavigationbarTitleLabel"];
//    [self.rightButton loadColor:@"kNavigationbarTitleLabel"];
    
}
- (IBAction)buttonPressed:(id)sender
{
    self.buttonTappedBlock(sender);
}

    
@end
