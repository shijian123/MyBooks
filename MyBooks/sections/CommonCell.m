
#import "CommonCell.h"

@implementation CommonCell

+ (UINib *)nib
{
    if (isPad) {
        return [UINib nibWithNibName:@"CommonCell_ipad" bundle:nil];
    } else {
        return [UINib nibWithNibName:@"CommonCell_iphone" bundle:nil];
    }
}


+(UINib *)nibWithFavouriteCell
{
    return [UINib nibWithNibName:@"CommonFavouriteCell" bundle:nil];
}

+ (UINib *)nibWithFolder
{
    return [UINib nibWithNibName:@"CommonCell_Folder" bundle:nil];
}

//主题图片在这里添加
- (void)awakeFromNib
{
    [super awakeFromNib];
//    通过判断cell的reuseIdentifier 设置主题
    if ([self.reuseIdentifier isEqualToString:@"CommonCell"]) {
        
    }
}


- (void)configureTheme
{
//    [self.vLineImageView loadImage:@"line2_list_img@2x.png"];
//    [self.bookNameLabel loadLabel:@"kCommonCellTitle"];
//    [self.authorLabel loadLabel:@"kCommonCellAuthor"];
//    [self.bookIntroLabel loadLabel:@"kCommonCellAuthor"];
//    [self.bookMemorySize loadLabel:@"kCommonCellBookSize"];
//    [self.readBookButton loadImage:@"reading_list_img@2x.png"];
//    [self.downLoadBook loadImage:@"downloading_list_btn@2x.png"];
}

- (void)configureThemeInFolder
{
//    [self.bookNameLabel loadLabel:@"kCommonCellTitle"];
//    [self.authorLabel loadLabel:@"kCommonCellAuthor"];
//    [self.lineImageView loadImage:@"line_search_img@2x.png"];
}

- (void)configureFavouriteCellTheme
{
//    [self.bookNameLabel loadLabel:@"kSearchFavouriteTitle"];
//    [self.authorLabel loadLabel:@"kSearchFavouriteAuthor"];
//    [self.lineImageView loadImage:@"line_search_img@2x.png"];
//    [self.penView loadImage:@"Search_pen@2x.png"];
}

@end
