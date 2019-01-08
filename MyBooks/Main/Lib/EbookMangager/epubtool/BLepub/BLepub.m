//
//  BLepub.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLepub.h"
#import "BLepubtool.h"
@implementation BLepub

+(BLepubinfoelement*)getEpubookinfofrompath:(NSString*)filepath
{

    ZipArchive* za = [[[ZipArchive alloc] init] autorelease];
    BOOL UnZipOpen ;
     
    UnZipOpen = [za UnzipOpenFile:filepath];
    

    
    
    if( UnZipOpen ){
		NSString* tofilepath;
        NSFileManager *filemanager=[NSFileManager defaultManager];
       NSString* temp  = NSTemporaryDirectory();
        

        NSProcessInfo*a = [NSProcessInfo processInfo];

        tofilepath=[temp stringByAppendingPathComponent:[a globallyUniqueString]];
		if (![filemanager fileExistsAtPath:tofilepath]) {
            
            [filemanager createDirectoryAtPath:tofilepath withIntermediateDirectories:YES attributes:nil error:NULL];
		}
		//start unzip
		BOOL ret = [za UnzipFileTo:tofilepath overWrite:YES];
    
       
		if( NO==ret ){
			// error handler here
//			UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Error"
//                                                           message:@"An unknown error occured"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil] autorelease];
//			[alert show];
		}
		[za UnzipCloseFile];
     
       
       NSString* opfpath= [BLepubcontainerinfo getOpfpath:tofilepath];
        
       
        
        
        opfpath=[tofilepath stringByAppendingPathComponent:opfpath];
        
        
        
       BLepubOpfinfo* opf= [[[BLepubOpfinfo alloc]init] autorelease];
        
        
         
    BLepubinfoelement*ele=[opf analysisOpf:opfpath];
        ele.rootpath=tofilepath;
        
        
        
        return ele;
        
	}else
    {
        return nil;
    }
}


+(BLepubinfoelement*)getEpubookinfofrompath:(NSString*)filepath cachpath:(NSString*)tofilepath
{

    ZipArchive* za = [[[ZipArchive alloc] init] autorelease];
    BOOL UnZipOpen ;
    
    UnZipOpen = [za UnzipOpenFile:filepath];
    
    
    
    
    if( UnZipOpen ){
        NSFileManager *filemanager=[NSFileManager defaultManager];
        
        
		if (![filemanager fileExistsAtPath:tofilepath]) {
            
            [filemanager createDirectoryAtPath:tofilepath withIntermediateDirectories:YES attributes:nil error:NULL];
		}
		//start unzip
		BOOL ret = [za UnzipFileTo:tofilepath overWrite:YES];
        
        
		if( NO==ret ){
			// error handler here
//			UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Error"
//                                                           message:@"An unknown error occured"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil] autorelease];
//			[alert show];
		}
		[za UnzipCloseFile];
        
        
        NSString* opfpath= [BLepubcontainerinfo getOpfpath:tofilepath];
        
        
        
        
        opfpath=[tofilepath stringByAppendingPathComponent:opfpath];
        
        
        
        BLepubOpfinfo* opf= [[[BLepubOpfinfo alloc]init] autorelease];
        
        
        
        BLepubinfoelement*ele=[opf analysisOpf:opfpath];
        ele.rootpath=tofilepath;
        
        
        
        return ele;
        
	}else
    {
        return nil;
    }
}


@end
