

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DownloadHelper;
@protocol DownloadHelperDelegate <NSObject>
@optional

- (void) didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData;
- (void) dataDownloadFailed:(NSString *) reason;
@end
@interface DownloadHelper : NSObject 
{
	NSURLResponse *response;
	NSMutableData *data;
	NSString *urlString;
	NSURLConnection *urlconnection;
	id <DownloadHelperDelegate> delegate;
	BOOL isDownloading;
    int tag;
}
@property (retain) NSURLResponse *response;
@property (retain) NSURLConnection *urlconnection;
@property (retain) NSMutableData *data;
@property (assign,nonatomic) id delegate;
@property int tag;
@property (assign) BOOL isDownloading;
- (void) download:(NSString *) aURLString;
- (void)post:(NSString*)strcontext url:(NSString *) aURLString;
- (void) cancel;
@end
