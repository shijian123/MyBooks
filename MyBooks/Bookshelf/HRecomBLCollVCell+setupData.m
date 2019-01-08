//
//  HRecomBLCollVCell+setupData.m
//  History
//
//  Created by 朝阳 on 14-7-25.
//  Copyright (c) 2014年 Work. All rights reserved.
//

#import "HRecomBLCollVCell+setupData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SmalleEbookWindow.h"
//#import "ThemeImgView.h"
#import "HBaseFunction.h"
@implementation HRecomBLCollVCell (setupData)
- (void)configureForCell:(id)dict
{
    NSString *imageUrl = [HBaseFunction getmutilogoImageUrl:dict imageStyley:2];
    [self.recommBookImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"select_bookOut1_img@2x.png"]];

    self.recBookTitle.text = dict[@"title"];
    self.recBookAuthor.text = dict[@"author"];
    self.recBookContent.text = dict[@"summary"];
    
    self.recommKuangImg.image = [UIImage imageNamed:(iphone)?@"select_bookOut3_img.png":@"select_bookOut3_img_ipad.png"];
//    [self.recommKuangImg loadImage:(iphone)?@"select_bookOut3_img.png":@"select_bookOut3_img_ipad.png"];
    
    if (isSunTheme) {
        self.backgroundColor = MAINTHEME_SUN_BGColor;
        
        self.recommBookLineImg.backgroundColor = MAINTHEME_SUN_LINEColor;
        self.recBookTitle.textColor = MAINTHEME_SUN_BookTitle;
        self.recBookAuthor.textColor = MAINTHEME_SUN_BookAuthor;
        self.recBookContent.textColor = MAINTHEME_SUN_BookAuthor;
        
    }else
    {
        self.backgroundColor = MAINTHEME_NIGHT_BGColor;
        self.recommBookImg.alpha = 0.5;
        self.recBookContent.textColor = RGBCOLOR(107, 107, 107, 1.0);
        
        self.recommBookLineImg.backgroundColor = MAINTHEME_MOON_LINEColor;
        self.recBookTitle.textColor = MAINTHEME_MOON_BookTitle;
        self.recBookAuthor.textColor = MAINTHEME_MOON_BookAuthor;
        self.recBookContent.textColor = MAINTHEME_MOON_BookAuthor;

    }

}

@end
