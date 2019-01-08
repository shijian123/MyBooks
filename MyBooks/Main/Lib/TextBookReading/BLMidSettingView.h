


#import <UIKit/UIKit.h>

#import "listcell.h"
#import "CustomSegmentedControl.h"
#import "SimpleTextBookReadingHelp.h"
#import "BookReadingBookMarkCell.h"

#define novippercent     0.3333

/*
Tag;
 100退出引擎
 1设置界面
 2列表按钮
 3字体变大
 4字体变小
 5黑天白天
 6书签
 7章节列表
 8书签列表
 9switchbut
 11progressbut
 12 style1
 13 style2
 
*/
#define Maxfontsize  45
#define Minfontsize  15

@protocol BookChapterMangeViewControllerDelegate
- (void)ChapterIndexChanged:(NSUInteger)index;
- (void)BookMarkIndexChanged:(NSDictionary*)bookmarkdir;
- (void)GotoMainForm:(BOOL)isGoMainForm;
-(void)setbookmark;
-(void)sliderChanged:(UISlider*)sender;
-(void)sliderTouchUp:(UISlider*)sender;
-(IBAction)sliderTouchCancel:(UISlider*)sender;

-(void)exit;
@end

@class SimpleTextBookReading;




@interface BLMidSettingView : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomSegmentedControlDelegate>
{
	UIImageView*backgroundview;
	UIButton* disbut;
    UIImageView*top;
    UIImageView*bot;
    UIView*left;
    UIView*set;
    
    
    UISlider* pro;
    
    
    UIView*readproback;
    UISlider* readpro;
    UILabel* readprolab;
    

    UIButton* setout;
    UIButton* setback;
    UIImageView*sun1;
    UIImageView*sun2;
    
    
    UIView* pifu;
    UIButton* pifuout;
    UIButton* pifuback;
  
    
    UIImageView*jianjiaos;
    UIImageView*jianjiao;
    UIImageView* readproshade;
    UIImageView* readproshade1;
    
    UIView* ziti;
    UIButton* zitiout;
    UIButton* zitiback;
    
    
    
    UIButton*pagestyle1;
    UIButton*pagestyle2;
    UIButton*pagestyle3;
    UIImageView*pagestyle1back1;
    UIImageView*pagestyle1back2;
    UIImageView*pagestyle1back3;
    UILabel*    pagestylelab1;
    UILabel*    pagestylelab2;
    UILabel*    pagestylelab3;
    
    UIButton*pifu1;
    UIButton*pifu2;
    UIButton*pifu3;
    UIButton*pifu4;
    UIButton*pifu5;
    UIButton*pifu6;
    UIImageView*pifuback1;
    UIImageView*pifuback2;
    UIImageView*pifuback3;
    UIImageView*pifuback4;
    UIImageView*pifuback5;
    UIImageView*pifuback6;
    
    
    
    
    UIButton*ziti1;
    UIButton*ziti2;
    UIButton*ziti3;
    
    UIButton*fontbig;
    UIButton*fontsmall;
    
    
    UIButton*  backbut;
    UIButton*  mulubut;


	UIButton*  daytimeBut;
    UIButton*  bringhtnessbut;
	UIButton*  bookmarkBut;
    UIButton*   booklistbut;
    UIButton*   marklistbut;
	UITableView* listtable;
    UITableView* markable;
    UIImageView* leftchoose;
    UIImageView*leftchooseback;
    
    
    
    UILabel* titlelab;
    UIButton*   switchbut;
    UIButton*listbackbut;
    BOOL showed;
    UIView* background2;
    
    
    BOOL showvip;
    
    
    @private
    BOOL   active;
	BOOL   havemark;
	BOOL   daytimeyes;
    BOOL   isbooklist;
    float  progresslength;
	CGPoint progressstartpoint;
	
    CGRect  mulurect;
    CGRect  readprorect;
    
    
    NSString* device;
    NSString* diviecemode;
    NSString* daytime;
    
	int currentchapter;
	int currentmark;
    
    id<BookChapterMangeViewControllerDelegate> delegate;
    SimpleTextBookReadingStytle *style;
    SimpleTextBookReadingForChapter *ChapterEnqin;
    
    UILabel*timelab;
    NSTimer*timer;
    
    UIColor* titlecolor;
    UIColor* textcolor;
    UIColor* selectcolor;
    UIColor* hilightedcolor;
    SimpleTextBookReading* mumu;
    BOOL fontischanged;
    BOOL is5h;
    BOOL  nofinish;
    NSRegularExpression *reg;
    int movekey;
}
@property(readwrite)BOOL showvip;

@property(retain,nonatomic)UIColor* hilightedcolor;
@property(retain,nonatomic)UIColor* selectcolor;
@property(retain,nonatomic)UIColor* titlecolor;
@property(retain,nonatomic)UIColor* textcolor;
@property(assign,nonatomic)UIImageView*backgroundview;

@property(nonatomic,retain) SimpleTextBookReadingForChapter *ChapterEnqin;

@property(nonatomic,assign)id<BookChapterMangeViewControllerDelegate> delegate;
@property(nonatomic,retain)SimpleTextBookReadingStytle *style;


@property(assign,nonatomic)SimpleTextBookReading* mumu;



@property(assign,nonatomic)BOOL showed;

@property(assign,nonatomic)UIView* background2;

@property(retain,nonatomic)UIFont* titlefont;

-(void)reloadbooklist;

-(void)show;


-(void)butclick:(id)sender forEvent:(UIEvent*)event;


-(NSInteger)ChaptersToPages:(NSInteger)chapterindex;
-(CGSize)ChapterSize:(NSString*)chapter;
-(void)anidisappear;
-(void)imidisappear;
-(void)listjump;
-(void)setbookmark:(BOOL)have;


-(void)showset;
-(void)setdiss;




-(void)provaluechange:(UISlider*)sender;


-(void)chooselistaction;



-(void)showstatusbar;

-(void)changdirect;
-(void)setnightpic;

-(void)loadselfview;

-(void)refreshdate;

@end
