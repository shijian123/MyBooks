#import <UIKit/UIKit.h>
#import "SmalleBasebookViewController.h"
#import "ASINetworkQueue.h"
#import "AppRecord.h"
#import "IconDownloader.h"
#import "ASIHTTPRequest.h"
#import "BLurltable.h"

typedef enum{
	GoodBookPage = 0,
    PaihangBookPage,
    ClassBookPage,
    SearchBookPage,
    basepage,

    
} EbookPageType;
@interface bookOnlineViewController : SmalleBasebookViewController
{
    int currentPage;
    int maxPage;
    EbookPageType TypeID;
    NSString* TagName;
    
    
    NSMutableArray*butarr;
    
    UITableView *table;
    
    
    //图片缓存
    ASINetworkQueue *ImageQueue;
    NSMutableDictionary *entries;   //图标缓存列表
    NSMutableDictionary *imageDownloadsInProgress;//图标下载队
    UIView* blseg;
    NSInteger selection;
    
    BOOL showed;
    BOOL show1;
    
    BLurltable* urltable;
    UIButton* tablebackbut;
    
    NSInteger tablechooseindex;
    
    int linecount;
    BOOL isloading;
    BOOL receivedata;
    BOOL showAlert;
}

@property (readwrite) NSInteger tablechooseindex;
@property  (nonatomic,retain) NSString* TagName;

- (id)initWithEbookPageType:(EbookPageType)ebookPageType;


@property EbookPageType TypeID;

-(void)createblseg;

-(void)setblsegselection:(NSInteger)key;

-(void)showlist;

-(void)backtobase;

-(void)powerreload;

//-(void)changedirect:(NSNotification *)notification;
-(void)choosebook:(id)sender;
-(void)yueduClick:(UIButton*)sender;
//-(void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification;
@end
