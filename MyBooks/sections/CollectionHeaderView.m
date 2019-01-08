//
//  CollectionHeaderView.m
//  BookStore
//
//  Created by Work on 14-7-7.
//  Copyright (c) 2014年 wukai. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

+ (UINib *)nib{
    if (isPad) {
        return [UINib nibWithNibName:@"CollectionHeaderView_ipad" bundle:nil];
    } else {
        return [UINib nibWithNibName:@"CollectionHeaderView_iphone" bundle:nil];
    }
}

/**
 是否显示搜索功能
 
 @param isShow 是否显示
 */
- (void)showSearchBtnMethod:(BOOL)isShow{
    
    if (isShow) {
        self.searchCancel.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.rectangleButton.alpha = 0.3;
            self.listButton.alpha = 0.3;
            self.searchCancel.alpha = 1.0;
        }completion:^(BOOL finished) {
            self.rectangleButton.hidden = YES;
            self.listButton.hidden = YES;
        }];
    }else{
        self.rectangleButton.hidden = NO;
        self.listButton.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.rectangleButton.alpha = 1.0;
            self.listButton.alpha = 1.0;
            self.searchCancel.alpha = 0.3;
        }completion:^(BOOL finished) {
            self.searchCancel.hidden = YES;
        }];
        self.searchTextF.text = @"";
    }
    
}

@end
