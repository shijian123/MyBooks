//
//  BookChapterMangeViewController.m
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookChapterMangeViewController.h"
#import "BookReadingBookMarkCell.h"

@interface BookChapterMangeViewController ()
-(CGSize)ChapterSize:(NSString*)chapter;
-(NSInteger)ChaptersToPages:(NSInteger)chapterindex;
@end

@implementation BookChapterMangeViewController
@synthesize shuku,xudu,segment,tableview,booktitle,delegate,ChapterEnqin;
-(void)dealloc{
      [shuku release];
      [xudu release];
      [segment release];
      [tableview release];
      [booktitle release];
      [ChapterEnqin release];
     [super dealloc];
}
-(IBAction)xuduClick:(id)sender{
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( GotoMainForm:)]) {
        [self.delegate GotoMainForm:NO];
    }}
-(IBAction)shukuClick:(id)sender{
    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( GotoMainForm:)]) {
        [self.delegate GotoMainForm:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.view.frame=[[UIScreen mainScreen] bounds];
        self.booktitle.frame=CGRectMake((self.view.frame.size.width-300)/2.0,44,300,30);
    }else{
        self.xudu.hidden=YES;
        self.shuku.hidden=YES;
        self.booktitle.frame=CGRectMake((self.view.frame.size.width-300)/2.0,20,300,30);
    }
    
    style=[SimpleTextBookReadingStytle sharedSimpleTextBookReadingStytle];
      AdvanceFont *booknameFont = [[style PublickSettingsForKey:@"booknameFont"] AdvanceFontFromString:style.SkinIndex];
     self.view.backgroundColor =[UIColor colorWithPatternImage:[UIScreen ImageToIphone5inch:[style PublickSettingsForKey:@"pageviewbackgroung" skinindex:style.SkinIndex+1]]] ;
     self.booktitle.font=booknameFont.textFont;
    self.booktitle.textColor=booknameFont.textColor;
    [self.segment ADDitems:[NSArray arrayWithObjects: [CustomSegmentedControlImages initWithImages:[style PublickSettingsForKey:@"navigationbookneirong" skinindex:style.SkinIndex+1 buttonState:@"up"] CheckImagePath:[style PublickSettingsForKey:@"navigationbookneirong" skinindex:style.SkinIndex+1 buttonState:@"down"]], [CustomSegmentedControlImages initWithImages:[style PublickSettingsForKey:@"navigationbookshuqian" skinindex:style.SkinIndex+1 buttonState:@"up"] CheckImagePath:[style PublickSettingsForKey:@"navigationbookshuqian" skinindex:style.SkinIndex+1 buttonState:@"down"]], nil]];
    self.segment.selectedSegmentIndex=0;
    self.segment.delegate=self;
     [ self.shuku setImage:[UIImage imagefileNamed:[style PublickSettingsForKey:@"navigationbookshuku" skinindex:style.SkinIndex+1 buttonState:@"up"]]  forState:UIControlStateNormal];
    [ self.shuku setImage:[UIImage imagefileNamed:[style PublickSettingsForKey:@"navigationbookshuku" skinindex:style.SkinIndex+1 buttonState:@"down"]]  forState:UIControlStateHighlighted];
    
    [ self.xudu setImage:[UIImage imagefileNamed:[style PublickSettingsForKey:@"navigationbookxudu" skinindex:style.SkinIndex+1 buttonState:@"up"]]  forState:UIControlStateNormal];
    [ self.xudu setImage:[UIImage imagefileNamed:[style PublickSettingsForKey:@"navigationbookxudu" skinindex:style.SkinIndex+1 buttonState:@"down"]]  forState:UIControlStateHighlighted];
        self.booktitle.text=[self.ChapterEnqin BookName]; 
   /* if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.xudu.frame=CGRectMake(100,12,62,32);
        self.shuku.frame=CGRectMake(20,12,62,32);
        self.booktitle.frame=CGRectMake((self.view.frame.size.width-300)/2.0,44,300,30);
        self.segment.frame=CGRectMake((self.view.frame.size.width-100)/2.0,76,100,32);
        
     }else 
    {*/
        self.xudu.frame=CGRectMake(75,12,43,29);
        self.shuku.frame=CGRectMake(20,12,43,29);
        self.segment.frame=CGRectMake((self.view.frame.size.width-86)/2.0,74,86,29);
     //}
    self.tableview.frame=CGRectMake(self.tableview.frame.origin.x, self.segment.frame.origin.y+self.segment.frame.size.height,  self.view.frame.size.width-20, self.view.frame.size.height-self.segment.frame.origin.y-self.segment.frame.size.height);
//    
//////    }
}
- (void)JunmpNewRow{
    @try {
    [self.tableview scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: self.ChapterEnqin.CurrenChapterIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop  animated:NO];
    }
    @catch (NSException *exception) {
        
    }
}
- (void)Junmp0{
    @try {
        [self.tableview scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] atScrollPosition:UITableViewScrollPositionTop  animated:NO];
    }
    @catch (NSException *exception) {
        
    }
}


- (void)SelectIndexChangedForCustomSegmentedControl:(NSUInteger)segmentIndex{
    if (self.segment.selectedSegmentIndex==0 )
    {
    [self performSelector:@selector(JunmpNewRow) withObject:nil afterDelay:0.0];
    }
    else
    {
    [self performSelector:@selector(Junmp0) withObject:nil afterDelay:0.0];
    
    }
    
        [self.tableview reloadData];  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex==0 ) {
        return [self.ChapterEnqin.DataSourse numberOfChaptersInFormal:section];
    }
    else {
        NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        return [bookmark count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookReadingBookMarkCell";
    BookReadingBookMarkCell *cell = (BookReadingBookMarkCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[BookReadingBookMarkCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.henxian.image=[UIImage imagefileNamed: [style PublickSettingsForKey:@"navigationbookhengxian" skinindex:style.SkinIndex+1]];
        AdvanceFont *chaptertitleFont = [[style PublickSettingsForKey:@"chaptertitleFont"] AdvanceFontFromString:style.SkinIndex];
        cell.chaptertitle.font=chaptertitleFont.textFont;
        cell.chaptertitle.textColor=chaptertitleFont.textColor;
        cell.chapterindextitle.textColor=chaptertitleFont.textColor;
        cell.tophenxian.image=cell.henxian.image;
  
    }
    if (indexPath.row==0) {
        cell.tophenxian.hidden=NO;
        cell.tophenxian.frame=CGRectMake(2, -9, self.tableview.frame.size.width-4, 9);
    }else {
        cell.tophenxian.hidden=YES;
 
    }
      if (self.segment.selectedSegmentIndex==0 ) {
          if (self.ChapterEnqin.CurrenChapterIndex==indexPath.row) {
              cell.accessoryType=UITableViewCellAccessoryCheckmark;
          }else {
              cell.accessoryType=UITableViewCellAccessoryNone;
  
          }
         NSString *title=[self.ChapterEnqin TitleForChapterIndex:indexPath.row  ];
        CGSize sz=[self ChapterSize: title];
         cell.henxian.frame=CGRectMake(2, sz.height+9, self.tableview.frame.size.width-4, 9);
         cell.chaptertitle.frame=CGRectMake(20, 7, 3*self.tableview.frame.size.width/4.0, sz.height);
         cell.chapterindextitle.frame=CGRectMake(3*self.tableview.frame.size.width/4.0, (sz.height-21)/2.0+3.0, self.tableview.frame.size.width/4.0, 21);
        // cell.chaptertitle.text=title;
          cell.chaptertitle.text=[NSString stringWithFormat:@"%3i.  %@",indexPath.row+1,title];

        cell.chapterindextitle.text=[NSString stringWithFormat:@"%d",[self ChaptersToPages:indexPath.row]+1];
    }else {
        cell.accessoryType=UITableViewCellAccessoryNone;

        NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        NSString *title=[[bookmark objectAtIndex:indexPath.row] objectForKey:@"stringbookmark"];
        CGSize sz=[self ChapterSize: title];
        cell.henxian.frame=CGRectMake(2, sz.height+9, self.tableview.frame.size.width-4, 9);
        cell.chaptertitle.frame=CGRectMake(20, 7, 3*self.tableview.frame.size.width/4.0, sz.height);
        cell.chapterindextitle.frame=CGRectMake(3*self.tableview.frame.size.width/4.0, (sz.height-21)/2.0+3.0, self.tableview.frame.size.width/4.0, 21);
       // cell.chaptertitle.text=title;
        cell.chaptertitle.text=[NSString stringWithFormat:@"%3i.  %@",indexPath.row+1,title];

        if(self.ChapterEnqin.isStop)
        {
        cell.chapterindextitle.text=[NSString stringWithFormat:@"%d", [self.ChapterEnqin StringIndexToPageIndex: [[[bookmark objectAtIndex:indexPath.row] objectForKey:@"stringpoint"] intValue]]+[self ChaptersToPages:[[[bookmark objectAtIndex:indexPath.row] objectForKey:@"chapterindex"] intValue]] +1];
            cell.chapterindextitle.textColor=[UIColor blackColor];
        }
        else
        {
            cell.chapterindextitle.text=[NSString stringWithFormat:@"%d", 1];
            cell.chapterindextitle.textColor=[UIColor grayColor];
        }
        

        
        
        
    }
   
    return cell;
}
-(CGSize)ChapterSize:(NSString*)chapter{
    AdvanceFont *chaptertitleFont = [[style PublickSettingsForKey:@"chaptertitleFont"] AdvanceFontFromString:style.SkinIndex];
     CGSize size = [chapter sizeWithFont:chaptertitleFont.textFont constrainedToSize:CGSizeMake(3*self.view.frame.size.width/4.0, 9999)
                       lineBreakMode:UILineBreakModeWordWrap];
     
    return size;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex==0 ) {
   
        [self performSelector:@selector(JunmpNewRow) withObject:nil afterDelay:0.0];

        
        
        return   [self ChapterSize: [self.ChapterEnqin TitleForChapterIndex:indexPath.row  ]].height+18;
    }else {
            NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
        return   [self ChapterSize: [[bookmark objectAtIndex:indexPath.row] objectForKey:@"stringbookmark"]].height+18;

    }
}
#pragma mark - Table view delegate

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissModalViewControllerAnimated:YES];
    if (self.segment.selectedSegmentIndex==0 ) {
        if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( ChapterIndexChanged:)]) {
            [self.delegate ChapterIndexChanged:indexPath.row];
        }
    }else {
        if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector( BookMarkIndexChanged:)]) {
            NSMutableArray *bookmark=[self.ChapterEnqin.BookHistory objectForKey:@"bookmark"];
           [self.delegate BookMarkIndexChanged:[bookmark objectAtIndex:indexPath.row] ];
            [delegate setbookmark];
        } 
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return self.segment.selectedSegmentIndex==0?NO:YES; 
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

@end
