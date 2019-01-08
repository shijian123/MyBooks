/*
 *通用datasource
 *适用于tableview和CollectionView 
 *no sectionHeader && no sectionFooter
 */

#import <Foundation/Foundation.h>

typedef void(^CellConfigureBlock)(id cell, id item, NSIndexPath *index);

typedef void(^HeaderConfigureBlock)(id cell, id item);
typedef void(^WIKIDataSourceScrollBlock) (BOOL ok);

@interface WIKIDataSource : NSObject
<UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) WIKIDataSourceScrollBlock scrollBlock;

/**
 *  数据源初始化方法
 *
 *  @param dataArray           列表视图或网格视图的数据
 *  @param aCellIdentifier     cell的标示符
 *  @param aCellConfigureBlock configurecell
 *
 *  @return WIKIDataSource
 */
- (instancetype)initWithItems:(NSArray *)dataArray
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CellConfigureBlock)aCellConfigureBlock;

- (instancetype)initWithItems:(NSArray *)dataArray
               cellIdentifier:(NSString *)aCellIdentifier
                   headerView:(UIView *)headerView
           configureCellBlock:(CellConfigureBlock)aCellConfigureBlock;

- (instancetype)initWithItems:(NSArray *)dataArray
               cellIdentifier:(NSString *)aCellIdentifier
           configureCellBlock:(CellConfigureBlock)aCellConfigureBlock
               headerDataDict:(NSDictionary *)aHeaderDataDict
             headerIdentifier:(NSString *)aHeaderIdentifier
         configureHeaderBlock:(HeaderConfigureBlock)aHeaderConfigureBlock;
/**
 *  刷新数据源
 *
 *  @param aArray 新的数据数组
 */
- (void)refreshDataSourceWithArray:(NSArray *)aArray;

/**
 *  从数据数组中获取indexPath对应的数据（某个cell的数据）
 *
 *  @param indexPath 索引
 *
 *  @return id类型
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
