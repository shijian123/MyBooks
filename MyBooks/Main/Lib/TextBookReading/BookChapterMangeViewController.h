//
//  BookChapterMangeViewController.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "BLMidSettingView.h"
#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "SimpleTextBookReadingHelp.h"
#import "EBookLocalStore.h"
#import "UIScreen+Iphone5inch.h"
//@protocol BookChapterMangeViewControllerDelegate  
//- (void)ChapterIndexChanged:(NSUInteger)index;  
//- (void)BookMarkIndexChanged:(NSDictionary*)bookmarkdir;  
//- (void)GotoMainForm:(BOOL)isGoMainForm;
//-(void)setbookmark;
//@end  
@interface BookChapterMangeViewController : UIViewController<CustomSegmentedControlDelegate>
{
    IBOutlet UIButton*shuku;
    IBOutlet UIButton*xudu;
    IBOutlet CustomSegmentedControl*segment;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *booktitle;
    UITableView* marktable;
    id<BookChapterMangeViewControllerDelegate> delegate;
    SimpleTextBookReadingStytle *style;
    SimpleTextBookReadingForChapter *ChapterEnqin;

}
@property(nonatomic,retain) SimpleTextBookReadingForChapter *ChapterEnqin;
@property(nonatomic,retain)UIButton*shuku;
@property(nonatomic,retain)UIButton*xudu;
@property(nonatomic,retain)CustomSegmentedControl*segment;
@property(nonatomic,retain)UITableView*tableview;
@property(nonatomic,retain)UILabel*booktitle;
@property(nonatomic,assign)id<BookChapterMangeViewControllerDelegate> delegate;

- (void)Junmp0;
-(IBAction)xuduClick:(id)sender;
-(IBAction)shukuClick:(id)sender;
@end
