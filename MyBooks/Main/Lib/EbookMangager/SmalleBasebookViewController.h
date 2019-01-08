#import <UIKit/UIKit.h>
#import "SmalleEbookWindow.h"


@interface SmalleBasebookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
    NSMutableArray *Rows;
    DownloadHelper *dldHelper;
    UIActivityIndicatorView *_waitDataActivity;//等待提示
//    UISegmentedControl*_seg;
    UIImageView *_TopImageView;
    UIButton *_GoBackButton;
    UILabel *_TopTitle;
}
@property (nonatomic,retain)  UITableView *tableView;
@property (retain,nonatomic)  DownloadHelper *dldHelper;
@property (atomic,retain)  NSMutableArray *Rows;
- (UIImageView*)TopImageView;
- (UIButton*)GoBackButton;
- (UILabel*)TopTitle;
//- (UISegmentedControl*)seg;
-(void)ShowwaitDataActivity;
-(void)HiddenwaitDataActivity;
-(void)Tongji:(NSString*)bookid;
-(void)RemoveAllEventsAndObjects;



-(void)setbarandviewsize:(NSString*)horv  deviece:(NSString*)device;

@end
