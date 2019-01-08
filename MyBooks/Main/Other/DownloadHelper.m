/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "DownloadHelper.h"
#import "XmlDataSet1.h"

@implementation DownloadHelper
@synthesize response;
@synthesize data;
@synthesize delegate,tag;
@synthesize urlconnection;
@synthesize isDownloading;

- (void) start
{
    [self retain];
	self.isDownloading = NO;
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	if (!url)
	{
		NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", urlString];
        if (delegate && [delegate respondsToSelector:@selector(dataDownloadFailed:)])
        {
            [self.delegate dataDownloadFailed:reason];
        }
        [self release];
		return;
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
	if (!theRequest)
	{
		NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", urlString];
        if (delegate && [delegate respondsToSelector:@selector(dataDownloadFailed:)])
        {
            [self.delegate dataDownloadFailed:reason];
        }
        [self release];
 		return;
	}
    //NSLog(@"url=%@",url);
	self.urlconnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	if (!self.urlconnection)
	{
		NSString *reason = [NSString stringWithFormat:@"URL connection failed for string %@", urlString];
        if (delegate && [delegate respondsToSelector:@selector(dataDownloadFailed:)])
        {
            [self.delegate dataDownloadFailed:reason];
        }
        [self release];
		return;
	}
	
	self.isDownloading = YES;
	
	// Create the new data object
	self.data = [NSMutableData data];
	self.response = nil;
	[self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
//Post 提交数据方法：
- (void)post:(NSString*)strcontext url:(NSString *) aURLString {
    [self retain];
    [self cancel];
	urlString = [aURLString copy];// aURLString;
	self.isDownloading = NO;
    NSData *postData = [strcontext dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    self.urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	self.isDownloading = YES;
	self.data = [NSMutableData data];
	self.response = nil;
	[self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void) cleanup
{
    [self release];
	[data release];
	[response release];
	[urlconnection release];
	isDownloading = NO;
	[urlString release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
 	self.response = aResponse;
 	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
 	[self.data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    XmlDataSet *textxml=[[XmlDataSet alloc] init];
    
    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"Error"];
    [textxml LoadNSMutableData:self.data Xpath:pp];
    NSMutableArray *datasArr=textxml.Rows;
    [textxml release];
    if (datasArr.count>0) {
        NSRange range =[urlString rangeOfString:@"oss.aliyuncs.com"];
        if (range.location==NSNotFound) {
            
        }else{
            NSString *newUrlString=[urlString stringByReplacingCharactersInRange:range withString:@"dlmdj.com"];
            [self download:newUrlString];
        }
        
        return;
    }
    
    
 	self.response = nil;
    if (delegate && [delegate respondsToSelector:@selector(didReceiveData:Data:)]) {
        [self.delegate didReceiveData:self Data:self.data];
    }
    
	[self.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[self cleanup];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
	self.isDownloading = NO;
    if (delegate && [delegate respondsToSelector:@selector(dataDownloadFailed:)])
    {
        [self.delegate dataDownloadFailed:[error description]];
    }
    [self cleanup];
}

- (void) download:(NSString *) aURLString
{
	[self cancel];
	urlString = [aURLString copy];// aURLString;
	[self start];
}

- (void) cancel
{
	if (isDownloading) [urlconnection cancel];
}

@end
