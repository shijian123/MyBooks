//
//  SqlClient.m
//  HappyGO
//
//  Created by xiaogong on 10-1-26.
//  Copyright 2010 XunjieMobile . All rights reserved.
//
#import "SqlClient.h"
@implementation SqlClient
static SqlClient * sharedPublicSqlClientInstance = nil;

- init {
	if (self = [super init]) 
	{
		isopendatabase=NO;
	}
	return self;
}
 
+ (SqlClient *)sharedPublicSqlClient {
    //用于单线程
    @synchronized(self) {
        if (sharedPublicSqlClientInstance == nil) {
            sharedPublicSqlClientInstance=[[self alloc] init]; // assignment not done here
			[sharedPublicSqlClientInstance OpenDataBase];
        }
    }
    return sharedPublicSqlClientInstance;
}
 
-(NSMutableArray *)backChaptermessage:(int)bookid{
    sqlite3_stmt *statement = nil;
	NSMutableArray* Rows=[NSMutableArray arrayWithCapacity:1000];
    NSString *sql =[NSString stringWithFormat:@"select id,chaptertitle FROM chapterlist WHERE bookid=%d",bookid];
	
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithCapacity:4];
			[dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
			[dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"chaptertitle"];
			[Rows addObject: dir];
		}
		
	}
    sqlite3_finalize(statement);
	return Rows;
}
//返回章节内容
/*-(NSString *)contentOfchapter:(int)chapterid{
    sqlite3_stmt *statement = nil;
    
    NSString *sql =[NSString stringWithFormat:@"select htmlcontent FROM chapterlist WHERE id=%d",chapterid];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
    }
	NSString *txtcontent=nil;
    sqlite3_step(statement);
	txtcontent=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] autorelease];
    sqlite3_finalize(statement);
    
    return txtcontent;
    
}
*/
//返回阅读内容
-(NSString *)contentOfchapter:(int)chapterid{
    @synchronized(self) {
        sqlite3_stmt *statement = nil;
        NSString *test=@"测试";
        NSStringEncoding encoding =[test smallestEncoding];
        NSString *sql =[NSString stringWithFormat:@"select htmlcontent FROM chapterlist WHERE id=%d",chapterid];
        NSString *txtcontent=nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            int bytes = sqlite3_column_bytes(statement, 0);
            const void *value = sqlite3_column_blob(statement, 0);
            if( value != NULL && bytes != 0 ){
                NSData *data = [NSData dataWithBytes:value length:bytes];
                //此段为解密算法
                NSUInteger len = [data length];
                Byte *byteData = (Byte*)malloc(len-19);
                [data getBytes:byteData range:NSMakeRange(19, len-19)];
                NSData *newdata=[NSData dataWithBytes:byteData length:len-19];
                free( byteData);
                txtcontent=[[[NSString alloc] initWithData:newdata  encoding:encoding] autorelease];
            }
            sqlite3_finalize(statement);
        }
        return txtcontent;
    }
}
//返回章节信息内容
-(NSString *)chaptertitleContent:(int)chapterid{
    sqlite3_stmt *statement = nil;
    
    NSString *sql =[NSString stringWithFormat:@"select chaptertitle FROM chapterlist WHERE id=%d",chapterid];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
    }
	NSString *txtcontent=nil;
    sqlite3_step(statement);
	txtcontent=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] autorelease];
    sqlite3_finalize(statement);
    
    return txtcontent;
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//创建表
- (BOOL)CreateTable{
	char *sql = "CREATE TABLE IF NOT EXISTS booklist (id INTEGER PRIMARY KEY, \
	bookid integer, \
	mes text)";
    //char *sql = "CREATE TABLE IF NOT EXISTS chapterlist1 (id INTEGER PRIMARY KEY  AUTOINCREMENT  UNIQUE, \bookid integer, \chaptertitle text, \htmlcontent text)";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
        return NO;
    }
    return YES;
}
//创建表索引
- (BOOL)Createindex{
	char *sql = "create index bookindex on booklist(bookid)";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
        return NO;
    }
    return YES;
}
//插入数据
- (void)InsertToBOOKTable:(NSString*)title  Message:(NSString*)imagepath
{
	
	[self OpenDataBase];
	sqlite3_stmt *statement;
    static char *sql = "INSERT INTO booklist (title,image)\
	VALUES(?,?)";
	
    //问号的个数要和(cid,title,imageData,imageLen)里面字段的个数匹配，代表未知的值，将在下面将值和字段关联。
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert:channels");
        return ;
    }
	//这里的数字1，2，3，4代表第几个问号
    sqlite3_bind_text(statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [imagepath UTF8String], -1, SQLITE_TRANSIENT);
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return ;
    }
}
-(int)backid{
    
    int i=sqlite3_last_insert_rowid(database);
    return i;
}
//插入数据
- (void)InsertToTable:(int)bookid  chaptertitle:(NSString*)chaptertitle  htmlcontent:(NSString*)htmlcontent
{
	
	[self OpenDataBase];
	sqlite3_stmt *statement;
    static char *sql = "INSERT INTO chapterlist (bookid,chaptertitle,htmlcontent)\
	VALUES(?,?,?)";
	
    //问号的个数要和(cid,title,imageData,imageLen)里面字段的个数匹配，代表未知的值，将在下面将值和字段关联。
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert:channels");
        return ;
    }
	//这里的数字1，2，3，4代表第几个问号
    sqlite3_bind_int(statement, 1, bookid); 
    sqlite3_bind_text(statement, 2, [chaptertitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [htmlcontent UTF8String], -1, SQLITE_TRANSIENT);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return ;
    }
}

- (NSString*)GetBookContent:(int)bookid{
	sqlite3_stmt *statement = nil;
    NSString *sql =[NSString stringWithFormat:@"select mes from booklist where bookid=%d",bookid];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
    }
	NSString *txtcontent=nil;
    sqlite3_step(statement);
	txtcontent=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] autorelease];
    sqlite3_finalize(statement);
	return txtcontent;	
}

- (NSMutableArray*)SelectALLBooksRow:(NSString *)notShow
{
	sqlite3_stmt *statement = nil;
	NSMutableArray* Rows=[NSMutableArray arrayWithCapacity:445];
//	NSString *sql =@"select id,title,image,zuoze,jianjie  from  booklist";
//	NSString *sql =@"select id,title,image,zuoze,jianjie  from  booklist where id is not in (%@)";
	NSString *sql =[NSString stringWithFormat:@"select id,title,image,zuoze,jianjie  from  booklist where id not in (%@)",notShow];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithCapacity:4];
			[dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"id"];
			[dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"title"];
            [dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"image"];
            [dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"zuoze"];
            //[dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"subtitle"];
            [dir setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"jianjie"];
			[Rows addObject: dir];
		}
	}
    sqlite3_finalize(statement);
	return Rows;
} 

- (void)updatBooks:(int)bookid Chaptermes:(NSString*)chaptermes{
	const char * sql = "update booklist set mes = ?  where bookid = ?";
    sqlite3_stmt *update_statement = nil;    
    int success = sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL);
    if(success==SQLITE_OK)
    {
        sqlite3_bind_text(update_statement, 1, [chaptermes UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(update_statement, 2, bookid);
        int success = sqlite3_step(update_statement); 
        if (success == SQLITE_ERROR) {
            NSLocalizedString(@"err_update", @"delete error");
        }         
        
        sqlite3_finalize(update_statement);
        
    }else{
        NSLocalizedString(@"err_update", @"delete error");
    }    
    	
}

//打开数据库，如果没有打开，则打开，没有创建数据库，则创建数据库
- (BOOL)OpenDataBase{
	if(isopendatabase&&database)
		return isopendatabase;
	NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
	NSString *path =  [resourcePath stringByAppendingPathComponent:@"girlbook.sqlite"];
	/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"girlbook.sqlite"];
    //NSLog(@"%@----------------------------------------------------------------",path);*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    if (find) {
        if(sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            return NO;
        }
		isopendatabase=YES;
        return YES;
	}else{
		if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) 
		{
			[self CreateTable];
			isopendatabase=YES;
			return YES;
		}
	}
	return NO;
}

- (BOOL)OpenFileDataBase:(NSString*)BDNAME{
	if(isopendatabase)
		return isopendatabase;
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:BDNAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    if (!find) 
	{
        [[NSFileManager defaultManager] copyItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"tempgirlbook.sqlite" ]  toPath: path error:nil];
    }
    
    if(sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    isopendatabase=YES;
    return YES;
    
	return NO;
}
- (BOOL)Open{
	NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
	NSString *dbPath = [resourcePath stringByAppendingPathComponent:@"girlbook.sqlite"];
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
	{
		isopendatabase=YES;
		return YES;
	}
	return NO;
}
- (void)CloseDataBase
{
	if(isopendatabase)
	{
        sqlite3_close(database);
	}
database=nil;
}
- (void)dealloc {
    
    [super dealloc];
}
@end
