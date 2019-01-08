#import "bookOnlineViewController.h"
#import "XmlDataSet1.h"

#import "EBookLocalStore.h"

#import "BLalert.h"

#import "BLCellview.h"



@implementation bookOnlineViewController
@synthesize TagName,TypeID,tablechooseindex;
- (instancetype)initWithEbookPageType:(EbookPageType)ebookPageType{
    if (self=[super init]) {
        self.TypeID=ebookPageType;
    }
    return self;
}

- (instancetype)init{
    if(self=[super init]){
        
        entries=[[NSMutableDictionary alloc] init];
        imageDownloadsInProgress =[[NSMutableDictionary alloc] init];
        ImageQueue=[[ASINetworkQueue alloc]init];
        ImageQueue.maxConcurrentOperationCount=2;
        //设置支持较高精度的进度追踪
        [ImageQueue setShowAccurateProgress:YES];
        [ImageQueue go];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestErrorFunction:) name:EBookLocalStorRequestError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerreload  ) name:@"blalertpicdown" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRepeatDownFunction:) name:EBookLocalStorRepeatDown object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReBuiltFrame)
                                                 name:@"derectchanggexx"
                                               object:nil];

    
    self.tableView.hidden=YES;
    maxPage=1;
    currentPage=0;
    
    [self.view addSubview:_waitDataActivity];
    _waitDataActivity.center=self.view.center;
    
    [self refreshTable:1];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self ReBuiltFrame];
    
}





-(void)ReBuiltFrame{
    NSString*device;
    NSString*fangxiang;
    device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"];
    fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
    
    
    float segH=0.0;
    float titleH=0.0;
    if([device isEqualToString:@"iPad"])
    {
    if([fangxiang isEqualToString:@"h"])
    {
        titleH=75;
        //调试
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 706);
//        self.view.frame=CGRectMake(0, 0, 1024, 706);
    }else{
            titleH=75;
        self.view.frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), 962);
//            self.view.frame=CGRectMake(0, 0, 768, 962);
        }
    }else{
        if([UIScreen mainScreen].bounds.size.height>490){
            if([fangxiang isEqualToString:@"h"]){
                titleH=57;
                self.view.frame=CGRectMake(0, 0, 568, 320);
            }else{
                titleH=44;
                self.view.frame=CGRectMake(0, 0, 320, 522);
            }
        }else{
            if([fangxiang isEqualToString:@"h"])
            {
                titleH=57;
                self.view.frame=CGRectMake(0, 0, 480, 263);
            }else{
                titleH=44;
                
                self.view.frame=CGRectMake(0, 0, 320, 434);
            }
        }
    }
    
    self.TopImageView.frame=CGRectMake(0, 0, self.view.bounds.size.width, titleH);
    _TopImageView.image=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_topBar",device,fangxiang,device,fangxiang ]];
    
    
    self.TopTitle.frame= self.TopImageView.bounds;
    self.TopTitle.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:22];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.TopTitle.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
    }
    
    
    UIImage* segima;
    UIImage* butima;
    float length;
    CGSize butsize;
    
    titleH=titleH-3;
    butima=nil;
    switch (TypeID) {
        case  GoodBookPage:
            segH=0;
        
            
            break;
        case  ClassBookPage:
            segima=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_optionBar",device,fangxiang,device,fangxiang ]];
            segH=segima.size.height;
            //segH=64;
//            butima=  [UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_optionSelected",device,device] ];
//            butsize=butima.size;

            
           
            

            
            
            
            
            break;  
        case  SearchBookPage:
            segima=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_SearchBgBar",device,fangxiang,device,fangxiang ]];
            //segH=64;
            segH=segima.size.height;
            if(blseg==nil)
            {
                [self createblseg];
            }
            blseg.frame=CGRectMake(0 , titleH+3 ,  self.view.bounds.size.width, segH);
            blseg.backgroundColor=[UIColor colorWithPatternImage:segima];
            
            
            
            self.TopTitle.hidden=NO;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                
                [self.view viewWithTag:6789].frame=CGRectMake((self.view.size.width-460)/2 , titleH+(segH-39)/2+4 ,  460, 39);
                [self.view viewWithTag:6788].frame=CGRectMake(0 , (self.view.frame.size.height-21)/2.0 ,  self.view.frame.size.width, 21);
            }
            else
            {
                [self.view viewWithTag:6789].frame=CGRectMake((self.view.size.width-255)/2 , titleH+(segH-22)/2+3 , 255 , 22);
                [self.view viewWithTag:6788].frame=CGRectMake(0 , (self.view.frame.size.height-21)/2.0 ,  self.view.frame.size.width, 21);
            
            }
            
            
            
            

            [self.view bringSubviewToFront:[self.view viewWithTag:6789]];
            
            break;
        case  PaihangBookPage:
            
            
            segima=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_optionBar",device,fangxiang,device,fangxiang ]];
            segH=segima.size.height;
           // segH=64;
          
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                butsize=CGSizeMake(174/2, 74/2);
            }
            else
            {
            butsize=CGSizeMake(118/2, 54/2);
            }
          
            
            
            if(blseg==nil)
            {
                [self createblseg];
            }
            
            blseg.frame=CGRectMake(0 , titleH+3 ,  self.view.bounds.size.width, segH);
            blseg.backgroundColor=[UIColor colorWithPatternImage:segima];

            length=segima.size.width/8;
            
            UIButton*b1 = [blseg viewWithTag:11];

            b1.frame=CGRectMake(length-butsize.width/2, (segima.size.height-butsize.height)/2, butsize.width, butsize.height);
            [b1 setTitle:@"本周最新" forState:UIControlStateNormal];
            [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton*b2=    [blseg viewWithTag:12];
            b2.frame=CGRectMake(length*3-butsize.width/2, (segima.size.height-butsize.height)/2, butsize.width, butsize.height);
            [b2 setTitle:@"本周最热" forState:UIControlStateNormal];
            [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton*b3=    [blseg viewWithTag:13];
            b3.frame=CGRectMake(length*5-butsize.width/2, (segima.size.height-butsize.height)/2, butsize.width, butsize.height);
            [b3 setTitle:@"本月最热" forState:UIControlStateNormal];
            [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton*b4=    [blseg viewWithTag:14];
            b4.frame=CGRectMake(length*7-butsize.width/2, (segima.size.height-butsize.height)/2, butsize.width, butsize.height);
            [b4 setTitle:@"年度最热" forState:UIControlStateNormal];
            [b4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setblsegselection:selection];
            
            break;
        case basepage:
            segima=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_optionBar",device,fangxiang,device,fangxiang ]];
            segH=segima.size.height;
            //segH=64;
//            butima=  [UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_optionSelected",device,device] ];
//            butsize=butima.size;
            
            urltable.chooseindex=0;
            if(blseg==nil)
            {
                [self createblseg];
            }
//            self.TopTitle.text=@"书库分类";

            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                blseg.frame=self.TopTitle.frame;
                blseg.backgroundColor=[UIColor clearColor];

            UIButton *b111 = [blseg viewWithTag:11];
                b111.frame=CGRectMake(60, 0, 100, 43);
                [b111 setTitle:@"最热" forState:UIControlStateNormal];
                [b111 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [b111 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

                [b111 setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iphonezuiselected"] forState:UIControlStateSelected];
                [b111 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            UIButton *b222 = [blseg viewWithTag:12];
                b222.frame = CGRectMake(160, 0, 100, 43);
                [b222 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [b222 setTitle:@"最新" forState:UIControlStateNormal];
                
                [b222 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                [b222 setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iphonezuiselected"] forState:UIControlStateSelected];
               [b222 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                b111.titleLabel.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
                b222.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
                [b111 setExclusiveTouch:YES];
                [b222 setExclusiveTouch:YES];
            }else{
                blseg.frame=self.TopTitle.frame;
                blseg.backgroundColor=[UIColor clearColor];

                UIButton *b111 = [blseg viewWithTag:11];
                b111.frame=CGRectMake(384-230, 0, 230, 75);
                [b111 setTitle:@"最热" forState:UIControlStateNormal];
                [b111 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [b111 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [b111 setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/ipadzuiselected"] forState:UIControlStateSelected];
             
                
                UIButton *b222 = [blseg viewWithTag:12];
                b222.frame = CGRectMake(384, 0, 230, 75);
                [b222 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [b222 setTitle:@"最新" forState:UIControlStateNormal];
                [b222 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [b222 setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/ipadzuiselected"] forState:UIControlStateSelected];
                [b222 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [b111 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                b111.titleLabel.font= [UIFont fontWithName:@"FZLTHJW--GB1-0" size:22];
                b222.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:22];
                [b111 setExclusiveTouch:YES];
                [b222 setExclusiveTouch:YES];
            }
[self setblsegselection:selection];
            break;
            
            
        default:
            break;
    }
    self.tableView.frame=CGRectMake(0 , segH+titleH+3 ,self.view.frame.size.width, self.view.frame.size.height-segH-titleH);

    UIImageView *image12 = [[[UIImageView alloc]initWithFrame:CGRectMake(0, segH+titleH+2, 768, 1)] autorelease];
    UIImage *image21 = [UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_line2"];
    image12.image = image21;
    [self.view addSubview:image12];
    if(showed)
    {
        urltable.frame=CGRectMake(0 ,titleH+1,self.view.bounds.size.width, segH);

    }

     [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

    
}

- (void)change:(id)sender
{
    UIButton *b = [[[UIButton alloc]init] autorelease];
    b.tag=11;
    [self switchindexClick:b];
}

-(void)backtobase
{
    if(TypeID==basepage)
    {
        
//    self.TopTitle.text=@"书库分类";
    self.tableView.hidden=YES;
    maxPage=1;
    currentPage=0;
        urltable.chooseindex=0;
        [urltable reloadvi];
//    if(showed)
//    {
//        [self showlist];
//    }
    
    [self.view addSubview:_waitDataActivity];
    _waitDataActivity.center=self.view.center;
    [self refreshTable:1];
    }
    else
    {
        if(!receivedata)
        {
        self.tableView.hidden=YES;
        maxPage=1;
        currentPage=0;
        selection=0;
        [self.view addSubview:_waitDataActivity];
        _waitDataActivity.center=self.view.center;
        [self refreshTable:1];
        }
    }
    
    
}


-(void)createblseg
{
    blseg =[[[UIView alloc]init] autorelease];
    switch (TypeID) {
            
        case basepage:
            
            for (int i=11; i<13; i++) {
                UIButton*but=[[[UIButton alloc]init ] autorelease];
                but.tag=i;
                
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                {
                    but.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
                    but.titleLabel.textColor= [UIColor blackColor];
                    
                }
                
                but.titleLabel.textColor=[UIColor blackColor];
                
                [but addTarget:self action:@selector(switchindexClick:) forControlEvents:UIControlEventTouchUpInside];
                [but setExclusiveTouch:YES];
                
                [blseg addSubview:but];
            }
            
            break;
            case PaihangBookPage:
          
            for (int i=11; i<15; i++) {
                UIButton*but=[[[UIButton alloc]init ] autorelease];
                but.tag=i;
                
                if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
                {
                    but.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:12];
                }
                else
                {
                but.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:18];
                but.titleLabel.textAlignment = NSTextAlignmentCenter;
                }
                
                     [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                     [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [but setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/ipadtableselected"] forState:UIControlStateSelected];
                       
                        
                    }
                    else
                    {
                        [but setBackgroundImage:[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iphonetableselected"] forState:UIControlStateSelected];
                       
                    }
                
                
                but.titleLabel.textColor=[UIColor blackColor];

                [but setExclusiveTouch:YES];
                [but addTarget:self action:@selector(switchindexClick:) forControlEvents:UIControlEventTouchUpInside];
                [blseg addSubview:but];
            }
            
            
            break;
        default:
            break;
    }
    
    
    
    
    
    
    
    [self.view addSubview:blseg];
}





- (void)loadView{
    [super loadView];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        linecount=1;
    }
    else
    {
    linecount=2;
    }
    
    NSString*device;
//    NSString*fangxiang;
    device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"];
//    fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
//    UIImage *ima22;
//    UIImage *ima11;
    UIImage *ima1;
    UIImage *ima2;

    switch (TypeID) {
        case  GoodBookPage:
            [self.view addSubview:self.GoBackButton];
            
            
            ima1=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_returnBtn",device,device]];
            ima2=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_returnBtnClicked",device,device]];
            _GoBackButton.frame=CGRectMake(9, 0, ima1.size.width, ima1.size.height);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                _GoBackButton.frame=CGRectMake(18, 0, ima1.size.width, ima1.size.height);
            }
            [_GoBackButton setImage:ima1 forState:UIControlStateNormal];
            [_GoBackButton setImage:ima2 forState:UIControlStateHighlighted];
            
            
            [self.GoBackButton addTarget:self action:@selector(CloseWindowClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.TopTitle];
            self.TopTitle.text=self.title;
            break;
        case  ClassBookPage:
            
            [self.view addSubview:self.TopTitle];
            self.TopTitle.text=self.title;
            
            break;
        case  SearchBookPage:{
            
            [self.view addSubview:self.TopTitle];
            self.TopTitle.text=@"搜索" ;
            
            UISearchBar* m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
            m_searchBar.delegate = self;
            
            if([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending){
                
                m_searchBar.searchBarStyle=UISearchBarStyleMinimal;
                m_searchBar.barStyle = UIBarStyleDefault ;
            }else{
                m_searchBar.barStyle = UIBarStyleBlack;
            }
            m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            m_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
            m_searchBar.placeholder =@"请输入书籍名称";
            m_searchBar.text=[[NSUserDefaults standardUserDefaults] stringForKey: @"EBookLocalStorSearchKeyWord"];
            m_searchBar.showsCancelButton=NO;
            
            for (UIView *subview in m_searchBar.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [subview removeFromSuperview];
                    break;
                }
            }

            m_searchBar.keyboardType =  UIKeyboardTypeDefault;
            m_searchBar.tintColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
            m_searchBar.tag=6789;
            [self.view addSubview:m_searchBar];
            
            m_searchBar.backgroundColor=[UIColor clearColor];
            
            [m_searchBar release];
            
            UILabel *nosearch=[[UILabel alloc] initWithFrame:CGRectZero];
            nosearch.textAlignment = NSTextAlignmentCenter;
            nosearch.textColor=[UIColor colorWithRed:57.0/255.0 green:42.0/255.0 blue:14.0/255.0 alpha:1.0];
            nosearch.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15];
            nosearch.backgroundColor=[UIColor clearColor];
            nosearch.text=@"无匹配";
            nosearch.tag=6788;
            nosearch.hidden=YES;
            [self.view addSubview:nosearch];
            [nosearch release];
            
            
            
        }
            break;
        case  PaihangBookPage:
            
            [self.view addSubview:self.TopTitle];
            self.TopTitle.text=self.title;
            break;
        case basepage:
            
            
            if(urltable==nil)
            {
                urltable=[[[BLurltable alloc]initWithFrame:CGRectMake(0,60, 768, 62) url:[NSString stringWithFormat:@"%@/upload/xml/%@",EbookWebXmlServiceBaseUrl,@"maintags.xml"]]autorelease];
                urltable.delegate=self;
                showed=YES;
                //urltable.backgroundColor = [UIColor redColor];
                urltable.transform = CGAffineTransformMakeRotation(M_PI/-2);
                [self.view addSubview:urltable];
                
                //                         tablebackbut=[[UIButton alloc]init];
                //                         [tablebackbut addTarget:self action:@selector(showlist) forControlEvents:UIControlEventTouchDown];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    urltable.frame=CGRectMake(0,43,320,43);
                }
                else
                {
                    urltable.frame=CGRectMake(0,74,768,62);
                }
                
            }
            [self.view addSubview:self.GoBackButton];
            
            //                   ima11=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_switchBtn",device,device]];
            [self.view addSubview:self.TopTitle];
            self.TopTitle.text=self.title;
            break;
            
        default:
            break;
    }

}

-(void)showlist{
    
    if(showed){
        //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        //    {
        //        [tablebackbut removeFromSuperview];
        //        [UIView animateWithDuration:0.5 animations:^{
        //            //        urltable.frame=CGRectMake(-urltable.size.width, urltable.frame.origin.y, urltable.size.width, urltable.size.height);
        //            urltable.frame=CGRectMake(0,43,320,43);
        //        }];
        //    }
        //    else
        //    {
        //
        //
        //    [tablebackbut removeFromSuperview];
        //    [UIView animateWithDuration:0.5 animations:^{
        ////        urltable.frame=CGRectMake(-urltable.size.width, urltable.frame.origin.y, urltable.size.width, urltable.size.height);
        //
        //    }];
        //    }
    }else{
        
        [self.view bringSubviewToFront:urltable];
        
        //        tablebackbut.frame=self.view.bounds;
        //             [self.view insertSubview:tablebackbut belowSubview:urltable];
        [UIView animateWithDuration:0.5 animations:^{
            //            urltable.frame=CGRectMake(0, urltable.frame.origin.y, urltable.size.width, urltable.size.height);
            urltable.frame = CGRectMake(0, 43,320,43);
        }];
    }
    showed=!showed;
}

- (void)CloseWindowClicked:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseEbookWindowNotification" object:nil userInfo:nil];
}
- (void)GobackClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)switchindexClick:(UIButton *)sender{
    
    currentPage=0;
    selection = sender.tag-11;
    [self setblsegselection:selection];
    [self.Rows removeAllObjects];
    maxPage=1;
    currentPage=0;
    [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
   
    [self.view addSubview:_waitDataActivity];
    _waitDataActivity.center=self.view.center;
    
    [self refreshTable:1];

}

-(void)setblsegselection:(NSInteger)key
{
    int l=0;
    if(TypeID==PaihangBookPage){
     
        l=4;
        
        for(int i=0;i<l;i++){
            UIButton* bb=[blseg viewWithTag:i+11];
            [bb setBackgroundImage:nil forState:UIControlStateNormal];
            bb.selected=NO;
        }
        
        UIButton*but=[blseg viewWithTag:key+11];
        but.selected=YES;
        
        return;
    }
    if(TypeID==ClassBookPage)
    {
        l=2;
    }
    if(TypeID==basepage)
    {
        l=2;
    }
    for(int i=0;i<l;i++)
    {
        UIButton* bb=[blseg viewWithTag:i+11];
        bb.selected=NO;
        
    }

    UIButton*but=[blseg viewWithTag:key+11];

    but.selected=YES;

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if ([self.view viewWithTag:6788]!=nil) {
        [self.view viewWithTag:6788].hidden=YES;
    }
}
/*搜索按钮*/
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self doSearch:searchBar];
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[self doSearch:searchBar];
}

/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.TagName=searchBar.text;
    if ([self.TagName length]>0) {
         currentPage=0;
        [[NSUserDefaults standardUserDefaults] setValue:self.TagName  forKey:@"EBookLocalStorSearchKeyWord"];
        [self.view addSubview:_waitDataActivity];
        _waitDataActivity.center=self.view.center;
         [self refreshTable:1];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.TypeID==SearchBookPage) {
     UISearchBar *searchBar=(UISearchBar *)[self.view viewWithTag:6789];
        [searchBar resignFirstResponder];
    }else{
        if ([self.Rows count]==0) {
             //刷新
            [self.view addSubview:_waitDataActivity];
            _waitDataActivity.center=self.view.center;
            
            [self refreshTable:1];
        }
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    
    if (maxPage>(currentPage+1)) {
         return ceil([self.Rows count]/2.0)+1;  
    }else {
        return ceil([self.Rows count]/2.0);  
    }
    }else{
        if (maxPage>(currentPage+1)) {
            return [self.Rows count]+1;
        }else {
            return [self.Rows count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    return 204;
    }else
    {
    return 110;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableViewvvv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    if (indexPath.row<ceil([self.Rows count]/2.0))
    {
        NSString*iden=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
        UITableViewCell*cell=[self.tableView dequeueReusableCellWithIdentifier:iden];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] autorelease];
            
            cell.clipsToBounds=YES;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
           BLCellview*bl1= [[[BLCellview alloc] init] autorelease];
            BLCellview*bl2= [[[BLCellview alloc] init] autorelease];
            bl1.tag=399;
            bl2.tag=398;
            bl2.frame=CGRectMake(bl2.frame.size.width+2, 0, bl2.frame.size.width, bl2.frame.size.height);
            [bl1.backgroundbut addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];
            [bl2.backgroundbut addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];
            [bl1.chakan addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];
            [bl2.chakan addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];
            
           UIImageView*ima= [[[UIImageView alloc]initWithFrame:CGRectMake(bl2.frame.size.width, 0, 2, 904)] autorelease];
            ima.image=[UIImage imagefileNamed:@"EBookManagerImage2.bundle/iPad/iPad_backgroundMidline"];
            
            
            
            [cell addSubview:bl1];
            [cell addSubview:bl2];
            [cell addSubview:ima];
         
        }
    
    
    if (indexPath.row %2==0) {
        cell.contentView.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0  ];
    }else {
        cell.contentView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
    }

        BLCellview*bl1=(BLCellview*)[cell viewWithTag:399];
        BLCellview*bl2=(BLCellview*)[cell viewWithTag:398];
        


        

        [bl1.yuedu removeTarget:self action:@selector(yueduClick:) forControlEvents:UIControlEventTouchUpInside];
        [bl2.yuedu removeTarget:self action:@selector(yueduClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [bl1.yuedu addTarget:self action:@selector(xiazaiClick:) forControlEvents: UIControlEventTouchUpInside];
        [bl2.yuedu addTarget:self action:@selector(xiazaiClick:) forControlEvents: UIControlEventTouchUpInside];
        
        NSString *imageUrl;
        NSDictionary *bookinfor=[self.Rows objectAtIndex:indexPath.row*2];
        bl1.bookname.text=[NSString stringWithFormat:@"%ld.%@",indexPath.row*2+1,[bookinfor objectForKey:@"title"]];
        bl1.bookinfo=bookinfor;
        
        bl1.jianjie.text=[bookinfor objectForKey:@"summary"];

        bl1.yuedu.tag=indexPath.row*2;
        int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus:bookinfor]];
        //-1 表示：未下载
        //0 表示：下载中
        //1 表示下载完成
        //2:表示下载错误
        //3：表示解压错误
        //4：表示重复下载
        //5:下载未完成
        switch (status) {
            case -1:
                
                [bl1 setstate:-1];
                
                
                break;
            case 0:
                [bl1 setstate:0];

                break;
            case 1:
                [bl1 setstate:1];
                [bl1.yuedu removeTarget:self action:@selector(xiazaiClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [bl1.yuedu addTarget:self action:@selector(yueduClick:) forControlEvents: UIControlEventTouchUpInside];
                

                break;
            case 2:
                [bl1 setstate:2];

                break;
            case 3:
                [bl1 setstate:3];
                

                break;
            case 4:
                [bl1 setstate:4];
                

                break;
            case 5:
                [bl1 setstate:5];
                

                break;
            default:
                break;
        }
        imageUrl=[[bookinfor objectForKey:@"logo"] absoluteorRelative];

        AppRecord *appRecord = [entries objectForKey:imageUrl];
        if (imageUrl!=nil&&!appRecord.appIcon)
        {
            appRecord=[[[AppRecord alloc] init] autorelease];
            
            appRecord.imageURLString=imageUrl;
            [entries setObject:appRecord forKey:imageUrl];
            appRecord.appIcon=[UIImage imageWithContentsOfFile: [appRecord ImageCacheFile]];
        }
        
        if (imageUrl!=nil&&!appRecord.appIcon)
        {
            if (tableViewvvv.dragging == NO && tableViewvvv.decelerating == NO && tableViewvvv.isTracking==NO)
            {
                [self startIconDownload:appRecord forIndexPath:imageUrl];
            }
            
            bl1.bookpic.image=[UIImage imageNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_moren",[[NSUserDefaults standardUserDefaults] objectForKey:@"device"],[[NSUserDefaults standardUserDefaults] objectForKey:@"device"]]];
        }
        else
        {
            bl1.bookpic.image = appRecord.appIcon;
        }

        
        
        if(indexPath.row*2+1<[self.Rows count])
        {
            bl2.hidden=NO;
            
            NSDictionary *bookinfor=[self.Rows objectAtIndex:indexPath.row*2+1];
            bl2.bookinfo=bookinfor;
            bl2.jianjie.text=[bookinfor objectForKey:@"summary"];
            bl2.bookname.text=[NSString stringWithFormat:@"%ld.%@",indexPath.row*2+2,[bookinfor objectForKey:@"title"]];

            bl2.yuedu.tag=indexPath.row*2+1;
            int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus:bookinfor]];
            //-1 表示：未下载
            //0 表示：下载中
            //1 表示下载完成
            //2:表示下载错误
            //3：表示解压错误
            //4：表示重复下载
            //5:下载未完成
            switch (status) {
                case -1:
                    [bl2 setstate:-1];
                    
                    break;
                case 0:
                    [bl2 setstate:0];

                    break;
                case 1:
                    [bl2 setstate:1];
                    [bl2.yuedu removeTarget:self action:@selector(xiazaiClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [bl2.yuedu addTarget:self action:@selector(yueduClick:) forControlEvents: UIControlEventTouchUpInside];
                    

                    break;
                case 2:
                    [bl2 setstate:2];

                    break;
                case 3:
                    [bl2 setstate:3];

                    break;
                case 4:
                    [bl2 setstate:4];

                    break;
                case 5:
                    [bl2 setstate:5];

                    break;
                default:
                    break;
            }
            
            imageUrl=[[bookinfor objectForKey:@"logo"] absoluteorRelative];

            AppRecord *appRecord = [entries objectForKey:imageUrl];
            if (imageUrl!=nil&&!appRecord.appIcon)
            {
                appRecord=[[[AppRecord alloc] init] autorelease];
                
                appRecord.imageURLString=imageUrl;
                [entries setObject:appRecord forKey:imageUrl];
                appRecord.appIcon=[UIImage imageWithContentsOfFile: [appRecord ImageCacheFile]];
            }
            
            if (!appRecord.appIcon)
            {
                if (tableViewvvv.dragging == NO && tableViewvvv.decelerating == NO && tableViewvvv.isTracking==NO)
                {
                    [self startIconDownload:appRecord forIndexPath:imageUrl];
                }
                bl2.bookpic.image=[UIImage imageNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_moren",[[NSUserDefaults standardUserDefaults] objectForKey:@"device"],[[NSUserDefaults standardUserDefaults] objectForKey:@"device"]]];
            }
            else
            {
                bl2.bookpic.image = appRecord.appIcon;
            }
            
        
        }
        else
        {
            bl2.hidden=YES;
        
        }
        
        
        
        

        return cell;
        
    }else
    {
        
        NSString*device;
        NSString*fangxiang;
        device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"];
        fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"more%@",fangxiang]];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"more%@",fangxiang]] autorelease];
            cell.contentView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIButton *morebutton= [[[UIButton alloc] init] autorelease];
            UIImage*imag=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_more",device,fangxiang,device,fangxiang ]];
            morebutton.frame=CGRectMake(0, 0, self.view.size.width, imag.size.height);
            [morebutton setBackgroundImage:imag  forState:UIControlStateNormal];
            
//            morebutton.showsTouchWhenHighlighted = NO;


            [morebutton setTitle:@"加载更多..." forState:UIControlStateNormal];
            morebutton.tag=2;
            morebutton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [morebutton setTitleColor:[UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0]  forState:0];
            morebutton.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20];
            [cell addSubview: morebutton];
            [morebutton addTarget:self action:@selector(LoadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        UIButton* vi=[cell viewWithTag:2];
        if(isloading)
        {
        [vi setTitle:nil forState:UIControlStateNormal];
        vi.enabled=NO;
        [vi addSubview:_waitDataActivity];
            _waitDataActivity.frame=CGRectMake((vi.frame.size.width-_waitDataActivity.frame.size.width)/2, (vi.frame.size.height-_waitDataActivity.frame.size.height)/2, _waitDataActivity.frame.size.width, _waitDataActivity.frame.size.height);
            
        }
        else{
        [vi setTitle:@"加载更多..." forState:UIControlStateNormal];
            vi.enabled=YES;
        }
        
        return cell;
        
    
    }
    }
    else
    {
        
        if (indexPath.row<[self.Rows count])
        
        
        {
            NSString*iden=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
            UITableViewCell*cell=[self.tableView dequeueReusableCellWithIdentifier:iden];
            if(cell==nil)
            {
                cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] autorelease];
                
                cell.clipsToBounds=YES;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                BLCellview*bl1= [[[BLCellview alloc] init] autorelease];
             
                bl1.tag=399;
               
                [bl1.backgroundbut addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];

                [bl1.chakan addTarget:self action:@selector(choosebook:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:bl1];

                
            }
            
            
            if (indexPath.row %2==0) {
                cell.contentView.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0  ];
            }else {
                cell.contentView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
            }
            
            BLCellview*bl1=(BLCellview*)[cell viewWithTag:399];

            
            
            
            
            
            [bl1.yuedu removeTarget:self action:@selector(yueduClick:) forControlEvents:UIControlEventTouchUpInside];

            
            
            [bl1.yuedu addTarget:self action:@selector(xiazaiClick:) forControlEvents: UIControlEventTouchUpInside];

            
            NSString *imageUrl;
            NSDictionary *bookinfor=[self.Rows objectAtIndex:indexPath.row];
            bl1.bookname.text=[NSString stringWithFormat:@"%ld.%@",indexPath.row+1,[bookinfor objectForKey:@"title"]];
            bl1.bookinfo=bookinfor;
            
            bl1.jianjie.text=[bookinfor objectForKey:@"summary"];
            
            bl1.yuedu.tag=indexPath.row;
            int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus:bookinfor]];
            //-1 表示：未下载
            //0 表示：下载中
            //1 表示下载完成
            //2:表示下载错误
            //3：表示解压错误
            //4：表示重复下载
            //5:下载未完成
            switch (status) {
                case -1:
                    [bl1 setstate:-1];
                    break;
                case 0:
                    [bl1 setstate:0];
                    
                    break;
                case 1:
                    [bl1 setstate:1];
                    [bl1.yuedu removeTarget:self action:@selector(xiazaiClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [bl1.yuedu addTarget:self action:@selector(yueduClick:) forControlEvents: UIControlEventTouchUpInside];
                    break;
                case 2:
                    [bl1 setstate:2];
                    break;
                case 3:
                    [bl1 setstate:3];
                    break;
                case 4:
                    [bl1 setstate:4];
                    break;
                case 5:
                    [bl1 setstate:5];
                    break;
                default:
                    break;
            }
            imageUrl=[[bookinfor objectForKey:@"logo"] absoluteorRelative];

            AppRecord *appRecord = [entries objectForKey:imageUrl];
            if (imageUrl!=nil&&!appRecord.appIcon)
            {
                appRecord=[[[AppRecord alloc] init] autorelease];
                
                appRecord.imageURLString=imageUrl;
                [entries setObject:appRecord forKey:imageUrl];
                appRecord.appIcon=[UIImage imageWithContentsOfFile: [appRecord ImageCacheFile]];
            }
            
            if (!appRecord.appIcon)
            {
                if (tableViewvvv.dragging == NO && tableViewvvv.decelerating == NO && tableViewvvv.isTracking==NO)
                {
                    [self startIconDownload:appRecord forIndexPath:imageUrl];
                }
                
                bl1.bookpic.image=[UIImage imageNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@/%@_moren",[[NSUserDefaults standardUserDefaults] objectForKey:@"device"],[[NSUserDefaults standardUserDefaults] objectForKey:@"device"]]];
            }else{
                bl1.bookpic.image = appRecord.appIcon;
            }
            
            return cell;
        }else{
            
            NSString*device;
            NSString*fangxiang;
            device=[[NSUserDefaults standardUserDefaults]objectForKey:@"device"];
            fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
            
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"more%@",fangxiang]];
            if (cell==nil) {
                cell=[[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"more%@",fangxiang]] autorelease];
                cell.contentView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0  ];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

                UIButton *morebutton= [[[UIButton alloc] init] autorelease];
                UIImage*imag=[UIImage imagefileNamed:[NSString stringWithFormat:@"EBookManagerImage2.bundle/%@_%@/%@_%@_more",device,fangxiang,device,fangxiang ]];
                morebutton.frame=CGRectMake(0, 0, self.view.size.width, imag.size.height);
                [morebutton setBackgroundImage:imag  forState:UIControlStateNormal];
                
                //            morebutton.showsTouchWhenHighlighted = NO;
                
                
                [morebutton setTitle:@"加载更多..." forState:UIControlStateNormal];
                
                morebutton.titleLabel.textAlignment = NSTextAlignmentCenter;
                
                [morebutton setTitleColor:[UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0]  forState:0];
                morebutton.titleLabel.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16];
                [cell addSubview: morebutton];
                morebutton.tag=2;
                [morebutton addTarget:self action:@selector(LoadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            UIButton* vi=[cell viewWithTag:2];
            if(isloading)
            {
                [vi setTitle:nil forState:UIControlStateNormal];
                vi.enabled=NO;
                [vi addSubview:_waitDataActivity];
                _waitDataActivity.frame=CGRectMake((vi.frame.size.width-_waitDataActivity.frame.size.width)/2, (vi.frame.size.height-_waitDataActivity.frame.size.height)/2, _waitDataActivity.frame.size.width, _waitDataActivity.frame.size.height);
                
            }
            else{
                [vi setTitle:@"加载更多..." forState:UIControlStateNormal];
                vi.enabled=YES;
            }
            
            return cell;
            
            
        }

        
    }
}
-(void)LoadMoreClick:(UIButton*)sender{
    if ((currentPage+1)<=maxPage) {
        currentPage++;
    }

    
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    isloading=YES;
    [sender setTitle:nil forState:UIControlStateNormal];
    [cell  addSubview: _waitDataActivity];
    sender.enabled=NO;
    
    _waitDataActivity.frame=CGRectMake((sender.frame.size.width-_waitDataActivity.frame.size.width)/2, (sender.frame.size.height-_waitDataActivity.frame.size.height)/2, _waitDataActivity.frame.size.width, _waitDataActivity.frame.size.height);
    
    
    
   [self refreshTable:2];
}
-(void)xiazaiClick:(UIButton*)sender{
    NSDictionary *datadir=[self.Rows objectAtIndex:sender.tag];
    [self ActionClick:datadir];
}

-(void)ActionClick:(NSDictionary*)bookinfor{
    NSDictionary *downbookinfor=[SmalleEbookWindow BuilteBookStatus:bookinfor];
    int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:downbookinfor];
    //-1 表示：未下载
    //0 表示：下载中
    //1 表示下载完成
    //2:表示下载错误
    //3：表示解压错误
    //4：表示重复下载
    //5:下载未完成
    if (status==-1){
        [EBookLocalStore AddNewBookToDownload:downbookinfor];
    }else{
        [EBookLocalStore ReStartToDownloadBook:downbookinfor];
    } 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeveyTabBarControllerSelectChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:4] forKey:@"selectIndex"]];
    [self Tongji:[bookinfor objectForKey:@"id"]];
     [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
//    [self.tableView reloadData];
}
-(void)EBookLocalStorRequestErrorFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
//    bookCell *cell = [self BookInforForcell:bookInfor];
    if ([[bookInfor objectForKey:@"status"] intValue]!=1){
//        cell.xiazai.enabled=YES;
//        [cell.xiazai setTitle:@"重试" forState:0];
//        cell.progress.hidden=YES;
//        [cell.progress setProgress:0.0];
        
         [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
//        [self.tableView reloadData];
    }
}
-(void)EBookLocalStorRepeatDownFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
    
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"重复下载《%@》",[bookInfor objectForKey:@"name"]]
                                                  message:nil
                                                 delegate:nil 
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil] autorelease];
    [av show];  
}
-(void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
//    bookCell *cell = [self BookInforForcell:bookInfor];
    if ([[bookInfor objectForKey:@"status"] intValue]==1){
//        cell.xiazai.enabled=NO;
//        cell.yuedu.enabled=YES;
//        [cell.xiazai setTitle:@"已下载" forState:0];
//        cell.progress.hidden=YES;
//        [cell.progress setProgress:0.0];
         [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
        
        
//        [self.tableView reloadData];
    }
}
-(UIView*)BookInforForcell:(NSDictionary*)bookInfor{
    
    
    
    
    return nil;
//    NSInteger arrindex=[self.Rows indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//        return [[NSString stringWithFormat:@"%@%@",EbookWebXmlServiceBaseUrl,[obj objectForKey:@"source"]] isEqualToString:[bookInfor objectForKey:@"url"]];
//    }];
//    bookCell *cell = (bookCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:arrindex inSection: 0]];
//    return cell;
    
}
-(void)jianjieClick:(UIButton*)sender{
    NSDictionary *datadir=[self.Rows objectAtIndex:sender.tag];
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:[datadir objectForKey:@"title"]
                                                  message:[datadir objectForKey:@"summary"]
                                                 delegate:nil 
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil] autorelease];
    [av show]; 
}
-(NSString*)TimeToString:(NSString*)str{
    NSArray *arr=[str componentsSeparatedByString:@" "];
    return  [arr objectAtIndex:0];
}
#pragma mark - Table view delegate




-(void)choosebook:(id)sender
{
    UIButton*but=sender;
    BLCellview* cell = (BLCellview* )but.superview;
//    cell.bookinfo;
    if (self.TypeID==SearchBookPage) {
        UISearchBar *searchBar=(UISearchBar *)[self.view viewWithTag:6789];
        [searchBar resignFirstResponder];
    }

    
    BLalert *jianjie=[[[BLalert alloc] init] autorelease];
    jianjie.bookinfor = [NSMutableDictionary dictionaryWithDictionary:cell.bookinfo];
    int status=[[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus: jianjie.bookinfor]];
    [ jianjie.bookinfor setValue:[NSNumber numberWithInt:status]  forKey:@"status"];
    
    jianjie.delegate=self;
    //    jianjie.view.frame=self.view.bounds;
    [self.view addSubview: jianjie];
    [jianjie loadinfo];
    jianjie.alpha=0.0;
    [UIView animateWithDuration:0.50
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
                         jianjie.alpha=1.0;
					 }
					 completion:^(BOOL finished){
                         
                     }];

    
    
}
#pragma mark implement DownloadHelper methods
- (void) dataDownloadFailed: (NSString *) reason {
    if (!showAlert) {
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"暂时无法获取服务！请重试", @"", nil)   message:@"No Service! Please Retry!"  delegate:self  cancelButtonTitle:NSLocalizedStringFromTable(@"确定", @"", nil) otherButtonTitles:NSLocalizedStringFromTable(@"重试", @"", nil) ,nil] autorelease];
        [av show];
        showAlert=YES;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    showAlert=NO;
    NSString*fangxiang;
    
    fangxiang=[[NSUserDefaults standardUserDefaults]objectForKey:@"fangxiang"];
    NSString*st=[NSString stringWithFormat:@"more%@",fangxiang];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:st];
    if(cell==nil)
    {
        for(UITableViewCell* ce
            in self.tableView.visibleCells)
        {
        if([ce.reuseIdentifier isEqualToString:st ])
        {
            cell=ce;
            break;
        }
        
        }
    
    }
    
    UIButton* vi= [cell viewWithTag:2];

    [_waitDataActivity stopAnimating];
    
	if(buttonIndex==1){
        if(isloading){
            [self LoadMoreClick:vi];
        }else{
            [self performSelector:@selector(permission) withObject:nil afterDelay:1.0f];
        }
	}else{
        if(isloading){
            [vi setTitle:@"加载更多..." forState:UIControlStateNormal];
            vi.enabled=YES;
            isloading=NO;
        }
    }
    
}
-(void)permission{
    //retry
    [self refreshTable:0];
}

- (void)didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData;{
    receivedata=YES;
    isloading=NO;
    [NSThread detachNewThreadSelector:@selector(DataPares:) toTarget:self withObject: theData];
    
}

-(void)DataPares:(NSData*)theData{
    
    @synchronized(self) {
    @autoreleasepool {
    [self SETMAXPages:theData];
	XmlDataSet *data=[[XmlDataSet alloc] init];
    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"item"];
	[data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
    if (self.dldHelper.tag==1) {
        //refresh
        [self.Rows removeAllObjects];
    }if(data.Rows!=nil)
    {
	[self.Rows addObjectsFromArray: data.Rows];
    }
	[data release];
    }
    [self performSelector:@selector(ToMainUI) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    }
}
-(void)SETMAXPages:(NSData*)theData{
	XmlDataSet *data=[[XmlDataSet alloc] init];
    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"book"];
	[data LoadNSMutableData: (NSMutableData*)theData Xpath:pp];
    if([data.Rows count]>0){
        maxPage=[[[data.Rows objectAtIndex:0] objectForKey:@"pages"] intValue];
    }
	[data release];
}
-(void)ToMainUI{
    [self HiddenwaitDataActivity];

    self.tableView.hidden = self.Rows.count > 0 ? NO : YES;

//    self.tableView.hidden = ![self.Rows count]>0;
    [self.tableView reloadData];
    if (self.dldHelper.tag==2 ){
        //more
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x ,  self.tableView.contentOffset.y+81)  animated:YES]; 
    }else if (self.dldHelper.tag==1 ){
        [self.tableView setContentOffset:CGPointMake(0,  0)  animated:YES]; 
    }
    if (self.TypeID==SearchBookPage && [self.Rows count]==0) {
        if ([self.view viewWithTag:6788]!=nil) {
            [self.view viewWithTag:6788].hidden=NO;
        } 
    }
}

- (void)powerreload{
    [self.tableView reloadData];
    [urltable.mytableview reloadData];

}

- (void)refreshTable:(int)tag
{
    if (self.TypeID==SearchBookPage && [self.TagName length]==0 ) {
        return;
    }
    if ([self.view viewWithTag:6788]!=nil) {
        [self.view viewWithTag:6788].hidden=YES;
    }
    [self ShowwaitDataActivity];
    self.dldHelper.delegate=nil;
    [self.dldHelper cancel];
    self.dldHelper=nil;
    
    self.dldHelper = [[[DownloadHelper alloc] init] autorelease];
	self.dldHelper.delegate = self;
    self.dldHelper.tag=tag;
    [self.dldHelper download:[self CreateURL]]; 
    
}

- (NSString*)CreateURL{
    NSString *url=@"";
    switch (TypeID) {
        case  GoodBookPage:
            return [NSString stringWithFormat:@"%@/upload/xml/goodbook-%d.xml",EbookWebXmlServiceBaseUrl,currentPage+1];
            break;
        case  ClassBookPage:

            if (selection==0) {
                return [NSString stringWithFormat:@"%@/upload/xml/hotbook_%@-%d.xml",EbookWebXmlServiceBaseUrl,[[urltable.Rows objectAtIndex:tablechooseindex-1] objectForKey:@"title"],currentPage+1];
            }else {
                return [NSString stringWithFormat:@"%@/upload/xml/newbook_%@-%d.xml",EbookWebXmlServiceBaseUrl,[[urltable.Rows objectAtIndex:tablechooseindex-1] objectForKey:@"title"],currentPage+1];
            }
            break;  
        case  SearchBookPage:
            //搜索 吕
            return [NSString stringWithFormat:@"%@/Default.aspx?type=2&keyword=%@&page=%d",SearchBaseUrl2,self.TagName,currentPage+1];
            break;
        case  PaihangBookPage:
//        {
//            int key=0;
//            switch (selection) {
//                case 0:
//                    key=22;
//                    break;
//                case 1:
//                    key=8;
//                    break;
//                case 2:
//                    key=9;
//                    break;
//                case 3:
//                    key=10;
//                    break;
//                    
//                default:
//                    key=22;
//                    break;
//            }
//            
//            
//            return [NSString stringWithFormat:@"%@/xml/paihang_%@-%d.xml",EbookWebXmlServiceBaseUrl,[NSString stringWithFormat:@"%d",key],currentPage+1];
//            
//        }
            
            return [NSString stringWithFormat:@"%@/upload/xml/paihang_%@-%d.xml",EbookWebXmlServiceBaseUrl,[NSString stringWithFormat:@"%ld",4+selection],currentPage+1];
//            4567
            break;
        case basepage:
            if (selection==0) {
                return [NSString stringWithFormat:@"%@/upload/xml/hotpaihang-%d.xml",EbookWebXmlServiceBaseUrl,currentPage+1];
            }else {
                return [NSString stringWithFormat:@"%@/upload/xml/newpaihang-%d.xml",EbookWebXmlServiceBaseUrl,currentPage+1];
            }
            break;


        default:
            break;
    }
    return url;
}
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void)dealloc{
    
    for(ASIHTTPRequest* req in ImageQueue.operations )
    {
        req.delegate=nil;
        [req clearDelegatesAndCancel];
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [tablebackbut release];
    [entries release];

    [imageDownloadsInProgress release];
	[ImageQueue cancelAllOperations];
	[ImageQueue release];
    
    [TagName release];
    [super dealloc];
}
//-(void)changedirect:(NSNotification *)notification
//{
//
//
//}
-(void)yueduClick:(UIButton*)sender{
    NSMutableDictionary *bookinfor=[self.Rows objectAtIndex:sender.tag];


    if ( [[EBookLocalStore defaultEBookLocalStore] CheckBookListStatusAtBookInfor:[SmalleEbookWindow BuilteBookStatus:bookinfor]]==1) {
        
        NSMutableDictionary *bookDiction=[EBookLocalStore samedicinbooklist:bookinfor];
        if (bookDiction!=nil && [bookDiction objectForKey:@"url"]!=nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SmalleEbook-StartBookReadingNotification" object:nil userInfo:bookDiction];
            return;
        }
        
        if ([bookinfor objectForKey:@"url"]==nil) {
            [bookinfor setObject: [[bookinfor objectForKey:@"source"] absoluteorRelative]  forKey:@"url"];
            [bookinfor setObject:[bookinfor objectForKey:@"title"]  forKey:@"name"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SmalleEbook-StartBookReadingNotification" object:nil userInfo:bookinfor];
    }
}

-(void)choose:(int)index
{
//    if(showed)
//    {
//        [self showlist];
//    }
if(tablechooseindex==index)
{
   
    return;
}
    [self.Rows removeAllObjects];
    maxPage=1;
    currentPage=0;
//    self.TopTitle.text=[[urltable.Rows objectAtIndex:index-1] objectForKey:@"title"];
    
    
    tablechooseindex=index;
    self.TypeID=ClassBookPage;
    
    [self.view addSubview:_waitDataActivity];
    _waitDataActivity.center=self.view.center;
    
     [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

    [self refreshTable:1];

}

//-(void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification{
//    NSDictionary *bookInfor=[notification userInfo];
//    bookCell *cell = [self BookInforForcell:bookInfor];
//    if ([[bookInfor objectForKey:@"status"] intValue]==0){
//        cell.xiazai.enabled=YES;
//        cell.yuedu.enabled=NO;
//        [cell.xiazai setTitle:@"暂停" forState:0];
//        [cell.progress setProgress:[[bookInfor objectForKey:@"percent"] floatValue]];
//        
//    }
//}

#pragma mark-延迟加载

#pragma mark Table cell image support
- (AppRecord*)GetAppRecordByNSIndexPath:(NSString *)indexPath{
	AppRecord *appRecord = [entries objectForKey:indexPath];
	//     NSDictionary* dic;
	//    dic=[arr objectAtIndex: indexPath];
    
	return appRecord;
}

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSString *)indexPath
{
    NSNull *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (appRecord!=nil &&indexPath!=nil&& iconDownloader == nil)
    {
		NSURL *ur=[NSURL URLWithString:appRecord.imageURLString];
        ASIHTTPRequest *requst=[ASIHTTPRequest requestWithURL:ur];
		NSMutableDictionary *infor=[NSMutableDictionary dictionaryWithCapacity:2];
		[infor setObject:appRecord  forKey:@"appRecord"];
		[infor setObject:indexPath  forKey:@"indexPath"];
		
        requst.userInfo=infor;
        [requst setDownloadProgressDelegate:self];
        [requst setDelegate:self];
        NSString *downloadPath=[appRecord ImageCacheFile];
        NSString *tempPath=[NSString stringWithFormat:@"%@.temp" ,[appRecord ImageCacheFile]];
        //设置下载路径
        [requst setDownloadDestinationPath:downloadPath];
        //设置缓存路径
        [requst setTemporaryFileDownloadPath:tempPath];
        //设置支持断点续传
        [requst setAllowResumeForFileDownloads:YES];
        [requst setDidFinishSelector:@selector(requestDone:)];
        [requst setDidFailSelector:@selector(requestWentWrong:)];
        [ImageQueue addOperation:requst];
		
        iconDownloader = [[NSNull alloc] init];

        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader release];
		
    }
}
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
	//	NSLog(@"");
}
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
//    NSMutableDictionary *bookInfor=request.userInfo;
	
	
}
- (void)requestDone:(ASIHTTPRequest *)request{
	NSMutableDictionary *bookInfor = (NSMutableDictionary *)request.userInfo;
	
	[self appImageDidLoad:[bookInfor objectForKey:@"indexPath"] selll:nil];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSMutableDictionary *bookInfor = (NSMutableDictionary *)request.userInfo;
    [imageDownloadsInProgress removeObjectForKey:[bookInfor objectForKey:@"indexPath"]];
    
}

-(void)faildown:(NSString *)indexPath selll:(id)selfff
{

}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows{
    
    if ([entries count] > 0 )
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			for(int k=0;k<linecount;k++)
			{
				if(indexPath.row*linecount+k<[Rows count])
				{
					NSDictionary* dic=[Rows objectAtIndex:(indexPath.row*linecount+k)];
					
					NSString* ur=[dic objectForKey:@"logo"];
					NSString *imageUrl;
					if(ur!=nil)
					{
						imageUrl=[[dic objectForKey:@"logo"] absoluteorRelative];
						;

						
						
						AppRecord *appRecord = [self GetAppRecordByNSIndexPath: imageUrl];
						if (imageUrl!=nil &&!appRecord) {
							appRecord=[[[AppRecord alloc] init] autorelease];
							
							appRecord.imageURLString=imageUrl;
							[entries setObject:appRecord forKey:imageUrl];
							
						}
						if (!appRecord.appIcon)
						{
							[self startIconDownload:appRecord forIndexPath:imageUrl];
						}
					}
				}
			}
        }
        
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSString *)indexPathxx selll:(id)selfff
{
	//    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
	NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		for(int k=0;k<linecount;k++)
		{
			if(indexPath.row*linecount+k<[Rows count])
			{
				
				
				
				NSDictionary* dic=[Rows objectAtIndex:(indexPath.row*linecount+k)];
				
				NSString *imageUrl=[[dic objectForKey:@"logo"] absoluteorRelative];
				;
				if(imageUrl!=nil)
				{

					if([imageUrl isEqualToString:indexPathxx])
					{
                        
                        [self performSelector:@selector(powerreload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
                        
//						[tableView reloadData];
						
						//						[downloaer removeObjectAtIndex:0];
						//						[self loadnext];
						
						return;
					}
					
				}
				
			}
			
			
		}
		
	}
	
	
	//    if (iconDownloader != nil)
	//    {
	//        BookViewCell *cell =(BookViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	//		if( cell != nil )
	//		{
	//			cell.BookImage.image =iconDownloader.appRecord.appIcon;
	//		}
	//    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
