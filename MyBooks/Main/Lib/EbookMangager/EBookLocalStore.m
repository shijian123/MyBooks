#import "EBookLocalStore.h"
#import "ZipArchive.h"
#import "ASIHTTPRequest.h"
#import "NSString+MD5.h"
#import "XmlDataSet1.h"
#import "NSFileManager+TextBookReadingFileManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <sys/xattr.h>

#define ebooklistPath [EBookSaveRootPath stringByAppendingPathComponent:@"ebooklist.db"]
#define pathEn [EBookSaveRootPath stringByAppendingPathComponent:@"ebooklistnew.xml"]
@implementation UIImage(BLextern)
+(UIImage*)imagefileNamed:(NSString *)name
{
    NSString* extername=[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:name];
    BOOL isexist=[[NSFileManager defaultManager]fileExistsAtPath:extername];
    if (isexist) {
        return [UIImage imageWithContentsOfFile:extername];
    }
    //    UIImage* image=[UIImage imageWithContentsOfFile:extername];
    UIImage* image=nil;
    
    if(image==nil&& [UIScreen mainScreen].scale==1 )
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@".png"]];
    }
    if(image==nil&& [UIScreen mainScreen].scale==2 )
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.png"]];
    }
    if (image==nil&[UIScreen mainScreen].scale==3) {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@3x.png"]];
    }
    //    if(image==nil )
    //    {
    //        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@".png"]];
    //    }
    if(image==nil&& [UIScreen mainScreen].scale==1)
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@".jpg"]];
    }
    if(image==nil&& [UIScreen mainScreen].scale==2)
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@2x.jpg"]];
    }
    if(image==nil&[UIScreen mainScreen].scale==3)
    {
        image=[UIImage imageWithContentsOfFile:[extername stringByAppendingString:@"@3x.jpg"]];
    }
    
#ifdef DEBUG
    if(image==nil)
    {
        //        NSLog(@"image does't exist at path:%@",extername);
    }
#endif
    
    return image;
}

+(UIImage*)catchimagenamed:(NSString *)name
{
    NSString* extername=name;
    
    UIImage* image=[UIImage imageNamed:extername];
    
    if(image==nil)
    {
        extername=[name stringByAppendingString:@".jpg"];
        
        image=[UIImage imageNamed:extername];
    }

    
    

#ifdef DEBUG
    if(image==nil)
    {
//        NSLog(@"image does't exist at path:%@",extername);
    }
#endif
     return image;
}

@end

#ifndef DEBUG

@implementation NSString(BLextern)
- (id)objectAtIndex:(NSUInteger)index
{
    return self;
}

- (NSUInteger)count
{
    return 1;
}
- (NSString *)stringValue
{
    return self;
}

@end

@implementation NSNumber(BLextern)

- (id)objectAtIndex:(NSUInteger)index
{
    return self;
}

- (NSUInteger)count
{
    return 1;
}

-(BOOL)isEqualToString:(NSString *)aString
{
    
    return [[self stringValue]isEqualToString:[aString stringValue]];
    
}
- (NSString *)stringByAppendingString:(NSString *)aString
{
    return [[self stringValue] stringByAppendingString:aString];
}

- (NSString *)stringByAppendingPathComponent:(NSString *)str
{
return [[self stringValue] stringByAppendingPathComponent:str];
}

@end

#endif
@implementation EBookLocalStore
static EBookLocalStore *_defaultEBookLocalStore=nil;
+(id)defaultEBookLocalStore{
    @synchronized(self) {
        static dispatch_once_t predicate;
        
        dispatch_once(&predicate, ^{
            if (_defaultEBookLocalStore==nil) {
                _defaultEBookLocalStore=[[EBookLocalStore alloc] init];
            }
        });
    
    }
    return _defaultEBookLocalStore;
}


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    
    return success;
}
-(void)CreateEBookListPath{
    if (![[NSFileManager  defaultManager] fileExistsAtPath:EBookSaveRootPath]) {
        [[NSFileManager  defaultManager] createDirectoryAtPath:EBookSaveRootPath  withIntermediateDirectories:YES attributes:nil error:nil];
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:EBookSaveRootPath]];
    }
}
-(id)init{
    self=[super init];
    if (self) {
        [self CreateEBookListPath];
        requestQueue=[[ASINetworkQueue alloc]init];
        requestQueue.maxConcurrentOperationCount=3;
        //设置支持较高精度的进度追踪
        [requestQueue setShowAccurateProgress:YES];
        [requestQueue go];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ebooklistPath]) {
            
            //--------------------
            FMDatabase *db= [FMDatabase databaseWithPath:ebooklistPath];
            [db open];
            //            [db executeUpdate:@"CREATE TABLE downlink (format text, url text)"]; //创建表
            [db executeUpdate:@"CREATE TABLE downlink (format text, url text)"];
            FMResultSet *rs=[db executeQuery:@"SELECT * FROM downlink"];
            while ([rs next]){
                [[rs stringForColumn:@"url"] writeToFile:pathEn atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
            }
            Booklist=[NSMutableArray arrayWithContentsOfFile:pathEn];
            
            [db close];
            
            //--------------------
        }else{
            if ([[NSFileManager defaultManager] fileExistsAtPath:EBookListPath]) {
                Booklist=[NSMutableArray arrayWithContentsOfFile:EBookListPath];
            }else{
                Booklist =[NSMutableArray array];
                [Booklist writeToFile:EBookListPath atomically:YES];
            }
            
            FMDatabase *db= [FMDatabase databaseWithPath:ebooklistPath] ;
            [db open];
            [db executeUpdate:@"CREATE TABLE downlink (format text, url text)"];
            [db executeUpdate:@"INSERT INTO downlink (format,url) VALUES (?,?)",@"downlink",Booklist];
            [db close];
  
        }
        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:EBookListPath]) {
//            Booklist=[NSMutableArray arrayWithContentsOfFile:EBookListPath];
//        }
        if (Booklist==nil) {
            Booklist=[NSMutableArray array];
        }
        [Booklist retain];
        [self ReSetBookList];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorAddNewBookToDownloadFunction:) name:EBookLocalStorAddNewBookToDownload object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorDeleteBookFunction:) name:EBookLocalStorDeleteBook object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorStopDownFunction:) name:EBookLocalStorStopDown object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorReStartDownFunction:) name:EBookLocalStorReStartDown object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(SaveAllBook)
//                                                     name:UIApplicationDidEnterBackgroundNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(SaveAllBook)
//                                                     name:UIApplicationWillTerminateNotification
//                                                   object:nil];
        
    }
    return self;
}

+(BOOL)AddNewBookToDownload:(NSMutableDictionary*)bookInfor forzhuanti:(NSString*)zhuantiid
{
    if([bookInfor objectForKey:@"id"]!=nil)
    {
        NSString* tongjiurl=[NSString stringWithFormat:@"http://ring.dlmdj.com/Default.aspx?type=1&id=%@",[bookInfor objectForKey:@"id"] ];
        if(zhuantiid!=nil)
        {
            tongjiurl= [NSString stringWithFormat:@"%@&zhuantiid=%@",tongjiurl,zhuantiid];
        }
        
        if([[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"]!=nil)
        {
            tongjiurl= [NSString stringWithFormat:@"%@&productid=%@",tongjiurl,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"itunesconnectappleid"]];
            
        }
        
        DownloadHelper *dldHelper = [[[DownloadHelper alloc] init] autorelease];
        [dldHelper download:tongjiurl];
        
    }
    return  [self AddNewBookToDownload:bookInfor];
}



+(BOOL)AddNewBookToDownload:(NSMutableDictionary*)bookInfor{
    int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:bookInfor];
    
    if (status==-1) {
        [[NSNotificationCenter defaultCenter]  postNotificationName:EBookLocalStorAddNewBookToDownload  object:nil userInfo:bookInfor];
        /*百度事件统计,传入的数据为:eventId,eventLabel
         1=其他
         100004=小书城启动次数
         100003=热门推荐点击次数
         100002=强制营销点击次数
         100001=图书阅读次数
         100000=图书下载次数
         */
//        if([bookInfor objectForKey:@"name"]!=nil)
//        {
//
//        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BaiduMobStat-CustomEventNotification"  object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"100000",[bookInfor objectForKey:@"name"], nil]  forKeys:[NSArray arrayWithObjects:@"eventId",@"eventLabel", nil] ]];
//        }
        return YES;
    }else if([[EBookLocalStore defaultEBookLocalStore] CheckBookListErrorExistsAtBookInfor:bookInfor]) {
        //下载出现错误或者没有完成，重新下载
        [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorReStartDown object:nil userInfo:bookInfor];
        return YES;
    }else {
        return NO;
    }
}

+ (NSMutableDictionary*)samedicinbooklist:(NSDictionary*)dic{
    
    return   [[EBookLocalStore defaultEBookLocalStore] samefordic: dic];
}

- (NSMutableDictionary*)samefordic:(NSDictionary*)bookInfor{

    NSInteger arrindex=[Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj objectForKey:@"id"] isEqualToString:[bookInfor objectForKey:@"id"]] ;
    }];
    
    if(arrindex!=NSNotFound){
        return  [Booklist objectAtIndex:arrindex];
    }
    else{
        return nil;
    }

}

//下载 必填信息：name,url
-(void)EBookLocalStorAddNewBookToDownloadFunction:(NSNotification *)notification{
    NSMutableDictionary *bookInfor=[NSMutableDictionary dictionaryWithDictionary: [notification userInfo]];
    if ([self CheckBookListExistsAtrequestQueue:bookInfor]==nil) {
        [bookInfor setValue:@"0" forKey:@"status"];
        //0 表示：下载中
        //1 表示下载完成
        //2:表示下载错误
        //3：表示解压错误
        //4：表示重复下载
        //5:下载未完成
        NSURL *ur=[NSURL URLWithString:[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[bookInfor objectForKey:@"url"], NULL, NULL, kCFStringEncodingUTF8) autorelease]];
        ASIHTTPRequest *requst=[ASIHTTPRequest requestWithURL:ur];
        requst.userInfo=bookInfor;
        [requst setDownloadProgressDelegate:self];
        [requst setDelegate:self];
        NSString *currentPath=[self GetBookRootPath:bookInfor];
        NSString *downloadPath=[NSString stringWithFormat:@"%@.zip" ,currentPath];
        NSString *tempPath=[NSString stringWithFormat:@"%@.zip.temp" ,currentPath];
        //设置下载路径
        [requst setDownloadDestinationPath:downloadPath];
        //设置缓存路径
        [requst setTemporaryFileDownloadPath:tempPath];
        //设置支持断点续传
        [requst setAllowResumeForFileDownloads:YES];
        [requst setDidFinishSelector:@selector(requestDone:)];
        [requst setDidFailSelector:@selector(requestWentWrong:)];
        [requestQueue addOperation:requst];
        [Booklist insertObject:bookInfor  atIndex:0];
        [self SaveAllBook];
    }else {
        //该资源正在下载中...重复下载
//        [bookInfor setValue:@"4" forKey:@"status"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorRepeatDown object:nil userInfo:bookInfor];
    }
}

- (void)requestDone:(ASIHTTPRequest *)request{
    [NSThread detachNewThreadSelector:@selector(ZipData:) toTarget:self withObject: request];
}

-(void)ZipData:(ASIHTTPRequest *)request{
    @autoreleasepool {
        NSMutableDictionary *bookInfor = (NSMutableDictionary *)request.userInfo;
        NSString *currentZipPath=request.downloadDestinationPath ;
        NSFileManager *fm=[NSFileManager defaultManager];
        /* if (![fm fileExistsAtPath:currentPath]) {
         [fm createDirectoryAtPath:currentPath withIntermediateDirectories:YES attributes:nil error:nil];
         }*/
        
        BOOL issuccess=NO;
        if ([fm fileExistsAtPath:currentZipPath]) {
            
            BLepubinfoelement*metadata=[BLepub getEpubookinfofrompath:currentZipPath cachpath:[currentZipPath stringByDeletingPathExtension]];
            
            if(metadata.spine==nil||[metadata.spine count]==0){
                ZipArchive *zip=[[ZipArchive alloc]init];
#warning 标注-解密
//                NSString *passwordStr = bookInfor[@"password"];
                //带密码的文件
//                [zip UnzipOpenFile:currentZipPath Password:@"QWERTYUIOP"];
                [zip UnzipOpenFile:currentZipPath Password:@"SOREVENGE"];

                issuccess=[zip UnzipFileTo:[currentZipPath stringByDeletingPathExtension] overWrite:YES];
                if (![fm removeItemAtPath:currentZipPath error:nil]) {
                     CYLog(@"delete err");
                }
                [zip UnzipCloseFile];
                [zip release];
                
            }else{
                NSMutableArray* muti=[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:2],[NSArray arrayWithObject:[currentZipPath stringByDeletingPathExtension]], nil];
                
                NSString*BLdisk=[[currentZipPath stringByDeletingPathExtension] stringByAppendingPathComponent:@"BLinfo"];
                if(![[NSFileManager defaultManager] fileExistsAtPath:BLdisk])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:BLdisk withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                NSArray* arr=[metadata bookComtentPathlist];
                
                NSArray*maybetitle=[metadata bookmaybetitles];
                
                NSMutableArray* contentarr=[NSMutableArray arrayWithCapacity:[arr count]];
                NSMutableArray* contentype=[NSMutableArray arrayWithCapacity:[arr count]];
                NSMutableArray* title=[NSMutableArray arrayWithCapacity:[arr count]];
                for(int i=0;i<[arr count];i++)
                {
                    @autoreleasepool {
                        NSString* onepath=[arr objectAtIndex:i];
                        
                        BLhtmlinfo* ele;
                        @try {
                            ele= [BLhtml getinfofromhtml:onepath];
                            
                            //删掉了读取过的html文件，减小内存使用
                            NSFileManager* mana=[NSFileManager defaultManager];
                            [mana removeItemAtPath:onepath error:nil];
                        }
                        @catch (NSException *exception) {
                            continue;
                        }
                        
                        
                        if(ele!=nil && ele.BLhtmlstr!=nil && ele.BLhtmlstr.length>0)
                        {
                            //                path=[BLdisk stringByAppendingPathComponent:[NSString stringWithFormat:@"ele%d",[contentarr count]]];
                            onepath=[NSString stringWithFormat:@"ele%lu",(unsigned long)[contentarr count]];
                            
                            
                            [contentarr addObject:onepath];
                            [contentype addObject:[NSNumber numberWithInt:2]];
                            [ele writetofile:[BLdisk stringByAppendingPathComponent:onepath]];
                            
                            if(ele.BLhtmltitle!=nil &&ele.BLhtmltitle.length>0)
                            {
                                [title addObject:ele.BLhtmltitle];
                            }
                            else
                            {
                                [title addObject:@""];
                            }
                        }
                    }
                }
                for(int i=0;i<[title count];i++)
                {
                    
                    if(![[title objectAtIndex:i]isKindOfClass:[NSString class]]||((NSString*)[title objectAtIndex:i]).length==0)
                    {
                        if([maybetitle count]>=[title count]-i)
                        {
                            NSInteger count=[title count];
                            [title removeObjectAtIndex:i];
                            [title insertObject:[maybetitle objectAtIndex:i-(count-[maybetitle count])] atIndex:i];
                        }
                    }
                }
                
                if([contentarr count]==0){
                    issuccess=NO;
                }else{
                    [muti addObject:contentarr];
                    [muti addObject:contentype];
                    [muti addObject:title];
                    [muti writeToFile:[BLdisk stringByAppendingPathComponent:@"BLinfo"] atomically:YES];
                    
                    issuccess=YES;
                    [bookInfor setObject:[NSNumber numberWithBool:YES] forKey:@"isepub"];
                }
            }
        }
        
        if (!issuccess ){
            
            [bookInfor setValue:@"3" forKey:@"status"];
//            NSError * zipError = [NSError errorWithDomain:[NSString  stringWithFormat:@"ZipArchiveError %@",currentZipPath] code:100001 userInfo:[NSDictionary dictionaryWithObject:@"解压失败"  forKey:@"ZipArchiveFaile"]];
            //            [bookInfor setObject:zipError  forKey:@"error"];
            //        [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorRequestError object:nil userInfo:bookInfor];
            [self performSelector:@selector(BoMainThread:) onThread:[NSThread mainThread] withObject:bookInfor waitUntilDone:NO];

        }else{
            [bookInfor setValue:@"1" forKey:@"status"];
            NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithDictionary:bookInfor];
            [dir setObject:[NSNumber numberWithFloat:1.0]  forKey:@"percent"];
            [self performSelector:@selector(BringToMainThread:) onThread:[NSThread mainThread] withObject:dir waitUntilDone:NO];
        }
//        //保存下载后的状态
//        for (int a = 0; a < Booklist.count; a++) {
//            NSDictionary *bookDic = [NSDictionary dictionaryWithDictionary:Booklist[a]];
//            if (bookDic[@"url"] == bookInfor[@"url"]) {
//                [Booklist replaceObjectAtIndex:a withObject:bookInfor];
//                break;
//            }
//        }
        [self SaveAllBook];
    }
}

-(void)BoMainThread:(NSMutableDictionary *)dir{
    [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorRequestError object:nil userInfo:dir];
    
}


-(void)BringToMainThread:(NSMutableDictionary *)dir{
    SystemSoundID soundID4;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"on" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)fileUrl, &soundID4);
    //播放
    AudioServicesPlaySystemSound(soundID4);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorRequestDone object:nil userInfo:dir];
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    NSMutableDictionary *bookInfor = (NSMutableDictionary *)request.userInfo;
    NSNumber* numbb=[bookInfor objectForKey:@"percent"];
    
//    [bookInfor setObject:[NSNumber numberWithFloat:(float)(request.totalBytesRead+request.partialDownloadSize)/(request.contentLength+request.partialDownloadSize)]  forKey:@"percent"];
    
    float pre=[numbb floatValue];
    float percen=(float)(request.totalBytesRead+request.partialDownloadSize)/(request.contentLength+request.partialDownloadSize);
    if( percen-pre>=0.01 ||percen==1)
    {
        
        [bookInfor setObject:[NSNumber numberWithFloat:percen]  forKey:@"percent"];
         [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStoreProgressUpdate object:nil userInfo:bookInfor];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request{
    NSMutableDictionary *bookInfor=(NSMutableDictionary *)request.userInfo;
    
    if([bookInfor isKindOfClass:[NSMutableDictionary class]])
    {
        [bookInfor setValue:@"2" forKey:@"status"];
        [self performSelector:@selector(BoMainThread:) onThread:[NSThread mainThread] withObject:bookInfor waitUntilDone:NO];
    }
}

+(void)DeleteBook:(NSDictionary*)bookInfor{
    [EBookLocalStore defaultEBookLocalStore];
    [[NSNotificationCenter defaultCenter]  postNotificationName:EBookLocalStorDeleteBook  object:nil userInfo:bookInfor];
}
-(void)EBookLocalStorDeleteBookFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
    
//    if([bookInfor objectForKey:@"id"]==nil)
//    {
//
//        [[BLwifistore defaultBLwifistore] BLdeletebook:bookInfor];
//        return;
//    }
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:EBookLocalStorStopDown  object:nil userInfo:bookInfor];
    NSInteger objectindex=[Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        return [[obj objectForKey:@"url"] isEqualToString:[bookInfor objectForKey:@"url"]] ;
    }];
    NSFileManager *fm=[NSFileManager defaultManager];
    if (objectindex!=NSNotFound ) {
        NSString *currentPath=[self GetBookRootPath:bookInfor];
        if ([fm fileExistsAtPath:currentPath]) {
            [fm removeItemAtPath:currentPath  error:nil];
        }
        [Booklist removeObjectAtIndex:objectindex];
    }
    [self SaveAllBook];
    [fm ClearBookCacheDataWithKeyWord:[[bookInfor objectForKey:@"url"] MD5String]];
}
+(void)StopToDownloadBook:(NSDictionary*)bookInfor{
    [EBookLocalStore defaultEBookLocalStore];
    [[NSNotificationCenter defaultCenter]  postNotificationName:EBookLocalStorStopDown  object:nil userInfo:bookInfor];
}
-(void)EBookLocalStorStopDownFunction:(NSNotification *)notification{
    NSMutableDictionary *bookInfor=( NSMutableDictionary *)[notification userInfo];
    ASIHTTPRequest *requst=[self CheckBookListExistsAtrequestQueue:bookInfor];
    if (requst!=nil) {
      
        [requst.userInfo setValue:@"5" forKey:@"status"];
        
        if(requst.totalBytesRead==0)
        {
            requst.userInfo=nil;
        }
        requst.delegate=nil;
        requst.userInfo=nil;
        requst.url=nil;
        requst.downloadDestinationPath=nil;
        requst.temporaryFileDownloadPath=nil;
        [requst clearDelegatesAndCancel];
        
    }
    [self SaveAllBook];
}
+(void)ReStartToDownloadBook:(NSDictionary*)bookInfor{
    [EBookLocalStore defaultEBookLocalStore];
    [[NSNotificationCenter defaultCenter]  postNotificationName:EBookLocalStorReStartDown  object:nil userInfo:bookInfor];
}
-(void)EBookLocalStorReStartDownFunction:(NSNotification *)notification{
    
    NSInteger objectindex=[self ErrorBookinforIndexForBookList:[notification userInfo]];
    if (objectindex!=NSNotFound ) {
        NSMutableDictionary *bookInfor=[Booklist objectAtIndex: objectindex];
        if([[bookInfor objectForKey:@"status"] intValue]!=5)
        {
            NSString *currentPath=[self GetBookRootPath:bookInfor];
            NSString *downloadPath=[NSString stringWithFormat:@"%@.zip" ,currentPath];
            NSString *tempPath=[NSString stringWithFormat:@"%@.zip.temp" ,currentPath];
            if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager]removeItemAtPath:downloadPath error:nil];
            }
            if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
            {
                [[NSFileManager defaultManager]removeItemAtPath:tempPath error:nil];
            }
        }
        
        if ([self CheckBookListExistsAtrequestQueue:bookInfor]==nil) {
            [bookInfor setValue:@"0" forKey:@"status"];
            NSURL *ur=[NSURL URLWithString:[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[bookInfor objectForKey:@"url"], NULL, NULL, kCFStringEncodingUTF8) autorelease]];
                        
            ASIHTTPRequest *requst=[ASIHTTPRequest requestWithURL:ur];
            requst.userInfo=bookInfor;
            [requst setDownloadProgressDelegate:self];
            [requst setDelegate:self];
            
            NSString *currentPath=[self GetBookRootPath:bookInfor];
            NSString *downloadPath=[NSString stringWithFormat:@"%@.zip" ,currentPath];
            NSString *tempPath=[NSString stringWithFormat:@"%@.zip.temp" ,currentPath];
            //设置下载路径
            [requst setDownloadDestinationPath:downloadPath];
            //设置缓存路径
            [requst setTemporaryFileDownloadPath:tempPath];
            //设置支持断点续传
            [requst setAllowResumeForFileDownloads:YES];
            [requst setDidFinishSelector:@selector(requestDone:)];
            [requst setDidFailSelector:@selector(requestWentWrong:)];
            [requestQueue addOperation:requst];
            [self SaveAllBook];
        }else{
            //该资源正在下载中...重复下载
//            [bookInfor setValue:@"4" forKey:@"status"];
            [[NSNotificationCenter defaultCenter] postNotificationName:EBookLocalStorRepeatDown object:nil userInfo:bookInfor];
        }
    }
    
}
//返回书籍的章节列表，以及章节的文件路径.
-(NSMutableArray*)ObtainBookChapterList:(NSDictionary*)bookInfor{
    NSMutableArray *chapterlist;
    NSString *currentPath=[self GetBookRootPath:bookInfor];
    NSString *xmlpath=[currentPath stringByAppendingPathComponent: [self GetBookMainCatalogXml:currentPath]];
  	XmlDataSet *data=[[XmlDataSet alloc] init];
    NSData *theData=[NSData dataWithContentsOfFile:xmlpath];
    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"item"];
	[data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
    if([data.Rows count]>0){
        chapterlist=data.Rows ;
    }else{
        chapterlist=[NSMutableArray arrayWithCapacity:0];
    }
	[data release];
    return  chapterlist;
}

-(NSString*)ObtainBookChapterContentForPath:(NSDictionary*)bookInfor ChapterPath:(NSString*)chapterPath{
    NSString *currentPath=[self GetBookRootPath:bookInfor];
    currentPath=[currentPath stringByAppendingPathComponent:chapterPath];
    NSData *thedata= [NSData dataWithContentsOfFile:currentPath] ;
    NSString *str=[[[NSString alloc] initWithData:thedata encoding:NSUTF8StringEncoding] autorelease];
    if (str==nil) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        str=[[[NSString alloc] initWithData:thedata encoding:gbkEncoding] autorelease];
    }
    return str;
}
//获取书籍的主目录的XML地址，相对地址
-(NSString*)GetBookMainCatalogXml:(NSString*)currentPath{
    NSString *mainxml=@"";
    NSString *pattern=@"*.xml";
    pattern=[pattern stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    pattern=[pattern stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    pattern=[pattern stringByReplacingOccurrencesOfString:@"?" withString:@".?"];
    pattern=[NSString stringWithFormat:@"^%@$",pattern];
    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    BOOL isDir = NO;
    NSFileManager *filemanager=[NSFileManager defaultManager];
    NSArray *fileList=[filemanager contentsOfDirectoryAtPath:currentPath error:nil];
    for (NSString *file in fileList) {
        if ([reg numberOfMatchesInString:file  options: NSMatchingReportCompletion range:NSMakeRange(0,[file length]) ]>0) {
            NSString *filepath = [currentPath stringByAppendingPathComponent:file];
            [filemanager fileExistsAtPath:filepath isDirectory:(&isDir)];
            if (!isDir) {
                mainxml=file;
                break;
            }
        }
        isDir = NO;
    }
    return mainxml;
}
-(NSString*)GetBookRootPath:(NSDictionary*)bookInfor{
    return [EBookSaveRootPath stringByAppendingPathComponent:[[bookInfor objectForKey:@"url"] MD5String]];
}
-(BOOL)CheckBookListExistsAtBookInfor:(NSDictionary*)bookInfor{
    return [self BookinforIndexForBookList:bookInfor]!=NSNotFound;
}
-(NSInteger)BookinforIndexForBookList:(NSDictionary*)bookInfor{
    NSInteger arrindex=[Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj objectForKey:@"url"] isEqualToString:[bookInfor objectForKey:@"url"]] && [[obj objectForKey:@"status"] intValue]==1;
    }];
    return arrindex;
}
-(int)CheckBookListStatusAtBookInfor:(NSDictionary*)bookInfor{
    NSInteger arrindex = [Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj objectForKey:@"source"]!=nil && [bookInfor objectForKey:@"source"]!=nil) {
            return [[obj objectForKey:@"source"] isEqualToString:[bookInfor objectForKey:@"source"]];
        }
        if ([obj objectForKey:@"id"]!=nil && [bookInfor objectForKey:@"id"]!=nil) {
            return [[obj objectForKey:@"id"] isEqualToString:[bookInfor objectForKey:@"id"]];
        }
        return [[obj objectForKey:@"url"] isEqualToString:[bookInfor objectForKey:@"url"]];
    }];
    if (arrindex!=NSNotFound) {
        return  [[[Booklist objectAtIndex: arrindex] objectForKey:@"status"] intValue];
    }
    return -1;
}
-(BOOL)CheckBookListErrorExistsAtBookInfor:(NSDictionary*)bookInfor{
    return [self ErrorBookinforIndexForBookList:bookInfor]!=NSNotFound;
}
-(NSInteger)ErrorBookinforIndexForBookList:(NSDictionary*)bookInfor{
    NSInteger arrindex=[Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj objectForKey:@"url"] isEqualToString:[bookInfor objectForKey:@"url"]] &&( [[obj objectForKey:@"status"] intValue]==2 || [[obj objectForKey:@"status"] intValue]==3|| [[obj objectForKey:@"status"] intValue]==5);
    }];
    return arrindex;
}

-(void)ReSetBookList{
//    NSFileManager *fm=[NSFileManager defaultManager]; //9号  ebooklocalstore.m fm nerverread
    for (int i=0; i<[Booklist count]; i++) {
        NSMutableDictionary* bookInfor=[Booklist objectAtIndex:i];
        if ([[bookInfor objectForKey:@"status"] intValue]!=1) {
            [bookInfor setValue:@"5" forKey:@"status"];
        }else{
//            NSString *currentPath=[self GetBookRootPath:bookInfor];
//            if (![fm fileExistsAtPath:currentPath]) {
//                [bookInfor setValue:@"5" forKey:@"status"];
//            }
        }
    }
}
-(ASIHTTPRequest *)CheckBookListExistsAtrequestQueue:(NSDictionary*)bookInfor{
    ASIHTTPRequest *requst=nil;
    NSInteger arrindex=[[requestQueue operations] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        ASIHTTPRequest *requst=(ASIHTTPRequest *)obj;
        return [[requst.userInfo objectForKey:@"url"] isEqualToString:[bookInfor objectForKey:@"url"]];
    }];
    if (arrindex!=NSNotFound) {
        requst=[[requestQueue operations] objectAtIndex: arrindex];
    }
    return requst;
}
-(NSArray*)SearchBookListWithKeyWord:(NSPredicate*)keywordPredicate{
    NSIndexSet *arrindexs=[Booklist indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return  [keywordPredicate evaluateWithObject:obj] ;
    }];
    return [Booklist objectsAtIndexes:arrindexs];
}
-(void)SaveAllBook{
    
    FMDatabase *db= [FMDatabase databaseWithPath:ebooklistPath] ;
    [db open];
    [db executeUpdate:@"DELETE FROM downlink"];
    [db executeUpdate:@"INSERT INTO downlink (format,url) VALUES (?,?)",@"downlink",Booklist];
    
    [db close];
    
    [Booklist writeToFile:EBookListPath atomically:YES];
}
-(NSDictionary*)ObtainEBookLocalStoreInfor{
    //获取读书相关信息,downcount:下载总数 reandcount:阅读次数
    //    int reandcount;
    //    //contentsOfDirectoryAtPath
    //    NSFileManager *fm=[NSFileManager defaultManager];
    //    reandcount=[[fm contentsOfDirectoryAtPath:[fm CreateBookPageSegmentsDirectory]  error:nil] count];
    //    if (reandcount<0) {
    //        reandcount=0;
    //    }
    
    
    
    int bookreadedcount=0;
    for(int i=0;i<[Booklist count];i++)
    {
        NSDictionary* dic=[Booklist objectAtIndex:i];
        if([dic objectForKey:@"blbookisreaded"]!=nil)
        {
            bookreadedcount++;
        }
    }
    
    
    
    return [NSDictionary dictionaryWithObjects:
            [NSArray arrayWithObjects:
             [NSNumber numberWithInteger: [Booklist count]],[NSNumber numberWithInt:bookreadedcount],nil]
                                       forKeys:
            [NSArray arrayWithObjects:@"downcount",@"reandcount", nil]];
}
-(NSDictionary*)ObtainEBookLocalStoreDownloadedInfor{
    //获取读书相关信息,downcount:已下载总数 reandcount:阅读次数
    NSInteger reandcount;
    //contentsOfDirectoryAtPath
    NSFileManager *fm=[NSFileManager defaultManager];
    reandcount=[[fm contentsOfDirectoryAtPath:[fm CreateBookPageSegmentsDirectory]  error:nil] count];
    if (reandcount<0) {
        reandcount=0;
    }
    
    NSPredicate *keywordPredicate=[NSPredicate predicateWithFormat:@"status ='1'"];
    NSIndexSet *arrindexs=[Booklist indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return  [keywordPredicate evaluateWithObject:obj] ;
    }];
    
    return [NSDictionary dictionaryWithObjects:
            [NSArray arrayWithObjects:
             [NSNumber numberWithInteger: [arrindexs count]],[NSNumber numberWithInteger:reandcount],nil]
                                       forKeys:
            [NSArray arrayWithObjects:@"downcount",@"reandcount", nil]];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

//吕 -- 添加
-(NSMutableDictionary *)handelBookInfoMethod:(NSMutableDictionary *)bookDic{
    NSInteger arrindex=[Booklist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj objectForKey:@"source"]!=nil && [bookDic objectForKey:@"source"]!=nil) {
            return [[obj objectForKey:@"source"] isEqualToString:[bookDic objectForKey:@"source"]];
        }
        return [[obj objectForKey:@"id"] isEqualToString:[bookDic objectForKey:@"id"]];
    }];
    if (arrindex!=NSNotFound) {
        return  [Booklist objectAtIndex: arrindex];
    }
    return nil;
}
@end
