//
//  SpecialHeaderView.m
//  OneWord
//
//  Created by wukai on 14-9-28.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import "SpecialHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Stringhttpfix.h"

@implementation SpecialHeaderView

- (void)configureImageViewWithUrlString:(NSString *)string
{
    self.imageUrlString = [string mutableCopy];
    self.imageUrlString = [self.imageUrlString absoluteorRelative];
    
    [self.specialImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlString] placeholderImage:nil];
}

- (void)configureWithData:(id)aData
{
    if ([aData objectForKey:@"imgurl"]) {
        
        self.imageUrlString = [aData[@"imgurl"] mutableCopy];
        self.imageUrlString = [self.imageUrlString absoluteorRelative];
        
        NSString *holderImageName = isPad ? @"zhuanti_bookshop_img_ipad" : @"zhuanti_bookshop_img";
        
        [self.specialImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlString] placeholderImage:[UIImage imageNamed:holderImageName]];
    } if ([aData objectForKey:@"imageName"]) {
        [self.specialImageView setImage:[UIImage imageNamed:aData[@"imageName"]]];
    } else {
        
    }
}

- (void)configureTheme
{
//    self.specialImageView.image = 
//    [self.specialImageView loadImage:@""];
}
+(UINib *)nib
{
    return [UINib nibWithNibName:@"SpecialHeaderView_ipad" bundle:nil];
}

+(UINib *)nibInSearch
{
    return [UINib nibWithNibName:@"SpecialHeaderViewInSearch" bundle:nil];
}
@end
