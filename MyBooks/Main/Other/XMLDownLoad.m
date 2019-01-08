//
//  PerCenterViewConPostDatas.m
//  SSBar
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "XMLDownLoad.h"
@implementation XMLDownLoad
static XMLDownLoad *downDatas=nil;

@synthesize downHelper,strTags;
- (void)dealloc
{
    self.downHelper=nil;
    self.strTags=nil;
    [super dealloc];
}

+(id)defaultXmlDown{
    @synchronized(self) {
        if (downDatas==nil) {
            downDatas=[[XMLDownLoad alloc] init];
        }
    }
    return downDatas;
}
-(id)init{
    self=[super init];
    if (self) {
        
	}
    return self;
}
+(void)stopDownLoad{
    [XMLDownLoad defaultXmlDown];
    downDatas->cancel=YES;
    [downDatas releaseDownloadHelper];
}
-(void)releaseDownloadHelper{
    self.downHelper.delegate=nil;
    [self.downHelper cancel];
    self.downHelper=nil;
}
+(void)startDown:(NSString *)downUrl downLoadTag:(int)downTags{
    [XMLDownLoad defaultXmlDown];
    downDatas->cancel=NO;
    NSString *fileNames=[downDatas getFileName:downTags];
    NSString *textpath=[downDatas RootPath:fileNames];
    if ([[NSFileManager defaultManager]fileExistsAtPath:textpath]) {
        [downDatas readXml:fileNames fileTag:downTags];
    }else if (downTags == -4||downTags == -7||downTags == -11||downTags == -12 ||downTags == -13||downTags == -14 || downTags == -15||downTags == -16||downTags == -17)
    {
        NSData *txtdata=[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"zhuanti%d.xml",downTags]]];
        [txtdata writeToFile:textpath  atomically:YES];
        [downDatas readXml:fileNames fileTag:downTags];
        
    }
    
    [downDatas LoadXml:downUrl downTags:downTags];
    
    
}
-(NSString *)getFileName:(int)tags{
    return [NSString stringWithFormat:@"zhuanti%d.xml",tags];
}
-(NSString*)RootPath:(NSString*)filename{
    NSString *MainBookResource=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MainBookResource"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:MainBookResource]){//判断是否创建文件夹
        [[NSFileManager defaultManager]createDirectoryAtPath:MainBookResource withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [NSString stringWithFormat:@"%@/%@", MainBookResource,filename];
}
-(void)readXml:(NSString *)fileNam fileTag:(int)filtag{
    NSString *textpath=[self RootPath:fileNam];
    XmlDataSet *textxml=[[XmlDataSet alloc] init];
    NSData *data= [NSData dataWithContentsOfFile:textpath];
    NSMutableArray *pp =[NSMutableArray arrayWithObject:@"item"];
    [textxml LoadNSMutableData:[NSMutableData dataWithData:data] Xpath:pp];
    NSMutableArray *datasArr=textxml.Rows;
    [textxml release];
    
    if (cancel==NO) {
        if (datasArr!=nil && datasArr.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:fileNam object:datasArr];
            });
        }
        
    }
}
- (BOOL)LoadXml:(NSString *)Url downTags:(int)tags
{
	self.downHelper = [[[DownloadHelper alloc] init] autorelease];
    downHelper.tag=tags;
	downHelper.delegate = downDatas;
    cancel=NO;
	[downHelper download:Url];
    return YES;
}
- (void) didReceiveData:(DownloadHelper*)sender Data:(NSData *)theData{
    NSString *fileNames=[self getFileName:sender.tag];
    NSString *textpath=[self RootPath:fileNames];
    
    [theData writeToFile:textpath   atomically:YES];
    [self readXml:fileNames fileTag:sender.tag];
}
- (void) dataDownloadFailed:(NSString *) reason{
    
}


@end
