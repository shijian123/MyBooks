//
//  BLalert.m
//  OfficerEye
//
//  Created by BLapple on 13-3-18.
//  Copyright (c) 2013年 北邮3G. All rights reserved.
//

#import "BLalert.h"

@implementation BLalert

@synthesize delegate;
@synthesize nowdowning,bookname,bookjianjie,bookinfor,bookpic,editer,redu,fenlei,zishu;

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    downlo.delegate=nil;
    [downlo cancelDownload];
    [downlo release];
    [bookinfor release];
    [delegate release];
    [super dealloc];
}
//加载设置内容
-(void)loadinfo
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
//    CGSize size=    [[self.bookinfor objectForKey:@"title"] sizeWithFont:self.bookname.font forWidth:self.bookname.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
       CGSize size = [[self.bookinfor objectForKey:@"title"] sizeWithFont:self.bookname.font];
        
        if(size.width>self.bookname.frame.size.width)
        {
            self.bookname.numberOfLines=2;
        }
        else
        {
            self.bookname.frame=CGRectMake(self.bookname.frame.origin.x, self.bookname.frame.origin.y-5, self.bookname.frame.size.width, self.bookname.frame.size.height);
        }
    
    }
  
    
    self.bookname.text=[self.bookinfor objectForKey:@"title"];
//    self.bookjianjie.text=[NSString stringWithFormat:@"简介：\r\n   %@\r\n",[self.bookinfor objectForKey:@"summary"]];
    
    NSString *contentStr=[[self.bookinfor objectForKey:@"summary"] stringByConvertingHTMLToPlainText];
    
    NSString *changeStr=[contentStr stringByReplacingOccurrencesOfString:@" " withString:@"\r\n"];
    NSString *jiaohuan=changeStr;
    jiaohuan=[jiaohuan stringByReplacingOccurrencesOfString:@"\n" withString:@"\n  "];
    
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　| )*";
	NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    jiaohuan=[reg stringByReplacingMatchesInString:jiaohuan  options:NSMatchingReportProgress  range:NSMakeRange(0, [jiaohuan length])  withTemplate:@"\n"];
	jiaohuan=[jiaohuan stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if(jiaohuan==nil||jiaohuan.length==0)
    {
        jiaohuan=@" ";
    }
    NSString* fullstring=[NSString stringWithFormat:@"简介：\n%@",jiaohuan];
    
    NSMutableAttributedString* attstring=[[[NSMutableAttributedString alloc] initWithString:fullstring] autorelease];
    
    
    //第一步：加载文本格式：字体颜色
    [attstring addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:(id)self.bookjianjie.textColor.CGColor
                      range:NSMakeRange(0, [attstring length])];
    
    UIFont* textviewfont=self.bookjianjie.font;
    CTFontRef ft=CTFontCreateWithName((CFStringRef)textviewfont.fontName, textviewfont.pointSize,
                                      NULL)  ;
    [attstring addAttribute:(NSString *)kCTFontAttributeName
                      value:(id)ft
                      range:NSMakeRange(0, [attstring length])];
    CFRelease(ft);
    //对齐方式
    CTParagraphStyleSetting paragraphalignment;
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    paragraphalignment.spec = kCTParagraphStyleSpecifierAlignment;
    paragraphalignment.value = &alignment;
    paragraphalignment.valueSize = sizeof(CTTextAlignment);
    
    //首行缩进
     CGFloat topSpacing = self.bookjianjie.font.pointSize*2+3;
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        topSpacing+=5;
//    }
  
    
   
    CTParagraphStyleSetting topSpacingStyle;
    topSpacingStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    topSpacingStyle.value = &topSpacing;
    topSpacingStyle.valueSize = sizeof(CGFloat);
    
    //设置文本段间距
    CTParagraphStyleSetting ParagraphSpacing;
    CGFloat paragraphspacing = 0 ;
    ParagraphSpacing.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    ParagraphSpacing.value = &paragraphspacing;
    ParagraphSpacing.valueSize = sizeof(CGFloat);
    //设置文本行间距
    CGFloat spacing = spacing=4.0;;
    long number = 0;
    
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    
    
    
    [attstring addAttribute:(NSString*)kCTKernAttributeName
                      value:(id)num
                      range:NSMakeRange(0, attstring.length)];
    
    CFRelease(num);
    
    
    CTParagraphStyleSetting LineSpacing;
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {paragraphalignment,topSpacingStyle,ParagraphSpacing,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 4);
    [attstring addAttribute:(NSString *)kCTParagraphStyleAttributeName
                      value:(id)paragraphStyle
                      range:NSMakeRange(attstring.string.length-jiaohuan.length, jiaohuan.length)];
    CFRelease(paragraphStyle);
    
    
    BLattributetextview* atttview=[[[BLattributetextview alloc] initWithFrame:self.bookjianjie.bounds width:self.bookjianjie.bounds.size.width string:attstring] autorelease];
    
    
    UIScrollView* scrolll=[[[UIScrollView alloc] initWithFrame:CGRectMake(self.bookjianjie.frame.origin.x, self.bookjianjie.frame.origin.y, self.bookjianjie.frame.size.width+7, self.bookjianjie.frame.size.height)] autorelease];
    scrolll.contentSize=CGSizeMake(scrolll.bounds.size.width, atttview.bounds.size.height>scrolll.bounds.size.height?atttview.bounds.size.height:scrolll.bounds.size.height+1) ;
    
    
    
    [scrolll addSubview:atttview];
    scrolll.backgroundColor=[UIColor clearColor];
    [self addSubview:scrolll];
    self.bookjianjie.hidden=YES;

//    NSString* str=[NSString stringWithFormat:@"简介：\r\n   %@\r\n",[self.bookinfor objectForKey:@"summary"]];
//    NSString *pattern=@"(\r\n)+";
//    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
//    str=[reg stringByReplacingMatchesInString:str  options:NSMatchingReportProgress  range:NSMakeRange(0, [str length])  withTemplate:@"\n"];
    
    
    
//    self.bookjianjie.text=str;

//    if(bookjianjie.contentSize.height<bookjianjie.frame.size.height)
//    {
//        bookjianjie.contentSize=CGSizeMake(bookjianjie.contentSize.width, bookjianjie.frame.size.height+1);
//    }
    
    
    self.zishu.text = [NSString stringWithFormat:@"字数：%@",[self.bookinfor objectForKey:@"words"]];
    self.redu.text = [NSString stringWithFormat:@"热度：%@",[self.bookinfor objectForKey:@"clicks"]];
    self.fenlei.text = [NSString stringWithFormat:@"分类：%@",[self.bookinfor objectForKey:@"tag"]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
            editer.text=[NSString stringWithFormat:@"作者: %@",[self.bookinfor objectForKey:@"author"]];
    }
    else
    {
        editer.text=[NSString stringWithFormat:@"作者: %@",[self.bookinfor objectForKey:@"author"]];
    }
    
    if([self.bookinfor objectForKey:@"status"])
    {
        [self setstate:[[self.bookinfor objectForKey:@"status"] intValue]];
    }
    else
    {
        [self setstate:-1];
    }
    
    NSString*imageUrl=[[bookinfor objectForKey:@"logo"] absoluteorRelative];
  
    AppRecord *appRecord ;
    appRecord=[[[AppRecord alloc] init] autorelease];
    
    appRecord.imageURLString=imageUrl;
    
    appRecord.appIcon=[UIImage imageWithContentsOfFile: [appRecord ImageCacheFile]];
    if (!appRecord.appIcon)
    {
       downlo=[[IconDownloader alloc]init] ;
        downlo.appRecord=appRecord;
         downlo.delegate = self;
        [downlo startDownload];
    bookpic.image =[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_moren",[[NSUserDefaults standardUserDefaults] objectForKey:@"device"],[[NSUserDefaults standardUserDefaults] objectForKey:@"device"]]];
    }else{
        bookpic.image = appRecord.appIcon;
    }
    
}

- (void)appImageDidLoad:(NSString *)indexPath  selll:(id)selfff{
    bookpic.image =((IconDownloader*)selfff).appRecord.appIcon;

    downlo=nil;
[[NSNotificationCenter defaultCenter] postNotificationName: @"blalertpicdown" object:nil userInfo:nil];
    
}

-(void)faildown:(NSString *)indexPath   selll:(id)selfff
{

    downlo=nil;

}

-(id)init
{
if(self=[super init])
{
    bookname=[[[UILabel alloc]init ] autorelease];
   
  
    editer=[[[UILabel alloc]init ] autorelease];
//    redu=[[[UILabel alloc]init] autorelease];
    redu=nil;
    zishu=[[[UILabel alloc]init] autorelease];
    fenlei=[[[UILabel alloc]init] autorelease];
    nowdowning=[[[UIButton alloc]init ] autorelease];
    bookjianjie=[[[UITextView alloc] init] autorelease];
    closebut=[[[UIButton alloc]init]autorelease];
    bookpic=[[[UIImageView alloc]init] autorelease];
    bgroundview=[[[UIImageView alloc]init]autorelease];
    bookpicback=[[[UIImageView alloc]init]autorelease];
    bookjianjie.editable=NO;
    bookjianjie.backgroundColor=[UIColor clearColor];
    bookname.textAlignment = NSTextAlignmentLeft;
    bookname.backgroundColor = [UIColor clearColor];
    editer.textAlignment = NSTextAlignmentLeft;
    editer.backgroundColor=[UIColor clearColor];
    
    prolab=[[[UILabel alloc]init] autorelease];

    [self addSubview:bgroundview];
    [self addSubview:bookname];
    [self addSubview:nowdowning];
    [self addSubview:bookjianjie];
    [self addSubview:bookpic];
    [self addSubview:bookpicback];
    [self addSubview:prolab];
    [self addSubview:closebut];
    [self addSubview:editer];
    [self addSubview:redu];
    [self addSubview:fenlei];
    [self addSubview:zishu];
}
    
    bookjianjie.textColor=[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];

    [closebut addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [nowdowning addTarget:self action:@selector(ActionClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedirect:)
                                                 name:@"derectchanggexx"
                                               object:nil];
    
    
    
    NSString*device;
    NSString*fangxiang = nil;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            fangxiang=@"v";
            break;
        case UIInterfaceOrientationLandscapeLeft:
            fangxiang=@"h";
            break;
        case UIInterfaceOrientationLandscapeRight:
            fangxiang=@"h";
            break;
        default:
            
            break;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    
        device=@"iPad";
        editer.numberOfLines=1;
        
        bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        
        editer.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        redu.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        zishu.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:13];
        fenlei.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        bookjianjie.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:17];
        [closebut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_introductionAlertBoxClose"] forState:UIControlStateNormal];
        //[closebut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_introductionAlertBoxCloseClicked"] forState:UIControlStateHighlighted];
        nowdowning.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        bgroundview.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_introductionAlertBoxBackground"];
        bookpicback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookCoverBackgroud"];
        

        
    }
    else
    {
        device=@"iPhone";
        editer.numberOfLines=1;
        bookname.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        editer.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:13];
        bookjianjie.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:13];
        nowdowning.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        
        fenlei.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:13];
        zishu.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:11];
        redu.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:11];

        [closebut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_introductionAlertBoxClose"]forState:UIControlStateNormal];
        //[closebut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_introductionAlertBoxClose"] forState:UIControlStateHighlighted];
        //[closebut setImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_introductionAlertBoxCloseClicked"] forState:UIControlStateNormal];
        
        bgroundview.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_introductionAlertBoxBackground"];
        bookpicback.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPhone/iPhone_bookCoverBackgroud"];
        

        
        
        
    }
//    bookname.lineBreakMode=NSLineBreakByClipping;
    prolab.text=nil;
    prolab.backgroundColor=[UIColor clearColor];
    prolab.textColor=[UIColor blackColor];
    prolab.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStoreProgressUpdateFunction:) name:EBookLocalStoreProgressUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];
    
    
    [self setselfsize:device horv:fangxiang];
    return self;

}
//进度
-(void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification{
    NSDictionary *bookdic=[notification userInfo];
    
    if([[bookinfor objectForKey:@"source"] isEqualToString:[bookdic objectForKey:@"source"]])
    {
    prolab.text=[NSString stringWithFormat:@"%2.0f%%",[[bookdic objectForKey:@"percent"] floatValue]*100];
    
    }
    
}
//下载完成
-(void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification{
    NSDictionary *bookdic=[notification userInfo];
    if([[bookinfor objectForKey:@"source"] isEqualToString:[bookdic objectForKey:@"source"]]){
        [self setstate:1];
    }
    
}
//开始阅读
-(void)startread{
    if ([[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus:bookinfor]]==1) {
        
        [bookinfor setObject: [[bookinfor objectForKey:@"source"] absoluteorRelative]  forKey:@"url"];
        [bookinfor setObject:[bookinfor objectForKey:@"title"]  forKey:@"name"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SmalleEbook-StartBookReadingNotification" object:nil userInfo:bookinfor];
    }
[self CloseClick:nil];
}
-(void)setBookinfor:(NSMutableDictionary *)_bookinfor
{
if(bookinfor!=_bookinfor)
{
    [bookinfor release];
    bookinfor=_bookinfor;
    [bookinfor retain];
}
    
prolab.text=[NSString stringWithFormat:@"%2.0f%%",[[bookinfor objectForKey:@"percent"] floatValue]*100];
}



-(void)setselfsize:(NSString*)device horv:(NSString*)horv
{
  if([device isEqualToString:@"iPad"])
  {
    if([horv isEqualToString:@"h"])
    {
        self.frame=CGRectMake(0, 0, 1024, 768);
        bookname.frame=CGRectMake(370, 200+5, 200, 30);
        editer.frame=CGRectMake(470, 255, 200, 20);
        
        nowdowning.frame=CGRectMake(290, 449, 198, 40);
        bookjianjie.frame=CGRectMake(465, 290, 200, 250);
        closebut.frame=CGRectMake(668, 178, 69, 32);
        bookpicback.frame=CGRectMake(210, 316, 120, 165);
        bookpic.frame=CGRectMake(323, 293, 87, 126);
        bgroundview.frame=CGRectMake(179, 287, 410, 450);
        
        //prolab.frame=CGRectMake(320, 415, 93, 50);
    }
      else
      {
      self.frame=CGRectMake(0, 0, 768, 1024);
          
          bookname.frame=CGRectMake(307+10, 231+5, 288-10, 40);
          editer.frame=CGRectMake(307+10, 286, 200-10, 16);
          
          fenlei.frame=CGRectMake(307+10, 322, 200-10, 16);
          
          redu.frame=CGRectMake(350, 412, 200, 16);
          
          //zishu.frame=CGRectMake(350, 408, 200, 16);
          
          nowdowning.frame=CGRectMake(307+10, 364, 198, 40);
          bookjianjie.frame=CGRectMake(172, 436, 423, 327);
          closebut.frame=CGRectMake(603, 201, 34, 34);
          bookpicback.frame=CGRectMake(172, 239, 120, 165);
          bookpic.frame=CGRectMake(177, 246, 110, 151);
          bgroundview.frame=CGRectMake(137, 208, 493, 607);
//          180  282   43  74
//407 450
          //prolab.frame=CGRectMake(200, 545, 93, 50);
      }
      
      
  }
    else
    {
        if([horv isEqualToString:@"h"])
        {
            self.frame=CGRectMake(0, 0, 0, 0);
        }
        else
        {
            
            
            
            if([UIScreen mainScreen].bounds.size.height>490)
            {
                self.frame=CGRectMake(0, 0, 320, 568);
                bookname.frame=CGRectMake(122, 89+44+5, 148, 20*2);
                editer.frame=CGRectMake(122, 119+44+7+7, 140, 15);
                redu.frame = CGRectMake(122, 207, 100, 12);
                fenlei.frame = CGRectMake(122, 141+44+10, 143, 20);
                
                nowdowning.frame=CGRectMake(51, 305+44+50-5, 219, 28);
                bookjianjie.frame=CGRectMake(51, 195+44-10, 219, 100+50+10);
                closebut.frame=CGRectMake(270, 55+44, 35, 35);
                bookpicback.frame=CGRectMake(51, 91+44, 61, 84);
                bookpic.frame=CGRectMake(54, 95+44, 55, 76);
                bgroundview.frame=CGRectMake(31, 107, 258, 40+285+10);
            }
            else
            {
                self.frame=CGRectMake(0, 0, 320, 480);
                
                bookname.frame=CGRectMake(122, 89+5, 143, 20*2);
                
                fenlei.frame=CGRectMake(122, 141+10, 140, 12);
                
                editer.frame=CGRectMake(122,119+5+7 , 140, 15);
                
                redu.frame = CGRectMake(122, 163, 100, 12);
                
                //zishu.frame = CGRectMake(122, 155, 100, 12);
                
                nowdowning.frame=CGRectMake(51, 305+20-3, 219, 28);
                
                bookjianjie.frame=CGRectMake(50, 195-10, 225-3, 100+10+20-3);
               
                closebut.frame=CGRectMake(270, 55, 28, 28);
                
                bookpicback.frame=CGRectMake(51, 91, 61, 84);
                bookpic.frame=CGRectMake(54, 95, 55, 76);
                bgroundview.frame=CGRectMake(31, 63, 258, 285+20);
                
                //prolab.frame=CGRectMake(54, 213, 56, 30);
            }
            
            
            
        }
    
    }
    
}



-(void)ActionClick:(id)sender{
    if (delegate && [(NSObject*)delegate respondsToSelector:@selector(ActionClick:)])
    {
        [self.delegate ActionClick:self.bookinfor];
    }
    [self CloseClick:nil];
}


-(void)CloseClick:(id)sender{
    
    self.alpha=1.0;
    [UIView animateWithDuration:0.75
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
                         self.alpha=0.0;
					 }
					 completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}


-(void)changedirect:(NSNotification *)notification
{
NSDictionary *dirr=[notification userInfo];
    [self setselfsize:[dirr objectForKey:@"device"] horv:[dirr objectForKey:@"fangxiang"]];
    
    
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
            nowdowning.enabled=YES;
//            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload",device,device]] forState:UIControlStateNormal];
            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownload12",device,device]] forState:UIControlStateNormal];
            [nowdowning setTitle:@"立即下载" forState:0];
            [nowdowning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            break;
        case 0:
            nowdowning.enabled=NO;
//            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookDownloading1",device,device]] forState:UIControlStateNormal];
             [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/blank_btn_ipad",device]] forState:UIControlStateNormal];
            
            
            [nowdowning setTitle:@"下载中" forState:0];
            [nowdowning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
        case 1:
//            nowdowning.enabled=NO;
//            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_introductionAlertBox",device,device]] forState:UIControlStateNormal];
//            [nowdowning setTitle:@"已下载" forState:0];
//            [nowdowning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            nowdowning.enabled=YES;
//            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_bookStartReadingBtn",device,device]] forState:UIControlStateNormal];
             [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/blank_btn_ipad",device]] forState:UIControlStateNormal];
            [nowdowning setTitle:@"开始阅读" forState:0];
            [nowdowning setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [nowdowning removeTarget:self action:@selector(ActionClick:) forControlEvents:UIControlEventTouchUpInside];
            [nowdowning addTarget:self action:@selector(startread) forControlEvents:UIControlEventTouchUpInside];
            prolab.text=@"100%";
            
            break;
        case 2:
            nowdowning.enabled=YES;
            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_introductionAlertBoxDownload",device,device]] forState:UIControlStateNormal];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            [nowdowning setTitle:@"下载出错  请重试" forState:0];
            }
            else
            {
            [nowdowning setTitle:@"点击重试" forState:0];
            }
            [nowdowning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            break;
        case 3:
            nowdowning.enabled=YES;
            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_introductionAlertBoxDownload",device,device]] forState:UIControlStateNormal];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            [nowdowning setTitle:@"解压错误  请重试" forState:0];
            }
            else
            {
            [nowdowning setTitle:@"点击重试" forState:0];
            
            }
            [nowdowning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 4:
            nowdowning.enabled=NO;
            [nowdowning setBackgroundImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_introductionAlertBox",device,device]] forState:UIControlStateNormal];
            [nowdowning setTitle:@"已下载过" forState:0];
            [nowdowning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            break;
        case 5:
            nowdowning.enabled=YES;
            [nowdowning setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_bookDownload12"] forState:UIControlStateNormal];
            [nowdowning setTitle:@"已暂停" forState:0];
            
            [nowdowning setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }


}

@end
