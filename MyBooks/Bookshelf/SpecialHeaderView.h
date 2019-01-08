//
//  SpecialHeaderView.h
//  OneWord
//
//  Created by wukai on 14-9-28.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialHeaderView : UICollectionReusableView

@property (nonatomic, weak)IBOutlet UIImageView *specialImageView;
@property (nonatomic, strong) NSString *imageUrlString;

+(UINib *)nib;

+(UINib *)nibInSearch;

- (void)configureImageViewWithUrlString:(NSString *)string;

- (void)configureWithData:(id)aData;

- (void)configureTheme;
@end
