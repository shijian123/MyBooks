//
//  BLCellview.h
//  OfficerEye
//
//  Created by BLapple on 13-3-19.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@interface BLCellview : UIView
{
    UIImageView* picback;
    UIImageView* bookpic;
    UIButton*    backgroundbut;
    NSDictionary*bookinfo;
    UILabel*  jianjie;
    UILabel *bookname;
//    UILabel *tagname;
//    UIProgressView *progress;
//    UIButton *xiazai;
    UIButton *yuedu;
    UIButton*chakan;
    
    
}
@property(assign) UILabel*  jianjie;
@property(assign) UILabel *bookname;
//@property(assign)UILabel *tagname;
@property(retain,nonatomic)NSDictionary*bookinfo;
@property(assign)UIImageView* bookpic;
//@property(assign)UIProgressView *progress;
//@property(assign)UIButton *xiazai;
@property(assign)UIButton *yuedu;
@property(assign)UIButton*    backgroundbut;
@property(assign)UIButton*chakan;

//-(void)loaddelete;
-(void)setpicloca;

-(void)setstate:(int )key;


@end
