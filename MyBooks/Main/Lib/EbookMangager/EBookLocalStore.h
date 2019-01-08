
#define EBookSaveRootPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ebookdown"]

#define EBookListPath [EBookSaveRootPath stringByAppendingPathComponent:@"ebooklist.plist"]
#define EBookSpecialListPath [EBookSaveRootPath stringByAppendingPathComponent:@"ebookspeciallist_%@.plist"]

//重复下载
#define EBookLocalStorRepeatDown @"EBookLocalStorRepeatDown"
//开始下载
#define EBookLocalStorAddNewBookToDownload @"EBookLocalStorAddNewBookToDownload"
//下载中
#define EBookLocalStoreProgressUpdate @"EBookLocalStoreProgressUpdate"
//下载完成
#define EBookLocalStorRequestDone @"EBookLocalStorRequestDone"
//下载失败
#define EBookLocalStorRequestError @"EBookLocalStorRequestError"
//删除数据
#define EBookLocalStorDeleteBook @"EBookLocalStorDeleteBook"
//停止下载
#define EBookLocalStorStopDown @"EBookLocalStorStopDown"
//重新下载
#define EBookLocalStorReStartDown @"EBookLocalStorReStartDown"

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BLepub.h"
#import "BLhtml.h"
//#import "BLwifistore.h"
#import "DownloadHelper.h"

@interface UIImage(BLextern)

+ (UIImage*)imagefileNamed:(NSString *)name;

+ (UIImage*)catchimagenamed:(NSString *)name;

@end

@interface EBookLocalStore : NSObject{
    
     NSMutableArray *Booklist; /**< dir{name,url}*/
     ASINetworkQueue *requestQueue;
}

+ (BOOL)AddNewBookToDownload:(NSMutableDictionary*)bookInfor forzhuanti:(NSString*)zhuantiid  ;
+ (id)defaultEBookLocalStore;
+ (NSMutableDictionary*)samedicinbooklist:(NSDictionary*)dic;


/**
 添加一本图书

 @param bookInfor 必填信息：name,url。但不仅仅包含这2个字段
 @return 返回是否开始下载
 */
+ (BOOL)AddNewBookToDownload:(NSDictionary*)bookInfor;

/**
 删除某个图书

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 */
+ (void)DeleteBook:(NSDictionary*)bookInfor;

/**
 暂停某个图书的下载

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 */
+ (void)StopToDownloadBook:(NSDictionary*)bookInfor;

/**
 重新下载某个图书的下载

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 */
+ (void)ReStartToDownloadBook:(NSDictionary*)bookInfor;

/**
 检查某本书籍是否存在

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 @return 是否成功
 */
- (BOOL)CheckBookListExistsAtBookInfor:(NSDictionary*)bookInfor;

/**
 检查某本书籍的下载状态

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 @return 状态int
 */
- (int)CheckBookListStatusAtBookInfor:(NSDictionary*)bookInfor;

/**
 获取某本图书的目录列表。

 @param bookInfor 必填信息：name,url。只需包含这2个字段
 @return 图书的目录列表
 */
- (NSMutableArray*)ObtainBookChapterList:(NSDictionary*)bookInfor;

/**
 获取指定路径的文件类内
 */
- (NSString*)ObtainBookChapterContentForPath:(NSDictionary*)bookInfor ChapterPath:(NSString*)chapterPath;

/**
 使用谓词搜素图书,返回的是一个基于name,url字典的数组。但不仅仅包含这2个字段.
 //例如:[NSPredicate predicateWithFormat:@"name contains[cd] %@", keyword];
 //例如: [NSPredicate predicateWithFormat:@"name !=''"]
 */
- (NSArray*)SearchBookListWithKeyWord:(NSPredicate*)keywordPredicate;

/**
 保存数据
 */
- (void)SaveAllBook;

/**
 获取读书相关信息,downcount:下载总数 reandcount:阅读次数
 */
- (NSDictionary*)ObtainEBookLocalStoreInfor;

/**
 获取读书相关信息,downcount:已下载总数 reandcount:阅读次数
 */
- (NSDictionary*)ObtainEBookLocalStoreDownloadedInfor;

- (NSMutableDictionary*)samefordic:(NSDictionary*)dic;

//吕 -- 添加
- (NSMutableDictionary *)handelBookInfoMethod:(NSMutableDictionary *)bookDic;

-(NSString*)GetBookRootPath:(NSDictionary*)bookInfor;

@end
 
