
#import "CommonCollectionCell.h"

@interface CommonCollectionCell (ConfigureCommonCollectionCellData)

- (void)configureCellWithData:(id)aData;

- (void)showSelect:(BOOL)isSelect;

- (void)showEditModelImage:(BOOL)isShow;

- (void)configureCellInThirdBookShopWithData:(id)aData;

- (void)configureBaseViewCellWithData:(id)aData;

//pad文件夹列表
- (void)configureCellWithDataInPadListModel:(id)aData;
-(IBAction)downLoadBook:(id)sender;

-(IBAction)readBook:(id)sender;

@end
