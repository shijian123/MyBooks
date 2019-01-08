//
//  SimpleTextBookReadingHelp.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleTextBookReadingHelp.h"
#import "UIFont+CoreTextExtensions.h"
#import "NSFileManager+TextBookReadingFileManager.h"

@implementation BookReadingSettingView
@synthesize delegate,fontischanged;
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder ];
    UISlider *slider=(UISlider *)[self viewWithTag:1];
    slider.backgroundColor = [UIColor clearColor];
	[slider setThumbImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/iphone-v-bookreading-Slide-1.png"]   forState:UIControlStateNormal];
	[slider setMinimumTrackImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/iphone-v-bookreading-Slide-3.png"] forState:UIControlStateNormal];
	[slider setMaximumTrackImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/iphone-v-bookreading-Slide-2.png"] forState:UIControlStateNormal];
    slider.continuous = YES;
    slider.maximumValue = 1.0;
    slider.minimumValue = 0.0;
    slider.value=[UIScreen mainScreen].brightness;
    [self ChangeSetting];
    
    return self;
}
-(IBAction)valueChanged:(UISlider*)sender{
    [UIScreen mainScreen].brightness=sender.value;
}

-(IBAction)ButtonClick:(UIButton*)sender{
    SimpleTextBookReadingStytle*style=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
    Boolean haveChanged=NO;
    int fonttypeindex=[[style StaticSettinsForKey:@"fonttypeindex"] intValue];
    int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
    int skinindex=[[style StaticSettinsForKey:@"skinindex"] intValue];
    if (sender.tag>=100 && sender.tag<=102 ) {
        [style ChangedStaticSettinsForKey:@"fonttypeindex"  Value:[NSNumber numberWithInt:(int)sender.tag-100]];
        haveChanged=fonttypeindex!=(sender.tag-100);
        fontischanged=haveChanged;
    }if (sender.tag>=200 && sender.tag<=201 ) {
        haveChanged=YES;
        fontischanged=haveChanged;
    }if (sender.tag>=300 && sender.tag<=303 ) {
        [style ChangedStaticSettinsForKey:@"pagetypeindex"  Value:[NSNumber numberWithInt:(int)sender.tag-300]];
        haveChanged=pagetypeindex!=(sender.tag-300);
    } if (sender.tag==400) {
        if (!(fonttypeindex==0&&pagetypeindex==0&&skinindex==0 )) {
            haveChanged=YES;
            fontischanged=haveChanged;
            [style ChangedStaticSettinsForKey:@"fonttypeindex"  Value:[NSNumber numberWithInt:0]];
            [style ChangedStaticSettinsForKey:@"pagetypeindex"  Value:[NSNumber numberWithInt:0]];
            [style ChangedStaticSettinsForKey:@"skinindex"  Value:[NSNumber numberWithInt:0]];
            
        }
        ((UIButton*)[self viewWithTag:400]).enabled=NO;
    }else if (sender.tag>=500 && sender.tag<=505 ) {
        [style ChangedStaticSettinsForKey:@"skinindex"  Value:[NSNumber numberWithInt:sender.tag-500]];
        haveChanged=skinindex!=(sender.tag-500);
    }
    [self ChangeSetting];
    if (haveChanged) {
        if(self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(ButtonClick: )]){
            [self.delegate ButtonClick:sender];
        }
    }
}

-(void)ChangeSetting{
    SimpleTextBookReadingStytle*style=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
    //100 字体
    NSArray *fontarr=(NSArray *)[style StaticSettinsForKey:@"fonttype"];
    int fonttypeindex=[[style StaticSettinsForKey:@"fonttypeindex"] intValue];
    for (int i=100; i<=102; i++) {
        UIButton *fontbutton=((UIButton*)[self viewWithTag:i]);
        NSArray *fontname=[[fontarr objectAtIndex:i-100]  componentsSeparatedByString:@"|"];
        [fontbutton setFont:[UIFont fontWithName:[fontname objectAtIndex:0] size:15]];
        [fontbutton setTitle: [fontname objectAtIndex:1] forState:0];
        if (fonttypeindex==(i-100) ) {
            [fontbutton setBackgroundImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/iphone-v-bookreading-button-fontbackground-check.png"]  forState:0];
        }else {
            [fontbutton setBackgroundImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/iphone-v-bookreading-button-fontbackground-uncheck.png"]  forState:0];
        }
    }
    //300 翻页方式 303
    int pagetypeindex=[[style StaticSettinsForKey:@"pagetypeindex"] intValue];
    [self viewWithTag:304].center=[self viewWithTag:pagetypeindex+300 ].center;
    //500 翻页方式 506
    int skinindex=[[style StaticSettinsForKey:@"skinindex"] intValue];
    [self viewWithTag:506].center=[self viewWithTag:skinindex+500 ].center;
    ((UIButton*)[self viewWithTag:400]).enabled=!(fonttypeindex==0&&pagetypeindex==0&&skinindex==0);
}
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *subview = [super hitTest:point withEvent:event];
    if(UIEventTypeTouches == event.type)
    {
        CGRect rg=CGRectMake([self viewWithTag:2].frame.origin.x+10,[self viewWithTag:2].frame.origin.y+20 , [self viewWithTag:2].frame.size.width-20,[self viewWithTag:2].frame.size.height-40 );
        BOOL touchedInside =CGRectContainsPoint(rg,point);
#ifdef UI_USER_INTERFACE_IDIOM
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (!touchedInside && self.superview.alpha==1.0) {
                //NSLog(@"Pad close");
                self.superview.alpha=1.0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.superview.alpha = 0.0;
                    if(fontischanged && self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(valueChanged: )]){
                        [NSObject cancelPreviousPerformRequestsWithTarget:self.delegate];
                        [(NSObject*)self.delegate performSelector:@selector( valueChanged:) withObject:self afterDelay:0.2];
                        
                    }
                }];
            }
        }
        else
#endif
        {
            if (!touchedInside && self.alpha==1.0) {
                //NSLog(@"close");
                self.alpha=1.0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.alpha = 0.0;
                    if(fontischanged && self.delegate!=nil && [((NSObject*)self.delegate) respondsToSelector:@selector(valueChanged: )]){
                        [NSObject cancelPreviousPerformRequestsWithTarget:self.delegate];
                        [(NSObject*)self.delegate performSelector:@selector( valueChanged:) withObject:self afterDelay:0.2];
                    }
                }];
            }
        }
    }
    return subview;
}
@end
@implementation TopSettingView
@synthesize GoBackButton=_GoBackButton, CatalogButton=_CatalogButton,SettingButton=_SettingButton,BookMarkButton=_BookMarkButton,Changedirection=_Changedirection;
-(id)initWithDefualt:(NSString*)mode{
    if (self=[super init]) {
        self.backgroundColor=[UIColor clearColor];
        if ([mode isEqualToString:@"iphone"] ) {
            self.frame=CGRectMake(0, -3, 320, 53);
            self.GoBackButton=[[[UIButton alloc] initWithFrame:CGRectMake(9,0,38,38)] autorelease];
            self.GoBackButton.tag=1;
            self.CatalogButton=[[[UIButton alloc] initWithFrame:CGRectMake(59,0,38,38)] autorelease];
            self.CatalogButton.tag=2;
            
            self.SettingButton=[[[UIButton alloc] initWithFrame:CGRectMake(110,0,38,38)] autorelease];
            self.SettingButton.tag=3;
            
            self.BookMarkButton=[[[UIButton alloc] initWithFrame:CGRectMake(273,-4,35,45)] autorelease];
            self.BookMarkButton.tag=4;
            self.Changedirection=[[[UIButton alloc] initWithFrame:CGRectMake(0,0,0,0)] autorelease];
            self.Changedirection.tag=5;
            self.Changedirection.hidden=YES;
            
        }else {
            if ([mode isEqualToString:@"ipad"] )
            {
                
                self.frame=CGRectMake(0, 0, 768, 51);
                self.GoBackButton=[[[UIButton alloc] initWithFrame:CGRectMake(21,0,42,42)] autorelease];
                self.GoBackButton.tag=1;
                self.CatalogButton=[[[UIButton alloc] initWithFrame:CGRectMake(90,0,42,42)] autorelease];
                self.CatalogButton.tag=2;
                self.SettingButton=[[[UIButton alloc] initWithFrame:CGRectMake(161,1,42,42)] autorelease];
                self.SettingButton.tag=3;
                
                self.BookMarkButton=[[[UIButton alloc] initWithFrame:CGRectMake(655,-4,42,42)] autorelease];
                self.BookMarkButton.tag=4;
                
                self.Changedirection=[[[UIButton alloc] initWithFrame:CGRectMake(586,-4,42,42)] autorelease];
                self.Changedirection.tag=5;
                
            }
            else
            {
                self.frame=CGRectMake(0, 0, 1024, 51);
                self.GoBackButton=[[[UIButton alloc] initWithFrame:CGRectMake(21,0,42,42)] autorelease];
                self.GoBackButton.tag=1;
                self.CatalogButton=[[[UIButton alloc] initWithFrame:CGRectMake(90,0,42,42)] autorelease];
                self.CatalogButton.tag=2;
                self.SettingButton=[[[UIButton alloc] initWithFrame:CGRectMake(161,1,42,42)] autorelease];
                self.SettingButton.tag=3;
                self.BookMarkButton=[[[UIButton alloc] initWithFrame:CGRectMake(911,-4,42,42)] autorelease];
                self.BookMarkButton.tag=4;
                
                self.Changedirection=[[[UIButton alloc] initWithFrame:CGRectMake(842,-4,42,42)] autorelease];
                self.Changedirection.tag=5;
                
            }
            
            
            
        }
    }
    [self addSubview:self.GoBackButton ];
    [self addSubview:self.CatalogButton ];
    [self addSubview:self.SettingButton ];
    [self addSubview:self.BookMarkButton ];
    [self addSubview:self.Changedirection];
    return self;
}
-(void)dealloc{
    [_GoBackButton release];
    [_CatalogButton release];
    [_SettingButton release];
    [_BookMarkButton release];
    [_Changedirection release];
    [super dealloc];
}
@end
@implementation ButtomSettingView
@synthesize buttonSlider=_buttonSlider;
-(id)init{
    if (self=[super initWithFrame:CGRectMake(0,0, 279, 23)]) {
        self.buttonSlider=[[[UISlider alloc] initWithFrame:CGRectZero] autorelease];
        self.buttonSlider.tag=1;
    }
    [self addSubview:self.buttonSlider ];
    return self;
}
-(void)setFrame:(CGRect)frame{
    super.frame=frame;
    self.buttonSlider.frame=self.bounds;
}

-(void)dealloc{
    [super dealloc];
    [_buttonSlider release];
}
@end
@implementation PageInforView
@synthesize titleView=_titleView,inforView=_inforView;
-(id)init{
    if (self=[super initWithFrame:CGRectMake(0,0,280, 55)]) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imagefileNamed:@"AdvanceBookReadingImage.bundle/bookreading-paginfor.png" ]];
        self.titleView=[[[UILabel alloc] initWithFrame:CGRectMake(10,3, 260, 30)] autorelease];
        self.titleView.backgroundColor=[UIColor clearColor ];
        
        self.titleView.textAlignment = NSTextAlignmentCenter;
        self.titleView.tag=1;
        self.inforView=[[[UILabel alloc] initWithFrame:CGRectMake(10,30, 260, 20)] autorelease];
        self.inforView.textAlignment = NSTextAlignmentCenter;
        
        self.inforView.backgroundColor=[UIColor clearColor ];
        self.inforView.tag=2;
    }
    [self addSubview:self.titleView ];
    [self addSubview:self.inforView ];
    return self;
}
-(void)dealloc{
    [_titleView release];
    [_inforView release];
    [super dealloc];
}
@end
@implementation SimpleTextBookView
@synthesize textAlignment;
@synthesize ChapterTitleView,ChapterFootView,isepub,contentrange,spearr;
-(id)init{
    if (self=[super init]) {
        contextstr=NULL;
        bookBounds=self.bounds;
        [self CreateInforView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        contextstr=NULL;
        bookBounds=self.bounds;
        [self CreateInforView];
    }
    return self;
}
-(void)CreateInforView{
    self.ChapterTitleView=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.ChapterTitleView.backgroundColor=[UIColor clearColor];
    self.ChapterTitleView.textAlignment=NSTextAlignmentCenter;
    self.ChapterFootView=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    
    self.ChapterFootView.backgroundColor=[UIColor clearColor ];
    self.ChapterFootView.textAlignment=NSTextAlignmentRight;
    [self addSubview: self.ChapterTitleView];
    [self addSubview: self.ChapterFootView];
}
-(void)setText:(NSMutableAttributedString *)newtext{
    if (text!=newtext) {
        [text release];
        text=[newtext retain];
        if (text!=nil) {
            isautoResize=NO;
            [self setNeedsDisplay];
        }
    }
}
-(void)setBookBounds:(CGRect)newbookBounds{
    if (!CGRectEqualToRect(bookBounds, newbookBounds)) {
        bookBounds=newbookBounds;
        isautoResize=NO;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            if(self.frame.size.width>330)
            {
                self.ChapterTitleView.frame=CGRectMake(bookBounds.origin.x, 6, bookBounds.size.width ,18);
                self.ChapterFootView.frame=CGRectMake(bookBounds.origin.x, self.bounds.size.height-23, bookBounds.size.width ,20);
            }
            else
            {
                self.ChapterTitleView.frame=CGRectMake(bookBounds.origin.x, 7, bookBounds.size.width ,18);
                self.ChapterFootView.frame=CGRectMake(-10, self.bounds.size.height-29, self.bounds.size.width ,20);
            }
            
        }
        else
        {
            self.ChapterTitleView.frame=CGRectMake(bookBounds.origin.x, 21, bookBounds.size.width ,20);
            self.ChapterFootView.frame=CGRectMake(bookBounds.origin.x, self.bounds.size.height-30, bookBounds.size.width ,20);
            
        }

        //
        [self setNeedsDisplay];
    }
}
-(void)ShowChapterText:(NSMutableAttributedString *)newtext{
    if (text!=newtext) {
        [text release];
        text=[newtext retain];
        if (text!=nil) {
            isautoResize=YES;
            NSRange rg=NSMakeRange( 0, 1);
            CTFontRef ft=  (CTFontRef)[newtext attribute: (NSString *)kCTFontAttributeName atIndex:0  effectiveRange: &rg];
            float fontsize= CTFontGetSize(ft)*2;
            // CFRelease(ft);
            CTFramesetterRef framesetter =
            CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
            CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(bookBounds.size.width, 900000), NULL);
            self.bounds=CGRectMake(0 , 0, self.bounds.size.width, suggestedSize.height+fontsize);
            bookBounds = CGRectMake(bookBounds.origin.x , bookBounds.origin.y, bookBounds.size.width, suggestedSize.height+fontsize);
            CFRelease(framesetter);
            [self setNeedsDisplay];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(isepub&&contextstr!=NULL)
    {
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
        CGContextScaleCTM(context, 1.0 ,-1.0);
        CGMutablePathRef contentpath=CGPathCreateMutable();
        CGPathAddRect(contentpath, NULL,
                      CGRectMake(bookBounds.origin.x ,self.frame.size.height-bookBounds.size.height- bookBounds.origin.y, bookBounds.size.width, bookBounds.size.height)
                      );
        CTFrameRef contextframe=CTFramesetterCreateFrame(contextstr, CFRangeMake(contentrange.location  ,contentrange.length ), contentpath, NULL);
        
        CTFrameDraw(contextframe, context);
        CGPathRelease(contentpath);
        
        if(contextframe!=NULL)
        {
            CFRelease(contextframe);
        }
        
        for (int i=0; i<[spearr count]; i++) {
            NSString*spestr= [spearr objectAtIndex:i];
            NSArray* spestrarr=[spestr componentsSeparatedByString:@"|"];
            if([[spestrarr objectAtIndex:0]isEqualToString:@"blima"])
            {
                NSString*imageName=[spestrarr objectAtIndex:1];
                
                UIImage *image = [UIImage imageWithContentsOfFile:imageName];
                
                if(!image)
                {
                    NSString* catchstring=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSArray* conpo=  [imageName componentsSeparatedByString:@"/"];
                    int cathlocation=0;
                    for(int i=0;i<[conpo count];i++)
                    {
                        NSString* pathi=[conpo objectAtIndex:i];
                        if([[pathi lowercaseString]isEqualToString:@"caches"])
                        {
                            cathlocation=i;
                        }
                    }
                    
                    for(int i=cathlocation+1;i<[conpo count];i++)
                    {
                        catchstring=[catchstring stringByAppendingPathComponent:[conpo objectAtIndex:i]];
                        
                    }
                    
                    imageName=catchstring;
                    image = [UIImage imageWithContentsOfFile:imageName];
                    
                }
                NSArray* imaarr=[[spestrarr objectAtIndex:2] componentsSeparatedByString:@";"];
                
                CGRect imageDrawRect=CGRectMake([[imaarr objectAtIndex:0] floatValue], [[imaarr objectAtIndex:1] floatValue], [[imaarr objectAtIndex:2] floatValue], [[imaarr objectAtIndex:3] floatValue]);
                
                CGContextDrawImage(context, imageDrawRect, image.CGImage);
                
            }
        }
        
        
        
        
        
        return;
    }
    
    
    
    
    if ([text length]>0) {
        CTFramesetterRef framesetter =
        CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGMutablePathRef path = CGPathCreateMutable();
        if (textAlignment==NSTextAlignmentCenter) {
            CTFramesetterRef Centerframesetter =
            CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
            CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(Centerframesetter, CFRangeMake(0, 0), NULL, CGSizeMake(bookBounds.size.width, 9000), NULL);
            CFRelease(Centerframesetter);
            CGPathAddRect(path, NULL, CGRectMake((bookBounds.size.width-suggestedSize.width)/2.0,(bookBounds.size.height-suggestedSize.height)/2.0, suggestedSize.width, suggestedSize.height));
        }else {
            CGPathAddRect(path, NULL, CGRectMake(bookBounds.origin.x ,self.frame.size.height-bookBounds.size.height- bookBounds.origin.y, bookBounds.size.width, bookBounds.size.height));
        }
        CTFrameRef frame =
        CTFramesetterCreateFrame(framesetter,
                                 CFRangeMake(0, [text length]), path, NULL);
        CTFrameDraw(frame, context);
        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
    }
}

-(CTFramesetterRef)contextstr
{
    return contextstr;
}

-(void)setContextstr:(CTFramesetterRef)_contextstr
{
    if(contextstr!=_contextstr)
    {
        if(_contextstr!=NULL)
        {
            CFRetain(_contextstr);
        }
        if(contextstr!=NULL)
        {
            CFRelease(contextstr);
        }
        contextstr=_contextstr;
    }
    
}

-(void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [text release];text=nil;
    self.ChapterTitleView=nil;
    self.ChapterFootView=nil;
    self.spearr=nil;
    if(contextstr!=NULL)
    {
        CFRelease(contextstr);
        contextstr=NULL;
    }
    
    [super dealloc];
    
}
@end
@interface SimpleTextBookReadingForChapter()
-(void)ApplyFontStyleAttribute:(NSMutableAttributedString*)attString isFistWordBig:(BOOL)fistwordBig;

@end
@implementation SimpleTextBookReadingForChapter
@synthesize ChapterCount,PageCount,CurrenPageIndex,chapterArray,FormalsCount,CurrenFormalsIndex,textFont,bookBounds,AllPageViewArray,AllPageCount,BookHistory,chapterIndexChangedDelegate,isStop,isepub,currentformater;
@synthesize style;
-(id)init{
    if (self=[super init]) {
        FormalsCount=1;
        CurrenFormalsIndex=0;
        ChapterCount=0;
        PageCount=0;
        isStop=YES;
        isexit=NO;
        countturn=0;
        contextstr=NULL;
        titlelengthplus=0;
    }
    return self;
}


-(void)setCurrenChapterIndex:(NSInteger)index{
    if (CurrenChapterIndex!=index) {
        CurrenChapterIndex=index;
        if (self.chapterIndexChangedDelegate &&[(NSObject*)chapterIndexChangedDelegate respondsToSelector:@selector(ChapterIndexChanged:Index:)]) {
            [self.chapterIndexChangedDelegate ChapterIndexChanged:self Index:CurrenChapterIndex];
        }
    }
}
-(NSInteger)CurrenChapterIndex{
    
    
    return CurrenChapterIndex;
}
-(void)setDataSourse:(id<TextBookReadingDataSourse>)InputDataSourse{
    if(DataSourse!=InputDataSourse)
    {
        [DataSourse release];
        [InputDataSourse retain];
        DataSourse=InputDataSourse;
    }
    isepub=NO;
    if(InputDataSourse &&[InputDataSourse respondsToSelector:@selector(bookInfor)]  )
    {
        NSMutableDictionary* dic=[InputDataSourse bookInfor];
        
        if([dic isKindOfClass:[NSMutableDictionary class]]&& [dic respondsToSelector:@selector(objectForKey:)])
        {
            
            isepub=[[[InputDataSourse bookInfor] objectForKey:@"isepub"] boolValue];
        }
        
    }
    
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm CreateBookMarksDirectory];
    NSString *BookHistoryfilepath=nil;
    if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
    {
        BookHistoryfilepath=[fm GetBookMarkPathWithKeyWord: [self.DataSourse TextBookReadingForKeyWord]];
    }
    
    
    if ([fm fileExistsAtPath:BookHistoryfilepath]) {
        self.BookHistory=[NSMutableDictionary dictionaryWithContentsOfFile: BookHistoryfilepath];
    }
    if (self.BookHistory==nil ) {
        self.BookHistory=[NSMutableDictionary dictionaryWithCapacity:2];
        [BookHistory setObject: [NSNumber numberWithInt:AllPageCount]  forKey:@"allpagecount"];
        NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
        [BookHistory setObject: [NSNumber numberWithInt:0]  forKey:@"pageindex"];
        [BookHistory setObject: [NSNumber numberWithInt:0]  forKey:@"chapterindex"];
        if (bookmark==nil ) {
            bookmark=[NSMutableArray arrayWithCapacity:0];
            [BookHistory setObject: bookmark forKey:@"bookmark"];
        }
    }
    self.CurrenChapterIndex=[[BookHistory objectForKey:@"chapterindex"] intValue];
    self.CurrenPageIndex=[[BookHistory objectForKey:@"pageindex"] intValue];
    
    
    
    
    AllPageCount=[[BookHistory objectForKey:@"allpagecount"] intValue];
    [fm CreateBookPageSegmentsDirectory];
    NSString *Pagefilepath=nil;
    
    if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
    {
        Pagefilepath=[fm GetBookPageSegmentPathWithKeyWord: [self.DataSourse TextBookReadingForKeyWord]];
    }
    
    
    if ([fm fileExistsAtPath:Pagefilepath]) {
        self.AllPageViewArray=[NSMutableArray arrayWithContentsOfFile: Pagefilepath];
    }
    if (self.AllPageViewArray==nil ) {
        self.AllPageViewArray=[NSMutableArray arrayWithCapacity:0];
        self.chapterArray=[NSMutableArray arrayWithCapacity:0];
        
    }else {
        if ([self.AllPageViewArray  count]>self.CurrenChapterIndex ) {
            self.chapterArray=[self.AllPageViewArray objectAtIndex:self.CurrenChapterIndex];
        }else {
            self.chapterArray=[NSMutableArray arrayWithCapacity:0];
        }
    }
    if (self.DataSourse!=nil) {
        FormalsCount=1;
        if ([self.DataSourse  respondsToSelector:@selector(numberOfFormalsInTextBook:)])
        {
            FormalsCount=[self.DataSourse  numberOfFormalsInTextBook:self];
        }
        ChapterCount=0;
        for (int i=0; i<FormalsCount; i++) {
            ChapterCount+=[self.DataSourse numberOfChaptersInFormal:i];
        }
    }
}
-(id<TextBookReadingDataSourse>)DataSourse{
    return DataSourse;
}
+(void)ClearAllPagesFile{
    [[NSFileManager defaultManager] ClearAllBookPageSegments];
}
// 获取书籍的某一页是否有书签
-(BOOL)BookMarkForPageIndex:(NSInteger)pageIndex{
    NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
    BOOL havesearch=NO;
    for(int i=0;i<[bookmark count];i++){
        
        int stringIndex=[[[bookmark objectAtIndex:i]  objectForKey:@"stringpoint"]  intValue];
        
        
        NSInteger re=0;
        NSMutableArray*ar=self.chapterArray;
        
        
        for (int i=0; i<[ar count]; i++) {
            NSArray *arr=[[ar objectAtIndex: i] componentsSeparatedByString:@","] ;
            if (stringIndex>=[[arr objectAtIndex:0] intValue] && stringIndex<([[arr objectAtIndex:0] intValue]+[[arr objectAtIndex:1] intValue])) {
                re=i;
                break;
            }
        }
        
        int searchpageindex=re;
        
        
        
        
        
        
        
        
        NSInteger tempchapterindex=[[[bookmark objectAtIndex:i] objectForKey:@"chapterindex"] intValue];
        if(searchpageindex==pageIndex&& tempchapterindex==self.CurrenChapterIndex){
            havesearch=YES;
            break;
        }
    }
    return havesearch;
}

-(BOOL)BookMarkForPageIndexnextchapter:(NSInteger)pageIndex{
    NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
    BOOL havesearch=NO;
    for(int i=0;i<[bookmark count];i++){
        int searchpageindex=[self StringIndexToPageIndex:[[[bookmark objectAtIndex:i]  objectForKey:@"stringpoint"]  intValue]];
        NSInteger tempchapterindex=[[[bookmark objectAtIndex:i] objectForKey:@"chapterindex"] intValue];
        if(searchpageindex==pageIndex&& tempchapterindex==(self.CurrenChapterIndex+1)){
            havesearch=YES;
            break;
        }
    }
    return havesearch;
}




-(BOOL)AddBookMark:(NSInteger)stringpoint{
    NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
    BOOL haveRepeat=NO;
    for(int i=0;i<[bookmark count];i++){
        NSMutableDictionary *dir=[bookmark objectAtIndex:i];
        NSInteger tempchapterindex=[[[bookmark objectAtIndex:i] objectForKey:@"chapterindex"] intValue];
        
        if([[dir objectForKey:@"stringpoint"] intValue]==stringpoint && self.CurrenChapterIndex==tempchapterindex){
            haveRepeat=YES;
            break;
        }
    }
    if(!haveRepeat){
        NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithCapacity:4];
        [dir setObject:[NSNumber numberWithInt:stringpoint]   forKey:@"stringpoint"];
        
        NSString *mark=nil;
        if(isepub)
        {
            NSString* st=[self.currentformater.str string];
            
            if(stringpoint+140<st.length)
            {
                mark=[st substringWithRange:NSMakeRange(stringpoint, 140)];
            }
            else
            {
                mark=[st substringWithRange:NSMakeRange(stringpoint, st.length-stringpoint)];
            }
            
            
            
        }
        else
        {
            
            mark=[self.DataSourse simpleTextBookReading:self NSRangeInCurrentChapter:NSMakeRange(stringpoint , 140)];
        }
        
        
        
        
        mark=[mark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        NSDateFormatter *date_format_str =[[[NSDateFormatter alloc] init] autorelease];
        date_format_str.dateFormat=@"YYYY.MM.dd HH:mm";
        date_format_str.timeZone=[NSTimeZone defaultTimeZone];
        
        [dir setObject: [self TitleForChapterIndex:self.CurrenChapterIndex]  forKey:@"markchap"];
        
        [dir setObject: mark  forKey:@"stringbookmark"];
        
        [dir setObject: [NSString stringWithFormat:@"%@",[date_format_str stringFromDate:[NSDate date]]]  forKey:@"marktime"];
        
        [dir setObject: [NSNumber numberWithInt:self.CurrenPageIndex]  forKey:@"pageindex"];
        [dir setObject: [NSNumber numberWithInt:self.CurrenChapterIndex]  forKey:@"chapterindex"];
        
        [bookmark insertObject:dir atIndex:0];
        //        [bookmark addObject:dir ];
    }
    return  !haveRepeat;
}

-(BOOL)RemoveBookMark:(NSInteger)pageIndex{
    NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
    
    for(int i=0;i<[bookmark count];i++){
        if([self StringIndexToPageIndex:[[[bookmark objectAtIndex:i]  objectForKey:@"stringpoint"]  intValue]]==pageIndex){
            [bookmark removeObjectAtIndex:i];
            break;
        }
    }
    return YES;
}

-(BOOL)RemovenextchapterBookMark:(NSInteger)pageIndex{
    NSMutableArray *bookmark=[BookHistory objectForKey:@"bookmark"];
    
    for(int i=0;i<[bookmark count];i++){
        if([self StringIndexToPageIndex:[[[bookmark objectAtIndex:i]  objectForKey:@"stringpoint"]  intValue]]==pageIndex){
            [bookmark removeObjectAtIndex:i];
            break;
        }
    }
    return YES;
}



- (NSString *)CreateCachePathByAppending:(NSString*)appendingPath {
	NSString *savefile=[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: appendingPath];
    
    return savefile;
}
-(void)SaveAll{
    
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm CreateBookMarksDirectory];
    [fm CreateBookPageSegmentsDirectory];
    if(isStop)
    {
        if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
        {
            [self.AllPageViewArray writeToFile:[fm GetBookPageSegmentPathWithKeyWord: [self.DataSourse TextBookReadingForKeyWord]]  atomically:YES];
        }
        
        if(self.DataSourse &&[self.DataSourse respondsToSelector:@selector(bookInfor)]  )
        {
            float value=0;
            float key1=0;
            float key2=0;
            
            for(int i=0;i<[self.AllPageViewArray count];i++)
            {
                int ke= [[self.AllPageViewArray objectAtIndex:i]count];
                if(i<self.CurrenChapterIndex)
                {
                    key1+=ke;
                }
                
                key2+=ke;
            }
            key1+=self.CurrenPageIndex;
            value=key1/key2;
            
            NSMutableDictionary* dic=[self.DataSourse bookInfor];
            
            if(self.DataSourse &&[self.DataSourse respondsToSelector:@selector(saveinfodic)]  )
            {
                dic=[self.DataSourse saveinfodic];
            }
            
            if([dic isKindOfClass:[NSMutableDictionary class]]&&[dic respondsToSelector:@selector(setObject:forKey:)])
            {
                [dic setObject:[NSNumber numberWithFloat:value] forKey:@"readpercent"];
                
            }
            
        }
        
        
        
        
        
    }
    else
    {
        [[NSMutableArray array]writeToFile:[fm GetBookPageSegmentPathWithKeyWord: [self.DataSourse TextBookReadingForKeyWord]]  atomically:YES];
    }
    
    
    [BookHistory setObject: [NSNumber numberWithInt:[self CurrenStringIndex:CurrenPageIndex]]  forKey:@"currentstring"];
    
    
    [BookHistory setObject: [NSNumber numberWithInt:AllPageCount]  forKey:@"allpagecount"];
    [BookHistory setObject: [NSNumber numberWithInt:self.CurrenPageIndex]  forKey:@"pageindex"];
    [BookHistory setObject: [NSNumber numberWithInt:self.CurrenChapterIndex]  forKey:@"chapterindex"];
    
    if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
    {
        [BookHistory  writeToFile:[fm GetBookMarkPathWithKeyWord:[self.DataSourse TextBookReadingForKeyWord]]  atomically:YES];
    }
    
}

-(void)savehistory
{
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm CreateBookMarksDirectory];
    [fm CreateBookPageSegmentsDirectory];
    if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
    {
        [BookHistory  writeToFile:[fm GetBookMarkPathWithKeyWord:[self.DataSourse TextBookReadingForKeyWord]]  atomically:YES];
    }
}


-(void)stopcucu
{
    isexit=YES;
}




-(NSInteger)StringIndexToPageIndex:(NSInteger)stringIndex{
    NSInteger re=0;
    
    
    NSMutableArray*ar=[self PareseData: [NSIndexPath indexPathForRow:CurrenChapterIndex inSection:self.CurrenFormalsIndex]];
    for (int i=0; i<[ar count]; i++) {
        NSArray *arr=[[ar objectAtIndex: i] componentsSeparatedByString:@","] ;
        if (stringIndex>=[[arr objectAtIndex:0] intValue] && stringIndex<([[arr objectAtIndex:0] intValue]+[[arr objectAtIndex:1] intValue])) {
            re=i;
            break;
        }
    }
    
    return re;
}
//重新分析章节文本数据
-(void)ReloadData{
    [self retain];
    [self ReloadData:[NSIndexPath indexPathForRow:self.CurrenChapterIndex  inSection: self.CurrenFormalsIndex ]];
    [self release];
}

-(void)setbookconntent:(SimpleTextBookView*)view
               forpage:(int)pageindex
{
    [view setText:nil];
    view.isepub=YES;
    view.spearr=[[self.currentformater.spelinfodic objectForKey:@"spe"] objectAtIndex:pageindex];
    NSString* rangestr=@"0,0";
    if(pageindex <[[self.currentformater.spelinfodic objectForKey:@"PageFirstCharinChapter"] count])
    {
        
        rangestr=[[self.currentformater.spelinfodic objectForKey:@"PageFirstCharinChapter"]objectAtIndex:pageindex];
    }
    
    
    NSArray* ren=[rangestr componentsSeparatedByString:@"," ];
    
    NSRange ran;
    ran.location=[[ren objectAtIndex:0] intValue];
    ran.length=[[ren objectAtIndex:1] intValue];
    view.contentrange=ran;
    view.contextstr=self.currentformater.framesetter;
    
    [view setNeedsDisplay];
}


//重新分析某个章节文本数据
-(void)ReloadData:(NSIndexPath*)indexPath{
    if(isepub)
    {
        
        self.currentformater= [self makehtmlformater:indexPath];
        
        self.chapterArray=[currentformater.spelinfodic objectForKey:@"PageFirstCharinChapter"];
        
        
        PageCount=[self.chapterArray count];
        
        
        
        return;
    }
    
    
    
    if ( self.CurrenChapterIndex>=0 && self.CurrenChapterIndex<[self.AllPageViewArray count]) {
        [self setcurrentcontentforchapter:indexPath];
        self.chapterArray=[self.AllPageViewArray  objectAtIndex:self.CurrenChapterIndex];
    }else {
        if (self.DataSourse!=nil) {
            FormalsCount=1;
            if ([self.DataSourse  respondsToSelector:@selector(numberOfFormalsInTextBook:)])
            {
                FormalsCount=[self.DataSourse  numberOfFormalsInTextBook:self];
            }
            ChapterCount=0;
            for (int i=0; i<FormalsCount; i++) {
                ChapterCount+=[self.DataSourse numberOfChaptersInFormal:i];
            }
            
            // self.ChapterCount=[self.DataSourse
            //第一步：创建文本区域
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, bookBounds);
            //第一步：创建多格式文本，支持富文本
            
            
            
            NSMutableAttributedString* attString;
            NSString*str=[self.DataSourse simpleTextBookReading:self titleForHeaderInChapters: indexPath];
            
            int len=[str length]+1+1;
            titlelengthplus=len;
            
            
            
            
            
            str=[NSString stringWithFormat:@"%@\r\r%@",str,[self.DataSourse simpleTextBookReading: self TextContentInChapters:indexPath isCache:YES  ]];
            
            
            
            attString= [[[NSMutableAttributedString alloc]
                         initWithString:str] autorelease];
            
            
            //测试修改 开始
            int oldtitlelengthplus=titlelengthplus;
            titlelengthplus=len;
            //测试修改 结束
            [self ApplyFontStyleAttribute:attString isFistWordBig:NO];
            //测试修改 开始
            titlelengthplus=oldtitlelengthplus;
            //测试修改 结束
            CTFontRef ft=CTFontCreateWithName((CFStringRef)textFont.textFont.fontName, textFont.textFont.pointSize*1.5,
                                              NULL)  ;
            [attString addAttribute:(NSString *)kCTFontAttributeName
                              value:(id)ft
                              range:NSMakeRange(0, len-1)];
            
            CFRelease(ft);
            
            if(style.SkinIndex==5)
            {
                [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:10/255.0 green:45/255.0 blue:42/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
                
            }
            else
            {
                
                if(style.SkinIndex==0)
                {
                    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:137/255.0 green:49/255.0 blue:49/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
                }
                else
                {
                    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:15/255.0 green:127/255.0 blue:110/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
                }
                
            }
            
            
            CTFramesetterRef framesetter =
            CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
            [self setContextstr:framesetter];
            BOOL isend=NO;
            int startindex=0;
            //            [self.chapterArray removeAllObjects];
            self.chapterArray=[NSMutableArray array];
            
            CTFrameRef frame =
            CTFramesetterCreateFrame(framesetter,
                                     CFRangeMake(startindex, [attString length]-startindex), path, NULL);
            CFRange frameRange = CTFrameGetVisibleStringRange(frame);
            NSString *RangeString=[NSString stringWithFormat:@"%d,%d",0,(int)frameRange.length-len];
            [self.chapterArray addObject:RangeString];
            
            CFRelease(frame); //5
            startindex+=(int)frameRange.length;
            
            
            while (!isend){
                if (startindex<[attString length]) {
                    
                    CTFrameRef frame =
                    CTFramesetterCreateFrame(framesetter,
                                             CFRangeMake(startindex, [attString length]-startindex), path, NULL);
                    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
                    NSString *RangeString=[NSString stringWithFormat:@"%d,%d",(int)frameRange.location-len,(int)frameRange.length];
                    [self.chapterArray addObject:RangeString];
                    
                    CFRelease(frame); //5
                    startindex+=  (int)frameRange.length;
                }else {
                    isend=YES;
                }
            }
            CFRelease(path);
            CFRelease(framesetter);
            
        }}
    PageCount=[self.chapterArray count];
}
-(void)ApplyFontStyleAttribute:(NSMutableAttributedString*)attString isFistWordBig:(BOOL)fistwordBig{
    
    
    //第一步：加载文本格式：字体颜色
    

    
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:(id)textFont.textColor.CGColor
                      range:NSMakeRange(0, [attString length])];
    //第一步：加载文本格式：字体
    
    CTFontRef ft=CTFontCreateWithName((CFStringRef)textFont.textFont.fontName, textFont.textFont.pointSize,
                                      NULL)  ;
    [attString addAttribute:(NSString *)kCTFontAttributeName
                      value:(id)ft
                      range:NSMakeRange(0, [attString length])];
    CFRelease(ft);
    
    
    //第一步：加载文本格式：换行模式，强制支持按单词换行
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping; //换行模式
    //    CTLineBreakMode lineBreak =kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //设置文本行间距
    long number = 2;
    
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing =  textFont.textFont.pointSize;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (spacing>11.0) {
			spacing=11.0;
		}
	}
	else
	{
		number=2;
		if (spacing>5.0) {
			spacing=5.0;
		}
	}
    
    
    
    //    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type,&number);  //13号 数据精度丢失报错 kCFNumberSInt8Type
    
    
    
    [attString addAttribute:(NSString*)kCTKernAttributeName
                      value:(id)num
                      range:NSMakeRange(0, attString.length)];
    
    CFRelease(num);
    
    
    
    
    
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    //设置文本段间距
    CTParagraphStyleSetting ParagraphSpacing;
    CGFloat paragraphspacing = textFont.textFont.pointSize*0.4 ;
    ParagraphSpacing.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    ParagraphSpacing.value = &paragraphspacing;
    ParagraphSpacing.valueSize = sizeof(CGFloat);
    //对齐方式
    CTParagraphStyleSetting paragraphalignment;
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    paragraphalignment.spec = kCTParagraphStyleSpecifierAlignment;
    paragraphalignment.value = &alignment;
    paragraphalignment.valueSize = sizeof(CTTextAlignment);
    
    //首行缩进
    CGFloat topSpacing = textFont.textFont.pointSize*2+number*3;
    CTParagraphStyleSetting topSpacingStyle;
    topSpacingStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    topSpacingStyle.value = &topSpacing;
    topSpacingStyle.valueSize = sizeof(CGFloat);
    
    
    
    //    //段缩进
    //    CGFloat headindent = 10.0f;
    //    CTParagraphStyleSetting head;
    //    head.spec = kCTParagraphStyleSpecifierHeadIndent;
    //    head.value = &headindent;
    //    head.valueSize = sizeof(float);
    
    int formindex=0;
    if(titlelengthplus>1)
    {
        formindex=titlelengthplus;
    }
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing,ParagraphSpacing,paragraphalignment,topSpacingStyle};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 5);
    [attString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                      value:(id)paragraphStyle
                      range:NSMakeRange(formindex, attString.length-formindex)];
    
    
    
    CFRelease(paragraphStyle);
}

//分析所有的页面
-(BOOL)AllData:(BOOL)isFirst{
    if (isFirst && [self.AllPageViewArray count]>0) {
        isStop=YES;
        
        if(AllPageCount==0)
        {
            for(int i=0;i<[self.AllPageViewArray count];i++)
            {
                AllPageCount+=[[AllPageViewArray objectAtIndex:i] count];
            }
        }
        
        return YES;
    }
    @synchronized(self) {
        NSMutableArray *TempAllPageViewArray=[NSMutableArray arrayWithCapacity:0];
        isStop=NO;
        if (isexit) {
            return NO;
        }
        [self retain];
        
        
        
        [self.AllPageViewArray removeAllObjects];
        AllPageCount=0;
        
        if (self.DataSourse!=nil) {
            FormalsCount=1;
            if ([self.DataSourse  respondsToSelector:@selector(numberOfFormalsInTextBook:)])
            {
                FormalsCount=[self.DataSourse  numberOfFormalsInTextBook:self];
            }
            ChapterCount=0;
            for (int i=0; i<FormalsCount; i++) {
                ChapterCount+=[self.DataSourse numberOfChaptersInFormal:i];
            }
            
            for (int i=0; i<ChapterCount; i++ ) {
                if (isexit) {
                    
                    break;
                }else {
                    @autoreleasepool {
                        NSMutableArray *pagearr=[self PareseData:[NSIndexPath indexPathForRow:i  inSection: self.CurrenFormalsIndex ]];
                        AllPageCount+=[pagearr count];
                        [TempAllPageViewArray addObject:pagearr];
                    }
                }
            }
        }
        
        
        if(isexit)
        {
            isStop=NO;
        }
        else
        {
            isStop=YES;
        }
        self.AllPageViewArray=TempAllPageViewArray;
        [self autorelease];
        return !isexit;
        
    }
    
}

-(BLhtmlformatter*)makehtmlformater:(NSIndexPath*)indexPath
{
    if(isepub&& [self.DataSourse respondsToSelector:@selector(blhtmlinfoforchapter:)])
    {
        [self retain];
        
        BLhtmlformatter* formaterr=nil;
        if (self.DataSourse!=nil) {
            BLhtmlinfo* html=[self.DataSourse blhtmlinfoforchapter:indexPath.row];
            formaterr=[[[BLhtmlformatter alloc] init] autorelease];
            formaterr.pagesize=bookBounds;
            
            formaterr.font=textFont.textFont;
            formaterr.fontsize=textFont.textFont.pointSize;
            
            [formaterr setstrwithhtml:html prestr:nil];
            UIColor* textcolor=textFont.textColor;
            
            [formaterr.str addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[textcolor CGColor]range:NSMakeRange(0, [formaterr.str length])];
            
            NSString* spesavepath=nil;
            if([self.DataSourse respondsToSelector:@selector(TextBookReadingForKeyWord)])
            {
                
                
                spesavepath=[[NSFileManager defaultManager] GetBookPageSegmentPathWithKeyWord: [[self.DataSourse TextBookReadingForKeyWord] stringByAppendingString:[NSString stringWithFormat:@"spe%d",indexPath.row]]];
                
            }
            if(spesavepath&&[[NSFileManager defaultManager] fileExistsAtPath:spesavepath])
            {
                NSMutableDictionary*spedic=[[[NSMutableDictionary alloc]initWithContentsOfFile:spesavepath] autorelease];
                formaterr.spelinfodic=spedic;
                [formaterr makecontenstr];
            }
            else
            {
                [formaterr analysisstr:formaterr.str];
                
                if(spesavepath)
                {
                    [formaterr.spelinfodic writeToFile:spesavepath atomically:YES];
                }
            }
        }
        
        [self autorelease];
        return formaterr;
    }
    
    return nil;
    
}

-(NSMutableArray*)PareseData:(NSIndexPath*)indexPath{
    if(isepub&& [self.DataSourse respondsToSelector:@selector(blhtmlinfoforchapter:)])
    {
        [self retain];
        NSMutableArray *TempchapterArray=nil;
        if (self.DataSourse!=nil) {
            BLhtmlformatter* formaterr=[self makehtmlformater:indexPath];
            TempchapterArray=[formaterr.spelinfodic objectForKey:@"PageFirstCharinChapter"];
        }
        
        [self autorelease];
        return TempchapterArray;
    }
    
    [self retain];
    NSMutableArray *TempchapterArray=[NSMutableArray arrayWithCapacity:0];
    if (self.DataSourse!=nil) {
        //第一步：创建文本区域
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, bookBounds);
        //第一步：创建多格式文本，支持富文本
        NSMutableAttributedString* attString;
        
        NSString*str=[self.DataSourse simpleTextBookReading:self titleForHeaderInChapters: indexPath];
        int len=[str length]+1+1;
        
        
        str=[NSString stringWithFormat:@"%@\r\r%@",str,[self.DataSourse simpleTextBookReading: self TextContentInChapters:indexPath isCache:NO]];
        
        
        attString= [[NSMutableAttributedString alloc]
                    initWithString:str];
        
        
        
        
        //测试修改 开始
        int oldtitlelengthplus=titlelengthplus;
        titlelengthplus=len;
        //测试修改 结束
        [self ApplyFontStyleAttribute:attString isFistWordBig:NO];
        
        titlelengthplus=oldtitlelengthplus;
        //
        CTFontRef ft=CTFontCreateWithName((CFStringRef)textFont.textFont.fontName, textFont.textFont.pointSize*1.5,
                                          NULL)  ;
        [attString addAttribute:(NSString *)kCTFontAttributeName
                          value:(id)ft
                          range:NSMakeRange(0, len-1)];
        
        CFRelease(ft);
        //
        
        
        CTFramesetterRef framesetter =
        CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
        
        BOOL isend=NO;
        int startindex=0;
        
        
        
        CTFrameRef frame =
        CTFramesetterCreateFrame(framesetter,
                                 CFRangeMake(0,0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSString *RangeString=[NSString stringWithFormat:@"%d,%d",0,((int)frameRange.length-len)];
        [TempchapterArray addObject:RangeString];
        CFRelease(frame); //5
        startindex+=  (int)frameRange.length;
        
        while (!isend&&!isexit)
        {
            if (startindex<[attString length]) {
                
                CTFrameRef frame =
                CTFramesetterCreateFrame(framesetter,
                                         CFRangeMake(startindex, [attString length]-startindex), path, NULL);
                CFRange frameRange = CTFrameGetVisibleStringRange(frame);
                NSString *RangeString=[NSString stringWithFormat:@"%d,%d",(int)frameRange.location-len,(int)frameRange.length];
                [TempchapterArray addObject:RangeString];
                CFRelease(frame); //5
                startindex+=  (int)frameRange.length;
            }else {
                isend=YES;
            }
        }
        CFRelease(path);
        CFRelease(framesetter);
        [attString release];
    }
    
    [self release];
    return TempchapterArray;
}


-(NSInteger)CurrenStringIndex:(NSInteger)pageIndex{
    NSArray *arr=[[self.chapterArray objectAtIndex:pageIndex] componentsSeparatedByString:@","];
    
    return [[arr objectAtIndex:0] intValue];
}


-(void)setcurrentcontentforchapter:(NSIndexPath*)indexPath
{
    NSMutableAttributedString* attString;
    NSString*str=[self.DataSourse simpleTextBookReading:self titleForHeaderInChapters: indexPath];
    int len=[str length]+1+1;
    titlelengthplus=len;
    str=[NSString stringWithFormat:@"%@\r\r%@",str,[self.DataSourse simpleTextBookReading: self TextContentInChapters:indexPath isCache:YES  ]];
    
    attString= [[[NSMutableAttributedString alloc]
                 initWithString:str] autorelease];
    
    [self ApplyFontStyleAttribute:attString isFistWordBig:NO];
    CTFontRef ft=CTFontCreateWithName((CFStringRef)textFont.textFont.fontName, textFont.textFont.pointSize*1.5,
                                      NULL)  ;
    [attString addAttribute:(NSString *)kCTFontAttributeName
                      value:(id)ft
                      range:NSMakeRange(0, len-1)];
    
    CFRelease(ft);
    
    if(style.SkinIndex==5)
    {
        [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:10/255.0 green:45/255.0 blue:42/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
        
    }
    else
    {
        if(style.SkinIndex==0)
        {
            [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:137/255.0 green:49/255.0 blue:49/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
        }
        else
        {
            [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:15/255.0 green:127/255.0 blue:110/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
        }
        
    }
    
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    [self setContextstr:framesetter];
    
    CFRelease(framesetter);
}


-(void)setCustomebookconntent:(SimpleTextBookView*)view
                      forpage:(int)pageindex
{
    [view setText:nil];
    view.isepub=YES;
    view.spearr=nil;
    NSArray *ren=[NSArray arrayWithObjects:@"0",@"0", nil];
    ;
    if(pageindex <[self.chapterArray count])
    {
        ren=[[self.chapterArray objectAtIndex: pageindex] componentsSeparatedByString:@","];
    }
    NSRange ran;
    
    ran.location=[[ren objectAtIndex:0] intValue];
    
    
    
    ran.length=[[ren objectAtIndex:1] intValue];
    if(pageindex==0)
    {
        ran.length+=titlelengthplus;
    }
    else
    {
        
        ran.location+=titlelengthplus;
        
    }
    view.contentrange=ran;
    view.contextstr=[self contextstr];
    [view setNeedsDisplay];
}



//获取书籍的某一页的内容
-(NSMutableAttributedString*)ObjectForPageIndex:(NSInteger)pageIndex{
    if ( pageIndex<0 || pageIndex>=[self.chapterArray count]) {
        return nil;
    }
    NSArray *arr=[[self.chapterArray objectAtIndex: pageIndex] componentsSeparatedByString:@","];
    NSMutableAttributedString *AttributedString;
    
    
    if(pageIndex==0)
    {
        NSString*str=[self.DataSourse simpleTextBookReading:self titleForHeaderInChapters: [NSIndexPath  indexPathForRow:CurrenChapterIndex inSection:self.CurrenFormalsIndex]];
        int len=[str length]+1+1;
        str=[NSString stringWithFormat:@"%@\r\r%@",str,[self.DataSourse simpleTextBookReading:self NSRangeInCurrentChapter:NSMakeRange([[arr objectAtIndex:0] intValue] ,  [[arr objectAtIndex:1] intValue]) ]];
        
        AttributedString=[[[NSMutableAttributedString alloc] initWithString:str]autorelease];
        //测试修改  开始
        int oldtitlelengthplus=titlelengthplus;
        titlelengthplus=len;
        //测试修改  结束
        //
        [self ApplyFontStyleAttribute:AttributedString isFistWordBig:NO];
        //测试修改 开始
        titlelengthplus=oldtitlelengthplus;
        //测试修改 结束
        CTFontRef ft=CTFontCreateWithName((CFStringRef)textFont.textFont.fontName, textFont.textFont.pointSize*1.5,
                                          NULL)  ;
        [AttributedString addAttribute:(NSString *)kCTFontAttributeName
                                 value:(id)ft
                                 range:NSMakeRange(0, len-1)];
        if(style.SkinIndex==5)
        {
            [AttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:10/255.0 green:45/255.0 blue:42/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
            
        }
        else
        {
            
            if(style.SkinIndex==0)
            {
                [AttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:137/255.0 green:49/255.0 blue:49/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
            }
            else
            {
                [AttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:15/255.0 green:127/255.0 blue:110/255.0 alpha:1.0] CGColor]range:NSMakeRange(0, len)];
            }
            
        }
        
        
        CFRelease(ft);
        
    }
    else
    {
        AttributedString=[[[NSMutableAttributedString alloc] initWithString:[self.DataSourse simpleTextBookReading:self NSRangeInCurrentChapter:NSMakeRange([[arr objectAtIndex:0] intValue] ,  [[arr objectAtIndex:1] intValue]) ]] autorelease];
        [self ApplyFontStyleAttribute: AttributedString isFistWordBig:NO];
    }
    
    
    return  AttributedString;
}

// 获取每章节的标题
-(NSString*)TitleForChapterIndex:(NSInteger)ChapterIndex{
    return [self.DataSourse simpleTextBookReading:self titleForHeaderInChapters: [NSIndexPath indexPathForRow:ChapterIndex  inSection: self.CurrenFormalsIndex ]];
    
}
-(NSString*)BookName{
    return  [self.DataSourse TextBookReadingForTitle];
}

-(CTFramesetterRef)contextstr
{
    return contextstr;
}

-(void)setContextstr:(CTFramesetterRef)_contextstr
{
    if(contextstr!=_contextstr)
    {
        if(_contextstr!=NULL)
        {
            CFRetain(_contextstr);
        }
        if(contextstr!=NULL)
        {
            CFRelease(contextstr);
        }
        contextstr=_contextstr;
    }
    
}

-(void)dealloc{
    if(contextstr!=NULL)
    {
        CFRelease(contextstr);
        contextstr=NULL;
    }
    self.currentformater=nil;
    isexit=YES;
    [DataSourse release];
    self.chapterArray=nil;
    self.AllPageViewArray=nil;
    self.BookHistory=nil;
    self.textFont=nil;
    [textFont release];
    [super dealloc];
}
@end
#define DefualtAlarmSettingDocumentPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"BookReadingSkin.plist"]
#define DefualtAlarmSettingmainBundlePath [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BookReadingSkin.plist"]
@implementation  AdvanceFont
@synthesize textFont,textColor;
-(void)dealloc{
    [textFont  release];
    [textColor  release];
    [super dealloc];
}
@end
@implementation SimpleTextBookReadingStytle
@synthesize SkinIndex,OperationQueu,pageisdouble,autofollow;
static SimpleTextBookReadingStytle * sharedSimpleTextBookReadingStytleInstance = nil;
+ (SimpleTextBookReadingStytle *)sharedSimpleTextBookReadingStytle;
{
    //用于单线程
    @synchronized(self) {
        if (sharedSimpleTextBookReadingStytleInstance == nil) {
            sharedSimpleTextBookReadingStytleInstance=[[self alloc] init];
            [sharedSimpleTextBookReadingStytleInstance loadsettings];
        }
    }
    return sharedSimpleTextBookReadingStytleInstance;
}
-(void)loadsettings{
    
    NSMutableDictionary* defaultdic=[NSMutableDictionary dictionaryWithContentsOfFile:DefualtAlarmSettingmainBundlePath];
    
    
    
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath: DefualtAlarmSettingDocumentPath])
    {
        BookReadingSkin=[NSMutableDictionary dictionaryWithContentsOfFile:DefualtAlarmSettingmainBundlePath];
        [BookReadingSkin writeToFile: DefualtAlarmSettingDocumentPath atomically:YES];
    }else {
        BookReadingSkin=[NSMutableDictionary dictionaryWithContentsOfFile:DefualtAlarmSettingDocumentPath];
    }
    
    if([BookReadingSkin objectForKey:@"styleversionengine"]==nil)
    {
        BookReadingSkin=defaultdic;
    }
    
    if([[BookReadingSkin objectForKey:@"styleversionengine"] intValue]!=[[defaultdic objectForKey:@"styleversionengine"] intValue])
    {
        BookReadingSkin=defaultdic;
        [SimpleTextBookReadingForChapter ClearAllPagesFile];
        
    }
    
    [BookReadingSkin retain];
    self.SkinIndex=[[self StaticSettinsForKey:@"skinindex"] intValue];
    self.pageisdouble=[[self StaticSettinsForKey:@"pageisdouble"] boolValue];
    self.autofollow=[[self StaticSettinsForKey:@"autofollow"] boolValue];
    self.OperationQueu=[[[NSOperationQueue alloc] init] autorelease];
    self.OperationQueu.maxConcurrentOperationCount=1;
}
-(NSString*)DeviceInfor{
    //iPad code
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    } else
        
#endif
    {
        return @"iphone";
        
    }
}
-(NSString*)OrientationInfor{
    if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait||[UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        return @"v";
    }else {
        // return @"h";
        return @"v";
    }
}
-(void)SaveAllSettings{
    
    [BookReadingSkin setObject:[NSNumber numberWithBool:self.pageisdouble] forKey:@"pageisdouble"];
    
 	[BookReadingSkin writeToFile:DefualtAlarmSettingDocumentPath	atomically:YES];
}
-(void)ChangedStaticSettinsForKey:(NSString*)Key Value:(NSObject*)value{
    [BookReadingSkin setObject:value  forKey:Key];
}

-(void)ChangedPublicksettingsSettinsForKey:(NSString*)Key Value:(NSObject*)value{
    [[BookReadingSkin objectForKey:@"publicksettings"]  setObject:value  forKey:Key];
}

//限定性全局配置
-(NSString*)StaticSettinsForKey:(NSString*)Key{
    if ([Key isEqualToString:@"bookBounds"]) {
        if(pageisdouble){
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                return [NSString stringWithFormat:@"51,55,%d,315",(int)(CGRectGetWidth([UIScreen mainScreen].bounds)-102)];
//                return @"51,55,924,315";
            }else{
                
                return [NSString stringWithFormat:@"20,27,%d,%d",(int)(CGRectGetHeight([UIScreen mainScreen].bounds)-40),(int)(CGRectGetWidth([UIScreen mainScreen].bounds)-54)];

//                if([UIScreen mainScreen].bounds.size.height<490){
//                    return @"20,27,442,210";
//                }else{
//                    return @"20,27,530,298";
//                }
            }
            
        }
        //arr: 14, 30, 295, 50|15, 20, 50, 310|30,55, 710, 65|10, 20,1024 ,110
        NSArray *arr=[[BookReadingSkin objectForKey:Key] componentsSeparatedByString:@"|"];
        if ([[self DeviceInfor] isEqualToString:@"iphone"]&&[[self OrientationInfor] isEqualToString:@"v"]){//竖屏
            return [NSString stringWithFormat:@"14, 30, %d, 50",(int)(CGRectGetWidth([UIScreen mainScreen].bounds)-28)];
//            return  [arr objectAtIndex:0];
        }else if ([[self DeviceInfor] isEqualToString:@"iphone"]&&[[self OrientationInfor] isEqualToString:@"h"]){//横屏
            return [NSString stringWithFormat:@"15, 20, 50, %d", (int)(CGRectGetWidth([UIScreen mainScreen].bounds)-40)];
//            return  [arr objectAtIndex:1];
        }if ([[self DeviceInfor] isEqualToString:@"ipad"]&&[[self OrientationInfor] isEqualToString:@"v"]){
            return [NSString stringWithFormat:@"30,55, %d, 65",(int)(CGRectGetWidth([UIScreen mainScreen].bounds)-60)];

//            return  [arr objectAtIndex:2];
        }if ([[self DeviceInfor] isEqualToString:@"ipad"]&&[[self OrientationInfor] isEqualToString:@"h"])
            return [NSString stringWithFormat:@"10,20, %d, 110", (int)(CGRectGetHeight([UIScreen mainScreen].bounds)-20)];

//            return  [arr objectAtIndex:3];
    }
    return [BookReadingSkin objectForKey:Key];
}

//公共全局配置
-(NSString*)PublickSettingsForKey:(NSString*)Key {
    NSString *str=[NSString stringWithFormat: [[BookReadingSkin objectForKey:@"publicksettings"] objectForKey:Key],[self StaticSettinsForKey:@"bundlename"],[self DeviceInfor],[self OrientationInfor] ];
    return str;
}
-(NSString*)PublickSettingsForKey:(NSString*)Key skinindex:(NSInteger)index{
    NSString *str=[NSString stringWithFormat: [[BookReadingSkin objectForKey:@"publicksettings"] objectForKey:Key],[self StaticSettinsForKey:@"bundlename"],[self DeviceInfor],[self OrientationInfor],index ];
    return str;
}
-(NSString*)PublickSettingsForKey:(NSString*)Key skinindex:(NSInteger)index buttonState:(NSString*)state{
    NSString *str=[NSString stringWithFormat: [[BookReadingSkin objectForKey:@"publicksettings"] objectForKey:Key],[self StaticSettinsForKey:@"bundlename"],[self DeviceInfor],[self OrientationInfor],index ,state];
    return str;
}


//菜单配置
-(NSString*)MemuSettingsForKey:(NSString*)Key{
    NSString *str=[NSString stringWithFormat: [[BookReadingSkin objectForKey:@"memusettings"] objectForKey:Key],[self StaticSettinsForKey:@"bundlename"]];
    return str;
}
-(NSString*)MemuSettingsForKey:(NSString*)Key buttonState:(NSString*)state{
    NSString *str=[NSString stringWithFormat: [[BookReadingSkin objectForKey:@"memusettings"] objectForKey:Key],[self StaticSettinsForKey:@"bundlename"],state];
    
    return str;
}
-(void)dealloc{
    [OperationQueu cancelAllOperations];
    [OperationQueu release];
    [BookReadingSkin release];
    [super dealloc];
    
}
@end
@implementation NSString(RangeFromString)
-(UIColor*)ColorFromString{
    NSArray *arr=[self  componentsSeparatedByString:@","];
    if ([arr count]==3) {
        return [UIColor colorWithRed:[[arr objectAtIndex:0] intValue]/255.0  green:[[arr objectAtIndex:1] intValue]/255.0  blue:[[arr objectAtIndex:2] intValue]/255.0  alpha: 1.0];
    }else  if ([arr count]==4){
        return [UIColor colorWithRed:[[arr objectAtIndex:0] intValue]/255.0  green:[[arr objectAtIndex:1] intValue]/255.0  blue:[[arr objectAtIndex:2] intValue]/255.0  alpha:[[arr objectAtIndex:3] intValue]/255.0];
    }
    return [UIColor blueColor];
}
-(CGRect)RangeFromString{
    NSArray *arr=[self componentsSeparatedByString:@","];
    return CGRectMake([[arr  objectAtIndex:0] intValue],[[arr  objectAtIndex:1] intValue],[[arr  objectAtIndex:2] intValue],[[arr  objectAtIndex:3] intValue]);
}
-(AdvanceFont*)AdvanceFontFromString:(NSInteger)index{
    SimpleTextBookReadingStytle*style=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
    
    NSArray *arr=[self componentsSeparatedByString:@"|"];
    NSArray *fontarr=[[arr objectAtIndex:1] componentsSeparatedByString:@","];
    int fontsize=17;
    if ([[style DeviceInfor] isEqualToString:@"iphone"]) {
        fontsize=[[fontarr objectAtIndex:0] intValue];
    }else {
        fontsize=[[fontarr objectAtIndex:1] intValue];
    }
    NSString* fontname=[[[(NSArray *)[style StaticSettinsForKey:@"fonttype"] objectAtIndex:[[style StaticSettinsForKey:@"fonttypeindex"] intValue]]  componentsSeparatedByString:@"|"] objectAtIndex:0];
    if(fontname==nil)
    {
        fontname=[UIFont systemFontOfSize:17].fontName;
    }
    AdvanceFont *ft=[[[AdvanceFont alloc] init] autorelease];
    ft.textFont=[UIFont fontWithName:fontname  size:fontsize];
    if(ft.textFont==nil)
    {
        ft.textFont=[UIFont systemFontOfSize:17];
    }
    
    NSArray *colorarr=[[arr objectAtIndex:0] componentsSeparatedByString:@"-"];
    
    ft.textColor=[[colorarr objectAtIndex:index] ColorFromString];
    if(ft.textColor==nil)
    {
        ft.textColor=[UIColor blackColor];
    }
    return ft;
}

@end   


