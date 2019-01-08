//
//  BLepubinfoelement.h
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLepubinfoelement : NSObject
{
    NSMutableDictionary* metadata;//author,bookname etc.
    NSMutableDictionary* manifest;//element path type:pic/xhtml etc. 
    NSMutableArray*      spine;//spine:array for read index
    NSString*            Opfpath;
    NSString*            rootpath;
    NSArray*            maybetitles;
}
@property(retain,nonatomic)NSMutableDictionary* metadata;
@property(retain,nonatomic)NSMutableDictionary* manifest;
@property(retain,nonatomic)NSMutableArray*      spine;
@property(retain,nonatomic)NSString*            Opfpath;
@property(retain,nonatomic)NSString*            rootpath;
@property(retain,nonatomic)NSArray*            maybetitles;

-(void)writetofile:(NSString*)tofile;
+(BLepubinfoelement*)elementwithfile:(NSString*)filepath;

-(NSArray*)bookComtentPathlist;

-(NSArray*)bookmaybetitles;


@end
