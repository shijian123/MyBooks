/*
自定义UICollectioncell
在xib中编辑视图，连接属性即可
在cell的category中设置cell的属性
*/

#import <UIKit/UIKit.h>
//#import "ThemeImgView.h"
//#import "ThemeLabel.h"
//#import "ThemeButton.h"
@interface CommonCollectionCell : UICollectionViewCell

@property (retain, nonatomic) IBOutlet UIImageView *folderImage1;
@property (retain, nonatomic) IBOutlet UIImageView *folderImage2;
@property (retain, nonatomic) IBOutlet UIImageView *folderImage3;
@property (retain, nonatomic) IBOutlet UIImageView *folderImage4;
@property (nonatomic, weak)   IBOutlet UIImageView *bookImageView;
@property (retain, nonatomic) IBOutlet UIImageView *bookKuangImg;
@property (nonatomic, weak)IBOutlet UILabel *bookName;
@property (retain, nonatomic) IBOutlet UILabel *bookAuthor;

@property (nonatomic, weak)IBOutlet UIImageView *bookSelectedImage;
@property (nonatomic, assign)BOOL editBook;
@property (nonatomic, weak) IBOutlet UIImageView *editModelImage;
@property (nonatomic, weak)IBOutlet
UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet
UILabel *introLabel;
@property (nonatomic,weak) IBOutlet UILabel *introLabelTwo;
@property (nonatomic, weak) IBOutlet UIButton *downLoadBook;
@property (nonatomic, weak) IBOutlet UIButton *readBookButton;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, weak) IBOutlet UIImageView *lineView;

@property (nonatomic, weak) IBOutlet UILabel *booksizeLabel;
+(UINib *)nib;
+(UINib *)nibWithLand;
+(UINib *)nibWithGuess;
+(UINib *)nibWithFolderListModel;
+(UINib *)nibWithRecommend;

- (void)configureTheme;
//- (void)configureThemeInBookDetailFav;
@end
