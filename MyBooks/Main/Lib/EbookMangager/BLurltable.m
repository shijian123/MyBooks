//
//  BLurltable.m
//  OfficerEye
//
//  Created by BLapple on 13-3-20.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "BLurltable.h"

@implementation BLurltable
@synthesize url,Rows,delegate,mytableview,chooseindex;
-(void)dealloc
{
    [down cancel];
    [down release];
    [left release];
    [right release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame url:(NSString*)_url
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        UIView *tbview = [[UIView alloc]initWithFrame:CGRectMake(200, 200, 320, 50)];
        //        tbview.backgroundColor = [UIColor redColor];
        //        UIImageView*imav=[[[UIImageView alloc]init] autorelease];
        //
        //        UIImage*ima=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_shadow"];
        //
        //        imav.image=ima;
        //
        //        imav.frame=CGRectMake(frame.size.width-ima.size.width, 0, ima.size.width, ima.size.height);
        ////        imav.frame=CGRectMake(0,0,320,50);
        //        [self addSubview:imav];
        //        imav.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        
        
        
        
        //mytableview=[[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-3, self.bounds.size.height)] autorelease];
        //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //        {
        mytableview=[[[UITableView alloc]initWithFrame:self.bounds] autorelease];
        
        
        mytableview.showsHorizontalScrollIndicator=NO;
        mytableview.showsVerticalScrollIndicator=NO;
        // mytableview.rowHeight = 100.0;
        mytableview.clipsToBounds=YES;
        mytableview.autoresizingMask=UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleHeight;
        mytableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //        mytableview.separatorStyle = NO;
        
        mytableview.dataSource=self;
        mytableview.delegate=self;
        [self addSubview:mytableview];
        //[tbview addSubview:mytableview];
        
        self.backgroundColor=[UIColor clearColor];
        mytableview.backgroundColor=[UIColor clearColor];
        
        //self.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
        
        //        _waitDataActivity=[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        //        _waitDataActivity.color=[UIColor colorWithRed:57.0/255.0 green:42.0/255.0 blue:14.0/255.0 alpha:1.0];
        //
        //        [_waitDataActivity startAnimating];
        //
        //
        //        [self addSubview:_waitDataActivity];
        //[tbview addSubview:_waitDataActivity];
        //        _waitDataActivity.center=self.center;
        //        _waitDataActivity.autoresizingMask=UIViewAutoresizingFlexibleWidth|
        //        UIViewAutoresizingFlexibleHeight;
        
        down=[[DownloadHelper alloc]init];
        url=_url;
        down.delegate=self;
        //调试 暂时注释
//        down.urlconnection = url;
        [down download:url];
        // Initialization code
        
        left=[[UIImageView alloc] init];
        right=[[UIImageView alloc] init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            left.frame=CGRectMake(0, 0, 62, 62);
            right.frame=CGRectMake(0, 768-62, 62, 62);
            left.image=[UIImage imageNamed:@"ipad_left"];
            right.image=[UIImage imageNamed:@"ipad_right"];
            deletekey=768;
        }else{
            left.frame=CGRectMake(0, 0, 43, 43);
            right.frame=CGRectMake(0, 320-43, 43, 43);
            left.image=[UIImage imageNamed:@"iphone_left"];
            right.image=[UIImage imageNamed:@"iphone_right"];
            deletekey=320;
        }
        
        left.transform=CGAffineTransformMakeRotation(M_PI/2);;
        right.transform=CGAffineTransformMakeRotation(M_PI/2);
        [self addSubview:left];
        [self addSubview:right];
        left.hidden=YES;
        right.hidden=YES;
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString*device;  8号 device never read
    NSString*fangxiang;
//    device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"]; 8号 device never read
    fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
    
    NSString *CellIdentifier =fangxiang;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] autorelease];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView *imageview =[[[UIImageView alloc]init] autorelease];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            imageview.frame = CGRectMake(10, 8, 60, 27);
            UIImage *image = [UIImage imagefileNamed:@"EBookManagerImage2.bundle/iphonetableselected"];
            imageview.image = image;
            [cell.contentView addSubview:imageview];
            imageview.tag = 999;
            imageview.hidden = YES;
        }else{
            imageview.frame = CGRectMake(7, 12, 87, 37);
            UIImage *image = [UIImage imagefileNamed:@"EBookManagerImage2.bundle/ipadtableselected"];
            imageview.image = image;
            [cell.contentView addSubview:imageview];
            imageview.tag = 999;
            imageview.hidden = YES;
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            cell.textLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            cell.textLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.textLabel.textColor=[UIColor blackColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    if(chooseindex==0){
        [cell viewWithTag:999].hidden=YES;
        cell.textLabel.textColor=[UIColor blackColor];
    }else{
        if(  (chooseindex-1)==indexPath.row){
            [cell viewWithTag:999].hidden=NO;
            cell.textLabel.textColor=[UIColor whiteColor];
        }else{
            [cell viewWithTag:999].hidden=YES;
            cell.textLabel.textColor=[UIColor blackColor];
        }
    }
    
    if(indexPath.row<[Rows count]){
        cell.textLabel.text=[[Rows objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }else{
        cell.textLabel.text=nil;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 100;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 109;
    }else{
        return  80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>=[Rows count] ){
        return;
    }
    if(chooseindex==indexPath.row+1){
        return;
    }
    chooseindex = indexPath.row+1;
    
    if(delegate && [delegate respondsToSelector:@selector(choose:)]){
        [delegate choose:indexPath.row+1];
    }
    //[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"rowss"];
    [mytableview reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>20){
        left.hidden=NO;
    }else{
        left.hidden=YES;
    }

    if((scrollView.contentSize.height- scrollView.contentOffset.y-deletekey)>20){
        right.hidden=NO;
    }else{
        right.hidden=YES;
    }
    
}

- (void) didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData{
    @autoreleasepool {
        XmlDataSet *data=[[XmlDataSet alloc] init];
        NSMutableArray *pp =[NSMutableArray array];
        [pp addObject:@"item"];
        [data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
        self.Rows =data.Rows ;
        [data release];
    }
    
    //    [_waitDataActivity stopAnimating];
    //    [_waitDataActivity removeFromSuperview];
    
    [self performSelector:@selector(reloadvi) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(scrollViewDidScroll:) withObject:mytableview afterDelay:1];
    
    
}

- (void)reloadvi{
    [mytableview reloadData];
}

- (void) dataDownloadFailed:(NSString *)reason{
    
    
}

@end
