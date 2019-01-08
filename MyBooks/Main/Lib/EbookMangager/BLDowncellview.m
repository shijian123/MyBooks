//
//  BLCellview.m
//  OfficerEye
//
//  Created by BLapple on 13-3-19.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "BLDowncellview.h"

@implementation BLDowncellview
@synthesize bookinfo,bookname,bookpic,yuedu,prolab,progress,xiazai,deletbut,jixupic;

-(void)dealloc
{
    [bookinfo release];
    [super dealloc];
}


-(id)init
{
    if(self=[super init])
    {
        
        bookname=[[[UILabel alloc]init]autorelease];
        picback=[[[UIImageView alloc]init]autorelease];
        bookpic=[[[UIImageView alloc]init]autorelease];

        progress=[[[UIProgressView alloc]init]autorelease];
        xiazai=[[[UIButton alloc]init] autorelease];
        yuedu=[[[UIButton alloc]init] autorelease];
        prolab=[[[UILabel alloc]init]autorelease];
        
        
        
        deletbut=[[[UIButton alloc]init] autorelease];
        jixupic=[[[UIImageView alloc]init ] autorelease];
    }
    bookname.backgroundColor=[UIColor clearColor];
    prolab.textColor=[UIColor whiteColor];
    prolab.textAlignment = NSTextAlignmentCenter;
    prolab.backgroundColor=[UIColor clearColor];
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        
        bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        prolab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        
        
        
        progress.trackImage=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookDownloading"];
        progress.progressImage=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookDownloadingLine"];
        
        jixupic.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookStartDownload"];
        
        [deletbut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookDelete"] forState:UIControlStateNormal];
        //[deletbut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookDeleteClicked"] forState:UIControlStateHighlighted];
        yuedu.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        
        xiazai.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
    }
    else
    {
        bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:17];
        prolab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        
        
        
        progress.trackImage=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDownloading"];
        progress.progressImage=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDownloadingLine"];
        
        jixupic.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookStartDownload"];
        
        [deletbut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDelete"] forState:UIControlStateNormal];
        //[deletbut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDeleteClicked"] forState:UIControlStateHighlighted];
        yuedu.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        
        xiazai.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
    }

    [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [xiazai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    progress.userInteractionEnabled=NO;
    prolab.userInteractionEnabled=NO;
    
    [self addSubview:yuedu];
        [self addSubview:bookname];
    
    [self addSubview:bookpic];
    [self addSubview:picback];
    [self addSubview:xiazai];
    [self addSubview:progress];
    
    [self addSubview:deletbut];
    
   
    [self addSubview:prolab];
     [self addSubview:jixupic];
    [self setpicloca];
    
    [self.xiazai setExclusiveTouch:YES];
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
            picback.frame=CGRectMake(31, 17, 93, 132);
            bookpic.frame=CGRectMake(34, 20, 87, 126);


            bookname.frame=CGRectMake(130, 18, 237, 25);

            progress.frame=CGRectMake(145, 118, 161, 5);
            xiazai.frame=CGRectMake(130, 103, 237, 35);
            prolab.frame=CGRectMake(300, 113,80, 17);
            jixupic.frame=CGRectMake(328, 110,20,24);
            yuedu.frame=CGRectMake(130, 103, 237, 35);
            deletbut.frame=CGRectMake(277, 100, 198, 40);
            
            
            
        }
        else
        {
            self.frame=CGRectMake(0, 0, 383, 204);
            picback.frame=CGRectMake(19, 14, 120, 165);
            bookpic.frame=CGRectMake(24, 17, 110, 152);

            bookname.frame=CGRectMake(144, 25, 195, 25);
            
            progress.frame=CGRectMake(151, 102, 150, 5);
            xiazai.frame=CGRectMake(144, 85, 198, 40);
            yuedu.frame=CGRectMake(144, 85, 198, 40);
            prolab.frame=CGRectMake(283, 95, 80, 17);
            
            jixupic.frame=CGRectMake(315, 97,14,14);
            
            deletbut.frame=CGRectMake(144, 139, 198, 40);

            
        }
        picback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookCoverBackgroud"];
        
    }
    else
    {
        if([fangxiang  isEqualToString:@"h"])
        {
            self.frame=CGRectMake(0, 0, 200, 200);
            picback.frame=CGRectMake(0, 0, 200, 200);
            bookpic.frame=CGRectMake(0, 0, 200, 200);

            
          
            bookname.frame=CGRectMake(0, 0, 200, 200);
           
//             progress.frame=CGRectMake(0, 0, 200, 200);
            //            xiazai.frame=CGRectMake(0, 0, 200, 200);
            yuedu.frame=CGRectMake(0, 0, 200, 200);
        }
        else
        {
            self.frame=CGRectMake(0, 0, 320, 110);
            picback.frame=CGRectMake(15, 13, 61, 84);
            bookpic.frame=CGRectMake(18, 17, 55, 76);

            bookname.frame=CGRectMake(86, 30,124, 20);

            yuedu.frame=CGRectMake(86, 71, 219, 26);

            
            progress.frame=CGRectMake(100, 83, 160, 4);
            xiazai.frame=CGRectMake(86, 71, 219, 26);
            
            prolab.frame=CGRectMake(248, 75, 60, 17);
            
            jixupic.frame=CGRectMake(0, 0,14,14);
            
         
            
            deletbut.frame=CGRectMake(221, 30, 85, 27);
            
            
        }
         picback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookCoverBackgroud"];
        
//[prolab removeFromSuperview];
//prolab=nil;
        [jixupic removeFromSuperview];
        jixupic=nil;
        
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
            //[yuedu setTitle:@"立即下载" forState:0];
            [yuedu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [xiazai setTitle:nil forState:0];
            
            break;
        case 0:
            xiazai.enabled=YES;
            xiazai.hidden=NO;
            progress.hidden=NO;
            prolab.hidden=NO;
            jixupic.hidden=YES;
            
            yuedu.enabled=NO;
            yuedu.hidden=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            
            
            [xiazai setTitle:nil forState:0];
            [yuedu setTitle:nil forState:0];

            
            
            break;
        case 1:
            xiazai.enabled=NO;
            xiazai.hidden=YES;
            progress.hidden=YES;
            prolab.hidden=YES;
            jixupic.hidden=YES;
            
            yuedu.enabled=YES;
            yuedu.hidden=NO;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"] forState:UIControlStateNormal];
                
            }
            else
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
            }
            [xiazai setTitle:nil forState:0];
            [yuedu setTitle:@"开始阅读" forState:0];
            [yuedu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 2:
            xiazai.enabled=YES;
            xiazai.hidden=NO;
            
            progress.hidden=YES;
            prolab.hidden=YES;
            jixupic.hidden=YES;
            
            yuedu.enabled=NO;
            yuedu.hidden=YES;
            
            
            
//            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
//            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
//            
//            [xiazai setTitle:nil forState:0];
//            [yuedu setTitle:nil forState:0];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"] forState:UIControlStateNormal];
                
            }
            else
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"] forState:UIControlStateNormal];
            }
            [xiazai setTitle:@"下载失败，点击重试!" forState:0];
            [yuedu setTitle:@"下载失败，点击重试!" forState:0];
            [xiazai setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [yuedu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        case 3:
            xiazai.enabled=YES;
            xiazai.hidden=NO;
            
            progress.hidden=YES;
            prolab.hidden=YES;
            jixupic.hidden=YES;
            
            yuedu.enabled=NO;
            yuedu.hidden=YES;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
                
            }
            else
            {
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
            }
            [xiazai setTitle:@"下载失败，点击重试!" forState:0];
            [yuedu setTitle:@"下载失败，点击重试!" forState:0];
            [xiazai setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [yuedu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
//            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
            
            
          

            break;
        case 4:
            xiazai.enabled=YES;
            xiazai.hidden=NO;
            
            progress.hidden=YES;
            prolab.hidden=YES;
            jixupic.hidden=YES;
            
            yuedu.enabled=NO;
            yuedu.hidden=YES;
            
//            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
//            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_downshibai",device,device]] forState:UIControlStateNormal];
//            
//            [yuedu setTitle:nil forState:0];
//            [xiazai setTitle:nil forState:0];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPad/blank_btn_ipad"]] forState:UIControlStateNormal];
                
            }
            else
            {
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/blank_btn_ipad"]] forState:UIControlStateNormal];
            }
            [xiazai setTitle:@"下载失败，点击重试!" forState:0];
            [yuedu setTitle:@"下载失败，点击重试!" forState:0];
            [xiazai setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [yuedu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        case 5:
            
//
//            
//            xiazai.enabled=YES;
//            xiazai.hidden=NO;
//            progress.hidden=NO;
//            prolab.hidden=YES;
//            jixupic.hidden=NO;
//            
//            yuedu.enabled=NO;
//            yuedu.hidden=YES;
//            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
//            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
//            
//            
//            
//            [yuedu setTitle:nil forState:0];
//                [xiazai setTitle:nil forState:0];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                xiazai.enabled=YES;
                xiazai.hidden=NO;
                progress.hidden=NO;
                prolab.hidden=YES;
                jixupic.hidden=NO;
                
                yuedu.enabled=NO;
                yuedu.hidden=YES;
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
                
                
                [xiazai setTitle:nil forState:0];
                [yuedu setTitle:nil forState:0];
                
            }
            else
            {
                xiazai.enabled=YES;
                xiazai.hidden=NO;
                progress.hidden=YES;
                prolab.hidden=YES;
                jixupic.hidden=YES;
                
                yuedu.enabled=NO;
                yuedu.hidden=YES;
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDownload12.png"]] forState:UIControlStateNormal];
                [yuedu setTitle:nil forState:0];
                [xiazai setTitle:@"继续下载" forState:0];
                [xiazai setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            break;
            case 6:
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            xiazai.enabled=YES;
            xiazai.hidden=NO;
            progress.hidden=NO;
            prolab.hidden=YES;
            jixupic.hidden=NO;
            
            yuedu.enabled=NO;
            yuedu.hidden=YES;
            [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
            [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
            
            
            [xiazai setTitle:nil forState:0];
            [yuedu setTitle:nil forState:0];
            
            }
            else
            {
                xiazai.enabled=YES;
                xiazai.hidden=NO;
                progress.hidden=YES;
                prolab.hidden=YES;
                jixupic.hidden=YES;
                
                yuedu.enabled=NO;
                yuedu.hidden=YES;
                [yuedu setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
                [xiazai setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/iPhone/iPhone_bookDownload12"]] forState:UIControlStateNormal];
                [yuedu setTitle:nil forState:0];
                [xiazai setTitle:@"继续下载" forState:0];
                [xiazai setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        default:
            break;
    }
}




@end
