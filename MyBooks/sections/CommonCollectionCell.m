

#import "CommonCollectionCell.h"

@implementation CommonCollectionCell

+ (UINib *)nib{
    if (isPad) {
        return [UINib nibWithNibName:@"CommonCollectionCell_ipad" bundle:nil];
    } else {
        return [UINib nibWithNibName:@"CommonCollectionCell_iphone" bundle:nil];
    }
}

+(UINib *)nibWithLand
{
    if (isPad) {
        return [UINib nibWithNibName:@"CommonCollectionLandCell_ipad" bundle:nil];
    } else {
        return [UINib nibWithNibName:@"CommonCollectionLandCell_iphone" bundle:nil];
    }
}

+ (UINib *)nibWithRecommend
{
    return [UINib nibWithNibName:@"GuessFavouriteCell_ipad" bundle:nil];
}

+(UINib *)nibWithGuess
{
    if (isPad) {
        return [UINib nibWithNibName:@"GuessFavouriteInBookDetailCell" bundle:nil];
    } else {
        return [UINib nibWithNibName:@"GuessFavouriteCell" bundle:nil];
    }
}

+(UINib *)nibWithFolderListModel
{
    return [UINib nibWithNibName:@"CommonCollectionLandListCell_ipad" bundle:nil];
}


// todo
- (void)configureTheme
{
//    [self.bookName loadLabel:@"kCommonCellTitle"];
//    [self.bookAuthor loadLabel:@"kCommonCellTitle"];
//    [self.authorNameLabel loadLabel:@"kCommonCellAuthor"];
//    [self.introLabel loadLabel:@"kCommonCellAuthor"];
//    [self.introLabelTwo loadLabel:@"kCommonCellAuthor"];
//    [self.lineView loadImage: isPad ? @"line_top_introduction_img_ipad.png" : @"line_search_img@2x.png" ];
//    [self.booksizeLabel loadLabel:@"kCommonCellBookSize"];
//    
//    if (isSunTheme) {
//        
//        self.bookImageView.alpha = 1.0;
//        self.folderImage1.alpha = 1.0;
//        self.folderImage2.alpha = 1.0;
//        self.folderImage3.alpha = 1.0;
//        self.folderImage4.alpha = 1.0;
//
//        self.bookName.textColor = MAINTHEME_SUN_BookTitle;
//        self.authorNameLabel.textColor = MAINTHEME_SUN_BookAuthor;
//        self.introLabel.textColor = MAINTHEME_SUN_BookAuthor;
//        
//    }else
//    {
//        
//        self.bookImageView.alpha = 0.5;
//        self.folderImage1.alpha = 0.5;
//        self.folderImage2.alpha = 0.5;
//        self.folderImage3.alpha = 0.5;
//        self.folderImage4.alpha = 0.5;
//        self.bookName.textColor = MAINTHEME_MOON_BookTitle;
//        self.authorNameLabel.textColor = MAINTHEME_MOON_BookAuthor;
//        self.introLabel.textColor = MAINTHEME_MOON_BookAuthor;
//
//    }
}



@end
