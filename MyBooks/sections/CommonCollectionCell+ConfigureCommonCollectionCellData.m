
#import "CommonCollectionCell+ConfigureCommonCollectionCellData.h"
#import "NSString+Stringhttpfix.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+NewImageWIthNewSize.h"
#import "SmalleEbookWindow.h"

@implementation CommonCollectionCell (ConfigureCommonCollectionCellData)

- (void)configureCellWithData:(id)aData
{
//设置cell属性
//    本地书
    
    self.folderImage1.hidden = YES;
    self.folderImage2.hidden = YES;
    self.folderImage3.hidden = YES;
    self.folderImage4.hidden = YES;
    
    self.bookKuangImg.hidden = NO;
    self.introLabel.hidden = NO;
    
    [self configureTheme];
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    
    [self configureDownloadbookButton];
    [self showSelect:NO];

    self.bookKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_bookout1_img.png":@"bookShelf_bookout1_img_ipad.png"];
    
    if ([[aData allKeys] containsObject:@"isFolder"]) {
        self.introLabel.hidden = YES;
        self.bookName.text = aData[@"folderName"];
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }

        if ([aData[@"password"]isEqualToString:@""]) {
            
            self.bookImageView.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderCell_img":@"bookShelf_folderCell_img_ipad.png"];
            [self showFolderImageAction:[NSMutableArray arrayWithArray:[aData objectForKey:@"booksArray"]]];

        }else{
            self.bookImageView.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderLock_img":@"bookShelf_folderLock_img_ipad.png"];
            self.bookKuangImg.hidden = YES;
        }
        
        NSArray *arr = [NSArray arrayWithArray:aData[@"booksArray"]];
        self.authorNameLabel.text = [NSString stringWithFormat:@"共 %lu 本", [arr count]];
        
    } else if ([[aData allKeys] containsObject:@"image"]){
//        本地书
        self.introLabel.hidden = YES;
        [self.bookSelectedImage setImage:[UIImage imageNamed:@"shelf_book_edit_select.png"]];
        [self showSelect:NO];
        [self.bookImageView setImage:[UIImage imageNamed:[aData objectForKey:@"image"]]];
        self.bookName.text = aData[@"title"];
        
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }

        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabel.text = aData[@"jianjie"];
    }else if([aData[@"iswifibook"]integerValue] == 1){
        
        //wifi书籍
        self.bookName.text = aData[@"title"];
        self.authorNameLabel.text = aData[@"author"];
        self.bookImageView.image = [UIImage imageNamed:(iphone)?@"bookShelf_books_img.png":@"bookShelf_books_img_ipad.png"];
        self.introLabel.text = aData[@"summary"];

    }else{//下载的书

        NSString *imageUrlString = aData[@"imgUrl"];
//        imageUrlString = [aData[@"imgUrl"] absoluteorRelative];
//
//        if (aData[@"isepub"]) {
//            imageUrlString = [aData[@"imgUrl"] epubRelative];
//        }
        __weak CommonCollectionCell *weakSelf = self;
        NSString *imagenameString = isPad ? @"books_bookshelf_img_ipad" : @"books_bookshelf_img";
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"error With Image loaded");
            } else {
                UIImage *tmpImage = [image dropImageRadius];
                [weakSelf.bookImageView setImage:tmpImage];
            }
        }];
        
        self.bookName.text = aData[@"title"];
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }
        
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];

        }
        
        self.introLabel.text = aData[@"summary"];
    }
    
    
}


- (void)configureBaseViewCellWithData:(id)aData
{
    //设置cell属性
    //    本地书
    [self configureTheme];
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    
    [self configureDownloadbookButton];
    
    
    [self showSelect:NO];
    
    
    //        下载的书
    NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
    
    __weak CommonCollectionCell *weakSelf = self;
    
    NSString *imagenameString = isPad ? @"books_bookshelf_img_ipad" : @"books_bookshelf_img";
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            //                NSLog(@"error With Image loaded");
        } else {
            UIImage *tmpImage = [image dropImageRadius];
            [weakSelf.bookImageView setImage:tmpImage];
        }
    }];
    
//        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            if (error) {
////                NSLog(@"error With Image loaded");
//            } else {
//                UIImage *tmpImage = [image dropImageRadius];
//                [weakSelf.bookImageView setImage:tmpImage];
//            }
//        }];
    
        
        self.bookName.text = aData[@"title"];
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }
        
        
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabel.text = aData[@"summary"];
    
    CGFloat bookSize = [aData[@"size"] floatValue] / (1024 * 1024);
    NSString *string = bookSize > 0 ? @"MB" : @"KB";
    if (bookSize == 0) {
        bookSize = [aData[@"size"] floatValue] / 1024;
    }
    self.booksizeLabel.text = [NSString stringWithFormat:@"%.2f %@", bookSize, string];

    
}


- (void)configureCellInThirdBookShopWithData:(id)aData
{
    //设置cell属性
    //    本地书
    [self configureTheme];
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
   [self configureDownloadbookButton];
    
    [self showSelect:NO];
    
    
    if ([[aData allKeys] containsObject:@"isFolder"]) {
        
        self.bookName.text = aData[@"folderName"];
        NSString *tmppassword = aData[@"password"];
        
        NSString *imagename = tmppassword.length ? @"shelf_folder_lock" : @"shelf_folder_unlock";
        [self.bookImageView setImage:[UIImage imageNamed:imagename]];
        
        NSArray *arr = [NSArray arrayWithArray:aData[@"booksArray"]];
        self.authorNameLabel.text = [NSString stringWithFormat:@"共 %lu 本", [arr count]];
        
    } else if ([[aData allKeys] containsObject:@"image"]){
        //        本地书
        [self.bookSelectedImage setImage:[UIImage imageNamed:@"shelf_book_edit_select.png"]];
        
        [self showSelect:NO];
        [self.bookImageView setImage:[UIImage imageNamed:[aData objectForKey:@"image"]]];
        
        self.bookName.text = aData[@"title"];
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabel.text = aData[@"jianjie"];
        
    } else {
        //        下载的书
        NSString *imageUrlString = [aData[@"logo"] epubRelative];
        
        NSString *imagenameString = isPad ? @"books_bookshelf_img_ipad" : @"books_bookshelf_img";
        
        __weak CommonCollectionCell *weakSelf = self;
        
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                //                NSLog(@"error With Image loaded");
            } else {
                UIImage *tmpImage = [image dropImageRadius];
                [weakSelf.bookImageView setImage:tmpImage];
            }
        }];
//        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            if (error) {
////                NSLog(@"error With Image loaded");
//            } else {
//                UIImage *tmpImage = [image dropImageRadius];
//                [weakSelf.bookImageView setImage:tmpImage];
//            }
//        }];
        
        
        self.bookName.text = aData[@"title"];
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabel.text = aData[@"summary"];
    }
}


//pad文件夹列表
- (void)configureCellWithDataInPadListModel:(id)aData
{
    //设置cell属性
    //    本地书
    [self configureTheme];
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:aData];
    self.dict = [SmalleEbookWindow BuilteBookStatus:self.dict];
    
    self.downLoadBook.hidden = YES;
    self.readBookButton.hidden = YES;
    self.booksizeLabel.hidden = YES;
    
    [self showSelect:NO];
    
    self.introLabelTwo.hidden = NO;
    self.introLabel.hidden = YES;
    
    if ([[aData allKeys] containsObject:@"isFolder"]) {
        
        self.bookName.text = aData[@"folderName"];
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }
        
        //        [self.bookName sizeToFit];
        
        NSString *tmppassword = aData[@"password"];
        
        NSString *imagename;
        
        if (isPad) {
            imagename = tmppassword.length ? @"bookout_lock_img_ipad" : @"bookout_unlock_img_ipad";
        } else {
            imagename = tmppassword.length ? @"shelf_folder_lock" : @"shelf_folder_unlock";
        }
        //        NSString *imagename = tmppassword.length ? @"shelf_folder_lock" : @"shelf_folder_unlock";
        [self.bookImageView setImage:[UIImage imageNamed:imagename]];
        
        self.authorNameLabel.text = [NSString stringWithFormat:@"共 %lu 本", [(NSArray *)aData[@"booksArray"] count]];
        
    } else if ([[aData allKeys] containsObject:@"image"]){
        //        本地书
        [self.bookSelectedImage setImage:[UIImage imageNamed:@"shelf_book_edit_select.png"]];
        
        [self showSelect:NO];
        [self.bookImageView setImage:[UIImage imageNamed:[aData objectForKey:@"image"]]];
        
        self.bookName.text = aData[@"title"];
        
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }
        //        [self.bookName sizeToFit];
        
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabelTwo.text = aData[@"jianjie"];
    } else {
        //        下载的书
        NSString *imageUrlString = [aData[@"logo"] absoluteorRelative];
        
        __weak CommonCollectionCell *weakSelf = self;
        
        NSString *imagenameString = isPad ? @"books_bookshelf_img_ipad" : @"books_bookshelf_img";
        
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                //                NSLog(@"error With Image loaded");
            } else {
                UIImage *tmpImage = [image dropImageRadius];
                [weakSelf.bookImageView setImage:tmpImage];
            }
        }];
        
//        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:imagenameString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            if (error) {
////                NSLog(@"error With Image loaded");
//            } else {
//                UIImage *tmpImage = [image dropImageRadius];
//                [weakSelf.bookImageView setImage:tmpImage];
//            }
//        }];
        
        
        self.bookName.text = aData[@"title"];
        int breakLength = isPad ? 7 : 5;
        if (self.bookName.text.length <= breakLength) {
            self.bookName.text = [NSString stringWithFormat:@"%@\r", self.bookName.text];
        }
        
        
        if ([[aData allKeys] containsObject:@"zuoze"]) {
            self.authorNameLabel.text = aData[@"zuoze"];
        } else {
            self.authorNameLabel.text = aData[@"author"];
        }
        
        self.introLabelTwo.text = aData[@"summary"];
    }

}


- (void)showSelect:(BOOL)isSelect
{
    self.bookSelectedImage.hidden = !isSelect;
    self.editBook = isSelect;
}

- (void)showEditModelImage:(BOOL)isShow
{
    self.editModelImage.hidden = !isShow;
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

-(void)showFolderImageAction:(NSMutableArray *)bookArr
{
    
    
    if ([bookArr count]>=4) {

        self.folderImage1.hidden = NO;
        self.folderImage2.hidden = NO;
        self.folderImage3.hidden = NO;
        self.folderImage4.hidden = NO;
        [self getFoladImage:self.folderImage1 withBookDic:[bookArr  objectAtIndex:0]];
        [self getFoladImage:self.folderImage2 withBookDic:[bookArr  objectAtIndex:1]];
        [self getFoladImage:self.folderImage3 withBookDic:[bookArr  objectAtIndex:2]];
        [self getFoladImage:self.folderImage4 withBookDic:[bookArr  objectAtIndex:3]];
        self.bookKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderout4_img.png":@"bookShelf_folderout4_img_ipad.png"];
//        [self.bookKuangImg loadImage:(iphone)?@"bookShelf_folderout4_img.png":@"bookShelf_folderout4_img_ipad.png"];

    }else if ([bookArr count]>=3)
    {

        self.folderImage1.hidden = NO;
        self.folderImage2.hidden = NO;
        self.folderImage3.hidden = NO;
        [self getFoladImage:self.folderImage1 withBookDic:[bookArr  objectAtIndex:0]];
        [self getFoladImage:self.folderImage2 withBookDic:[bookArr  objectAtIndex:1]];
        [self getFoladImage:self.folderImage3 withBookDic:[bookArr  objectAtIndex:2]];
        self.bookKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderout3_img.png":@"bookShelf_folderout3_img_ipad.png"];
//        [self.bookKuangImg loadImage:(iphone)?@"bookShelf_folderout3_img.png":@"bookShelf_folderout3_img_ipad.png"];

    }else if ([bookArr count]>=2)
    {

        self.folderImage1.hidden = NO;
        self.folderImage2.hidden = NO;
        [self getFoladImage:self.folderImage1 withBookDic:[bookArr  objectAtIndex:0]];
        [self getFoladImage:self.folderImage2 withBookDic:[bookArr  objectAtIndex:1]];
        self.bookKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderout2_img.png":@"bookShelf_folderout2_img_ipad.png"];

//        [self.bookKuangImg loadImage:(iphone)?@"bookShelf_folderout2_img.png":@"bookShelf_folderout2_img_ipad.png"];
   
    }else if ([bookArr count]>=1)
    {

        self.folderImage1.hidden = NO;
        [self getFoladImage:self.folderImage1 withBookDic:[bookArr  objectAtIndex:0]];
        self.bookKuangImg.image = [UIImage imageNamed:(iphone)?@"bookShelf_folderout1_img.png":@"bookShelf_folderout1_img_ipad.png"];

//        [self.bookKuangImg loadImage:(iphone)?@"bookShelf_folderout1_img.png":@"bookShelf_folderout1_img_ipad.png"];

    }else{
        
    }
    
    

}

-(void)getFoladImage:(UIImageView *)myImageV withBookDic:(NSDictionary *)bookDic
{
    if ([[bookDic allKeys] containsObject:@"zuoze"]) {
        [myImageV setImage:[UIImage imageNamed:[bookDic objectForKey:@"image"]]];
    }else
    {
        NSString *imageUrl=[[bookDic objectForKey:@"logo"] absoluteorRelative];
        [myImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"books_bookshelf_img"]];
        
    }
    
}


@end
