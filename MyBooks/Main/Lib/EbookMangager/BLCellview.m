//
//  BLCellview.m
//  OfficerEye
//
//  Created by BLapple on 13-3-19.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "BLCellview.h"

@implementation BLCellview
@synthesize bookinfo,jianjie,bookname,bookpic,yuedu,backgroundbut,chakan;

-(void)dealloc
{
    [bookinfo release];
    [super dealloc];
}


-(id)init
{
if(self=[super init])
{
    jianjie=[[[UILabel alloc]init]autorelease];
    bookname=[[[UILabel alloc]init]autorelease];
    picback=[[[UIImageView alloc]init]autorelease];
    bookpic=[[[UIImageView alloc]init]autorelease];
    backgroundbut=[[[UIButton alloc]init]autorelease];


    yuedu=[[[UIButton alloc]init] autorelease];
}
    
    bookname.backgroundColor=[UIColor clearColor];
    jianjie.backgroundColor=[UIColor clearColor];
//    jianjie.editable=NO;
   jianjie.textColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    
    bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];

    jianjie.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
    
    yuedu.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
    
        jianjie.numberOfLines=3;

    
    }
    else
    {
        bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        
        jianjie.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
        jianjie.numberOfLines=2;
        yuedu.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        
    
    }
    
    [self addSubview:jianjie];
    [self addSubview:bookname];
    
    [self addSubview:bookpic];
    [self addSubview:backgroundbut];
    [self addSubview:picback];
    
    
    [self addSubview:yuedu];
    [self setpicloca];
    
    [self.yuedu setExclusiveTouch:YES];
    
    return self;
    
    

}

-(void)setpicloca
{
    NSString*device;
    NSString*fangxiang;
    device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"];
    fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
    if([device isEqualToString:@"iPad"])
    {
    if([fangxiang  isEqualToString:@"h"])
    {
        self.frame=CGRectMake(0, 0, 511, 161);
        picback.frame=CGRectMake(40, 13, 93, 132);
        bookpic.frame=CGRectMake(43, 16, 87, 126);
        backgroundbut.frame=CGRectMake(0, 0, 511, 161);
        jianjie.frame=CGRectMake(135, 35, 345, 65);
        bookname.frame=CGRectMake(141, 13, 340, 25);


        yuedu.frame=CGRectMake(239, 109, 198, 40);
        chakan=[[[UIButton alloc]initWithFrame:CGRectMake(142, 109, 87, 35)] autorelease];
        [chakan setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad_h/iPad_h_bookGetIntroBtn"] forState:UIControlStateNormal];
        
        [self addSubview:chakan];

    
    }
        else
        {
            self.frame=CGRectMake(0, 0, 383, 204);
            picback.frame=CGRectMake(19, 14, 120, 165);
            bookpic.frame=CGRectMake(24, 17, 110, 152);
            backgroundbut.frame=CGRectMake(0, 0, 383, 204);
            jianjie.frame=CGRectMake(144, 50, 195, 65);
            bookname.frame=CGRectMake(144, 15, 195, 25);


            yuedu.frame=CGRectMake(144, 139, 198, 40);
            
            
            
        }
    picback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookCoverBackgroud"];
    
    }
    else
    {
        if([fangxiang  isEqualToString:@"h"])
        {
            self.frame=CGRectMake(0, 0, 320, 100);
            picback.frame=CGRectMake(0, 0, 56, 79);
            bookpic.frame=CGRectMake(0, 0, 200, 200);
            backgroundbut.frame=CGRectMake(0, 0, 320, 100);

            jianjie.frame=CGRectMake(77, 38, 140, 50);
            bookname.frame=CGRectMake(0, 0, 200, 200);
//            tagname.frame=CGRectMake(0, 0, 200, 200);
//            progress.frame=CGRectMake(0, 0, 200, 200);
//            xiazai.frame=CGRectMake(0, 0, 200, 200);
            yuedu.frame=CGRectMake(0, 0, 200, 200);
        }
        else
        {
            self.frame=CGRectMake(0, 0, 320, 110);
            picback.frame=CGRectMake(15, 13, 61, 84);
            bookpic.frame=CGRectMake(18, 17, 55, 76);
            backgroundbut.frame=CGRectMake(0, 0, 320, 110);
            jianjie.frame=CGRectMake(86, 28, 219, 40);
            bookname.frame=CGRectMake(86, 13, 219, 17);

            
            yuedu.frame=CGRectMake(86, 71, 219, 26);
            
//            chakan=[[[UIButton alloc]initWithFrame:CGRectMake(235, 18, 72, 32)] autorelease];
//            [chakan setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookGetIntroBtn"] forState:UIControlStateNormal];
//            [chakan setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookGetIntroBtnClicked"] forState:UIControlStateHighlighted];
//            [self addSubview: chakan];
        }
        picback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookCoverBackgroud"];
        
        
    }
}

-(void)setstate:(int )key
{
    //-1 表示：未下载
    //0 表示：下载中
    //1 表示下载完成
    //2:表示下载错误
    //3：表示解压错误
    //4：表示重复下载
    //5:下载未完成
    NSString*device;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        device=@"iPad";
        
    }
    else
    {
    device=@"iPhone";
    }
    
    switch (key) {
        case -1:
            yuedu.enabled=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            [yuedu setTitle:@"立即下载" forState:0];
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            break;
        case 0:
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            yuedu.enabled=NO;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
            [yuedu setTitle:@"下载中" forState:0];
            [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else
            {
                yuedu.enabled=NO;
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
                [yuedu setTitle:@"下载中" forState:0];
                [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
            yuedu.enabled=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
            [yuedu setTitle:@"开始阅读" forState:0];
            [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             }
            else
            {
                yuedu.enabled=YES;
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
                [yuedu setTitle:@"开始阅读" forState:0];
                [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            
            break;
        case 2:
            yuedu.enabled=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            
            [yuedu setTitle:@"下载出错  请重试" forState:0];
            }else
            {
            [yuedu setTitle:@"点击重试" forState:0];
            }
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            
            break;
        case 3:
            yuedu.enabled=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            [yuedu setTitle:@"解压错误  请重试" forState:0];
            }
            else
            {
            [yuedu setTitle:@"点击重试" forState:0];
            }
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 4:
            yuedu.enabled=NO;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            [yuedu setTitle:@"已下载过" forState:0];
            
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 5:
            
            
            
            yuedu.enabled=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDownload12"]] forState:UIControlStateNormal];
            [yuedu setTitle:@"已暂停" forState:0];
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    

}




@end
