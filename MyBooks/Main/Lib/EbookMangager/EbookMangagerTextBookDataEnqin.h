//
//  TextBookDataEnqin.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTextBookReading.h"

//============数据格式适配类=================//

@interface EbookMangagerTextBookDataEnqin : NSObject<TextBookReadingDataSourse>
{
    NSMutableString *CurrentChapterBookTextData;//缓存当前阅读的章节内容
    NSDictionary*bookInfor;
    NSMutableArray*bookChapterlist;
}
@property (nonatomic,retain)NSDictionary*bookInfor;
@property (nonatomic,retain)NSMutableArray*bookChapterlist;
@property (nonatomic,retain) NSMutableString *CurrentChapterBookTextData;
@end
