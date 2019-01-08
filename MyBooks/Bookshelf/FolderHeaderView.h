#import <UIKit/UIKit.h>
//#import "ThemeImgView.h"

typedef void(^FolderHeaderViewTappedBlock)(id sender);

@interface FolderHeaderView : UIView


@property (retain, nonatomic) IBOutlet UIView *folderBotView;

@property (retain, nonatomic) IBOutlet UIImageView *folderNameIV;


@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UIImageView *lockImageView;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, copy) FolderHeaderViewTappedBlock block;
@property (nonatomic, strong) NSMutableDictionary *bookDict;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

- (IBAction)configurePassword:(id)sender;


@end
