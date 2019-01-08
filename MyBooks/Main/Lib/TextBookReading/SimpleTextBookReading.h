#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "UIViewAdditions.h"
#import "QuartzCore/QuartzCore.h" 
#import "ScrollPageViewController.h"
#import "CustomPageViewController.h"
#import "BookChapterMangeViewController.h"
#import "SimpleTextBookReadingHelp.h"
#import "BLLeavesController.h"
#import "BLpageContrller.h"
#import "customcontroller.h"
//#import "BLpageController2.h"
#import "BLMidSettingView.h"
#import "EBookLocalStore.h"
#import "PublicDATA1.h"
//#import "AdsWall.h"
//#import "LeftViewController.h"
/*
 2.10
 dataengine    name title          range.location  return @" "
 pulltable     retain  assign   [layer release]
 style         bookbounds       left:15
 simplehelper  kCTTextAlignmentJustified
 TextBookReadingForKeyWord
 TextBookReadingForTitle
 */

/*
 2.23
 ebookstore  request error
 
 downebook   perform 10delay
 simplereading.
 +(void)ShowSimpleTextBookReadingWithDataEnqin:
 [SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
 -(void)loadviewsss
 self.ChapterEnqin.style=style;
 -(void)ButtonClick:(UIButton*)sender
 -(void)changesetting:(int)key
 if(YES)
 {
 AdvanceFont *textFont= [[style PublickSettingsForKey:@"textFont"] AdvanceFontFromString:style.SkinIndex];
 
 self.ChapterEnqin.textFont=textFont;
 [self.ChapterEnqin ReloadData];
 
 }
 -(void)ApplyNewStyle:(SimpleTextBookView *)AfterView  PageIndex:(NSInteger)pageIndex
 if(self.ChapterEnqin.isepub)
 {
 
 [self.ChapterEnqin setbookconntent:AfterView forpage:pageIndex];
 
 }
 else
 {
 AfterView.isepub=NO;
 
 [self.ChapterEnqin setCustomebookconntent:AfterView forpage:pageIndex];
 
 }
 
 dataengine
 NSString *str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
 NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
 NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
 
 str=[reg stringByReplacingMatchesInString:str  options:NSMatchingReportProgress  range:NSMakeRange(0, [str length])  withTemplate:@"\n"];
 
 
 
 str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
 
 SimpleTextBookReadingHelp.h
 @interface SimpleTextBookReadingForChapter
 
 
 SimpleTextBookReadingHelp.m
 -drawrect
 
 -(id)init
 -(void)ReloadData:(NSIndexPath*)indexPat
 -(void)ApplyFontStyleAttribute:
 -(void)setcurrentcontentforchapter
 -(void)setCustomebookconntent:(SimpleTextBookView*)view
 forpage:(int)pageindex
 -(CTFramesetterRef)contextstr
 -(void)setContextstr:(CTFramesetterRef)_contextstr
 
 style  plist
 -(void)loadsettings
 
 
 BLhtmlformatter.m
 -(void)appledefaultstyle
 -(NSMutableDictionary*)analysisstr:(NSMutableAttributedString*)attr
 -(void)setstrwithhtml:(BLhtmlinfo*)info prestr:(NSString*)pre
 */
/*
 3.14
 simpletextbookreading   opaque
 ebookstore              opaque

 epubdataengine         reg:
 
 htmlformater simplehelp:draw      pic      picname;

 blmidsetting       show    cell height
 
*/

@interface Bookreadingcontroller : UIViewController

@end
@class SimpleTextBookReading,SimpleTextBookReadingStytle,SimpleTextBookReadingForChapter,SimpleTextBookView,AdvanceFont;
@protocol  TextBookReadingDataSourse;
@protocol BookReadingADSDelegate 
-(UIView*)LoadADS:(SimpleTextBookReading*)simpleTextBookReading;
@end
@interface SimpleTextBookReading : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource,BookReadingSettingViewEventDelegate,CustomPageViewControllerdelegate,UIGestureRecognizerDelegate,BLMidclickdelegate,BookChapterMangeViewControllerDelegate> {

    SimpleTextBookReadingForChapter *ChapterEnqin;
    BLLeavesController*      BLleavescontrller;
    BLpageContrller*         BLpagecontroller;
    BLpageContrller*        BLpagecontroller2;
    ScrollPageViewController *ScrollHPageViewController;
    customcontroller *CurrentViewController;
//    AdsMogoIntegralWall* adWall;
    CGRect RectBounds;
    PageInforView*pageInforView;
    SimpleTextBookReadingStytle *style;
    NSMutableDictionary *paramsDir;
    BookReadingSettingView *SettingView;
    NSInteger currentstringpoint;
    UIView *AdvanceAds;
    id<BookReadingADSDelegate> ADSdelegate;

    BOOL StatusBarIsHidden;
    BOOL isfisrt;
    BOOL havemark;
    BOOL receivead;
    UIView* rootview;
    
    
    UIColor* rightcolor;
    UIImageView*rootima;
    CGRect pagesi;
    BOOL   ischange;
    //设置图片
    BLMidSettingView* BLmidsetting;
    UIImageView* toppic;
    UIImageView* endpic;
    //最地层的controller
    Bookreadingcontroller*rootcon;
    //防止误点击的view
    UIView* backview;
    UIView* adshade;
    
    BOOL userisvip;
    
    BOOL userlocked;
   
    int wallkey;
    
    BOOL  listjump;
    int jumplist;
    BOOL hasNet;
}

+ (void)ShowSimpleTextBookReadingWithDataEnqin:(id<TextBookReadingDataSourse>)DataEnqinDataSourse adsDelegate:(id<BookReadingADSDelegate>)AdsDelegate chapterIndexDelegate:(id<ChapterIndexChangedDelegate>)ChapterIndexDelegate;
+ (void)ShowSimpleTextBookReadingWithDataEnqin:(id<TextBookReadingDataSourse>)DataEnqinDataSourse adsDelegate:(id<BookReadingADSDelegate>)AdsDelegate chapterIndexDelegate:(id<ChapterIndexChangedDelegate>)ChapterIndexDelegate ParentWindow:(UIWindow *)parentWindow;

@property(nonatomic, assign) UIView *backview;

@property(nonatomic, retain) Bookreadingcontroller *rootcon;
@property(nonatomic, retain) UIColor *rightcolor;
@property(nonatomic, retain) BLpageContrller *BLpagecontroller2;
@property(nonatomic, retain) BLpageContrller *BLpagecontroller;
@property(nonatomic, retain) UIView *rootview;
@property(nonatomic, retain) id<BookReadingADSDelegate> ADSdelegate;
@property(nonatomic, retain) SimpleTextBookReadingForChapter *ChapterEnqin;

@property(nonatomic, retain) CustomPageViewController *CustomVPageViewController;
@property(nonatomic, retain) BLLeavesController *BLleavescontrller;
@property(nonatomic, retain) ScrollPageViewController * ScrollHPageViewController;

@property(nonatomic, retain) customcontroller *CurrentViewController;

@property(nonatomic, retain) PageInforView *pageInforView;
@property(nonatomic, retain)  BookReadingSettingView *SettingView;

@property(nonatomic, retain) BLMidSettingView *BLmidsetting;
@property(nonatomic, retain) UIImageView *toppic;
@property(nonatomic, retain) UIImageView *endpic;
@property(nonatomic, retain) UIView *AdvanceAds;

- (void)SaveALLData;//安全保存
- (void)Changeengine;
- (void)loadviewsss;
- (void)Changedirection;
- (void)loadmidsetview;
- (void)exit;
- (void)setima;

- (void)disappertopendpic;
- (void)setbookmark;
- (CGImageRef)getimagRef:(UIView*)view;
- (void)setbookbackground;

- (CGAffineTransform)getcurrenttrans;

- (float)transformtopi:(CGAffineTransform)tran;
- (BOOL)isdefaultchange;

- (CGAffineTransform)getcurrentdevicetrans;

- (void)loadadinmain;

@end




