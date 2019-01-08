//
//  SqlClient.h
//  HappyGO
//
//  Created by xiaogong on 10-1-26.
//  Copyright 2010 XunjieMobile . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqlClient : NSObject 
{
	sqlite3 *database;	
	BOOL isopendatabase;
}
+ (SqlClient *)sharedPublicSqlClient;

//返回章节id，title，信息
-(NSMutableArray *)backChaptermessage:(int)bookid;
//返回书的标题，图片名
//-(NSMutableArray *)backBookmessage;
//返回章节内容
-(NSString *)contentOfchapter:(int)chapterid;
//返回最后插入行的id
-(int)backid;
- (void)InsertToTable:(int)bookid  chaptertitle:(NSString*)chaptertitle  htmlcontent:(NSString*)htmlcontent;
- (void)InsertToBOOKTable:(NSString*)title  Message:(NSString*)imagepath;
//创建表索引
- (BOOL)Createindex;
- (NSString*)GetBookContent:(int)bookid;
//插入数据
//- (void)InsertToTable:(int)bookid  Message:(NSString*)mes;
//创建表
- (BOOL)CreateTable;
//打开数据库
- (BOOL)Open;
//关闭数据库
- (void)CloseDataBase;
- (BOOL)OpenDataBase;
- (NSMutableArray*)SelectALLBooksRow:(NSString *)notShow;
- (void)updatBooks:(int)bookid Chaptermes:(NSString*)chaptermes;
- (BOOL)OpenFileDataBase:(NSString*)BDNAME;


@end
