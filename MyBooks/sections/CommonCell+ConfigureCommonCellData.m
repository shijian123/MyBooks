
#import "CommonCell+ConfigureCommonCellData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Stringhttpfix.h"
#import "UIImage+NewImageWIthNewSize.h"
#import "EBookLocalStore.h"
#import "SmalleEbookWindow.h"

@implementation CommonCell (ConfigureCommonCellData)

- (void)configureCellWithData:(id)aData
{
//    设置cell的属性
    [self configureTheme];
    
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    

    [self configureDownloadbookButton];
    
    if ([[aData allKeys] containsObject:@"image"]) {
        [self.bookImageView setImage:[UIImage imageNamed:aData[@"image"]]];
        self.authorLabel.text = aData[@"zuoze"];
        self.bookIntroLabel.text = aData[@"jianjie"];
        self.bookNameLabel.text = aData[@"title"];
    } else {
        NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
        
        __weak CommonCell *weakSelf = self;
        NSString *imagenameString = @"books_bookshop_img";
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.bookImageView setImage:[image dropImageRadius]];
            
        }];
//        [self.bookImageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//
//        }];
        
        self.bookNameLabel.text = aData[@"title"];
        self.authorLabel.text = aData[@"author"];
        self.bookIntroLabel.text = aData[@"summary"];
        
        CGFloat bookSize = [aData[@"size"] floatValue] / (1024 * 1024);
        NSString *string = bookSize > 0 ? @"MB" : @"KB";
        if (bookSize == 0) {
            bookSize = [aData[@"size"] floatValue] / 1024;
        }
        self.bookMemorySize.text = [NSString stringWithFormat:@"%.2f %@", bookSize, string];
    
    }
}

- (void)configureCellInFolderWithData:(id)aData
{
    //    设置cell的属性
    [self configureThemeInFolder];
    
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    
    
    [self configureDownloadbookButton];
    
    if ([[aData allKeys] containsObject:@"image"]) {
        [self.bookImageView setImage:[UIImage imageNamed:aData[@"image"]]];
        self.authorLabel.text = aData[@"zuoze"];
        self.bookIntroLabel.text = aData[@"jianjie"];
        self.bookNameLabel.text = aData[@"title"];
    } else {
        NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
        
        __weak CommonCell *weakSelf = self;
        NSString *imagenameString = @"books_bookshop_img";
        
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.bookImageView setImage:[image dropImageRadius]];
            
        }];
        
        self.bookNameLabel.text = aData[@"title"];
        self.authorLabel.text = aData[@"author"];
        
    }
}

- (void)configureCellWithData:(id)aData andIndexPath:(NSIndexPath *)index
{
    [self configureTheme];
     self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    //    设置cell的属性
     self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    [self configureDownloadbookButton];
    NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
    
     NSString *imagenameString = @"books_bookshop_img";
    
    __weak CommonCell *weakSelf = self;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.bookImageView setImage:[image dropImageRadius]];
        
    }];
    
//    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        
//        [weakSelf.bookImageView setImage:[image dropImageRadius]];
//    }];
    
    self.bookNameLabel.text = aData[@"title"];
    self.authorLabel.text = aData[@"author"];
    self.bookIntroLabel.text = aData[@"summary"];
}


- (void)configureFavouriteCellWithData:(id)aData
{
    [self configureFavouriteCellTheme];
     self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
     self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    [self configureDownloadbookButton];
    NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
    NSString *imagenameString = @"books_bookshop_img";
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString]];
    self.bookNameLabel.text = aData[@"title"];
    self.authorLabel.text = aData[@"author"];
}




-(IBAction)downLoadBook:(id)sender
{
        self.downLoadBook.enabled = NO;
        
        //    删除之前的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:EBookLocalStoreProgressUpdate
                                                      object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(EBookLocalStoreProgressUpdateFunction:)
                                                     name:EBookLocalStoreProgressUpdate
                                                   object:nil];
    
        BOOL willDownload =  [EBookLocalStore AddNewBookToDownload:self.dict];
    
    if (willDownload) {
        NSLog(@"开始下载");
    }
}


-(IBAction)readBook:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"StartBookReadingNotification"
     object:nil
     userInfo:self.dict];
}


-(void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification{
    NSDictionary *bookdic=[notification userInfo];
    if([[self.dict objectForKey:@"source"] isEqualToString:[bookdic objectForKey:@"source"]])
    {
        NSLog(@"%f", [[bookdic objectForKey:@"percent"] floatValue]);
        if ([[bookdic objectForKey:@"percent"] floatValue]==1.0) {
            self.downLoadBook.hidden = YES;
            self.readBookButton.hidden = NO;
        }else{
            self.downLoadBook.enabled = NO;
            self.readBookButton.hidden = YES;
        }
    }
}

- (void)configureDownloadbookButton
{
    int bookState =  [[EBookLocalStore defaultEBookLocalStore] CheckBookListExistsAtBookInfor:self.dict];
    
    if (bookState != 1) {
        self.downLoadBook.hidden = NO;
        self.downLoadBook.enabled = YES;
        self.readBookButton.hidden = YES;
    } else {
        self.downLoadBook.hidden = YES;
        self.readBookButton.hidden = NO;

    }

}


@end
