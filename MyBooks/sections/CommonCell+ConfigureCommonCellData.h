/*
    设置CommonCell的数据
    为了方便在各种情况下使用，aData为id类型
 */

#import "CommonCell.h"

@interface CommonCell (ConfigureCommonCellData)

- (void)configureCellWithData:(id)aData;

- (void)configureCellInFolderWithData:(id)aData;

- (void)configureFavouriteCellWithData:(id)aData;


- (void)configureCellWithData:(id)aData andIndexPath:(NSIndexPath *)index;


-(IBAction)downLoadBook:(id)sender;

-(IBAction)readBook:(id)sender;

@end
