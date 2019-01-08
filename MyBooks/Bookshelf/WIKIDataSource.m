
#import "WIKIDataSource.h"
#import "SpecialHeaderView.h"

@interface WIKIDataSource ()

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSDictionary *aDictionary;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (strong, nonatomic) NSString *headerIdentifier;
@property (copy, nonatomic) CellConfigureBlock cellConfigureBlock;
@property (copy, nonatomic) HeaderConfigureBlock headerConfigureBlock;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSString *headerImageUrlString;
@end
@implementation WIKIDataSource

- (instancetype)init {
    return nil;
}

- (instancetype)initWithItems:(NSArray *)dataArray cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(CellConfigureBlock)aCellConfigureBlock
{
    self = [super init];
    if (self) {
        _dataArray = dataArray;
        _cellIdentifier = aCellIdentifier;
        _cellConfigureBlock = [aCellConfigureBlock copy];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)dataArray
               cellIdentifier:(NSString *)aCellIdentifier
                   headerView:(UIView *)headerView
           configureCellBlock:(CellConfigureBlock)aCellConfigureBlock;
{
    self = [super init];
    if (self) {
        _dataArray = dataArray;
        _cellIdentifier = aCellIdentifier;
        _cellConfigureBlock = [aCellConfigureBlock copy];
        _headerView = headerView;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)dataArray
               cellIdentifier:(NSString *)aCellIdentifier
           configureCellBlock:(CellConfigureBlock)aCellConfigureBlock
               headerDataDict:(NSDictionary *)aHeaderDataDict
             headerIdentifier:(NSString *)aHeaderIdentifier
         configureHeaderBlock:(HeaderConfigureBlock)aHeaderConfigureBlock
{
    self = [super init];
    if (self) {
        _dataArray = dataArray;
        _aDictionary = aHeaderDataDict;
        _cellIdentifier = aCellIdentifier;
        _headerIdentifier = aHeaderIdentifier;
        _cellConfigureBlock = [aCellConfigureBlock copy];
        _headerConfigureBlock = [aHeaderConfigureBlock copy];
    }
    return self;
}


- (void)refreshDataSourceWithArray:(NSArray *)aArray
{
    self.dataArray = [aArray copy];
}

#pragma mark - UITableViewDataSource
- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray[(NSInteger) indexPath.item];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id item = [self itemAtIndexPath:indexPath];
    
    self.cellConfigureBlock(cell, item, indexPath);
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.bounds.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1000 && self.headerView) {
        return self.headerView;
    }
    return nil;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.scrollBlock) {
        return;
    }
    if (scrollView.contentOffset.y > 40) {
        self.scrollBlock(YES);
    } else if(scrollView.contentOffset.y < 20){
        self.scrollBlock(NO);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.cellConfigureBlock(cell, item, indexPath);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:_headerIdentifier forIndexPath:indexPath];
        
        
        self.headerConfigureBlock(reuseView, _aDictionary);
        return reuseView;
    } else
        return nil;
}
@end
