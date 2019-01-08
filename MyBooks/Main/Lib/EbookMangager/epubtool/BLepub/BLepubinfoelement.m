//
//  BLepubinfoelement.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-25.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLepubinfoelement.h"

@implementation BLepubinfoelement
@synthesize metadata,spine,manifest;
@synthesize Opfpath,rootpath,maybetitles;
-(void)dealloc
{
    [rootpath release];
    [Opfpath release];
    [metadata release];
    [spine release];
    [manifest release];
    [maybetitles release];
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Opfpath:\n%@\nmetadata:\n%@\nmanifest\n%@\nspine\n%@\nmaybetitles:\n%@\n",Opfpath,metadata,manifest,spine,maybetitles ];

}

-(void)writetofile:(NSString*)tofile
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:Opfpath,@"Opfpath",metadata,@"metadata",spine,@"spine",manifest,@"manifest",rootpath,@"rootpath",maybetitles,@"maybetitles", nil];
    [dic writeToFile:tofile atomically:YES];
    
}
+(BLepubinfoelement*)elementwithfile:(NSString*)filepath
{
    
    BLepubinfoelement* ele=[[[BLepubinfoelement alloc]init]autorelease];
    NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:filepath];
    ele.Opfpath=[dic objectForKey:@"Opfpath"];
    ele.metadata=[dic objectForKey:@"metadata"];
    ele.spine=[dic objectForKey:@"spine"];
    ele.manifest=[dic objectForKey:@"manifest"];
    ele.rootpath=[dic objectForKey:@"rootpath"];
    ele.maybetitles=[dic objectForKey:@"maybetitles"];
    return ele;
}

-(NSArray*)bookComtentPathlist
{
    NSInteger length=[self.spine count];
    NSMutableArray* arr=[NSMutableArray arrayWithCapacity:length];
    
    NSString* fileroot=[self.Opfpath stringByDeletingLastPathComponent];

   NSURL* baseurl=[[[NSURL alloc]initFileURLWithPath:fileroot isDirectory:YES]autorelease];

    NSFileManager* filemanager=[NSFileManager defaultManager];
    for(int i=0;i<length;i++)
    {
        NSDictionary* dic=[self.manifest  objectForKey:[self.spine objectAtIndex:i]];
        NSString* str=[dic objectForKey:@"href"];
        if(str!=nil)
        {
            NSURL* url=[NSURL URLWithString:str relativeToURL:baseurl];
            NSURL* ur=[url absoluteURL];
            NSString* path=[ur  path];
            if([filemanager fileExistsAtPath:path])
            {
                [arr addObject:path];
            }
        }
    }
    return arr;
  
}


-(NSArray*)bookmaybetitles
{
    return self.maybetitles;
    

}


@end
