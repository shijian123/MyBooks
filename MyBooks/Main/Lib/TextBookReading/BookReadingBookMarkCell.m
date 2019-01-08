//
//  BookReadingBookMarkCell.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookReadingBookMarkCell.h"

@implementation BookReadingBookMarkCell
@synthesize henxian,chapterindextitle,chaptertitle,tophenxian; 
-(void)dealloc{
    [henxian release];
    [chapterindextitle release];
    [chaptertitle release];
    [tophenxian release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.henxian=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.tophenxian=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];

        self.chapterindextitle=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.chapterindextitle.backgroundColor=[UIColor clearColor];
        self.chapterindextitle.textAlignment=NSTextAlignmentCenter;
          self.chaptertitle=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.chaptertitle.backgroundColor=[UIColor clearColor];
        self.chaptertitle.numberOfLines=20;
        [self.contentView addSubview: henxian];
        [self.contentView addSubview: chapterindextitle];
        [self.contentView addSubview: chaptertitle];
        [self.contentView addSubview: tophenxian];
       // self.selectionStyle=UITableViewCellSelectionStyleNone;

     }
    return self;
}

 
@end
