//
//  TextBookDataEnqin.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTextBookReading.h"
#import "SqlClient.h"

//============数据格式适配类=================//

@interface TextBookDataEnqin : NSObject<TextBookReadingDataSourse>
{
    NSString *CurrentChapterBookTextData;//缓存当前阅读的章节内容
    NSMutableArray*bookInfor;
    NSString *BookKeyWord;
    NSString *BookName;
    SqlClient *sql;
}
@property (nonatomic,retain)NSMutableArray*bookInfor;//
@property (nonatomic,retain)NSString *BookKeyWord;
@property (nonatomic,retain)NSString *BookName;
@property (nonatomic,retain)SqlClient *sql;

@property (nonatomic,retain) NSString *CurrentChapterBookTextData;
@property(nonatomic,retain)NSMutableDictionary*saveinfodic;
@end
