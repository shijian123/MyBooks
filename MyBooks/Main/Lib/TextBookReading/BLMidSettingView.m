

#import "BLMidSettingView.h"
#import "EBookLocalStore.h"
@interface BLMidSettingView( )
-(void)setbutpic;
-(void)listdismiss;
-(void)setdismiss;
@end


@implementation BLMidSettingView
@synthesize delegate,ChapterEnqin,backgroundview,style,showed,background2,mumu,titlecolor,textcolor,selectcolor,hilightedcolor,titlefont;
@synthesize showvip;
-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.titlefont=nil;
    self.hilightedcolor=nil;
    self.selectcolor=nil;
    self.titlecolor=nil;
    self.textcolor=nil;
    self.delegate=nil;
    self.ChapterEnqin=nil;
    self.style=nil;
    [titlelab release];
    [disbut release];
    [top release];
    [bot release];
    [left release];
    [set release];
    
    [pro release];
    
    [readproback release];
    [readpro release];
    [readprolab release];
    
    
    [setout release];
    [setback release];
    [sun1 release];
    [sun2 release];
    
    [pifu release];
    [pifuout release];
    [pifuback release];
    
    
    
    
    [ziti release];
    [zitiout release];
    [zitiback release];
    
    [jianjiao release];
    [jianjiaos release];
    [readproshade release];
    [readproshade1 release];
    
    [pagestyle1 release];
    [pagestyle2 release];
    [pagestyle3 release];
    [pagestyle1back1 release];
    [pagestyle1back2 release];
    [pagestyle1back3 release];
    [pagestylelab1 release];
    [pagestylelab2 release];
    [pagestylelab3 release];
    
    [pifu1 release];
    [pifu2 release];
    [pifu3 release];
    [pifu4 release];
    [pifu5 release];
    [pifu6 release];
    [pifuback1 release];
    [pifuback2 release];
    [pifuback3 release];
    [pifuback4 release];
    [pifuback5 release];
    [pifuback6 release];
    
    
    [ziti1 release];
    [ziti2 release];
    [ziti3 release];
    [fontbig release];
    [fontsmall release];
    
    
    [backbut release];
    [mulubut release];
    
    [daytimeBut release];
    [bringhtnessbut release];
    [bookmarkBut release];
    [booklistbut release];
    [marklistbut release];
    [listtable release];
    [markable release];
    [leftchoose release];
    [leftchooseback release];
    
    
    [switchbut release];
    [listbackbut release];
    
    [timelab release];
    [reg release];
    [timer invalidate];
    
    
    
    [super dealloc];
}

#pragma mark - View lifecycle

-(void)loadselfview
{
    
    readproshade=[[UIImageView alloc] initWithImage:[UIImage imagefileNamed:@"BLBookpic.bundle/shadowline"]] ;
    readproshade1=[[UIImageView alloc] initWithImage:[UIImage imagefileNamed:@"BLBookpic.bundle/shadowline"]] ;
    
    readproshade.frame=CGRectMake(0, 0, 1024, 1);
    is5h=NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        is5h=NO;
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height>490)
        {
            if(self.view.bounds.size.width>490)
            {
                is5h=YES;
            }
            
        }
    }
    if(style.SkinIndex!=5)
	{
		daytimeyes=YES;
        daytime=@"b";
	}
	else
	{
		daytimeyes=NO;
        daytime=@"d";
        
	}
    titlelab=[[UILabel alloc] init] ;
    titlelab.textColor=[UIColor blackColor];
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text=[self.ChapterEnqin BookName];
    titlelab.backgroundColor=[UIColor clearColor];
    
    
    NSString *pattern=@"^(\\d)*( 、|：|\\.)*";
    reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    [reg retain];
    self.view.clipsToBounds=YES;
    self.view.backgroundColor=[UIColor clearColor];
    jianjiao=[[UIImageView alloc] init];
    jianjiaos=[[UIImageView alloc] init];
    top=[[UIImageView alloc] init];
    bot=[[UIImageView alloc] init];
    left=[[UIView alloc]init];
    
    
    readproback=[[UIView alloc] init];
    readpro=[[UISlider alloc] init];
    readprolab=[[UILabel alloc] init];
    
    
    
    //top
    backbut=[[UIButton alloc] init];
    
    bookmarkBut=[[UIButton alloc] init];
    
    //bot
    daytimeBut=[[UIButton alloc] init];
    mulubut=[[UIButton alloc] init];
    switchbut=[[UIButton alloc] init];
    
    
    
    
    //bringt
    bringhtnessbut=[[UIButton alloc]init];
    set=[[UIView alloc] init];
    pro=[[UISlider alloc] init];
    setback=[[UIButton alloc] init];
    sun1=[[UIImageView alloc] init];
    sun2=[[UIImageView alloc] init];
    //pifu
    pifuout=[[UIButton alloc] init];
    pifu=[[UIView alloc] init];
    pifuback=[[UIButton alloc] init];
    pagestyle1=[[UIButton alloc] init];
    pagestyle2=[[UIButton alloc] init];
    pagestyle3=[[UIButton alloc] init];
    pagestyle1back1=[[UIImageView alloc] init];
    pagestyle1back2=[[UIImageView alloc] init];
    pagestyle1back3=[[UIImageView alloc] init];
    pagestylelab1=[[UILabel alloc]init];
    pagestylelab2=[[UILabel alloc]init];
    pagestylelab3=[[UILabel alloc]init];
    pifu1=[[UIButton alloc] init];
    pifu2=[[UIButton alloc] init];
    pifu3=[[UIButton alloc] init];
    pifu4=[[UIButton alloc] init];
    pifu5=[[UIButton alloc] init];
    pifu6=[[UIButton alloc] init];
    
    pifuback1=[[UIImageView alloc] init];
    pifuback2=[[UIImageView alloc] init];
    pifuback3=[[UIImageView alloc] init];
    pifuback4=[[UIImageView alloc] init];
    pifuback5=[[UIImageView alloc] init];
    pifuback6=[[UIImageView alloc] init];
    
    
    //ziti
    zitiout=[[UIButton alloc] init];
    ziti=[[UIView alloc] init];
    zitiback=[[UIButton alloc] init];
    ziti1=[[UIButton alloc] init];
    ziti2=[[UIButton alloc] init];
    ziti3=[[UIButton alloc] init];
    fontbig=[[UIButton alloc] init];
    fontsmall=[[UIButton alloc] init];
    
    
    //left
    
    listtable=[[UITableView alloc] init];
    markable=[[UITableView alloc] init];
    listbackbut=[[UIButton alloc] init];
    booklistbut=[[UIButton alloc] init];
    marklistbut=[[UIButton alloc] init];
    leftchoose=[[UIImageView alloc] init];
    leftchooseback=[[UIImageView alloc] init];
    
    
    
    
    
    
    readprolab.backgroundColor=[UIColor clearColor];
    
    readprolab.text=@"?/?";
    
    
    
    
    
    
    pagestylelab1.backgroundColor=[UIColor clearColor];
    pagestylelab2.backgroundColor=[UIColor clearColor];
    pagestylelab3.backgroundColor=[UIColor clearColor];
    pagestylelab1.textAlignment=NSTextAlignmentCenter;
    pagestylelab2.textAlignment=NSTextAlignmentCenter;
    pagestylelab3.textAlignment=NSTextAlignmentCenter;
    pagestyle1.tag=1;
    pagestyle2.tag=2;
    pagestyle3.tag=3;
    [pagestyle1 addTarget:self action:@selector(fanyechoose:) forControlEvents:UIControlEventTouchUpInside];
    [pagestyle2 addTarget:self action:@selector(fanyechoose:) forControlEvents:UIControlEventTouchUpInside];
    [pagestyle3 addTarget:self action:@selector(fanyechoose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pifu1.tag=1;
    pifu2.tag=2;
    pifu3.tag=3;
    pifu4.tag=4;
    pifu5.tag=5;
    pifu6.tag=6;
    
    [pifu1 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    [pifu2 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    [pifu3 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    [pifu4 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    [pifu5 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    [pifu6 addTarget:self action:@selector(shinchoose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [fontbig addTarget:self  action:@selector(fonttobig:) forControlEvents:UIControlEventTouchUpInside];
    [fontsmall addTarget:self action:@selector(fonttosmall:) forControlEvents:UIControlEventTouchUpInside];
    
    ziti1.tag=1;
    ziti2.tag=2;
    ziti3.tag=3;
    
    [ziti1 addTarget:self action:@selector(zitichoose:) forControlEvents:UIControlEventTouchUpInside];
    [ziti2 addTarget:self action:@selector(zitichoose:) forControlEvents:UIControlEventTouchUpInside];
    [ziti3 addTarget:self action:@selector(zitichoose:) forControlEvents:UIControlEventTouchUpInside];
    
    disbut=[[UIButton alloc]initWithFrame:self.view.bounds];
    [disbut addTarget:self action:@selector(anidisappear) forControlEvents:UIControlEventTouchDown];
    listbackbut=[[UIButton alloc]initWithFrame:self.view.bounds];
    [listbackbut addTarget:self action:@selector(listdismiss) forControlEvents:UIControlEventTouchDown];
    
    
    [pifuback addTarget:self action:@selector(pifudismiss) forControlEvents:UIControlEventTouchDown];
    
    [zitiback addTarget:self action:@selector(zitidismiss) forControlEvents:UIControlEventTouchDown];
    
    [setback addTarget:self action:@selector(setdiss) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    
    
    [disbut setExclusiveTouch:YES];
    [pro setExclusiveTouch:YES];
    [readpro setExclusiveTouch:YES];
    [setout setExclusiveTouch:YES];
    [setback setExclusiveTouch:YES];
    [pifuout setExclusiveTouch:YES];
    [pifuback setExclusiveTouch:YES];
    [zitiout setExclusiveTouch:YES];
    [zitiback setExclusiveTouch:YES];
    [pagestyle1 setExclusiveTouch:YES];
    [pagestyle2 setExclusiveTouch:YES];
    [pagestyle3 setExclusiveTouch:YES];
    [pifu1 setExclusiveTouch:YES];
    [pifu2 setExclusiveTouch:YES];
    [pifu3 setExclusiveTouch:YES];
    [pifu4 setExclusiveTouch:YES];
    [pifu5 setExclusiveTouch:YES];
    [pifu6 setExclusiveTouch:YES];
    [ziti1 setExclusiveTouch:YES];
    [ziti2 setExclusiveTouch:YES];
    [ziti3 setExclusiveTouch:YES];
    [fontbig setExclusiveTouch:YES];
    [fontsmall setExclusiveTouch:YES];
    [backbut setExclusiveTouch:YES];
    [mulubut setExclusiveTouch:YES];
    [daytimeBut setExclusiveTouch:YES];
    [bringhtnessbut setExclusiveTouch:YES];
    [bookmarkBut setExclusiveTouch:YES];
    [booklistbut setExclusiveTouch:YES];
    [marklistbut setExclusiveTouch:YES];
    [switchbut setExclusiveTouch:YES];
    [listbackbut setExclusiveTouch:YES];
    
    readproback.clipsToBounds=YES;
    bot.clipsToBounds=YES;
    
    readprolab.textAlignment=NSTextAlignmentRight;
    
    //TODO:dd
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        movekey=1;
        device=@"iPad";
        
        
        if(self.view.frame.size.width>788)
        {
            diviecemode=@"h";
            
            jianjiao.frame=CGRectMake(0, 0, 26, 10);
            jianjiaos.frame=CGRectMake(0, 0, 26, 10);
            top.frame=CGRectMake(0, 0, self.view.bounds.size.width, 90);
            
            
            bot.frame=CGRectMake(0, self.view.bounds.size.height-90, self.view.bounds.size.width, 90);
            
            left.frame= CGRectMake(-554, 0,554 , self.view.bounds.size.height);
            
            titlelab.frame=CGRectMake(0, 24, left.bounds.size.width, 30);
            int key=self.view.bounds.size.width/5;
            //pifu
            
            pifuback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            pifu.frame=CGRectMake(0, self.view.bounds.size.height-90-186, self.view.bounds.size.width, 186);
            
            backbut.frame=CGRectMake(30, 0, 88, 88);
            
            //brint
            bringhtnessbut.frame=CGRectMake(760, 0, 88, 88);
            bookmarkBut.frame=CGRectMake(1024-30-88, 0, 88, 88);
            
            
            
            
            
            mulubut.frame=CGRectMake(key*0.5-44, 0, 88, 88);
            
            daytimeBut.frame=CGRectMake(key*1.5-44, 0, 88, 88);
            
            pifuout.frame=CGRectMake(self.view.bounds.size.width/2-44, 0, 88, 88);
            zitiout.frame=CGRectMake(key*3.5-44, 0, 88, 88);
            switchbut.frame=CGRectMake(key*4.5-44, 0, 88, 88);
            
            int pagekey1=(354-70*3)/4;
            
            int pagekey2=(186-44)/2-96/2;
            
            
            pagestyle3.frame=CGRectMake(pagekey1, pagekey2+5, 70, 96);
            pagestyle2.frame=CGRectMake(pagekey1*2+70, pagekey2-4+5, 70, 100);
            pagestyle1.frame=CGRectMake(pagekey1*3+70*2, pagekey2+5, 70, 96);
            
            pagestyle1back3.frame=CGRectMake(pagekey1-8, pagekey2+5-9, 86, 114);
            pagestyle1back2.frame=CGRectMake(pagekey1*2+70-8, pagekey2-9+5, 86, 114);
            pagestyle1back1.frame=CGRectMake(pagekey1*3+70*2-8, pagekey2-9+5, 86, 114);
            pagestylelab3.frame=CGRectMake(pagekey1, pagekey2+96+9*3, 70, 20);
            pagestylelab2.frame=CGRectMake(pagekey1*2+70, pagekey2+96+9*3, 70, 20);
            pagestylelab1.frame=CGRectMake(pagekey1*3+70*2, pagekey2+96+9*3, 70, 20);
            int pifukey1=(1024-354-88*6)/7;
            int pifukey2=(186-88)/2;
            
            
            pifu2.frame=CGRectMake(354+pifukey1*1+88*0, pifukey2, 88, 88);
            pifu4.frame=CGRectMake(354+pifukey1*2+88*1, pifukey2, 88, 88);
            pifu3.frame=CGRectMake(354+pifukey1*3+88*2, pifukey2, 88, 88);
            pifu1.frame=CGRectMake(354+pifukey1*4+88*3, pifukey2, 88, 88);
            pifu5.frame=CGRectMake(354+pifukey1*5+88*4, pifukey2, 88, 88);
            pifu6.frame=CGRectMake(354+pifukey1*6+88*5, pifukey2, 88, 88);
            
            pifuback2.frame=CGRectMake(354+pifukey1*1+88*0-5-1, pifukey2-5, 98, 98);
            pifuback4.frame=CGRectMake(354+pifukey1*2+88*1-5-1, pifukey2-5, 98, 98);
            pifuback3.frame=CGRectMake(354+pifukey1*3+88*2-5-1, pifukey2-5, 98, 98);
            pifuback1.frame=CGRectMake(354+pifukey1*4+88*3-5-1, pifukey2-5, 98, 98);
            pifuback5.frame=CGRectMake(354+pifukey1*5+88*4-5-1, pifukey2-5, 98, 98);
            pifuback6.frame=CGRectMake(354+pifukey1*6+88*5-5-1, pifukey2-5, 98, 98);
            
            
            set.frame=CGRectMake(0, 90-2, self.view.bounds.size.width, 86);
            pro.frame=CGRectMake(119, 36, 786, 14);
            sun1.frame=CGRectMake(pro.frame.origin.x-55, 21, 40, 40);
            sun2.frame=CGRectMake(pro.frame.origin.x+pro.frame.size.width+30, 21, 40, 40);
            
            readproback.frame=CGRectMake(0, self.view.bounds.size.height-90-90+1, self.view.bounds.size.width, 90);
            
            readpro.frame=CGRectMake((1024-786)/2-45, 36, 786, 14);
            readprolab.frame=CGRectMake(readpro.frame.origin.x+readpro.frame.size.width+10, 32, 80, 20);
            
            
            setback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            //ziti
            ziti.frame=CGRectMake(0, self.view.bounds.size.height-90-186,self.view.bounds.size.width,186);
            ziti.clipsToBounds=YES;
            zitiback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            ziti1.frame=CGRectMake(self.view.bounds.size.width/2-38-236/2-236, 108, 236, 63);
            ziti2.frame=CGRectMake(self.view.bounds.size.width/2-236/2, 108, 236, 63);
            ziti3.frame=CGRectMake(self.view.bounds.size.width/2+38+236/2, 108, 236, 63);
            
            fontbig.frame=CGRectMake(self.view.bounds.size.width/2+20, 15, 236, 63);
            fontsmall.frame=CGRectMake(self.view.bounds.size.width/2-20-236, 15, 236, 63);
            
            listtable.frame=CGRectMake(0, 160, left.bounds.size.width, self.view.bounds.size.height-160);
            markable.frame=CGRectMake(0,160, left.bounds.size.width,self.view.bounds.size.height-160);
            booklistbut.frame=CGRectMake(left.bounds.size.width/2-150, 67, 150, 44);
            marklistbut.frame=CGRectMake(left.bounds.size.width/2, 67, 150, 44);
            leftchoose.frame=CGRectMake((left.bounds.size.width-300)/2, 110, 150, 3);
            leftchooseback.frame=CGRectMake((left.bounds.size.width-300)/2, 110, 300, 3);
        }
        else
        {
            diviecemode=@"v";
            
            jianjiao.frame=CGRectMake(0, 0, 26, 10);
            jianjiaos.frame=CGRectMake(0, 0, 26, 10);
            top.frame=CGRectMake(0, 0, self.view.bounds.size.width, 90);
            
            
            bot.frame=CGRectMake(0, self.view.bounds.size.height-90, self.view.bounds.size.width, 90);
            
            left.frame= CGRectMake(-554, 0,554 , self.view.bounds.size.height);
            
            titlelab.frame=CGRectMake(0, 24, left.bounds.size.width, 30);
            int key=self.view.bounds.size.width/5;
            //pifu
            
            pifuback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            pifu.frame=CGRectMake(0, self.view.bounds.size.height-90-230, self.view.bounds.size.width, 230);
            
            backbut.frame=CGRectMake(30, 0, 88, 88);
            
            //brint
            bringhtnessbut.frame=CGRectMake(525, 0, 88, 88);
            bookmarkBut.frame=CGRectMake(768-30-88, 0, 88, 88);
            
            mulubut.frame=CGRectMake(key*0.5-44, 0, 88, 88);
            
            daytimeBut.frame=CGRectMake(key*1.5-44, 0, 88, 88);
            
            pifuout.frame=CGRectMake(self.view.bounds.size.width/2-44, 0, 88, 88);
            zitiout.frame=CGRectMake(key*3.5-44, 0, 88, 88);
            switchbut.frame=CGRectMake(key*4.5-44, 0, 88, 88);
            
            int pagekey1=(383-70*3)/4;
            
            int pagekey2=(230-44)/2-96/2;
            
            
            pagestyle3.frame=CGRectMake(pagekey1, pagekey2+5, 70, 96);
            pagestyle2.frame=CGRectMake(pagekey1*2+70, pagekey2-4+5, 70, 100);
            pagestyle1.frame=CGRectMake(pagekey1*3+70*2, pagekey2+5, 70, 96);
            
            pagestyle1back3.frame=CGRectMake(pagekey1-8, pagekey2+5-9, 86, 114);
            pagestyle1back2.frame=CGRectMake(pagekey1*2+70-8, pagekey2-9+5, 86, 114);
            pagestyle1back1.frame=CGRectMake(pagekey1*3+70*2-8, pagekey2-9+5, 86, 114);
            pagestylelab3.frame=CGRectMake(pagekey1, pagekey2+96+9*3, 70, 20);
            pagestylelab2.frame=CGRectMake(pagekey1*2+70, pagekey2+96+9*3, 70, 20);
            pagestylelab1.frame=CGRectMake(pagekey1*3+70*2, pagekey2+96+9*3, 70, 20);
            int pifukey1=(768-384-88*3)/4;
            int pifukey2=(230-88*2)/3;
            int pifukey3=((230-88*2)/3)*2+88;
            
            
            pifu2.frame=CGRectMake(383+pifukey1*1+88*0, pifukey2, 88, 88);
            pifu4.frame=CGRectMake(383+pifukey1*2+88*1, pifukey2, 88, 88);
            pifu3.frame=CGRectMake(383+pifukey1*3+88*2, pifukey2, 88,     88);
            pifu1.frame=CGRectMake(383+pifukey1*1+88*0, pifukey3, 88, 88);
            pifu5.frame=CGRectMake(383+pifukey1*2+88*1, pifukey3, 88, 88);
            pifu6.frame=CGRectMake(383+pifukey1*3+88*2, pifukey3, 88, 88);
            
            pifuback2.frame=CGRectMake(383+pifukey1*1+88*0-5-1, pifukey2-5, 98, 98);
            pifuback4.frame=CGRectMake(383+pifukey1*2+88*1-5-1, pifukey2-5, 98, 98);
            pifuback3.frame=CGRectMake(383+pifukey1*3+88*2-5-1, pifukey2-5, 98, 98);
            pifuback1.frame=CGRectMake(383+pifukey1*1+88*0-5-1, pifukey3-5, 98, 98);
            pifuback5.frame=CGRectMake(383+pifukey1*2+88*1-5-1, pifukey3-5, 98, 98);
            pifuback6.frame=CGRectMake(383+pifukey1*3+88*2-5-1, pifukey3-5, 98, 98);
            
            
            set.frame=CGRectMake(0, 90-2, self.view.bounds.size.width, 86);
            pro.frame=CGRectMake((768-564)/2, 36, 564, 14);
            sun1.frame=CGRectMake(pro.frame.origin.x-55, 21, 40, 40);
            sun2.frame=CGRectMake(pro.frame.origin.x+pro.frame.size.width+30, 21, 40, 40);
            
            readproback.frame=CGRectMake(0, self.view.bounds.size.height-90-90+1, self.view.bounds.size.width, 90);
            
            readpro.frame=CGRectMake((768-564)/2-45, 36, 564, 14);
            readprolab.frame=CGRectMake(readpro.frame.origin.x+readpro.frame.size.width+10, 32, 80, 20);
            
            
            setback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            //ziti
            ziti.frame=CGRectMake(0, self.view.bounds.size.height-90-230,self.view.bounds.size.width,230);
            ziti.clipsToBounds=YES;
            zitiback.frame=CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-90-90);
            
            
            ziti1.frame=CGRectMake((384-236)/2, (230-63*3)/4+1, 236, 63);
            ziti2.frame=CGRectMake((384-236)/2,((230-63*3)/4)*2+63, 236, 63);
            ziti3.frame=CGRectMake((384-236)/2, ((230-63*3)/4)*3+63*2-1, 236, 63);
            
            fontbig.frame=CGRectMake(384+(384-236)/2, ((230-63*2)/3), 236, 63);
            fontsmall.frame=CGRectMake(384+(384-236)/2, ((230-63*2)/3)*2+63, 236, 63);
            
            listtable.frame=CGRectMake(0, 160, left.bounds.size.width, self.view.bounds.size.height-160);
            markable.frame=CGRectMake(0,160, left.bounds.size.width,self.view.bounds.size.height-160);
            booklistbut.frame=CGRectMake(left.bounds.size.width/2-150, 67, 150, 44);
            marklistbut.frame=CGRectMake(left.bounds.size.width/2, 67, 150, 44);
            leftchoose.frame=CGRectMake((left.bounds.size.width-300)/2, 110, 150, 3);
            leftchooseback.frame=CGRectMake((left.bounds.size.width-300)/2, 110, 300, 3);
        }
        
        
        [top addSubview:backbut];
        [top addSubview:bookmarkBut];
        [top addSubview:bringhtnessbut];
        
        
        [set addSubview:pro];
        [set addSubview:sun1];
        [set addSubview:sun2];
        
        
        [readproback addSubview:readpro];
        [readproback addSubview:readprolab];
        
        [left addSubview:marklistbut];
        [left addSubview:booklistbut];
        [left addSubview:titlelab];
        [left addSubview:listtable];
        [left addSubview:markable];
        [left addSubview:leftchooseback];
        [left addSubview:leftchoose];
        
        [bot addSubview:switchbut];
        [bot addSubview:daytimeBut];
        [bot addSubview:pifuout];
        [bot addSubview:zitiout];
        [bot addSubview:mulubut];
        
        [ziti addSubview:ziti1];
        [ziti addSubview:ziti2];
        [ziti addSubview:ziti3];
        [ziti addSubview:fontbig];
        [ziti addSubview:fontsmall];
        
        [pifu addSubview:pifuback1];
        [pifu addSubview:pifuback2];
        [pifu addSubview:pifuback3];
        [pifu addSubview:pifuback4];
        [pifu addSubview:pifuback5];
        [pifu addSubview:pifuback6];
        [pifu addSubview:pifu1];
        [pifu addSubview:pifu2];
        [pifu addSubview:pifu3];
        [pifu addSubview:pifu4];
        [pifu addSubview:pifu5];
        [pifu addSubview:pifu6];
        [pifu addSubview:pagestyle1back1];
        [pifu addSubview:pagestyle1back2];
        [pifu addSubview:pagestyle1back3];
        [pifu addSubview:pagestylelab1];
        [pifu addSubview:pagestylelab2];
        [pifu addSubview:pagestylelab3];
        [pifu addSubview:pagestyle1];
        [pifu addSubview:pagestyle2];
        [pifu addSubview:pagestyle3];
        
    }
    else
    {
        device=@"iPhone";
        movekey=0;
        readprolab.textAlignment=NSTextAlignmentCenter;
        if(self.view.frame.size.width>330)
        {
            diviecemode=@"h";
            
            jianjiao.frame=CGRectMake(0, 0, 13, 5);
            jianjiaos.frame=CGRectMake(0, 0, 13, 5);
            top.frame=CGRectMake(0, 0, self.view.bounds.size.width, 44);
            
            
            bot.frame=CGRectMake(0, self.view.bounds.size.height-45, self.view.bounds.size.width, 45);
            //            if(is5h)
            //            {
            //            left.frame= CGRectMake(-517, 0,517 , self.view.bounds.size.height);
            //            }
            //            else
            //            {
            left.frame= CGRectMake(-429, 0,429 , self.view.bounds.size.height);
            //            }
            titlelab.frame=CGRectMake(0, 12, left.bounds.size.width, 22);
            
            //pifu
            
            pifuback.frame=CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-45-44);
            pifu.frame=CGRectMake(0, self.view.bounds.size.height-45-93, self.view.bounds.size.width, 93);
            
            backbut.frame=CGRectMake(21, 0, 44, 44);
            
            //brint
            bringhtnessbut.frame=CGRectMake(self.view.bounds.size.width-133, 0, 44, 44);
            bookmarkBut.frame=CGRectMake(self.view.bounds.size.width-65, 0, 44, 44);
            
            
            
            int key=self.view.bounds.size.width/5;
            
            mulubut.frame=CGRectMake(key*0.5-22, 0, 44, 44);
            
            daytimeBut.frame=CGRectMake(key*1.5-22, 0, 44, 44);
            
            pifuout.frame=CGRectMake(self.view.bounds.size.width/2-22, 0, 44, 44);
            zitiout.frame=CGRectMake(key*3.5-22, 0, 44, 44);
            switchbut.frame=CGRectMake(key*4.5-22, 0, 44, 44);
            
            if(is5h)
            {
                pagestyle3.frame=CGRectMake(16, 13, 35, 48);
                pagestyle2.frame=CGRectMake(65, 11, 35, 50);
                pagestyle1.frame=CGRectMake(114, 13, 35, 48);
                
                pagestyle1back3.frame=CGRectMake(11, 8, 45, 58);
                pagestyle1back2.frame=CGRectMake(60, 8, 45, 58);
                pagestyle1back1.frame=CGRectMake(109, 8, 45, 58);
                pagestylelab3.frame=CGRectMake(16, 71, 35, 14);
                pagestylelab2.frame=CGRectMake(65, 71, 35, 14);
                pagestylelab1.frame=CGRectMake(114, 71, 35, 14);
                
                //                pifu1.frame=CGRectMake(180, 25, 43, 43);
                //                pifu2.frame=CGRectMake(247, 25, 43, 43);
                //                pifu3.frame=CGRectMake(314, 25, 43, 43);
                //                pifu4.frame=CGRectMake(381, 25, 43, 43);
                //                pifu5.frame=CGRectMake(448, 25, 43, 43);
                //                pifu6.frame=CGRectMake(515, 25, 43, 43);
                //
                //                pifuback1.frame=CGRectMake(176, 21, 51, 51);
                //                pifuback2.frame=CGRectMake(243, 21, 51, 51);
                //                pifuback3.frame=CGRectMake(310, 21, 51, 51);
                //                pifuback4.frame=CGRectMake(377, 21, 51, 51);
                //                pifuback5.frame=CGRectMake(444, 21, 51, 51);
                //                pifuback6.frame=CGRectMake(511, 21, 51, 51);
                pifu2.frame=CGRectMake(192, 25, 43, 43);
                pifu4.frame=CGRectMake(254, 25, 43, 43);
                pifu3.frame=CGRectMake(316, 25, 43, 43);
                pifu1.frame=CGRectMake(378, 25, 43, 43);
                pifu5.frame=CGRectMake(440, 25, 43, 43);
                pifu6.frame=CGRectMake(502, 25, 43, 43);
                
                pifuback2.frame=CGRectMake(188, 21, 51, 51);
                pifuback4.frame=CGRectMake(250, 21, 51, 51);
                pifuback3.frame=CGRectMake(312, 21, 51, 51);
                pifuback1.frame=CGRectMake(374, 21, 51, 51);
                pifuback5.frame=CGRectMake(436, 21, 51, 51);
                pifuback6.frame=CGRectMake(498, 21, 51, 51);
                
                
                
                set.frame=CGRectMake(0, 43, self.view.bounds.size.width, 43);
                pro.frame=CGRectMake(102, 15, 364, 14);
                sun1.frame=CGRectMake(67, 11, 20, 20);
                sun2.frame=CGRectMake(480, 11, 20, 20);
                
                readproback.frame=CGRectMake(0, self.view.bounds.size.height-45-45, self.view.bounds.size.width, 45);
                
                readpro.frame=CGRectMake((568-395-60-5)/2, 19, 395, 12);
                readprolab.frame=CGRectMake(readpro.frame.origin.x+readpro.frame.size.width+5, 17, 60, 14);
                
                
                
                //                210 165
                
                
                
                
                
            }
            else
            {
                pagestyle3.frame=CGRectMake(16, 13, 35, 48);
                pagestyle2.frame=CGRectMake(65, 11, 35, 50);
                pagestyle1.frame=CGRectMake(114, 13, 35, 48);
                
                pagestyle1back3.frame=CGRectMake(11, 8, 45, 58);
                pagestyle1back2.frame=CGRectMake(60, 8, 45, 58);
                pagestyle1back1.frame=CGRectMake(109, 8, 45, 58);
                pagestylelab3.frame=CGRectMake(16, 71, 35, 14);
                pagestylelab2.frame=CGRectMake(65, 71, 35, 14);
                pagestylelab1.frame=CGRectMake(114, 71, 35, 14);
                
                pifu2.frame=CGRectMake(180, 25, 43, 43);
                pifu4.frame=CGRectMake(230, 25, 43, 43);
                pifu3.frame=CGRectMake(280, 25, 43, 43);
                pifu1.frame=CGRectMake(330, 25, 43, 43);
                pifu5.frame=CGRectMake(380, 25, 43, 43);
                pifu6.frame=CGRectMake(430, 25, 43, 43);
                
                pifuback2.frame=CGRectMake(176, 21, 51, 51);
                pifuback4.frame=CGRectMake(226, 21, 51, 51);
                pifuback3.frame=CGRectMake(276, 21, 51, 51);
                pifuback1.frame=CGRectMake(326, 21, 51, 51);
                pifuback5.frame=CGRectMake(376, 21, 51, 51);
                pifuback6.frame=CGRectMake(426, 21, 51, 51);
                
                
                
                
                set.frame=CGRectMake(0, 43, self.view.bounds.size.width, 43);
                pro.frame=CGRectMake(58, 15, 364, 14);
                sun1.frame=CGRectMake(23, 11, 20, 20);
                sun2.frame=CGRectMake(480-44, 11, 20, 20);
                
                readproback.frame=CGRectMake(0, self.view.bounds.size.height-45-45, self.view.bounds.size.width, 45);
                
                readpro.frame=CGRectMake((480-395-60-5)/2, 19, 395, 12);
                readprolab.frame=CGRectMake(readpro.frame.origin.x+readpro.frame.size.width+5, 17, 70, 14);
                
                
                
                //                210 165
                
                
                
                
                
            }
            setback.frame=CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-45-44);
            //ziti
            ziti.frame=CGRectMake(0, self.view.bounds.size.height-45-93,self.view.bounds.size.width,93);
            ziti.clipsToBounds=YES;
            zitiback.frame=CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-45-44);
            ziti1.frame=CGRectMake(self.view.bounds.size.width/2-38-119/2-119, 56, 119, 33);
            ziti2.frame=CGRectMake(self.view.bounds.size.width/2-119/2, 56, 119, 33);
            ziti3.frame=CGRectMake(self.view.bounds.size.width/2+38+119/2, 56, 119, 33);
            
            fontbig.frame=CGRectMake(self.view.bounds.size.width/2+20, 9, 119, 33);
            fontsmall.frame=CGRectMake(self.view.bounds.size.width/2-20-119, 9, 119, 33);
            
            listtable.frame=CGRectMake(0, 105, left.bounds.size.width, self.view.bounds.size.height-105);
            markable.frame=CGRectMake(0,105, left.bounds.size.width,self.view.bounds.size.height-105);
            booklistbut.frame=CGRectMake(left.bounds.size.width/2-75, 57, 75, 22);
            marklistbut.frame=CGRectMake(left.bounds.size.width/2, 57, 75, 22);
            leftchoose.frame=CGRectMake((left.bounds.size.width-150)/2, 79, 75, 2);
            leftchooseback.frame=CGRectMake((left.bounds.size.width-150)/2, 79, 150, 2);
            
            
            
            
            
            
        }
        else
        {
            diviecemode=@"v";
            
            jianjiao.frame=CGRectMake(0, 0, 13, 5);
            jianjiaos.frame=CGRectMake(0, 0, 13, 5);
            top.frame=CGRectMake(0, 0, self.view.bounds.size.width, 44);
            bot.frame=CGRectMake(0, self.view.bounds.size.height-45, self.view.bounds.size.width, 45);
            left.frame= CGRectMake(-277, 0,277 , self.view.bounds.size.height);
            
            titlelab.frame=CGRectMake(0, 12, left.frame.size.width, 22);
            
            
            
            //pifu
            
            pifuback.frame=CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-45-44);
            pifu.frame=CGRectMake(0, self.view.bounds.size.height-45-115, self.view.bounds.size.width, 115);
            pagestyle3.frame=CGRectMake(16, 25, 35, 48);
            pagestyle2.frame=CGRectMake(65, 23, 35, 50);
            pagestyle1.frame=CGRectMake(114, 25, 35, 48);
            
            pagestyle1back3.frame=CGRectMake(11, 20, 45, 58);
            pagestyle1back2.frame=CGRectMake(60, 20, 45, 58);
            pagestyle1back1.frame=CGRectMake(109, 20, 45, 58);
            pagestylelab3.frame=CGRectMake(16, 83, 35, 14);
            pagestylelab2.frame=CGRectMake(65, 83, 35, 14);
            pagestylelab1.frame=CGRectMake(114, 83, 35, 14);
            
            
            pifu2.frame=CGRectMake(170, 15, 43, 43);
            pifu4.frame=CGRectMake(220, 15, 43, 43);
            pifu3.frame=CGRectMake(270, 15, 43, 43);
            pifu1.frame=CGRectMake(170, 65, 43, 43);
            pifu5.frame=CGRectMake(220, 65, 43, 43);
            pifu6.frame=CGRectMake(270, 65, 43, 43);
            
            pifuback2.frame=CGRectMake(166, 11, 51, 51);
            pifuback4.frame=CGRectMake(216, 11, 51, 51);
            pifuback3.frame=CGRectMake(266, 11, 51, 51);
            pifuback1.frame=CGRectMake(166, 61, 51, 51);
            pifuback5.frame=CGRectMake(216, 61, 51, 51);
            pifuback6.frame=CGRectMake(266, 61, 51, 51);
            
            //brint
            bringhtnessbut.frame=CGRectMake(217, 0, 44, 44);
            set.frame=CGRectMake(0, 43, 320, 43);
            pro.frame=CGRectMake(54, 15, 212, 14);
            sun1.frame=CGRectMake(25, 11, 20, 20);
            sun2.frame=CGRectMake(280, 11, 20, 20);
            
            readproback.frame=CGRectMake(0, self.view.bounds.size.height-45-45, 320, 45);
            
            readpro.frame=CGRectMake((320-240-50)/2, 19, 240, 12);
            readprolab.frame=CGRectMake(readpro.frame.size.width+readpro.frame.origin.x, 17, 70, 14);
            setback.frame=CGRectMake(0, 44, 320, self.view.bounds.size.height-45-44);
            //ziti
            ziti.frame=CGRectMake(0, self.view.bounds.size.height-45-115, 320, 115);
            ziti.clipsToBounds=YES;
            zitiback.frame=CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-45-44);
            
            
            
            ziti1.frame=CGRectMake(24, 4, 119, 33);
            ziti2.frame=CGRectMake(24, 41, 119, 33);
            ziti3.frame=CGRectMake(24, 78, 119, 33);
            
            fontbig.frame=CGRectMake(180, 20, 119, 33);
            fontsmall.frame=CGRectMake(180, 67, 119, 33);
            
            backbut.frame=CGRectMake(10, 0, 44, 44);
            bookmarkBut.frame=CGRectMake(266, 0, 44, 44);
            listtable.frame=CGRectMake(0, 105, 277, self.view.bounds.size.height-105);
            markable.frame=CGRectMake(0,105, 277,self.view.bounds.size.height-105);
            booklistbut.frame=CGRectMake(63, 57, 75, 22);
            marklistbut.frame=CGRectMake(138, 57, 75, 22);
            leftchoose.frame=CGRectMake(63, 79, 75, 2);
            leftchooseback.frame=CGRectMake(63, 79, 150, 2);
            
            
            int key=self.view.bounds.size.width/5;
            
            mulubut.frame=CGRectMake(key*0.5-22, 0, 44, 44);
            
            daytimeBut.frame=CGRectMake(key*1.5-22, 0, 44, 44);
            
            pifuout.frame=CGRectMake(self.view.bounds.size.width/2-22, 0, 44, 44);
            zitiout.frame=CGRectMake(key*3.5-22, 0, 44, 44);
            switchbut.frame=CGRectMake(key*4.5-22, 0, 44, 44);
        }
        
        
        [top addSubview:backbut];
        [top addSubview:bookmarkBut];
        [top addSubview:bringhtnessbut];
        
        
        [set addSubview:pro];
        [set addSubview:sun1];
        [set addSubview:sun2];
        
        
        [readproback addSubview:readpro];
        [readproback addSubview:readprolab];
        
        [left addSubview:marklistbut];
        [left addSubview:booklistbut];
        [left addSubview:titlelab];
        [left addSubview:listtable];
        [left addSubview:markable];
        [left addSubview:leftchooseback];
        [left addSubview:leftchoose];
        
        [bot addSubview:switchbut];
        [bot addSubview:daytimeBut];
        [bot addSubview:pifuout];
        [bot addSubview:zitiout];
        [bot addSubview:mulubut];
        
        [ziti addSubview:ziti1];
        [ziti addSubview:ziti2];
        [ziti addSubview:ziti3];
        [ziti addSubview:fontbig];
        [ziti addSubview:fontsmall];
        
        [pifu addSubview:pifuback1];
        [pifu addSubview:pifuback2];
        [pifu addSubview:pifuback3];
        [pifu addSubview:pifuback4];
        [pifu addSubview:pifuback5];
        [pifu addSubview:pifuback6];
        [pifu addSubview:pifu1];
        [pifu addSubview:pifu2];
        [pifu addSubview:pifu3];
        [pifu addSubview:pifu4];
        [pifu addSubview:pifu5];
        [pifu addSubview:pifu6];
        [pifu addSubview:pagestyle1back1];
        [pifu addSubview:pagestyle1back2];
        [pifu addSubview:pagestyle1back3];
        [pifu addSubview:pagestylelab1];
        [pifu addSubview:pagestylelab2];
        [pifu addSubview:pagestylelab3];
        [pifu addSubview:pagestyle1];
        [pifu addSubview:pagestyle2];
        [pifu addSubview:pagestyle3];
        
    }
    
    
    
    timelab=[[UILabel alloc]initWithFrame:top.bounds];
    
    timelab.textAlignment=NSTextAlignmentCenter;
    timelab.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    timelab.backgroundColor=[UIColor clearColor];
    timelab.userInteractionEnabled=NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        titlelab.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:19];
        timelab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
        ziti1.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        ziti2.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        ziti3.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        readprolab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
        fontbig.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        fontsmall.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
        booklistbut.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:21];
        marklistbut.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:21];
        pagestylelab1.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        pagestylelab2.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        pagestylelab3.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        
    }
    else
    {
        titlelab.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        timelab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        ziti1.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        ziti2.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        ziti3.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        readprolab.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
        fontbig.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        fontsmall.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
        booklistbut.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:17];
        marklistbut.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:17];
        pagestylelab1.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
        pagestylelab2.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
        pagestylelab3.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
        
    }
    
    [top addSubview:timelab];
    left.clipsToBounds=YES;
    
    
    top.userInteractionEnabled=YES;
    top.alpha=0;
    bot.userInteractionEnabled=YES;
    bot.alpha=0;
    
    readproback.alpha=0;
    backbut.tag=100;
    [backbut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    mulubut.tag=2;
    [mulubut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    daytimeBut.tag=5;
    [daytimeBut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    bookmarkBut.tag=6;
    [bookmarkBut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    booklistbut.tag=7;
    [booklistbut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [booklistbut setTitle:@"目录" forState:UIControlStateNormal];
    marklistbut.tag=8;
    [marklistbut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [marklistbut setTitle:@"书签" forState:UIControlStateNormal];
    
    
    
    
    
    listtable.delegate=self;
    listtable.dataSource=self;
    listtable.backgroundColor=[UIColor clearColor];
    markable.delegate=self;
    markable.dataSource=self;
    markable.backgroundColor=[UIColor clearColor];
    listtable.hidden=YES;
    markable.hidden=YES;
    
    listtable.separatorColor=[UIColor clearColor];
    markable.separatorColor=[UIColor clearColor];
    
    
    
    switchbut.tag=9;
    [switchbut addTarget:self action:@selector(butclick:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    bringhtnessbut.tag=999;
    [bringhtnessbut addTarget:self action:@selector(showset) forControlEvents:UIControlEventTouchUpInside];
    
    [zitiout addTarget:self action:@selector(showziti) forControlEvents:UIControlEventTouchUpInside];
    [pifuout addTarget:self action:@selector(showpifu) forControlEvents:UIControlEventTouchUpInside];
    
    set.alpha=0;
    pifu.alpha=0;
    ziti.alpha=0;
    
    
    
    
    
    //    [self.view addSubview:fanye];
    [self.view addSubview:ziti];
    [self.view addSubview:pifu];
    [self.view addSubview:set];
    //    [self.view addSubview:mulubut];
    [self.view addSubview:top];
    [self.view addSubview:bot];
    [self.view addSubview:left];
    [self.view addSubview:readproback];
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [dateformatter release];
    
    timelab.text=locationString;
    
    [pro addTarget:self action:@selector(provaluechange:) forControlEvents:UIControlEventValueChanged];
    [pro addTarget:self action:@selector(provaluechangeend:) forControlEvents:UIControlEventTouchUpInside];
    [pro addTarget:self action:@selector(provaluechangeend:) forControlEvents:UIControlEventTouchUpOutside];
    
    [readpro addTarget:self action:@selector(readprovaluechange:) forControlEvents:UIControlEventValueChanged];
    [readpro addTarget:self action:@selector(readprovalueset) forControlEvents:UIControlEventTouchUpInside];
    [readpro addTarget:self action:@selector(readprovalueset) forControlEvents:UIControlEventTouchUpOutside];
    [self setbutimages];
    
    
    readprorect=readproback.frame;
    [self setpifuback];
    [self setzitiback];
    [self setfanyeback];
}


-(void)daynightpic
{
    
    
    
    jianjiao.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_jianjiao",device,daytime ]];
    jianjiaos.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_jianjiaos",device,daytime ]];
    top.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/%@_%@/%@_%@_%@_topBar",device,diviecemode,device,daytime,diviecemode ]];
    bot.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/%@_%@/%@_%@_%@_Buttombar",device,diviecemode,device,daytime,diviecemode ]];
    
    set.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_lightswitchBoxBg",device,daytime,diviecemode ]]];
    readproback.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/%@_%@/%@_%@_%@_Buttombar",device,diviecemode,device,daytime,diviecemode ]]];
    
    [backbut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_BackBtn",device,daytime ]] forState:UIControlStateNormal];
    //    [backbut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_BackBtn1",device ]] forState:UIControlStateHighlighted];
    
    [bringhtnessbut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightBtn",device,daytime ]] forState:UIControlStateNormal];
    //    [bringhtnessbut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_lightBtn1",device ]] forState:UIControlStateHighlighted];
    
    [pifuout setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_skinBtn",device,daytime ]] forState:UIControlStateNormal];
    //    [pifuout setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_skinBtn1",device ]] forState:UIControlStateHighlighted];
    [zitiout setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_fontBtn",device,daytime ]] forState:UIControlStateNormal];
    //    [zitiout setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_fontBtn1",device ]] forState:UIControlStateHighlighted];
    [mulubut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_menu",device,daytime]] forState:UIControlStateNormal];
    
    [switchbut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_switchBtn",device,daytime ]] forState:UIControlStateNormal];
    sun1.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_sun2",device,daytime ]];
    sun2.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_sun1",device,daytime ]];
    
    pifu.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_pifubg",device,daytime,diviecemode ]]];
    
    [pagestyle1 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pageMode1",device,daytime ]] forState:UIControlStateNormal];
    [pagestyle2 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pageMode2",device,daytime ]] forState:UIControlStateNormal];
    [pagestyle3 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pageMode3",device,daytime ]] forState:UIControlStateNormal];
    UIImage* pifuseled=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_skinPageSelected",device,daytime ]];
    pifuback1.image=pifuseled;
    pifuback2.image=pifuseled;
    pifuback3.image=pifuseled;
    pifuback4.image=pifuseled;
    pifuback5.image=pifuseled;
    pifuback6.image=pifuseled;
    
    ziti.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_zitiAlertboxbg",device,daytime,diviecemode ]]];
    
    UIImage* fontdefault=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_fontbu",device,daytime ]];
    UIImage* fontselect=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_fontbu1",device,daytime ]];
    
    [ziti1 setBackgroundImage:fontdefault forState:UIControlStateNormal];
    [ziti2 setBackgroundImage:fontdefault forState:UIControlStateNormal];
    [ziti3 setBackgroundImage:fontdefault forState:UIControlStateNormal];
    [ziti1 setBackgroundImage:fontselect forState:UIControlStateHighlighted];
    [ziti2 setBackgroundImage:fontselect forState:UIControlStateHighlighted];
    [ziti3 setBackgroundImage:fontselect forState:UIControlStateHighlighted];
    [ziti1 setBackgroundImage:fontselect forState:UIControlStateSelected];
    [ziti2 setBackgroundImage:fontselect forState:UIControlStateSelected];
    [ziti3 setBackgroundImage:fontselect forState:UIControlStateSelected];
    
    [fontbig setBackgroundImage:fontdefault forState:UIControlStateNormal];
    [fontsmall setBackgroundImage:fontdefault forState:UIControlStateNormal];
    [fontbig setBackgroundImage:fontselect forState:UIControlStateHighlighted];
    [fontsmall setBackgroundImage:fontselect forState:UIControlStateHighlighted];
    [fontbig setBackgroundImage:fontselect forState:UIControlStateSelected];
    [fontsmall setBackgroundImage:fontselect forState:UIControlStateSelected];
    
    UIImage* pageseled=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_pageSelected",device,daytime ]];
    pagestyle1back1.image=pageseled;
    pagestyle1back2.image=pageseled;
    pagestyle1back3.image=pageseled;
    
    UIColor* titlecolors=nil;
    //TODO:color
    
    if([daytime isEqualToString:@"b"])
    {
        self.hilightedcolor=[UIColor  colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1.0];
        self.titlecolor=[UIColor colorWithRed:56/255.0 green:89/255.0 blue:84/255.0 alpha:1.0];
        self.textcolor=[UIColor colorWithRed:68/255.0 green:79/255.0 blue:77/255.0 alpha:1.0];
        titlecolors=self.titlecolor;
        self.selectcolor=[UIColor colorWithRed:43/255.0 green:170/255.0 blue:151/255.0 alpha:1.0];
        [readproback addSubview:readproshade1];
    }
    else
    {
        
        self.hilightedcolor=[UIColor  colorWithRed:20/255.0 green:24/255.0  blue:24/255.0  alpha:1.0];
        self.titlecolor=[UIColor colorWithRed:45/255.0 green:64/255.0 blue:61/255.0 alpha:1.0];
        self.textcolor=[UIColor colorWithRed:40/255.0 green:47/255.0 blue:46/255.0 alpha:1.0];
        titlecolors=[UIColor colorWithRed:49/255.0 green:56/255.0 blue:55/255.0 alpha:1.0];
        self.selectcolor=[UIColor colorWithRed:22/255.0 green:67/255.0 blue:60/255.0 alpha:1.0];
        [readproshade removeFromSuperview];
        [readproshade1 removeFromSuperview];
        
    }
    
    readprolab.textColor=self.selectcolor;
    [fontbig setTitleColor:self.selectcolor forState:UIControlStateNormal];
    timelab.textColor=self.selectcolor;
    [ziti1 setTitleColor:self.selectcolor forState:UIControlStateNormal];
    [ziti2 setTitleColor:self.selectcolor forState:UIControlStateNormal];
    [ziti3 setTitleColor:self.selectcolor forState:UIControlStateNormal];
    pagestylelab1.textColor=self.selectcolor;
    pagestylelab2.textColor=self.selectcolor;
    pagestylelab3.textColor=self.selectcolor;
    [fontsmall setTitleColor:self.selectcolor forState:UIControlStateNormal];
    [booklistbut setTitleColor:titlecolors forState:UIControlStateNormal];
    [marklistbut setTitleColor:titlecolors forState:UIControlStateNormal];
    titlelab.textColor=titlecolors;
    
    
    leftchoose.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lefthoose",device,daytime ]];
    
    leftchooseback.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lefthooseback",device,daytime ]];
    //    if(is5h)
    //    {
    //    left.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_leftback_568",device,daytime,diviecemode ]]];
    //    }
    //    else
    //    {
    left.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_leftback",device,daytime,diviecemode ]]];
    //    }
    
    
    
    [pro setThumbImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchBtn",device,daytime ]]   forState:UIControlStateNormal];
    
    [pro setMinimumTrackImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchColor",device,daytime ]] forState:UIControlStateNormal];
    
    
    [pro setMaximumTrackImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchColorBg",device,daytime ]] forState:UIControlStateNormal];
    
    
    [readpro setThumbImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchBtn",device,daytime ]]   forState:UIControlStateNormal];
    
    [readpro setMinimumTrackImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchColor",device,daytime ]] forState:UIControlStateNormal];
    
    [readpro setMaximumTrackImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_lightswitchColorBg",device ,daytime]] forState:UIControlStateNormal];
    
    [daytimeBut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_Daytime",device,daytime ]] forState:UIControlStateNormal];
    
    [pifu1 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color1",device,daytime]] forState:UIControlStateNormal];
    [pifu2 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color2",device,daytime]] forState:UIControlStateNormal];
    [pifu3 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color3",device,daytime ]] forState:UIControlStateNormal];
    [pifu4 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color4",device,daytime ]] forState:UIControlStateNormal];
    [pifu5 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color5",device,daytime ]] forState:UIControlStateNormal];
    [pifu6 setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_color6",device,daytime ]] forState:UIControlStateNormal];
    
    [markable reloadData];
    [listtable reloadData];
    
    [self setleavesshade];
}


-(void)setbutimages
{
    [self daynightpic];
    
    pagestylelab1.text=@"仿真";
    pagestylelab2.text=@"简约";
    pagestylelab3.text=@"左右";

    
    [ziti1 setTitle:[[[(NSArray *)[style StaticSettinsForKey:@"fonttype"] objectAtIndex:0]  componentsSeparatedByString:@"|"] objectAtIndex:1] forState:UIControlStateNormal];
    [ziti2 setTitle:[[[(NSArray *)[style StaticSettinsForKey:@"fonttype"] objectAtIndex:1]  componentsSeparatedByString:@"|"] objectAtIndex:1] forState:UIControlStateNormal];
    [ziti3 setTitle:[[[(NSArray *)[style StaticSettinsForKey:@"fonttype"] objectAtIndex:2]  componentsSeparatedByString:@"|"] objectAtIndex:1] forState:UIControlStateNormal];
    
    //TODO:color
    [fontbig setTitle:@"A+" forState:UIControlStateNormal];
    [fontsmall setTitle:@"A-" forState:UIControlStateNormal];
    
}

-(void)setzitiback
{
    int key=[[style StaticSettinsForKey:@"fonttypeindex"] intValue];
    ziti1.selected=NO;
    ziti2.selected=NO;
    ziti3.selected=NO;
    
    switch (key) {
        case 0:
            ziti1.selected=YES;
            break;
        case 1:
            ziti2.selected=YES;
            break;
        case 2:
            ziti3.selected=YES;
            break;
            
        default:
            break;
    }
}

-(void)setfanyeback
{
    int key=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
    
    pagestyle1back1.hidden=YES;
    pagestyle1back2.hidden=YES;
    pagestyle1back3.hidden=YES;
    
    switch (key) {
        case 0:
            pagestyle1back1.hidden=NO;
            break;
        case 1:
            pagestyle1back2.hidden=NO;
            break;
        case 2:
            pagestyle1back3.hidden=NO;
            break;
        default:
            break;
    }
    
}

-(void)setpifuback
{
    int key=[style SkinIndex];
    
    pifuback1.hidden=YES;
    pifuback2.hidden=YES;
    pifuback3.hidden=YES;
    pifuback4.hidden=YES;
    pifuback5.hidden=YES;
    pifuback6.hidden=YES;
    switch (key) {
        case 0:
            pifuback1.hidden=NO;
            break;
        case 1:
            pifuback2.hidden=NO;
            break;
        case 2:
            pifuback3.hidden=NO;
            break;
        case 3:
            pifuback4.hidden=NO;
            break;
        case 4:
            pifuback5.hidden=NO;
            break;
        case 5:
            pifuback6.hidden=NO;
            break;
        default:
            break;
    }
}


-(void)provaluechange:(UISlider*)sender
{
    [UIScreen mainScreen].brightness=sender.value;
    
}

-(void)provaluechangeend:(UISlider*)sender
{
    [UIScreen mainScreen].brightness=sender.value;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[UIScreen mainScreen].brightness] forKey:@"daybeforebringtness"];
    
}


//数值变化
-(void)readprovaluechange:(UISlider*)sender
{
    float value=readpro.value;
    int full=0;
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( numberOfPages:)]) {
        full= [self.delegate numberOfPages:nil];
    }
    int key=full*value+1;
    if(key<=0)
    {
        key=0;
    }
    
    if(key>=full)
    {
        key=full;
    }
    
    readprolab.text=[NSString stringWithFormat:@"%d/%d",key,full];
    
    
    
}
//数值确定
-(void)readprovalueset
{
    float value=readpro.value;
    int full=0;
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( numberOfPages:)]) {
        full= [self.delegate numberOfPages:nil];
    }
    int key=full*value;
    
    if(key<0)
    {
        key=0;
    }
    if(key>=full)
    {
        key=full-1;
    }
    
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( pageIndexChanged:)]) {
        [self.delegate pageIndexChanged:key];
    }
}


#pragma mark-设置显示
-(void)showset
{
    [zitiback removeFromSuperview];
    [pifuback removeFromSuperview];
    if([daytime isEqualToString:@"b"])
    {
        [bot addSubview:readproshade];
    }
    
    [self.view addSubview:setback];
    
    [self.view bringSubviewToFront:set];
    
    if(jianjiaos.frame.origin.x==0)
    {
        jianjiaos.frame=CGRectMake(bringhtnessbut.frame.origin.x+bringhtnessbut.frame.size.width/2-jianjiaos.frame.size.width/2,top.frame.origin.y+top.frame.size.height-jianjiaos.frame.size.height, jianjiaos.frame.size.width, jianjiaos.frame.size.height) ;
        jianjiaos.alpha=0;
        [self.view addSubview:jianjiaos];
    }
    [self.view bringSubviewToFront:jianjiaos];
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=0;
        pifu.alpha=0;
        ziti.alpha=0;
        set.alpha=1.0;
        jianjiao.alpha=0;
        jianjiaos.alpha=1.0;
        jianjiaos.frame=CGRectMake(bringhtnessbut.frame.origin.x+bringhtnessbut.frame.size.width/2-jianjiaos.frame.size.width/2,top.frame.origin.y+top.frame.size.height-jianjiaos.frame.size.height, jianjiaos.frame.size.width, jianjiaos.frame.size.height) ;
    }];
    
}
-(void)showpifu
{
    [zitiback removeFromSuperview];
    [setback removeFromSuperview];
    [readproshade removeFromSuperview];
    [self.view addSubview:pifuback];
    [self.view bringSubviewToFront:pifu];
    
    if(jianjiao.frame.origin.x==0)
    {
        jianjiao.frame=CGRectMake(pifuout.frame.origin.x+pifuout.frame.size.width/2-jianjiao.frame.size.width/2,bot.frame.origin.y-1-movekey, jianjiao.frame.size.width, jianjiao.frame.size.height) ;
        jianjiao.alpha=0;
        [self.view addSubview:jianjiao];
    }
    [self.view bringSubviewToFront:jianjiao];
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=0;
        pifu.alpha=1.0;
        ziti.alpha=0;
        set.alpha=0;
        jianjiaos.alpha=0;
        jianjiao.alpha=1.0;
        jianjiao.frame=CGRectMake(pifuout.frame.origin.x+pifuout.frame.size.width/2-jianjiao.frame.size.width/2,bot.frame.origin.y-1-movekey, jianjiao.frame.size.width, jianjiao.frame.size.height) ;
    }];
    
}

-(void)showziti
{
    [setback removeFromSuperview];
    [pifuback removeFromSuperview];
    [readproshade removeFromSuperview];
    [self.view addSubview:zitiback];
    [self.view bringSubviewToFront:ziti];
    
    if(jianjiao.frame.origin.x==0)
    {
        jianjiao.frame=CGRectMake(zitiout.frame.origin.x+zitiout.frame.size.width/2-jianjiao.frame.size.width/2,bot.frame.origin.y-1-movekey, jianjiao.frame.size.width, jianjiao.frame.size.height) ;
        jianjiao.alpha=0;
        [self.view addSubview:jianjiao];
    }
    
    [self.view bringSubviewToFront:jianjiao];
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=0;
        pifu.alpha=0;
        ziti.alpha=1.0;
        set.alpha=0;
        jianjiaos.alpha=0;
        jianjiao.alpha=1.0;
        jianjiao.frame=CGRectMake(zitiout.frame.origin.x+zitiout.frame.size.width/2-jianjiao.frame.size.width/2,bot.frame.origin.y-1-movekey, jianjiao.frame.size.width, jianjiao.frame.size.height) ;
    }];
    
}



#pragma mark-设置消退
-(void)setdiss
{
    [readproshade removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=1.0;
        pifu.alpha=0;
        ziti.alpha=0;
        set.alpha=0;
        jianjiao.alpha=0;
        jianjiaos.alpha=0;
    }];
    [setback removeFromSuperview];
}


-(void)pifudismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=1.0;
        pifu.alpha=0;
        ziti.alpha=0;
        set.alpha=0;
        jianjiao.alpha=0;
        jianjiaos.alpha=0;
    }];
    [pifuback removeFromSuperview];
}

-(void)zitidismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        readproback.alpha=1.0;
        pifu.alpha=0;
        ziti.alpha=0;
        set.alpha=0;
        jianjiao.alpha=0;
        jianjiaos.alpha=0;
    }];
    [zitiback removeFromSuperview];
}




#pragma mark-table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==listtable ) {
        return [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:section];
    }
    else {
        NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        if([bookmark count]==0)
        {
            markable.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
        else
        {
            markable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        }
        return [bookmark count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* iden=@"listcell";
    listcell* cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if(cell==nil)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if([diviecemode isEqualToString: @"v"])
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"listcell" owner:self options:nil]objectAtIndex:0];
            }
            else
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"listcell" owner:self options:nil]objectAtIndex:1];
            }
        }
        else
        {
            if([diviecemode isEqualToString: @"v"])
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"listcell" owner:self options:nil]objectAtIndex:2];
            }
            else
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"listcell" owner:self options:nil]objectAtIndex:3];
            }
        }
        //TODO:font
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cell.lab.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
            cell.index.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
        }
        else
        {
            cell.lab.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
            cell.index.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        }
        

        cell.daytimeline.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_tablesepline",device,@"b",diviecemode ]];
        cell.nighttimeline.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_%@_tablesepline",device,@"d",diviecemode ]];

        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        
        if(tableView ==markable)
        {
            cell.choosed.hidden=YES;
            cell.frame=CGRectMake(0, 0, cell.frame.size.width, 135);
            UILabel* lab=cell;
            UILabel* title=[[[UILabel alloc] initWithFrame:CGRectMake(lab.frame.origin.x, 10, lab.frame.size.width, 20)] autorelease];
            title.tag=10;
            title.textAlignment=NSTextAlignmentLeft;
            title.backgroundColor=[UIColor clearColor];
            [cell addSubview:title];
            
            
            title.numberOfLines=1;
 
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UILabel* content=[[[UILabel alloc] initWithFrame:CGRectMake(lab.frame.origin.x+20, 40, lab.frame.size.width-40, 60)] autorelease];
                content.tag=12;
                content.textAlignment=NSTextAlignmentLeft;
                content.backgroundColor=[UIColor clearColor];
                content.numberOfLines=3;
                
                [cell addSubview:content];
                
                cell.textLabel.text=nil;
                cell.lab.text=nil;
                
                UILabel* time=[[[UILabel alloc] initWithFrame:CGRectMake(10, 105, cell.frame.size.width-40, 20)] autorelease];
                time.tag=11;
                time.textAlignment=NSTextAlignmentRight;
                time.backgroundColor=[UIColor clearColor];
                
                [cell addSubview:time];
                time.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                content.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                content.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
                time.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
                title.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
                
            }
            else
            {
                UILabel* content=[[[UILabel alloc] initWithFrame:CGRectMake(lab.frame.origin.x+10, 40, lab.frame.size.width-20, 60)] autorelease];
                content.tag=12;
                content.textAlignment=NSTextAlignmentLeft;
                content.backgroundColor=[UIColor clearColor];
                content.numberOfLines=3;
                
                [cell addSubview:content];
                
                cell.textLabel.text=nil;
                cell.lab.text=nil;
                UILabel* time=[[[UILabel alloc] initWithFrame:CGRectMake(10, 100, cell.frame.size.width-20, 20)] autorelease];
                time.tag=11;
                time.textAlignment=NSTextAlignmentRight;
                time.backgroundColor=[UIColor clearColor];
                
                [cell addSubview:time];
                time.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                content.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                content.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14];
                time.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
                title.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
            }
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    
    if( tableView==listtable)
    {
        cell.index.textColor=self.titlecolor;
        cell.lab.textColor=self.titlecolor;
        cell.index.highlightedTextColor=self.hilightedcolor;
        cell.lab.highlightedTextColor=self.hilightedcolor;
        
		if(indexPath.row==currentchapter)
		{
            cell.contentView.backgroundColor=self.selectcolor;
            cell.lab.textColor=self.hilightedcolor;
            cell.index.textColor=self.hilightedcolor;
		}
		else
		{
            cell.contentView.backgroundColor=[UIColor clearColor];
		}
        
        
        
        NSString *title=[self.ChapterEnqin TitleForChapterIndex:indexPath.row  ];
        
        title=[reg stringByReplacingMatchesInString:title  options:NSMatchingReportProgress  range:NSMakeRange(0, [title length])  withTemplate:@""];
        if(title==nil|| [title length]==0)
        {
            title=@" ";
        }
        
        
        NSString* titlestr=nil;
        if(showvip && indexPath.row> [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:0]*novippercent)
        {
            titlestr=[NSString stringWithFormat:@"%d.vip%@",indexPath.row+1,title];
        }
        else
        {
            titlestr=[NSString stringWithFormat:@"%d.%@",indexPath.row+1,title];
        }
        
        
        CGSize linesize;
        float linewidth;
        float lineheight;
//        float baselineheight; 1号内存泄露 baselineheight deadstore
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if([diviecemode isEqualToString: @"v"])
            {
                linewidth=250;
            }
            else
            {
                linewidth=402;
            }
            lineheight=19;
//            baselineheight=45;    1号内存泄露 baselineheight deadstore
        }else
        {
            if([diviecemode isEqualToString: @"v"])
            {
                linewidth=506;
            }
            else
            {
                linewidth=506;
            }
            lineheight=23;
//            baselineheight=46;    1号内存泄露 baselineheight deadstore
        }
        
        
        linesize=[self  lineheightforstr:titlestr width:linewidth];
        
        if(linesize.height>lineheight)
        {
            listcell* catchcell=[[[listcell alloc] init] autorelease];
            catchcell.frame=cell.frame;
            UILabel* lab=[[[UILabel alloc] initWithFrame:CGRectMake(cell.lab.frame.origin.x, cell.lab.frame.origin.y+3, cell.lab.frame.size.width, lineheight) ] autorelease];
            lab.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
            lab.font=cell.lab.font;
            lab.textColor=cell.lab.textColor;
            lab.highlightedTextColor=cell.lab.highlightedTextColor;
            lab.numberOfLines=1;
            lab.lineBreakMode=NSLineBreakByClipping;
            lab.backgroundColor=[UIColor clearColor];
            [catchcell addSubview:lab];
            UIImageView*daytimeline=[[[UIImageView alloc] initWithFrame:CGRectMake(cell.daytimeline.frame.origin.x,catchcell.frame.size.height-(cell.frame.size.height-cell.daytimeline.frame.origin.y)-cell.daytimeline.frame.size.height, cell.daytimeline.frame.size.width, cell.daytimeline.frame.size.height)] autorelease];
            
            
            UIImageView*nighttimeline=[[[UIImageView alloc] initWithFrame:CGRectMake(cell.daytimeline.frame.origin.x,catchcell.frame.size.height-(cell.frame.size.height-cell.daytimeline.frame.origin.y)-cell.daytimeline.frame.size.height, cell.daytimeline.frame.size.width, cell.daytimeline.frame.size.height)] autorelease];
            daytimeline.image=cell.daytimeline.image;
            nighttimeline.image=cell.nighttimeline.image;
            daytimeline.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            nighttimeline.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            [catchcell addSubview:daytimeline];
            [catchcell addSubview:nighttimeline];
            catchcell.lab=lab;
            catchcell.daytimeline=daytimeline;
            catchcell.nighttimeline=nighttimeline;
            catchcell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
            catchcell.backgroundColor=[UIColor clearColor];
            catchcell.contentView.backgroundColor=[UIColor clearColor];
            
            int one= [self string:titlestr numberforwidth:linewidth];
            catchcell.lab.text=[titlestr substringWithRange:NSMakeRange(0, one)];
            int addcount=0;
            linewidth-=25;
            while (one<[titlestr length]) {
                int lenth=[self string:[titlestr substringWithRange:NSMakeRange(one, [titlestr length]-one)] numberforwidth:linewidth];
                UILabel* addlab=[[[UILabel alloc] initWithFrame:CGRectMake(catchcell.lab.frame.origin.x+25, catchcell.lab.frame.origin.y+catchcell.lab.frame.size.height+(lineheight+3)*addcount+catchcell.lab.frame.origin.y, linewidth, lineheight+3)] autorelease];
                addlab.text=[titlestr substringWithRange:NSMakeRange(one,lenth)];
                addlab.font=catchcell.lab.font;
                addlab.backgroundColor=[UIColor clearColor];
                addlab.textColor=catchcell.lab.textColor;
                addlab.highlightedTextColor=catchcell.lab.highlightedTextColor;
                addlab.lineBreakMode=UILineBreakModeWordWrap;
                [catchcell addSubview:addlab];
                one+=lenth;
                addcount++;
                
            }
            cell=catchcell;
            if(indexPath.row==currentchapter)
            {
                cell.contentView.backgroundColor=self.selectcolor;
            }
            else
            {
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
        }
        else
        {
        cell.lab.text=titlestr;
        }
}
    
    //TODO:cell
    cell.selectedBackgroundView.backgroundColor = self.selectcolor;
    
    if([daytime isEqualToString:@"b"])
    {
        cell.daytimeline.hidden=NO;
        cell.nighttimeline.hidden=YES;
    }
    else
    {
        cell.daytimeline.hidden=YES;
        cell.nighttimeline.hidden=NO;
    }
    
    
//    if( tableView==listtable)
//    {
//		NSString *title=[self.ChapterEnqin TitleForChapterIndex:indexPath.row  ];
//        
//        title=[reg stringByReplacingMatchesInString:title  options:NSMatchingReportProgress  range:NSMakeRange(0, [title length])  withTemplate:@""];
//        if(title==nil|| [title length]==0)
//        {
//            title=@" ";
//        }
//       
//      if(showvip && indexPath.row> [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:0]*novippercent)
//      {
//      cell.lab.text=[NSString stringWithFormat:@"%d.vip%@",indexPath.row+1,title];
//          
//          
//      }
//        else
//        {
//            cell.lab.text=[NSString stringWithFormat:@"%d.%@",indexPath.row+1,title];
//        }
//        cell.index.textColor=self.titlecolor;
//        cell.lab.textColor=self.titlecolor;
//        cell.index.highlightedTextColor=self.hilightedcolor;
//        cell.lab.highlightedTextColor=self.hilightedcolor;
//        
//        
//        
//		if(indexPath.row==currentchapter)
//		{
//			
//            cell.contentView.backgroundColor=self.selectcolor;
//            
//            cell.lab.textColor=self.hilightedcolor;
//            cell.index.textColor=self.hilightedcolor;
//            
//		}
//		else
//		{
//            cell.contentView.backgroundColor=[UIColor clearColor];
//		}
//    }
    if(tableView==markable)
    {
        
        
        
        NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        NSString *title=[[bookmark objectAtIndex:indexPath.row] objectForKey:@"stringbookmark"];
        ((UILabel*)[cell viewWithTag:11]).text=[[bookmark objectAtIndex:indexPath.row] objectForKey:@"marktime"];
        ((UILabel*)[cell viewWithTag:10]).text=[NSString stringWithFormat:@"%3i.  %@",indexPath.row+1,[[bookmark objectAtIndex:indexPath.row] objectForKey:@"markchap"]];
        ((UILabel*)[cell viewWithTag:12]).text=title;
        //title
        ((UILabel*)[cell viewWithTag:10]).textColor=self.titlecolor;
        ((UILabel*)[cell viewWithTag:10]).highlightedTextColor=self.hilightedcolor;
        
        //content
        ((UILabel*)[cell viewWithTag:12]).textColor=self.textcolor;
        ((UILabel*)[cell viewWithTag:12]).highlightedTextColor=self.hilightedcolor;
        //time
        ((UILabel*)[cell viewWithTag:11]).textColor=self.textcolor;
        ((UILabel*)[cell viewWithTag:11]).highlightedTextColor=self.hilightedcolor;
        cell.choosed.hidden=YES;
    }
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==markable)
    {
        return 135;
    }
    
    NSString *title=[self.ChapterEnqin TitleForChapterIndex:indexPath.row  ];
    
    title=[reg stringByReplacingMatchesInString:title  options:NSMatchingReportProgress  range:NSMakeRange(0, [title length])  withTemplate:@""];
    if(title==nil|| [title length]==0)
    {
        title=@" ";
    }
    
    
    NSString* titlestr=nil;
    if(showvip && indexPath.row> [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:0]*novippercent)
    {
        titlestr=[NSString stringWithFormat:@"%d.vip%@",indexPath.row+1,title];
    }
    else
    {
        titlestr=[NSString stringWithFormat:@"%d.%@",indexPath.row+1,title];
    }
    
    CGSize linesize;
    float linewidth;
    float lineheight;
    float baselineheight;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if([diviecemode isEqualToString: @"v"])
        {
            linewidth=250;
        }
        else
        {
            linewidth=402;
        }
        lineheight=19;
        baselineheight=45;
    }else
    {
        if([diviecemode isEqualToString: @"v"])
        {
            linewidth=506;
        }
        else
        {
            linewidth=506;
        }
        lineheight=23;
        baselineheight=46;
    }
    
    
    linesize=[self  lineheightforstr:titlestr width:linewidth];
    
    if(linesize.height>lineheight)
    {
        int one= [self string:titlestr numberforwidth:linewidth];
        int addcount=0;
        linewidth-=25;
        while (one<[titlestr length]) {
            one+=[self string:[titlestr substringWithRange:NSMakeRange(one, [titlestr length]-one)] numberforwidth:linewidth];
            addcount++;
        }
        return baselineheight+ addcount*(lineheight+3);
    }
    return baselineheight;
}

-(int)string:(NSString*)str numberforwidth:(float)width
{
    int i=0;
    for(i=0;i<=[str length];i++)
    {
  CGSize linesize=  [[str substringWithRange:NSMakeRange(0, i)] sizeWithFont:self.titlefont];
    if(linesize.width >width)
    {
        break;
    }
    }
    if(--i>[str length])
    {
        i=[str length];
    }
    
    return i;
}





-(CGSize)lineheightforstr:(NSString*)chapter  width:(float)width
{
    
    if(self.titlefont==nil)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.titlefont= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
        }
        else
        {
            self.titlefont= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
        }
    }

    CGSize size = [chapter sizeWithFont:self.titlefont constrainedToSize:CGSizeMake(width, 9999)
                          lineBreakMode:UILineBreakModeWordWrap];
    
    return size;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==listtable)
    {
        if((BOOL)[self.delegate useraskforchapter:(indexPath.row)])
        {
            return;
        }
        
        if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( ChapterIndexChanged:)]) {
            currentchapter=indexPath.row;
            [listtable reloadData];
            [self.delegate ChapterIndexChanged:indexPath.row];
            
        }
    }
    if(tableView==markable)
    {
        if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( BookMarkIndexChanged:)]) {
            NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
            [self.delegate BookMarkIndexChanged:[bookmark objectAtIndex:indexPath.row] ];
            
            
            
        }
    }
    
    [self chooselistaction];
    
    
}

#pragma mark-点击cell
-(void)chooselistaction
{
    UIView* cover=[[[UIView alloc]initWithFrame:self.view.bounds] autorelease];
    cover.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cover];
    [listbackbut  removeFromSuperview];
    [self refreshreadpro];
    
    showed=NO;
    [setback removeFromSuperview];
    [pifuback removeFromSuperview];
    [readproshade removeFromSuperview];
    [zitiback removeFromSuperview];
    
    
    [disbut removeFromSuperview];
    pifu.alpha=0;
    ziti.alpha=0;
    set.alpha=0;
    jianjiaos.alpha=0;
    jianjiao.alpha=0;
    top.alpha=1;
    bot.alpha=1;
    [UIView animateWithDuration:0.5 animations:^{
        [self.delegate  ShowAds];
        left.frame=CGRectMake(-left.frame.size.width, left.frame.origin.y, left.frame.size.width, left.frame.size.height);
        //        top.frame=CGRectMake(0, top.frame.origin.y, top.bounds.size.width, top.bounds.size.height);
        //        bot.frame=CGRectMake(0, bot.frame.origin.y, bot.bounds.size.width, bot.bounds.size.height);
        //               top.alpha=0;
        //                bot.alpha=0;
        //
        //        readproback.alpha=0;
        //
        //        readproback.frame=readprorect;
        //        backgroundview.frame=CGRectMake(0, 0, backgroundview.bounds.size.width, backgroundview.bounds.size.height);
        //        background2.frame=CGRectMake(0, background2.frame.origin.y, background2.bounds.size.width, background2.bounds.size.height);
        
    } completion:^(BOOL fi){
        
        [cover removeFromSuperview];
        [timer invalidate];
        timer=nil;
        showed=NO;
        [disbut removeFromSuperview];
        top.alpha=0;
        bot.alpha=0;
        
        readproback.alpha=0;
        [self.view removeFromSuperview];
    }];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==listtable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        [bookmark removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [delegate setbookmark];
    }
    
}


#pragma mark-显示
-(void)reloadbooklist
{

    [listtable reloadData];
}

-(void)delaydo
{
    [self refreshdate];
    [self refreshreadpro];
    if(timer==nil)
    {
    timer=[[[NSTimer alloc]initWithFireDate:nil interval:1.0 target:self selector:@selector(refreshdate) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes ];
    }
    [listtable reloadData];
	[markable reloadData];
    [self listjump];
}


-(void)show
{
    [setback removeFromSuperview];
    [pifuback removeFromSuperview];
    [readproshade removeFromSuperview];
    [zitiback removeFromSuperview];
    pifu.alpha=0;
    ziti.alpha=0;
    set.alpha=0;
    jianjiaos.alpha=0;
    jianjiao.alpha=0;

    pro.value=[UIScreen mainScreen].brightness;
    set.alpha=0;
    showed=YES;
 
    active=YES;
    disbut.frame=self.view.bounds;
    [self.view addSubview:disbut];
    [self.view  sendSubviewToBack:disbut];
    isbooklist=YES;
    listtable.hidden=NO;
    markable.hidden=YES;
    [self setleftchoose];
    
    marklistbut.selected=NO;
    booklistbut.selected=YES;

	currentchapter=ChapterEnqin.CurrenChapterIndex;
	currentmark=-10;


    [UIView animateWithDuration:0.3 animations:^{
        top.alpha=1.0;
        bot.alpha=1.0;
        readproback.alpha=1.0;
    }];
    
    
    
    [self performSelector:@selector(delaydo) withObject:nil afterDelay:0.25];
}

#pragma mark-list跳转
-(void)listjump
{
    [listtable scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop  animated:NO];
    
    NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
    
    if([bookmark count]>0)
    {
        [markable scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] atScrollPosition:UITableViewScrollPositionTop  animated:NO];
    }
    
    
}






#pragma mark-设置页面消失
-(void)anidisappear
{
    
   
    active=NO;
    showed=NO;
    [setback removeFromSuperview];
    [pifuback removeFromSuperview];
    [readproshade removeFromSuperview];
    [zitiback removeFromSuperview];
    
    [disbut removeFromSuperview];
    
    
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
   [UIView animateWithDuration:0.3 animations:^{
       top.alpha=0;
       bot.alpha=0;
       readproback.alpha=0;
       pifu.alpha=0;
       ziti.alpha=0;
       set.alpha=0;
       jianjiaos.alpha=0;
       jianjiao.alpha=0;
   } completion:^(BOOL finished) {
       if(finished)
       {
           [self.view removeFromSuperview];
       }
       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
   }];
    
    [self.delegate  ShowAds];
    [timer invalidate];
    timer=nil;
}

-(void)imidisappear
{
    
    [setback removeFromSuperview];
    [pifuback removeFromSuperview];
    [readproshade removeFromSuperview];
    [zitiback removeFromSuperview];
    [timer invalidate];
    timer=nil;
    showed=NO;
	[self listdismiss];
    [disbut removeFromSuperview];
    top.alpha=0;
    bot.alpha=0;
    
    
    readproback.alpha=0;
    pifu.alpha=0;
    ziti.alpha=0;
    set.alpha=0;
    jianjiaos.alpha=0;
    jianjiao.alpha=0;
    [self.view removeFromSuperview];
    [self.delegate  ShowAds];
}

#pragma mark-设置事件

-(void)shinchoose:(id)sender
{
    int skinbefore=style.SkinIndex;
    if(skinbefore==((UIButton*)sender).tag-1)
    {
        return;
    }
    if(skinbefore!=5)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:style.SkinIndex] forKey:@"daybeforeskin"];
    }
    
    int skin=((UIButton*)sender).tag-1;
    style.SkinIndex=skin;
    [style ChangedStaticSettinsForKey:@"skinindex"  Value:[NSNumber numberWithInt:skin]];
    
    [self  setbutpic];
    if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting:)]){
        [self.delegate changesetting:500];
    }
    [self setpifuback];
    if((skin==5||skinbefore==5)&&(skinbefore!=skin))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dayandnightchange" object:nil];
    }
}
-(void)fanyechoose:(id)sender
{
    int skin=((UIButton*)sender).tag-1;
    
    [style ChangedStaticSettinsForKey:@"pagetypeindex"  Value:[NSNumber numberWithInt:skin]];
    if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
        [self.delegate changesetting:300];
    }
    [self setfanyeback];
}


-(void)zitichoose:(id)sender
{
    int skin=((UIButton*)sender).tag-1;
    [style ChangedStaticSettinsForKey:@"fonttypeindex"  Value:[NSNumber numberWithInt:skin]];
    if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
        [self.delegate changesetting:100];
    }
    [self setzitiback];
    
}

-(void)fonttobig:(id)skin
{
    if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
        [self.delegate changesetting:201];
    }
    [self readprovaluechange:nil];
}
-(void)fonttosmall:(id)skin
{
    if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
        [self.delegate changesetting:200];
    }
    [self readprovaluechange:nil];
}


-(IBAction)butclick:(id)sender forEvent:(UIEvent*)event
{
    if(!active)return;
    UIButton* but=sender;
//    int skinindex=[[style StaticSettinsForKey:@"skinindex"] intValue]; 4号 deadstore skinindex=[style
    Boolean haveChanged=NO;
    switch (but.tag)
    {
        case 1:
		{
		}
            break;
        case 2:
            [setback removeFromSuperview];
            [pifuback removeFromSuperview];
            [zitiback removeFromSuperview];
            listbackbut.frame=self.view.bounds;
			[self.view addSubview:listbackbut];
            [self.view bringSubviewToFront:listbackbut];
            [self.view bringSubviewToFront:left];
            [UIView  animateWithDuration:0.5 animations:^{
                readproback.alpha=1.0;
                ziti.alpha=0;
                pifu.alpha=0;
                set.alpha=0;
                jianjiao.alpha=0;
                jianjiaos.alpha=0;
                
                left.frame=CGRectMake(0, 0, left.bounds.size.width, left.bounds.size.height);
                
                //                top.frame=CGRectMake(left.bounds.size.width, top.frame.origin.y, top.bounds.size.width, top.bounds.size.height);
                //                bot.frame=CGRectMake(left.bounds.size.width, bot.frame.origin.y, bot.bounds.size.width, bot.bounds.size.height);
                ////                top.alpha=0;
                ////                bot.alpha=0;
                ////                readproback.alpha=0;
                //                backgroundview.frame=CGRectMake(left.bounds.size.width, 0, backgroundview.bounds.size.width, backgroundview.bounds.size.height);
                //                background2.frame=CGRectMake(left.bounds.size.width, background2.frame.origin.y, background2.bounds.size.width, background2.bounds.size.height);
                //
                //
                //
                //                readproback.frame=CGRectMake(readproback.frame.origin.x+left.bounds.size.width, readproback.frame.origin.y, readproback.bounds.size.width, readproback.bounds.size.height);
                
            }];
//            NSMutableArray *bookmarkss=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];//5号 bookmarkss deadstore
            if(markable.hidden==NO)
            {
                
                [markable reloadData];
            }
            [self setleftchoose];
            break;
        case 3:
            haveChanged=YES;
            fontischanged=haveChanged;
            if (haveChanged) {
                if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
                    [self.delegate changesetting:201];
                }
            }
            break;
        case 4:
            haveChanged=YES;
            fontischanged=haveChanged;
            
            if (haveChanged) {
                if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(ButtonClick: )]){
                    [self.delegate changesetting:200];
                    
                }
            }break;
        case 5:
            daytimeyes=!daytimeyes;
            haveChanged=YES;
            if(style.SkinIndex==5)
            {
                style.SkinIndex=0;
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"daybeforeskin"]!=nil )
                {
                    style.SkinIndex=[[[NSUserDefaults standardUserDefaults] objectForKey:@"daybeforeskin"] intValue];
                }
                
                [style ChangedStaticSettinsForKey:@"skinindex"  Value:[NSNumber numberWithInt:style.SkinIndex]];
                
                [self  setbutpic];
                
            }
            else
            {
                //                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[UIScreen mainScreen].brightness] forKey:@"daybeforebringtness"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:style.SkinIndex] forKey:@"daybeforeskin"];
                style.SkinIndex=5;
                [style ChangedStaticSettinsForKey:@"skinindex"  Value:[NSNumber numberWithInt:5]];
                
                [self  setbutpic];
                
            }
            
            
            if (haveChanged) {
                if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
                    [self.delegate changesetting:500];
                    
                    //                    if(style.SkinIndex==5)
                    //                    {
                    //                    [UIView animateWithDuration:1 animations:^{
                    //                        pro.value=0.125;
                    //
                    //
                    //                        [UIScreen mainScreen].brightness=0.125;
                    //                    }];
                    //
                    //                    }
                    //                    else
                    //                    {
                    //                        if([[NSUserDefaults standardUserDefaults] objectForKey:@"daybeforebringtness"]!=nil )
                    //                        {
                    //
                    //                            [UIView animateWithDuration:1 animations:^{
                    //                                [UIScreen mainScreen].brightness=[[[NSUserDefaults standardUserDefaults] objectForKey:@"daybeforebringtness"] floatValue];
                    //                                pro.value=[[[NSUserDefaults standardUserDefaults] objectForKey:@"daybeforebringtness"] floatValue];
                    //                            }];
                    //
                    //
                    //                        }
                    //                    }
                    
                }
            }
            
            
            
            
            break;
        case 6:
            
            if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
                
                UIView* vi=[[[UIView alloc] init] autorelease];
                vi.tag=4;
                [self.delegate settingClick:vi];
                
            }
            break;
        case 7:
            listtable.hidden=NO;
            markable.hidden=YES;
            
            
            marklistbut.selected=NO;
            booklistbut.selected=YES;
            
            [self setleftchoose];
            
            break;
        case 8:
            listtable.hidden=YES;
            markable.hidden=NO;
			marklistbut.selected=YES;
            booklistbut.selected=NO;
            
            
            [self setleftchoose];
            [markable reloadData];
            break;
		case 9:
            [self anidisappear];
            [delegate Changedirection];
			break;
        case 10:
            //bringhtness
            
            
            break;
            
        case 12:
            [style ChangedStaticSettinsForKey:@"pagetypeindex"  Value:[NSNumber numberWithInt:0]];
			
            
            
            
            if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
                
                [self.delegate changesetting:300];
                
            }
            break;
        case 13:
            [style ChangedStaticSettinsForKey:@"pagetypeindex"  Value:[NSNumber numberWithInt:2]];
			
            
            
            
            if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(changesetting: )]){
                
                [self.delegate changesetting:300];
                
            }
            
            
            break;
            
        case 100:
            [delegate exit];
            [timer invalidate];
            timer=nil;
            break;
        default:
            break;
    }
}




-(void)changdirect
{
    [timer invalidate];
    timer =nil;
    
    [delegate Changedirection];
}

-(void)daytimeup
{
    
}

#pragma mark-设置图片，用于皮肤变换

-(void)sss
{
    
}


-(void)setleftchoose
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setleftchoose) object:nil ];
    
    CGRect rec;
    if(listtable.hidden==YES)
    {
        rec=CGRectMake(marklistbut.frame.origin.x, leftchoose.frame.origin.y, leftchoose.frame.size.width, leftchoose.frame.size.height) ;
    }
    else
    {
        rec=CGRectMake(booklistbut.frame.origin.x, leftchoose.frame.origin.y, leftchoose.frame.size.width, leftchoose.frame.size.height) ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        leftchoose.frame=rec;
    }];
    
    
    
    
}


-(void)setbutpic
{
    
	if(style.SkinIndex!=5)
	{
		daytimeyes=YES;
        daytime=@"b";
        
        
        
	}
	else
	{
		daytimeyes=NO;
        daytime=@"d";
        
        
        
        
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dayandnightchange" object:nil];
    
    [self setleavesshade];
    [self daynightpic];
    [self setpifuback];
    
}


-(void)setleavesshade
{
    
    switch (style.SkinIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:20] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"84,72,52,1.0" forKey:@"leavesshadecolor"];
            
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:20] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"91,79,65,1.0" forKey:@"leavesshadecolor"];
            
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:20] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"62,85,83,1.0" forKey:@"leavesshadecolor"];
            
            break;
        case 3:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:20] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"67,77,72,1.0" forKey:@"leavesshadecolor"];
            
            break;
        case 4:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:20] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"95,95,95,1.0" forKey:@"leavesshadecolor"];
            
            break;
        case 5:
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:40] forKey:@"leavesshadewidth"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0,0,0,1.0" forKey:@"leavesshadecolor"];
            
            break;
        default:
            break;
    }
}


-(void)setbookmark:(BOOL)_havemark
{
    havemark=_havemark;
	if(havemark)
	{
        [bookmarkBut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_Bookmark1",device,daytime ]] forState:UIControlStateNormal];
	}
	else
	{
        
        [bookmarkBut setImage:[UIImage imagefileNamed:[NSString stringWithFormat:@"BLBookpic.bundle/custom/%@_%@_Bookmark",device,daytime ]] forState:UIControlStateNormal];
	}
    
    
}

#pragma mark-list消失

-(void)listdismiss
{
    [listbackbut  removeFromSuperview];
    [UIView  animateWithDuration:0.5 animations:^{
        left.frame=CGRectMake(-left.frame.size.width, left.frame.origin.y, left.frame.size.width, left.frame.size.height);
        
        //        top.frame=CGRectMake(0, top.frame.origin.y, top.bounds.size.width, top.bounds.size.height);
        //        bot.frame=CGRectMake(0, bot.frame.origin.y, bot.bounds.size.width, bot.bounds.size.height);
        //        top.alpha=1;
        //        bot.alpha=1;
        //
        //        readproback.alpha=1.0;
        //
        //        readproback.frame=readprorect;
        //        backgroundview.frame=CGRectMake(0, 0, backgroundview.bounds.size.width, backgroundview.bounds.size.height);
        //        background2.frame=CGRectMake(0, background2.frame.origin.y, background2.bounds.size.width, background2.bounds.size.height);
        
    }
     ];
    
    
    
    
}



#pragma mark-刷新时间
-(void)refreshdate
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [dateformatter release];
    
    timelab.text=locationString;
}

-(void)refreshreadpro
{
    
    int full=0;
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( numberOfPages:)]) {
        full= [self.delegate numberOfPages:nil];
    }
    int key=ChapterEnqin.CurrenPageIndex+1;
    float value=(float)key/(float)full;
    
    
    readpro.value=value;
    readprolab.text=[NSString stringWithFormat:@"%d/%d",key,full];
    
    
}



-(NSInteger)ChaptersToPages:(NSInteger)chapterindex{
    NSInteger allpage=0;
    for (int i=0; i<chapterindex; i++) {
        if ([self.ChapterEnqin.AllPageViewArray count]>chapterindex) {
            NSArray *arr=[self.ChapterEnqin.AllPageViewArray objectAtIndex:i];
            allpage+=[arr count];
        }
    }
    return allpage;
}


-(CGSize)ChapterSize:(NSString*)chapter{
    AdvanceFont *chaptertitleFont = [[style PublickSettingsForKey:@"chaptertitleFont"] AdvanceFontFromString:style.SkinIndex];
    CGSize size = [chapter sizeWithFont:chaptertitleFont.textFont constrainedToSize:CGSizeMake(3*self.view.frame.size.width/4.0, 9999)
                          lineBreakMode:UILineBreakModeWordWrap];
    
    return size;
}

@end
