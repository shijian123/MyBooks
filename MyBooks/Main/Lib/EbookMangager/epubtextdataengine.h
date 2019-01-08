//
//  epubtextdataengine.h
//  yanqing
//
//  Created by BLapple on 13-10-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTextBookReading.h"
#import "EBookLocalStore.h"
#import "NSString+MD5.h"

#import "EbookMangagerTextBookDataEnqin.h"

@interface epubtextdataengine : EbookMangagerTextBookDataEnqin<TextBookReadingDataSourse>
{
    NSString* bookpath;
    NSString* bookdisk;
    NSMutableArray* mutiinfo;

}
@property(retain,nonatomic) NSString* bookpath;
@property(retain,nonatomic) NSString* bookdisk;
@property(retain,nonatomic) NSMutableArray* mutiinfo;
@property(retain,nonatomic) NSMutableArray* booktitle;
@property(retain,nonatomic) NSMutableArray* bookcontentpath;
@property(retain,nonatomic) NSMutableArray* bookcontenttype;

-(NSMutableArray*)makebookChapterlist:(NSString*)bookpath;

@end

