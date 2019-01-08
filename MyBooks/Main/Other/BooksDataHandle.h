//
//  BooksDataHandle.h
//  OfficerEye
//
//  Created by apple on 14-1-17.
//  Copyright (c) 2014年 北邮3G. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class TextBookDataEnqin;
#import "TextBookDataEnqin.h"

@protocol BooksDataHandleDelegate <NSObject>
@optional

-(void)reloadeTableDelegate;//刷新的代理方法
-(void)changeBadgeValueDelegate;//改变书城按钮数字的代理
-(void)AllbookArrChangedreloadeTableDelegate;//所有书籍改变后刷新的代理方法
@end

@interface BooksDataHandle : NSObject{
    NSMutableArray *localArr;//本地书籍数据的数组
    NSMutableArray *downloadArr;//下载书籍数据的数组
    NSMutableArray *wifiArr;//WiFi传输书籍数据的数组
    NSMutableArray *deleteLocalArr;//删除的本地书籍数据的数组
    TextBookDataEnqin *TextData;//书籍阅读引擎
    
    NSMutableArray *allBookArr;//所有的书籍的数组
    NSMutableArray *latestReadingArr;//最近阅读的数组
    int delteIndex; //准备删除的数据位置
    id<BooksDataHandleDelegate>delegate;
}
@property(retain,nonatomic) NSMutableArray *localArr;//本地书籍数据的数组
@property(retain,nonatomic) NSMutableArray *downloadArr;//下载书籍数据的数组
@property(retain,nonatomic) NSMutableArray *wifiArr;//WiFi传输书籍数据的数组
@property(retain,nonatomic) NSMutableArray *deleteLocalArr;//删除的本地书籍数据的数组
@property(retain,nonatomic) TextBookDataEnqin *TextData;//书籍阅读引擎

@property(retain,nonatomic) NSMutableArray *allBookArr;//所有的书籍的数组
@property(retain,nonatomic) NSMutableArray *latestReadingArr;//最近阅读的数组
@property(assign,nonatomic) id<BooksDataHandleDelegate>delegate;

+(id)booksDHInitMethod;//初始化自身类
+(NSMutableArray *)transferLocalArr;//传输本地书籍数组
+(NSMutableArray *)transferDownloadArr;//传输下载的书籍数组
+(NSMutableArray *)transferWifiArr;//传输WiFi上传书籍数组
+(NSMutableArray *)transferAllBookArr;//传输所有的书籍数组
+(NSMutableArray *)transferLatestReadingArr;//传输最近阅读的书籍数组
+(void)setDelegate:(id)VeiwCon;//设置代理执行的类
+(NSMutableDictionary *)getCurrentDic:(NSInteger)currentRow;//得到当前书籍信息的字典
+(void)deleteBooks:(int)deleteBookTag;//根据下标删除书籍
// -根据书籍字典删除书籍
+(void)deleteBookFromDic:(NSDictionary *)deleteBookDic;
//+(void)willReadingBookMethod:(int)selectBookTag;//选中图书，准备阅读
+(void)willReadingBookMethod:(NSDictionary *)selectBook;//选中图书，准备阅读

#pragma mark - 得到从书城下载或wifi的书籍
- (void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification;
#pragma mark - 删除从书城下载或者WiFi的书籍
- (void)EBookLocalStorDeleteBookFunction:(NSNotification *)notification;
+(void)saveAllArrMethod;//保存所有的数组（主要是在变换位置之后处理）
@end
