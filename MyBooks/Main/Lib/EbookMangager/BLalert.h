//
//  BLalert.h
//  OfficerEye
//
//  Created by BLapple on 13-3-18.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//
#import "NSString+HTML.h"
#import "BLattributetextview.h"
#import "AppRecord.h"
#import "IconDownloader.h"
#import <UIKit/UIKit.h>
#import "NSString+Stringhttpfix.h"
#import "EBookLocalStore.h"
#import "SmalleBasebookViewController.h"
@protocol EbooManagerJianjieViewClickEvent<NSObject>
-(void)ActionClick:(NSDictionary*)bookinfor;
@end

@interface BLalert : UIView
{
    UILabel *bookname;
    UILabel* editer;
    UILabel* fenlei;
    UILabel* redu;
    UILabel* zishu;
    
    UIButton *nowdowning;
    UITextView *bookjianjie;
    NSMutableDictionary *bookinfor;
    UIImageView* bookpic;
    UIImageView* bookpicback;
    
    UIButton*  closebut;
    UIImageView* bgroundview;
    id<EbooManagerJianjieViewClickEvent> delegate;
    
    UILabel*   prolab;
    IconDownloader*downlo;
}
@property (nonatomic,assign) UILabel *fenlei;
@property (nonatomic,assign) UILabel *redu;
@property (nonatomic,assign) UILabel *zishu;
@property  (nonatomic,assign) UIButton *nowdowning;
@property  (nonatomic,assign) UILabel *bookname;
@property(nonatomic,assign)UILabel* editer;
@property  (nonatomic,assign) UITextView *bookjianjie;
@property  (nonatomic,retain) NSMutableDictionary *bookinfor;
@property  (nonatomic,retain) id<EbooManagerJianjieViewClickEvent> delegate;
@property(assign)UIImageView* bookpic;


-(void)CloseClick:(id)sender;
-(void)ActionClick:(id)sender;
-(void)changedirect:(NSNotification *)notification;

-(void)loadinfo;


-(void)setselfsize:(NSString*)device horv:(NSString*)horv;

-(void)startread;
-(void)setstate:(int )key;


@end
