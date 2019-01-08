#import <UIKit/UIKit.h>
#import "SmalleBasebookViewController.h"

#import "ASINetworkQueue.h"
#import "AppRecord.h"
#import "IconDownloader.h"
#import "ASIHTTPRequest.h"

@interface bookTableViewController : SmalleBasebookViewController
{
    //图片缓存
    ASINetworkQueue *ImageQueue;
    NSMutableDictionary *entries;   //图标缓存列表
    NSMutableDictionary *imageDownloadsInProgress;//图标下载队
    NSDictionary*conmitdic;
    NSInteger  conmittag;
    NSInteger  linecount;
}

@property (retain, nonatomic) NSDictionary*conmitdic;

- (void)deleboookfor:(id)sender;
- (void)powerreload;

@end
