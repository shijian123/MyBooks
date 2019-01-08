#import "BLviewhead.h"
#import <UIKit/UIKit.h>
#import "BLLeaveview1.h"
#import <QuartzCore/QuartzCore.h>
@interface BLLeave1 : UIView
{
    BOOL  touchactive;
	BLLeaveview1* bl0;
    BLLeaveview1* bl1;
    BLLeaveview1* currentpagetomove;
	BLLeaveview1* temppage;
	UIView* temp;
    int   currentpage;
   __block int   movingcount;
    int   nextcount;
    BOOL  movelock;
	BOOL    touchbegain;
	BOOL    touchkeypre; //判断触摸位置
	BOOL    touchkeymid;
	BOOL    isClick;//判断是点击，防止将滑动判断为点击
	CGImageRef imag;
	CGPoint touchBeganPoint;
    id<BLviewdatasource>    datasource;
	id<BLMidclickdelegate>  midclickdelegate;
    __block  NSMutableArray* toremove;
    BOOL isload;
    BOOL limitload;
    int  movejudge;
    BOOL lockdevice;
    BOOL locked;
}
@property(assign,nonatomic)id<BLviewdatasource> datasource;
@property(assign,nonatomic)id<BLMidclickdelegate>          midclickdelegate;

-(void)BLviewSetUIView1:(UIView*)UIView1  UIView2:(UIView*)UIView2 animation:(BOOL)animation DirectionToNext:(BOOL)directin;


-(void)loadleft;
-(void)loadright;
@end
