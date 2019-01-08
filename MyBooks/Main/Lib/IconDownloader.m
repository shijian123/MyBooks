#import "IconDownloader.h"
@implementation IconDownloader
@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
#pragma mark
- (void)dealloc
{
	if( imageConnection != nil )
	{
		[imageConnection cancel];
		[imageConnection release];
	}
    [appRecord release];
    [indexPathInTableView release];
	if( activeDownload != nil )
        [activeDownload release]; 
    [super dealloc];
}

- (void)startDownload
{
	if (appRecord.imageURLString==nil ) {
		return;
	}
    self.activeDownload = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appRecord.imageURLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
    [conn release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
	//缓存图片
    self.appRecord.appIcon = image;
    [UIImagePNGRepresentation(self.appRecord.appIcon) writeToFile:[self.appRecord  ImageCacheFile]  atomically: YES];
    self.activeDownload = nil;
    [image release];
    self.imageConnection = nil;
    if( delegate && [delegate respondsToSelector:@selector(appImageDidLoad:)] ){
        [delegate appImageDidLoad:self.indexPathInTableView];
    }
}

@end

