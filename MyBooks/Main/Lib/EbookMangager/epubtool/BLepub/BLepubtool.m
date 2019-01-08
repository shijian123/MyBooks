//
//  BLepubtool.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLepubtool.h"






@implementation BLepubcontainerinfo
{
    NSMutableArray* containerarr;
    BLparser* parser;
}
+(NSString*)getOpfpath:(NSString*)path
{
    BLepubcontainerinfo* getter=[[[BLepubcontainerinfo alloc]init]autorelease];

   return  [getter getOpfpath:path];
    
}


-(NSString*)getOpfpath:(NSString*)path
{
    NSString* container=[path stringByAppendingPathComponent:@"META-INF/container.xml"] ;
    NSData* data=[NSData dataWithContentsOfFile:container];
    if(!data)
    { return nil;}
 
    containerarr=[NSMutableArray arrayWithCapacity:1];
    
     parser=[[[BLparser alloc]initWithData:data parsertype:BLNSXMLParser] autorelease];
    parser.delegate=self;
    [parser parse];
    if([containerarr count]==0)
    {
        return nil;
    }
    return [containerarr  objectAtIndex:0];
    
}




#pragma mark- parserdele


- (void)BLparser:(BLparser *)_parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    elementName=[elementName lowercaseString];
	if ([elementName isEqualToString:@"rootfile"]) {
		[containerarr addObject: [attributeDict valueForKey:@"full-path"]];
       
	}
    
}



@end


#pragma mark-BLepubOpfinfo




@implementation BLepubOpfinfo
{
 int  elementkey;
    
}
@synthesize metadata,spine,manifest,catchstring;

-(void)dealloc
{
    [catchstring release];
    [metadata release];
    [spine release];
    [manifest release];
  
    [super dealloc];
}


-(BLepubinfoelement*)analysisOpf:(NSString*)Opfpath
{
    
    elementkey=0;
    NSData* data=[NSData dataWithContentsOfFile:Opfpath];
    self.metadata=[NSMutableDictionary dictionary];
    self.manifest=[NSMutableDictionary dictionary];
    self.spine=[NSMutableArray array];
    BLparser* po=[[[BLparser alloc]initWithData:data encoding:NSUTF8StringEncoding parsertype:BLNSXMLParser] autorelease];
    
    po.delegate=self;
    [po parse];
   
    BLepubinfoelement*ele=[[[BLepubinfoelement alloc]init] autorelease];
    
    
    ele.metadata=self.metadata;
    ele.spine=self.spine;
    ele.manifest=self.manifest;
    ele.Opfpath=Opfpath;
    if([self.manifest objectForKey:@"ncx"]!=nil)
    {
        NSString* fileroot=[Opfpath stringByDeletingLastPathComponent];
        NSURL* baseurl=[[[NSURL alloc]initFileURLWithPath:fileroot isDirectory:YES]autorelease];
        NSURL* url=[NSURL URLWithString:[[self.manifest objectForKey:@"ncx"] objectForKey:@"href"]relativeToURL:baseurl];
        NSURL* ur=[url absoluteURL];
        NSString* path=[ur  path];
        BOOL isdirect=YES;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdirect]&&!isdirect)
        {
            BLparserfordata *data=[[[BLparserfordata alloc] init] autorelease];
            NSData *theData=[NSData dataWithContentsOfFile:path];
            [data BLparsedata:theData foritems:[NSMutableArray arrayWithObject:@"text"]];
           ele.maybetitles=data.Rows;
        }
       else
       {
            
       ele.maybetitles=[NSArray array];
       }
       
    }
    else
    {
       ele.maybetitles=[NSArray array];
    }
    
    
    return ele;
}

#pragma mark-bookinfo




#pragma mark-parser delegate

- (void)BLparser:(BLparser *)_parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
   
    elementName=[elementName lowercaseString];
    
    if([elementName isEqualToString:@"metadata"])
    {
        elementkey=1;
    }
    else
        if([elementName isEqualToString:@"manifest"])
        {
            elementkey=2;
        }
        else
            if([elementName isEqualToString:@"spine"])
            {
               elementkey=3;
            }

    
    switch (elementkey) {
        case 0:
            
            break;
        case 1:
            self.catchstring=@"";
            
            NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithDictionary:attributeDict];
            [metadata setObject:dic forKey:elementName];
            
            break;
        case 2:
            if ([elementName isEqualToString:@"item"]) {
                
                [manifest setValue:attributeDict  forKey:[attributeDict valueForKey:@"id"]];
            }
            break;
        case 3:
            if ([elementName isEqualToString:@"itemref"]) {
                
                [spine addObject:[attributeDict valueForKey:@"idref"]];
            }
            break;
        default:
            break;
    }

}


- (void)BLparser:(BLparser *)parser didEndElement:(NSString *)elementName
{
    
    elementName=[elementName lowercaseString];
    if([elementName isEqualToString:@"metadata"]||[elementName isEqualToString:@"manifest"]||[elementName isEqualToString:@"spine"] )
    {
        elementkey=0;
    }
   if(elementkey==1)
   {
     NSMutableDictionary* dic=[metadata objectForKey:elementName];
       [dic setObject:catchstring forKey:@"elecontent"];
   }
}


- (void)BLparser:(BLparser *)parser foundCharacters:(NSString *)string
{
   
    if(elementkey==1)
    {
        self.catchstring=[catchstring stringByAppendingString:string];
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
