#import <UIKit/UIKit.h>
#import "BLLeave1.h"
//#import "BLLeave2.h"
#import "BLviewhead.h"

#import "CustomPageViewControllerdelegate.h"
#import "customcontroller.h"

@interface BLLeavesController : customcontroller<BLviewdatasource>
{
    BOOL  pageisdouble;
    id<BLviewdatasource>    datasource;
	id<BLMidclickdelegate>          midclickdelegate;
    id<CustomPageViewControllerdelegate>  CustomDataSourceDelegate;//delegate
    UIView* UIView1;
    UIView* UIView2;
    BLLeave1*currentview;
    CGRect selfframe;
//    int CurrenPageIndex;
    int numberofchapterpage;
//    UIColor*  rightbackgroundcolor;
}
//@property(retain,nonatomic)UIColor*  rightbackgroundcolor;
@property(assign,nonatomic)id<BLviewdatasource> datasource;
@property(assign,nonatomic)id<BLMidclickdelegate>          midclickdelegate;
@property(assign,nonatomic)id<CustomPageViewControllerdelegate>CustomDataSourceDelegate;
//@property(readwrite)int CurrenPageIndex;
-(id)initandsetpageisdouble:(BOOL)pageisdouble frame:(CGRect)frame  rightcolor:(UIColor*)rightcolor;
-(void)reload;
-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin;
-(unsigned  int)getCurrentPageNumber;

@end
