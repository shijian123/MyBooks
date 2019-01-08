//
//  BLparserfordata.m
//  superreader
//
//  Created by BLapple on 13-10-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BLparserfordata.h"

@implementation BLparserfordata
@synthesize Rows,foritems;
-(void)dealloc
{
    self.Rows=nil;
    self.foritems=nil;
    [super dealloc];
}


-(NSArray*)BLparsedata:(NSData*)data   foritems:(NSMutableArray*)items
{
    self.Rows=[NSMutableArray array];
    openitems=NO;
    self.foritems=items;
    BLparser* po=[[[BLparser alloc]initWithData:data encoding:NSUTF8StringEncoding parsertype:BLNSXMLParser] autorelease];
    
    po.delegate=self;
    [po parse];
    
    return self.Rows;
}



#pragma mark-parser delegate

- (void)BLparser:(BLparser *)_parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    openitems=NO;
    for (int i=0 ; i<[self.foritems count]; i++) {
		
		if([[elementName lowercaseString]isEqualToString:[self.foritems objectAtIndex:i] ])
		{
			openitems=YES;
            break;
		}
	}
    
    
}


- (void)BLparser:(BLparser *)parser didEndElement:(NSString *)elementName
{
    openitems=NO;
}


- (void)BLparser:(BLparser *)parser foundCharacters:(NSString *)string
{
    if(openitems && string.length>0)
    {
        [self.Rows addObject:string];
    }
}

- (void)BLparserDidStartDocument:(BLparser *)parser
{
    //    NSLog(@"epub info start");
}


- (void)BLparserDidEndDocument:(BLparser *)parser
{
    //    NSLog(@"epub info end");
}




- (void)BLparser:(BLparser *)parser foundComment:(NSString *)comment
{
    
}

- (void)BLparser:(BLparser *)parser foundCDATA:(NSData *)CDATABlock
{
    
}


- (void)BLparser:(BLparser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
    
}


- (void)BLparser:(BLparser *)parser parseErrorOccurred:(NSError *)parseError
{
    
    
}

@end
