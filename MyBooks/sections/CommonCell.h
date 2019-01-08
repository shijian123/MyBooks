/*
 自定义UICollectioncell
 在xib中编辑视图，连接属性即可
 在cell的category中设置cell的属性
 */
#import <UIKit/UIKit.h>
//#import "ThemeButton.h"
//#import "ThemeImgView.h"
//#import "ThemeLabel.h"
@interface CommonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bookImageView;
@property (nonatomic, weak) IBOutlet UILabel *bookNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookIntroLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookMemorySize;
@property (nonatomic, weak) IBOutlet UIButton *downLoadBook;
@property (nonatomic, weak) IBOutlet UIButton *readBookButton;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, weak) IBOutlet UIImageView *lineImageView;
@property (nonatomic, weak) IBOutlet UIImageView *vLineImageView;
@property (nonatomic, weak) IBOutlet UIImageView *penView;
/**
 *  返回Cell的xib 在UITableView中注册Cell使用
 *
 *  @return nib对象
 */
+(UINib *)nib;

+(UINib *)nibWithFavouriteCell;

+ (UINib *)nibWithFolder;

- (void)configureTheme;
- (void)configureFavouriteCellTheme;
- (void)configureThemeInFolder;
@end
