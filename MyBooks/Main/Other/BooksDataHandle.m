//
//  BooksDataHandle.m
//  OfficerEye
//
//  Created by apple on 14-1-17.
//  Copyright (c) 2014年 北邮3G. All rights reserved.
//

#import "BooksDataHandle.h"
//#import "TextBookDataEnqin.h"
//#import "LeveyTabBarItem.h"

#define localbooksavepath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"localbook.plist"]
#define allbooksavepath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"allbook.plist"]
#define latestReadingsavepath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"latestReading.plist"]
#define latestReadingCount 3
static BooksDataHandle *booksDH=nil;

@implementation BooksDataHandle
@synthesize localArr,downloadArr,deleteLocalArr,TextData,delegate,wifiArr;
@synthesize allBookArr,latestReadingArr;
- (void)dealloc
{
    [localArr release];
    [downloadArr release];
    [deleteLocalArr release];
    [TextData release];
    [wifiArr release];
    [allBookArr release];
    [latestReadingArr release];
    [super dealloc];
}
+(id)booksDHInitMethod{
    @synchronized(self) {
        if (booksDH==nil) {
            booksDH=[[BooksDataHandle alloc] init];
        }
    }
    return booksDH;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self getDataArrMethod];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveloacal) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorDeleteBookFunction:) name:EBookLocalStorDeleteBook object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveloacal) name:@"EndBookReadingNotification" object:nil];
        //wifi
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upWifiSuccessMethod) name:BLwifistorerefresh object:nil];
        
    }
    return self;
}
#pragma mark - 初始化得到书籍信息
-(void)getDataArrMethod{
    
         self.downloadArr=[NSMutableArray arrayWithArray: [[EBookLocalStore defaultEBookLocalStore] SearchBookListWithKeyWord:[NSPredicate predicateWithFormat:@"name !=''"]]];
        for(int i=0 ;i<[self.downloadArr count];i++)
        {
            NSMutableDictionary* dic=[self.downloadArr objectAtIndex:i];
    
            if([[dic objectForKey:@"status"]intValue]!=1)
            {
                [self.downloadArr removeObjectAtIndex:i];
            }
        }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:allbooksavepath]) {
        self.allBookArr=[NSMutableArray arrayWithContentsOfFile:allbooksavepath];
    }else{
        //读取下载的图书
        NSString *fullpath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainFormDownloadRows.plist"];
        if ([[NSFileManager  defaultManager] fileExistsAtPath:fullpath]) {
            self.downloadArr=[NSMutableArray arrayWithContentsOfFile: fullpath];
            for(int i=0;i<[self.downloadArr count];i++)
            {
                NSMutableDictionary* onedic= [EBookLocalStore samedicinbooklist:[self.downloadArr objectAtIndex:i]];
                if(onedic !=nil)
                {
                    [self.downloadArr removeObjectAtIndex:i];
                    [self.downloadArr insertObject:onedic atIndex:i];
                }
            }
        }else{
            self.downloadArr=[NSMutableArray arrayWithArray: [[EBookLocalStore defaultEBookLocalStore] SearchBookListWithKeyWord:[NSPredicate predicateWithFormat:@"name !=''"]]];
            for(int i=0 ;i<[self.downloadArr count];i++)
            {
                NSMutableDictionary* dic=[self.downloadArr objectAtIndex:i];
                if([[dic objectForKey:@"status"]intValue]!=1)
                {
                    [self.downloadArr removeObjectAtIndex:i];
                }
            }
            if (self.downloadArr!=nil && downloadArr.count>0) {
                [self.downloadArr writeToFile:fullpath  atomically:YES];
            }
        }
        if (self.downloadArr==nil ) {
            self.downloadArr=[NSMutableArray array];
        }
        //获得本地书籍数组
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *tagVersion=[[NSUserDefaults standardUserDefaults] objectForKey:@"tagVersion"];
        if (tagVersion!=nil && [[NSFileManager defaultManager]fileExistsAtPath:localbooksavepath] && [version isEqualToString:tagVersion]) {
            self.localArr=[NSMutableArray arrayWithContentsOfFile:localbooksavepath];
        }else{
            NSString *idStr=@"";
            SqlClient *bk=[[SqlClient alloc] init];
            [bk OpenDataBase];
            self.localArr=[bk SelectALLBooksRow:idStr];
            [bk CloseDataBase];
            [bk release];
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tagVersion"];
        }
        //得到wifi上传的书籍的数组
        [self getwifiInfo];
        if (allBookArr==nil) {
            self.allBookArr=[NSMutableArray array];
            [self.allBookArr addObjectsFromArray:self.wifiArr];
            [self.allBookArr addObjectsFromArray:self.downloadArr];
            [self.allBookArr addObjectsFromArray:self.localArr];
        }
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:latestReadingsavepath]) {
        self.latestReadingArr=[NSMutableArray arrayWithContentsOfFile:latestReadingsavepath];
        for (int i=0; i<[latestReadingArr count];i++) {
            int tagIndex=[self selectBookIndex:[latestReadingArr objectAtIndex:i]];
            if (tagIndex!=-1) {
                [latestReadingArr removeObjectAtIndex:i];
                [latestReadingArr insertObject:[self GetCurrentDir:tagIndex] atIndex:i];
            }
        }
    }else{
        self.latestReadingArr=[NSMutableArray array];
    }
}
//保存所有的数组（主要是在变换位置之后处理）
+(void)saveAllArrMethod{
    [BooksDataHandle booksDHInitMethod];
    [booksDH saveAllArr];
}
-(void)saveAllArr{
    if (allBookArr!=nil) {
        [self.allBookArr writeToFile:localbooksavepath atomically:YES];
    }
    if (delegate && [delegate respondsToSelector:@selector(AllbookArrChangedreloadeTableDelegate)]) {
        [self.delegate AllbookArrChangedreloadeTableDelegate];
    }
}
#pragma mark - 得到从书城下载的书籍
- (void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification {
    NSDictionary *dir=[notification userInfo];
    NSInteger arrindex=[self.localArr indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        return [[obj objectForKey:@"title"] isEqualToString:[dir objectForKey:@"name"]] ;
    }];
    if (arrindex==NSNotFound ) {
        [self.downloadArr insertObject: dir atIndex:0];
        [[NSUserDefaults standardUserDefaults ] setInteger:[[NSUserDefaults standardUserDefaults ] integerForKey:@"currentIndex"]+1   forKey:@"currentIndex"];
        
        NSString *fullpath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainFormDownloadRows.plist"];
        [self.downloadArr writeToFile:fullpath  atomically:YES];
        if (allBookArr!=nil) {
            [self.allBookArr insertObject:dir atIndex:0];
            [self saveAllArr];
        }
        
        
        if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)]){
            [self.delegate reloadeTableDelegate];
        }
    }
}
#pragma mark - 删除从书城下载的书籍
- (void)EBookLocalStorDeleteBookFunction:(NSNotification *)notification
{
    NSDictionary *dir=[notification userInfo];
    NSInteger arrindex=[self.downloadArr indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj objectForKey:@"name"] isEqualToString:[dir objectForKey:@"name"]];
    }];
    if (arrindex!=NSNotFound) {
        [self.downloadArr removeObjectAtIndex:arrindex];
        [[NSUserDefaults standardUserDefaults ] setInteger:[[NSUserDefaults standardUserDefaults ] integerForKey:@"currentIndex"]-1   forKey:@"currentIndex"];
        NSString *fullpath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainFormDownloadRows.plist"];
        [self.downloadArr writeToFile:fullpath  atomically:YES];
        
        if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)])
        {
            [self.delegate reloadeTableDelegate];
        }
    }
}
#pragma mark -传输本地书籍数组
+(NSMutableArray *)transferLocalArr;{
    [BooksDataHandle booksDHInitMethod];
    return booksDH.localArr;
}
#pragma mark -传输下载和的书籍数组
+(NSMutableArray *)transferDownloadArr{
    [BooksDataHandle booksDHInitMethod];
    return booksDH.downloadArr;
}
#pragma mark -传输所有的书籍数组
+(NSMutableArray *)transferAllBookArr{
    [BooksDataHandle booksDHInitMethod];
    return booksDH.allBookArr;
}
#pragma mark -传输最近阅读的书籍数组
+(NSMutableArray *)transferLatestReadingArr{
    [BooksDataHandle booksDHInitMethod];
    return booksDH.latestReadingArr;
}

#pragma mark -保存数据

- (void)saveloacal {
    [self saveLatestReadingMethod];//保存最近阅读的数组
    [self saveAllArr];//保存所有的数组
    
    [self.localArr writeToFile:localbooksavepath atomically:YES];//如果书架显示阅读进度，则打开，否则关闭
    NSString *fullpath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainFormDownloadRows.plist"];
    
    [self.downloadArr writeToFile:fullpath atomically:YES];
    if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)]) {
        [self.delegate reloadeTableDelegate];
    }
}
#pragma mark -设置代理执行的类
+(void)setDelegate:(id)VeiwCon{
    [BooksDataHandle booksDHInitMethod];
    booksDH.delegate=VeiwCon;
}
#pragma mark -当前书籍字典
+ (NSMutableDictionary *)getCurrentDic:(NSInteger)currentRow{
    [BooksDataHandle booksDHInitMethod];
    return [booksDH GetCurrentDir:currentRow];
}
- (NSMutableDictionary *)GetCurrentDir:(NSInteger)row{
    if (row>=0&&row<[self.wifiArr count]) {
        return [self.wifiArr objectAtIndex:row];
    }else if ([self.wifiArr count]<=row && row<([self.wifiArr count]+[self.downloadArr count])) {
        NSInteger inde=row-[self.wifiArr count];
        
        NSMutableDictionary *onedic=[self.downloadArr objectAtIndex:inde];
        NSMutableDictionary* dic=[[EBookLocalStore defaultEBookLocalStore] samefordic:onedic];
        if(dic!=nil)
        {
            onedic=dic;
        }
        
        return onedic;
        
    } else if (row>=([self.wifiArr count]+[self.downloadArr count])&& row<([self.wifiArr count]+[self.downloadArr count]+[self.localArr count] )) {
        NSInteger index=row-([self.wifiArr count]+[self.downloadArr count]);
        return  [self.localArr objectAtIndex:index];
    }
    return nil;
}
#pragma mark -根据书籍字典删除书籍
#pragma mark -根据书籍字典删除书籍
+(void)deleteBookFromDic:(NSDictionary *)deleteBookDic{
    [BooksDataHandle booksDHInitMethod];
    [booksDH getWillDeleteDic:deleteBookDic];
}

-(void)getWillDeleteDic:(NSDictionary *)deleteDic{
    int selectBookTag=[booksDH selectBookIndex:deleteDic];
    [self.latestReadingArr removeObject:deleteDic];
    if (selectBookTag!=-1) {
        [self deleteFromAllArrs:deleteDic];
        delteIndex=selectBookTag;
        [self deleteMethod];
    }
    
}
//从所有的数组里面删除数据
-(void)deleteFromAllArrs:(NSDictionary *)willDeleteArr{
    if (allBookArr!=nil) {
        
        [self.allBookArr removeObject:willDeleteArr];
    }
    [self saveAllArr];
}

#pragma mark -根据下标删除书籍
+(void)deleteBooks:(int)deleteBookTag{
    [BooksDataHandle booksDHInitMethod];
    [booksDH deleteAlert:deleteBookTag];
}
-(void)deleteAlert:(int)alertTag{
    UIAlertView *alert;
    delteIndex=alertTag;
    if ([[self GetCurrentDir:alertTag] objectForKey:@"image"]!=nil) {
        alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定要删除《%@》吗？",[[self GetCurrentDir:delteIndex] objectForKey:@"title"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }else{
        if (delteIndex<[self.wifiArr count]) {
            alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定要删除《%@》吗？",[[self GetCurrentDir:delteIndex] objectForKey:@"name"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }else{
            alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定要删除《%@》吗？",[[self GetCurrentDir:delteIndex] objectForKey:@"title"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
    }
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self deleteMethod];
    }
}
-(void)deleteMethod{
    if ([[self GetCurrentDir:delteIndex] objectForKey:@"image"]!=nil) {
        [self.localArr removeObject:[self GetCurrentDir:delteIndex]];
        
        if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)])
        {
            [self.delegate reloadeTableDelegate];
        }
        
    }else{
        if (delteIndex<[self.wifiArr count]) {
            
//            [[BLwifistore defaultBLwifistore] BLdeletebook:[self.wifiArr objectAtIndex:delteIndex]];
            [self refreshView];
            
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self GetCurrentDir:delteIndex] objectForKey:@"source"]];
            [EBookLocalStore DeleteBook:[self GetCurrentDir:delteIndex]];
        }
    }
}

#pragma mark    -WiFi上传书籍数组
+(NSMutableArray *)transferWifiArr{
    [BooksDataHandle booksDHInitMethod];
    return booksDH.wifiArr;
}

//上传wifi数据成功
-(void)upWifiSuccessMethod{
    [self getwifiInfo];
    
    if (allBookArr!=nil && self.wifiArr.count > 0) {
        [self.allBookArr insertObject:[self.wifiArr objectAtIndex:0] atIndex:0];
        [self saveAllArr];
    }
    if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)]) {
        [self.delegate reloadeTableDelegate];
    }
}

//删除wifi数据后刷新
-(void)refreshView{
    [self getwifiInfo];
    if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)]) {
        [self.delegate reloadeTableDelegate];
    }
}

//得到wifi的数据
-(void)getwifiInfo{
//    self.wifiArr  = [[BLwifistore defaultBLwifistore] bookarray];
}

#pragma mark -选中图书，准备阅读

+ (void)willReadingBookMethod:(NSDictionary *)selectBook{
    [BooksDataHandle booksDHInitMethod];
    NSInteger selectBookTag=[booksDH selectBookIndex:selectBook];
    if (selectBookTag != -1) {
        [booksDH gotoReadMethod:selectBookTag];
    }
}

//获取书的索引
- (int)selectBookIndex:(NSDictionary *)bookDic{
    NSMutableArray *allArrs=[NSMutableArray array];
    
    [allArrs addObjectsFromArray:self.wifiArr];
    [allArrs addObjectsFromArray:self.downloadArr];
    [allArrs addObjectsFromArray:self.localArr];
    int arrindex = (int)[allArrs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj objectForKey:@"title"] isEqualToString:[bookDic objectForKey:@"title"]];
    }];
    
    if (arrindex != NSNotFound) {
        return arrindex;
    }
    return -1;
}

/**
 开始阅读书籍

 @param selectTags 输的索引
 */
- (void)gotoReadMethod:(NSInteger)selectTags{
    NSMutableDictionary *bookinfor=[BooksDataHandle getCurrentDic:selectTags];
    [self giveLatestReadingDic:bookinfor];//给最近阅读的书籍
    if (selectTags<([wifiArr count]+[downloadArr count])) {//读取WiFi或者网络下载数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartBookReadingNotification" object:nil userInfo:bookinfor];
    }else{//阅读本地数据
        //存储正在阅读的书籍
        [[NSUserDefaults standardUserDefaults] setObject:[bookinfor objectForKey:@"title"] forKey:@"isReading"];
        //存储最近阅读的书籍
        [[NSUserDefaults standardUserDefaults] setObject:bookinfor forKey:@"LatestReadedBook"];
        
        [self StartReadingBook:bookinfor];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartLocalBookReadingNotification" object:nil userInfo:bookinfor];
    }
}

//得到最近阅读的书籍的数组
- (void)giveLatestReadingDic:(NSMutableDictionary *)latestDic{
    if (latestReadingArr.count<1) {
        [self.latestReadingArr insertObject:latestDic atIndex:0];
    }else{
        if ([latestDic objectForKey:@"title"]==nil &&[latestDic objectForKey:@"name"]!=nil) {
            [latestDic setObject:[latestDic objectForKey:@"name"] forKey:@"title"];
        }
        NSInteger arrindex=[self.latestReadingArr indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
            return [[obj objectForKey:@"title"] isEqualToString:[latestDic objectForKey:@"title"]] ;
        }];
        if (arrindex==NSNotFound) {
            [self.latestReadingArr insertObject:latestDic atIndex:0];
            if (self.latestReadingArr.count>latestReadingCount) {
                [self.latestReadingArr removeLastObject];
            }
        }
    }
    [self saveLatestReadingMethod];
}

//保存最近阅读
- (void)saveLatestReadingMethod{
    [self.latestReadingArr writeToFile:latestReadingsavepath atomically:YES];
    if (delegate && [delegate respondsToSelector:@selector(reloadeTableDelegate)]) {
        [self.delegate reloadeTableDelegate];
    }
}

/**
 阅读本地书籍

 @param bookDics 书籍的信息（id,image,jianjie,title,zuoze）
 */
- (void)StartReadingBook:(NSMutableDictionary*)bookDics{
    NSMutableDictionary *dir=bookDics;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@-%@",[dir objectForKey:@"id"],[dir objectForKey:@"title"]]];
    //一、创建数据源，创建文本数据
    self.TextData=[[[TextBookDataEnqin alloc] init] autorelease];
    self.TextData.BookKeyWord=[NSString stringWithFormat:@"localbook-%@",[dir objectForKey:@"id"]];
    self.TextData.BookName=[dir objectForKey:@"title"];
    //获取书籍的章节，Title及对应的id
    self.TextData.bookInfor= [NSMutableArray arrayWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.plist", [[dir objectForKey:@"id"] intValue]]]];
    self.TextData.saveinfodic=dir;
    [SimpleTextBookReading ShowSimpleTextBookReadingWithDataEnqin:self.TextData adsDelegate:self chapterIndexDelegate:nil];
    /*百度事件统计,传入的数据为:eventId,eventLabel
     1=其他
     100004=小书城启动次数
     100003=热门推荐点击次数
     100002=强制营销点击次数
     100001=图书阅读次数
     100000=图书下载次数
     */
    if(self.TextData.BookName!=nil){
//        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BaiduMobStat-CustomEventNotification"  object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"100001",self.TextData.BookName, nil]  forKeys:[NSArray arrayWithObjects:@"eventId",@"eventLabel", nil]]];
    }
}
@end
