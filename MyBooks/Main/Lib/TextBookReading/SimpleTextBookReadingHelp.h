//
//  SimpleTextBookReadingHelp.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "EBookLocalStore.h"
#import <UIKit/UIKit.h>
#import "BLhtmlformatter.h"
@class AdvanceFont;
@protocol TextBookReadingDataSourse;
@protocol BookReadingSettingViewEventDelegate
@required
-(void)valueChanged:(id)sender;
-(void)ButtonClick:(id)sender;
@end
@protocol ChapterIndexChangedDelegate <NSObject>
-(void)ChapterIndexChanged:(id)sender Index:(NSInteger)index;
-(NSInteger)DefualtChapterIndex:(id)sender;
-(NSInteger)DefualtPageIndex:(id)sender;
@end
@interface BookReadingSettingView : UIView
{
    id< BookReadingSettingViewEventDelegate> delegate;
    BOOL fontischanged;
}
@property (nonatomic,assign) id< BookReadingSettingViewEventDelegate> delegate;
@property BOOL fontischanged;
-(IBAction)valueChanged:(UISlider*)sender;
-(IBAction)ButtonClick:(UIButton*)sender;
@end
@interface TopSettingView : UIView
@property(strong,nonatomic)  UIButton *GoBackButton;
@property(strong,nonatomic)  UIButton *CatalogButton;
@property(strong,nonatomic)  UIButton *SettingButton;
@property(strong,nonatomic) UIButton *BookMarkButton;
@property(strong,nonatomic)UIButton  *Changedirection;

-(id)initWithDefualt:(NSString*)mode;
-(void)OnlyShowText:(BOOL)isShow;
@end
@interface ButtomSettingView : UIView
@property(strong,nonatomic) UISlider *buttonSlider;
-(void)OnlyShowText:(BOOL)isShow;
@end
@interface PageInforView : UIView
@property(strong,nonatomic) UILabel *titleView;
@property(strong,nonatomic) UILabel *inforView;
@end
//============核心文本显示类=================//
@interface SimpleTextBookView : UIView
{
    NSTextAlignment textAlignment;
    NSMutableAttributedString *text;
    CGRect  bookBounds;//文本区域
    Boolean isautoResize;
    UILabel *ChapterTitleView;
    UILabel *ChapterFootView;
    BOOL isepub;
    CTFramesetterRef contextstr;
    NSRange  contentrange;
    NSMutableArray*spearr;
}
@property(retain,nonatomic)NSMutableArray*spearr;
@property(readwrite)NSRange  contentrange;
@property(readwrite)BOOL isepub;
@property NSTextAlignment textAlignment;
@property(retain,nonatomic) UILabel *ChapterTitleView;
@property(retain,nonatomic) UILabel *ChapterFootView;
-(void)setText:(NSMutableAttributedString *)newtext;
-(void)setBookBounds:(CGRect)newbookBounds;
-(void)ShowChapterText:(NSMutableAttributedString *)newtext ;


-(CTFramesetterRef)contextstr;
-(void)setContextstr:(CTFramesetterRef)contextstr;
@end
//============核心文本分析类，主要目的把章节拆分称合适的字数=================//
@class SimpleTextBookReadingStytle;
@interface SimpleTextBookReadingForChapter : NSObject
{
      id<TextBookReadingDataSourse> DataSourse;
      id<ChapterIndexChangedDelegate> chapterIndexChangedDelegate;
    NSInteger  FormalsCount;//卷总数
     NSInteger  CurrenFormalsIndex;//当前卷索引
      NSInteger ChapterCount;//章节总数
      NSInteger CurrenChapterIndex;//当前章节索引
      NSInteger PageCount;//页面总数
    NSInteger CurrenPageIndex;//当前页面索引
       NSInteger AllPageCount;
     CGRect  bookBounds;//文本区域
     BOOL isStop;
      BOOL isexit;
     SimpleTextBookReadingStytle*style;
    NSMutableArray *chapterArray;//每个页面的字符索引
     AdvanceFont *textFont;
     NSMutableArray *AllPageViewArray;
      NSMutableDictionary *BookHistory;
   int countturn;
    BOOL  isepub;
    BLhtmlformatter* currentformater;
    
    
    CTFramesetterRef contextstr;
    int titlelengthplus;
}
@property(retain,nonatomic)BLhtmlformatter* currentformater;
@property(readwrite)BOOL  isepub;
@property(nonatomic,retain) NSMutableArray *AllPageViewArray;
@property(nonatomic,retain)NSMutableArray *chapterArray;
@property(nonatomic,retain,readwrite)NSMutableDictionary *BookHistory;
@property (readonly) NSInteger FormalsCount;
@property  NSInteger CurrenFormalsIndex;
@property (readonly) NSInteger ChapterCount;
@property (readonly) NSInteger PageCount;
@property  NSInteger CurrenPageIndex; 
@property (readonly) NSInteger AllPageCount;
@property(readonly)BOOL isStop;
@property(assign)SimpleTextBookReadingStytle*style;

@property CGRect  bookBounds;//文本区域
@property (nonatomic,retain)AdvanceFont *textFont;

-(void)setbookconntent:(SimpleTextBookView*)view
               forpage:(NSInteger)pageindex;

-(void)ReloadData;//重新分析章节文本数据
-(void)ReloadData:(NSIndexPath*)indexPath;//重新分析某个章节文本数据
-(NSInteger)StringIndexToPageIndex:(NSInteger)stringIndex;
-(BOOL)AllData:(BOOL)isFirst;//分析所有的页面
-(void)stopcucu;



// 获取书籍的某一页是否有书签
-(NSMutableAttributedString*)ObjectForPageIndex:(NSInteger)pageIndex;
-(BOOL)BookMarkForPageIndexnextchapter:(NSInteger)pageIndex;
//获取书籍的某一页的内容
-(NSString*)TitleForChapterIndex:(NSInteger)ChapterIndex;// 获取每章节的标题
-(NSString*)BookName;
-(BOOL)BookMarkForPageIndex:(NSInteger)pageIndex;  
-(BOOL)AddBookMark:(NSInteger)stringpoint; 
-(BOOL)RemoveBookMark:(NSInteger)pageIndex; 
+(void)ClearAllPagesFile;
-(void)SaveAll;
-(NSInteger)CurrenStringIndex:(NSInteger)pageIndex;//当前页面第一个字符的索引
@property(nonatomic,assign)id<ChapterIndexChangedDelegate> chapterIndexChangedDelegate;
-(void)setDataSourse:(id<TextBookReadingDataSourse>)InputDataSourse;
-(id<TextBookReadingDataSourse>)DataSourse;
-(void)setCurrenChapterIndex:(NSInteger)index;
-(NSInteger)CurrenChapterIndex;


-(CTFramesetterRef)contextstr;
-(void)setContextstr:(CTFramesetterRef)contextstr;
-(void)setCustomebookconntent:(SimpleTextBookView*)view
                      forpage:(NSInteger)pageindex;
@end
@interface AdvanceFont: NSObject
{
    UIFont *textFont;//正文字体,包括大小
    UIColor *textColor;//正文文字颜色
}
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;
@end
//============样式配置：文字颜色配置=================//
@interface SimpleTextBookReadingStytle : NSObject
{
    BOOL      pageisdouble;
    BOOL      autofollow;
    NSInteger SkinIndex;//皮肤的索引
    NSMutableDictionary *BookReadingSkin;
    NSOperationQueue *OperationQueu;//全局线程队列
}
@property (readwrite) BOOL pageisdouble;
@property (readwrite) BOOL autofollow;
@property NSInteger SkinIndex;
@property (nonatomic, retain) NSOperationQueue *OperationQueu;

+ (SimpleTextBookReadingStytle *)sharedSimpleTextBookReadingStytle;
- (void)SaveAllSettings;//保存配置
- (NSString*)StaticSettinsForKey:(NSString*)Key;//限定性全局配置
- (NSString*)PublickSettingsForKey:(NSString*)Key;//公共全局配置
- (NSString*)MemuSettingsForKey:(NSString*)Key;//菜单配置
//-(NSString*)StaticSettinsForKey:(NSString*)Key;   11号 StaticSettinsForKey 重复声明
//-(NSString*)PublickSettingsForKey:(NSString*)Key; 11号 PublickSettingsForKey重复声明
- (NSString*)PublickSettingsForKey:(NSString*)Key skinindex:(NSInteger)index buttonState:(NSString*)state;
- (NSString*)PublickSettingsForKey:(NSString*)Key skinindex:(NSInteger)index;
- (void)ChangedStaticSettinsForKey:(NSString*)Key Value:(NSObject*)value;
- (void)ChangedPublicksettingsSettinsForKey:(NSString*)Key Value:(NSObject*)value;
- (NSString*)DeviceInfor;

@end
@interface NSString(RangeFromString)
-(CGRect)RangeFromString;
-(UIColor*)ColorFromString;
-(AdvanceFont*)AdvanceFontFromString:(NSInteger)index;
@end   

@protocol TextBookReadingDataSourse <NSObject>
@required

// 获取每个卷有多少个章节
-(NSInteger)numberOfChaptersInFormal:(NSInteger)section;             

// 获取每章节的标题
- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter titleForHeaderInChapters:(NSIndexPath*)indexPath;    

- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter TextContentInChapters:(NSIndexPath*)indexPath isCache:(BOOL)cacheChapter; 
// 获取每章节的文本内容

- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter NSRangeInCurrentChapter:(NSRange)Range; 
// 获取某一章节某些文本内容

-(NSString*)TextBookReadingForKeyWord;//必须返回一个书籍的唯一标示符号

@optional
-(NSInteger)numberOfFormalsInTextBook:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter;          
// 获取有多少个卷

- (NSString *)simpleTextBookReading:(SimpleTextBookReadingForChapter *)simpleTextBookReadingForChapter titleForHeaderInFormals:(NSInteger)formalsIndexs;   
// 卷的标题
-(NSString*)TextBookReadingForTitle;
//获取书籍的名称
@end





