//
//  BLDowncellview.h
//  OfficerEye
//
//  Created by BLapple on 13-3-21.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@interface BLDowncellview : UIView
{
    UIImageView* picback;
    UIImageView* bookpic;

    NSDictionary*bookinfo;

    UILabel *bookname;

    UIProgressView *progress;
    UIButton *xiazai;
    UIButton *yuedu;

    UILabel* prolab;
    
    UIButton* deletbut;
    UIImageView* jixupic;
    
}

@property(assign) UILabel *bookname;

@property(retain,nonatomic)NSDictionary*bookinfo;
@property(assign)UIImageView* bookpic;
@property(assign)UIProgressView *progress;
@property(assign)UIButton *xiazai;
@property(assign)UIButton *yuedu;

@property(assign)UILabel* prolab;
@property(assign) UIImageView* jixupic;
@property(assign)UIButton* deletbut;

//-(void)loaddelete;
-(void)setpicloca;

-(void)setstate:(int )key;
@end
