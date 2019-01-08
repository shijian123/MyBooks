//
//  BLhtmlelement.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-26.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLhtmlinfo.h"
@implementation NSValue(writetofile)
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSRange a=[self rangeValue];
    NSString* str=[NSString stringWithFormat:@"%d;%d",a.location,a.length];

    [aCoder encodeObject:str forKey:@"range"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    //if(self=[super initWithCoder:aDecoder])
    
    
    NSString* str=[aDecoder decodeObjectForKey:@"range"];
    
    NSArray* ar= [str componentsSeparatedByString:@";"];
    NSRange a;
    a.location=[[ar objectAtIndex:0] intValue];
    a.length=[[ar objectAtIndex:1]intValue];
    self=[NSValue valueWithRange:a];
    
    return self;
}
@end
@interface BLhtmlinfo()

-(void)changgevaluetodata:(NSMutableDictionary*)dic;

-(void)changearrvaluetodata:(NSMutableArray*)arr;

-(void)changgedatatovalue:(NSMutableDictionary*)dic;

-(void)changearrdatatovalue:(NSMutableArray*)arr;




@end

@implementation BLhtmlinfo
@synthesize BLhtmlstr,BLhtmlattributedic,BLhtmltitle;
-(void)dealloc
{
    [BLhtmltitle release];
    [BLhtmlstr release];
    [BLhtmlattributedic release];
    [super dealloc];
}

-(void)writetofile:(NSString*)tofile
{
    
    if([[BLhtmlattributedic objectForKey:@"range"]isKindOfClass:[NSValue class]])
    {
    [self changevaluetodata];
    }
    
    
    
    
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:BLhtmlattributedic,@"BLhtmlattributedic",BLhtmlstr,@"BLhtmlstr",BLhtmltitle,@"BLhtmltitle", nil];
    
    
    
    
    
    [dic writeToFile:tofile atomically:YES];
}

-(void)changgevaluetodata:(NSMutableDictionary*)dic
{
//    NSValue* va= [dic objectForKey:@"range"];
//    NSData* frreeze;
//    frreeze =[NSKeyedArchiver archivedDataWithRootObject:va];
//    [dic setObject:frreeze forKey:@"range"];
    NSValue* va= [dic objectForKey:@"range"];
    NSString* frreeze;
    frreeze =NSStringFromRange([va rangeValue]);
    [dic setObject:frreeze forKey:@"range"];

  
}





-(void)changearrvaluetodata:(NSMutableArray*)arr
{NSMutableArray* ar;
for(NSMutableDictionary* dic in arr)
{
    [self changgevaluetodata:dic];
    
    if((ar=[dic objectForKey:@"spe"])!=nil)
    {
        [self changearrvaluetodata:ar];
    }
}
}

-(void)changevaluetodata
{
    [self changgevaluetodata:BLhtmlattributedic];
    
    NSMutableArray* arr=[BLhtmlattributedic objectForKey:@"spe"];
    [self changearrvaluetodata:arr];
}

-(void)changedatatovalue
{
    [self changgedatatovalue:self.BLhtmlattributedic ];
    NSMutableArray* arr=[self.BLhtmlattributedic objectForKey:@"spe"];
    [self changearrdatatovalue:arr];

}


+(BLhtmlinfo*)infowithcontentoffile:(NSString*)filepath
{
    BLhtmlinfo* ele=[[[BLhtmlinfo alloc]init]autorelease];
    NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:filepath];
    ele.BLhtmlstr=[dic objectForKey:@"BLhtmlstr"];
    ele.BLhtmlattributedic=[dic objectForKey:@"BLhtmlattributedic"];
    ele.BLhtmltitle=[dic objectForKey:@"BLhtmltitle"];
    
    
    [ele  changedatatovalue];
    

    return ele;
}

-(void)changgedatatovalue:(NSMutableDictionary*)dic
{
    NSString* data= [dic objectForKey:@"range"];
    
    NSValue* value;
    value =[NSValue valueWithRange:NSRangeFromString(data)];
    [dic setObject:value forKey:@"range"];
    
//    if([data isKindOfClass:[NSData class]])
//    {
////        NSData* data= [dic objectForKey:@"range"];
//        NSValue* value;
//        value =[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)data];
//        [dic setObject:value forKey:@"range"];
//   
//    }
//    else
//    {
//        NSValue* value;
//        value =[NSValue valueWithRange:NSRangeFromString(data)];
//        [dic setObject:value forKey:@"range"];
//    }
    
}




-(void)changearrdatatovalue:(NSMutableArray*)arr
{

    
    NSMutableArray* ar;
    for(NSMutableDictionary* dic in arr)
    {
        [self changgedatatovalue:dic];
        
        if((ar=[dic objectForKey:@"spe"])!=nil)
        {
            [self changearrdatatovalue:ar];
        }
    }

}



-(NSString *)description
{    
    return [NSString stringWithFormat:@"attribute=\n%@\ncontent=\n%@\nlength=%d\ntitle=\n%@",self.BLhtmlattributedic,self.BLhtmlstr,[BLhtmlstr length],self.BLhtmltitle];
}








@end
