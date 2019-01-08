//
//  BLhtmlanalysiser.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-27.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLhtmlanalysiser.h"
#import "BLparser.h"

@interface BLhtmlanalysiser()


-(void)exterdicrangekeyforlength:(NSInteger)length;

@end



@implementation BLhtmlanalysiser
{
    BOOL  head;
    BOOL  title;
    NSMutableString* mutistring;
    int   rangelocation;
    BOOL  neednewlineafter;
    NSString* rootpath;
}
@synthesize temp,indexarr;
-(void)dealloc
{
    [mutistring release];
    [temp release];
    [super dealloc];
}

-(BLhtmlinfo*)gethtmlinfofromhtml:(NSString*)htmlpath
{
    NSData* data=[[[NSData alloc]initWithContentsOfFile:htmlpath] autorelease];
    rootpath=htmlpath;
    if(!data)
    {
        return nil;
    }
    
    head=NO;
    title=NO;
    neednewlineafter=NO;
    rangelocation=0;
    self.temp=[[[BLhtmlinfo alloc]init] autorelease];
    temp.BLhtmlstr=[NSMutableString stringWithCapacity:300];
    NSRange range;
    range.length=0;  
    range.location=0;
    
    
    
    temp.BLhtmlattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithRange:range],@"range", nil];
     self.indexarr=[[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"BLroot",@"elementName",temp.BLhtmlattributedic,@"indexspe", nil];
    
    [self.indexarr addObject:dic];
    mutistring=[[NSMutableString string] retain];
    BLparser* parser;
     if([[htmlpath pathExtension]isEqualToString:@"html"]||[[htmlpath pathExtension]isEqualToString:@"htm"])
     {
     parser=[[[BLparser alloc]initWithData:data parsertype:BLhtmlParser] autorelease];
     }
    else
    {
    parser=[[[BLparser alloc]initWithData:data parsertype:BLNSXMLParser] autorelease];
    }
    
    
    parser.delegate=self;
    [parser parse];
    
    self.indexarr=nil;
    return self.temp;
}

- (void)BLparser:(BLparser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    elementName=[elementName lowercaseString];
    //head info
    if([elementName isEqualToString:@"head"])
    {
        head=YES;
    }
    
    if(head){
        if([elementName isEqualToString:@"title"]){
            title=YES;
        }
        return;
    }

    //body
    //单标签   ima   hr  margin－top(不增长,不加入indexarr,加入spe)
    //处理标签 p  li  br   (处理，不增长，加入indexarr以确定身份)
    //增长标签 a   sub sup margin－left ( 增长，继承,加入indexarr，加入spe)
    NSMutableDictionary* indexdic = nil;
    if(attributeDict!=nil &&[attributeDict count]==0)
    {
     indexdic= [NSMutableDictionary dictionaryWithObjectsAndKeys:elementName,@"elementName",attributeDict,@"attributeDict", nil];
    }else{
    indexdic= [NSMutableDictionary dictionaryWithObjectsAndKeys:elementName,@"elementName", nil];
    }
    
    
    
    [indexarr addObject:indexdic];

    
    //ima
    
    if([elementName isEqualToString:@"img"])
    {
        NSString* src=[self  imadicisavaliable:attributeDict];
        
        if(src!=nil)
        {
            
         float width=[[attributeDict objectForKey:@"width"] floatValue];
            
          float height=[[attributeDict objectForKey:@"height"] floatValue];
            if(width*height==0){
                //调试 暂时注释
//                UIImage *image=[UIImage imageWithContentsOfFile:src];
//                width=image.size.width;
//                height=image.size.height;
            }
            
            NSString*imavalue=[NSString stringWithFormat:@"%@;%f;%f",src,width,height];
            
            
            NSMutableArray* key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:5]];
            NSMutableArray* value=[NSMutableArray arrayWithObject:imavalue];
            
           NSString* ali=[attributeDict objectForKey:@"align"];
            if(ali !=nil)
            {
                [key addObject:[NSNumber numberWithInt:4]];
                int k=0;
                
                if([ali isEqualToString:@"top"])
                {
                    k=0;
                }
                else
                    if([ali isEqualToString:@"middle"])
                {
                    k=2;
                }
                else
                    if([ali isEqualToString:@"bottom"])
                {
                    k=1;
                }
                [value addObject:[NSNumber numberWithInt:k]];
            }
            if([self currenttagneednewline])
            { 
                [temp.BLhtmlstr appendString:@"\n"];
                [self exterdicrangekeyforlength:1];
            }
            
            [temp.BLhtmlstr appendString:@"一"];
            NSRange imarange;
            imarange.location= rangelocation;
            imarange.length=1;
            
            [self exterdicrangekeyforlength:1];
            
            
            NSMutableDictionary*ima=[NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key",value,@"value",[NSValue valueWithRange:imarange],@"range", nil];
            
            [self insertspedic:ima];
            
        }
        
        return;
    }
    
    NSRange range;
    range.location=rangelocation;
    range.length=0;
    
    NSMutableDictionary*BLattributedic = nil;
    NSMutableArray*key=nil;
    NSMutableArray*value=nil;
    
    

 
    
    
    //处理标签
    if([elementName isEqualToString:@"br"])
    {
        [temp.BLhtmlstr appendString:@"\n"];
        [self exterdicrangekeyforlength:1];
        return;
    }
    
    
    
    
    
    
    
    
    
    NSString* ali=[attributeDict objectForKey:@"text-align"];
    if(ali !=nil)
    {
        int k=0;
        
        if([ali isEqualToString:@"top"])
        {
            k=0;
        }
        else
            if([ali isEqualToString:@"middle"])
            {
                k=2;
            }
            else
                if([ali isEqualToString:@"bottom"])
                {
                    k=1;
                }
        key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:4]];
        value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:k]];
        
    }
    
    NSString* paddingtop=[attributeDict objectForKey:@"margin-top"];
    if(paddingtop!=nil)
    {
        [temp.BLhtmlstr appendString:@"\n "];
        
        range.location=rangelocation+1;
        range.length=1;
        neednewlineafter=YES;
        
        [self exterdicrangekeyforlength:2];
        
        BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:6]],@"key",[NSMutableArray arrayWithObject:[NSNumber numberWithInt:20]],@"value",[NSValue valueWithRange:range],@"range", nil];
        
        [self insertspedic:BLattributedic];
        range.location=rangelocation;
        range.length=0;
        BLattributedic=nil;
    }
    
    
    
    NSString* paddingleft=[attributeDict objectForKey:@"margin-left"];
    if(paddingleft!=nil)
    {
        int left=20;
        if(left<100)
        {
            
            if(key==nil)
            {
                key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:1]];
                value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:left]];
            }
            else
            {
                [key addObject:[NSNumber numberWithInt:1]];
                [value addObject:[NSNumber numberWithInt:left]];
            }
        }
    }
    
    NSString* paddingright=[attributeDict objectForKey:@"margin-right"];
    if(paddingright!=nil)
    {
        int right=20;
        if(right<100)
        {
            if(key==nil)
            {
                key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:2]];
                value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:right]];
            }
            else
            {
                [key addObject:[NSNumber numberWithInt:2]];
                [value addObject:[NSNumber numberWithInt:right]];
            }
        }
    }
    
    
    
    
    
    
    if([elementName isEqualToString:@"li"]||[elementName isEqualToString:@"p"])
    {
//        BOOL need=neednewlineafter; //3号 冗余 dead store
        
        neednewlineafter=YES;
        if(key!=nil)
        {
            BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key",value,@"value",[NSValue valueWithRange:range],@"range", nil];
            [self insertspedic:BLattributedic];
            [indexdic setObject:BLattributedic forKey:@"indexspe"];
        }
        
        if([elementName isEqualToString:@"li"])
        {
        [temp.BLhtmlstr appendString:@"\n●"];
            [self exterdicrangekeyforlength:[@"\n●" length]];
        neednewlineafter=NO;
        }
        
        return;
        
    }
    //单标签

    if([elementName isEqualToString:@"hr"])
    {
        [temp.BLhtmlstr appendString:@"\n "];
        
        range.location=rangelocation+1;
        range.length=1;
        neednewlineafter=YES;
        
        [self exterdicrangekeyforlength:2];
        
        if(key==nil)
        {
            key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:11]];
            value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:1]];
        }
        else
        {
            [key addObject:[NSNumber numberWithInt:11]];
            [value addObject:[NSNumber numberWithInt:1]];
        }
        
        BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key",value,@"value",[NSValue valueWithRange:range],@"range", nil];
        
        [self insertspedic:BLattributedic];
        
        return;
    }

    
    //增长标签
    
    if([elementName isEqualToString:@"sup"]||[elementName isEqualToString:@"sub"]||[elementName isEqualToString:@"del"]||[elementName isEqualToString:@"a"])
    {
        int k=9;
       if([elementName isEqualToString:@"sup"])
       {
           k=9;
       }
        else
            if([elementName isEqualToString:@"sub"])
       {
           k=8;
        }
        else
            if([elementName isEqualToString:@"del"])
        {
             k=7;
        }
        else
        if([elementName isEqualToString:@"a"])
        {
             k=12;
        }
        
        if(key==nil)
        {
            key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:k]];
            value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:0]];
        }
        else
        {
        
            [key addObject:[NSNumber numberWithInt:k]];
            [value addObject:[NSNumber numberWithInt:0]];
        }
        
        
        BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key",[NSValue valueWithRange:range],@"range",value,@"value", nil];
        [self insertspedic:BLattributedic];
        [indexdic setObject:BLattributedic forKey:@"indexspe"];
        return;
    }
    
    if([elementName isEqualToString:@"h1"]||[elementName isEqualToString:@"h2"]||[elementName isEqualToString:@"h3"]||[elementName isEqualToString:@"h4"]||[elementName isEqualToString:@"h5"]||[elementName isEqualToString:@"h6"])
    {
        
        int k=0;
        if([elementName isEqualToString:@"h1"])
        {
            k=18;
        }
        else
            if([elementName isEqualToString:@"h2"])
            {
                k=15;
            }
            else
                if([elementName isEqualToString:@"h3"])
                {
                    k=12;
                }
                else
                    if([elementName isEqualToString:@"h4"])
                    {
                        k=9;
                    }
                    else
                        if([elementName isEqualToString:@"h5"])
                        {
                            k=6;
                        }
                        else
                            if([elementName isEqualToString:@"h6"])
                            {
                                k=3;
                            }
        
        if(key==nil)
        {
            key=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:4]];
            value=[NSMutableArray arrayWithObject:[NSNumber numberWithInt:k]];
        }
        else
        {
            
            [key addObject:[NSNumber numberWithInt:4]];
            [value addObject:[NSNumber numberWithInt:k]];
        }
        
        BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key",[NSValue valueWithRange:range],@"range",value,@"value", nil];
        
        [self insertspedic:BLattributedic];
        [indexdic setObject:BLattributedic forKey:@"indexspe"];
        return;
    }
    
    
    
    

    
   /*
    switch ([elementName hash]) {
        case 525155994:   //pre
            
            
            break;
        case 1107:        //p
            
            
            break;
        case 518002038:   //div
            
            
            
            break;
        case 794375:      //h1
            
            
            break;
        case 794380:      //h2
            
            
            
            
            break;
        case 794385:      //h3
            
            
            
            
            break;
        case 794390:       //h4
            
            
            
            break;
        case 794395:       //h5
            
            
            
            break;
        case 794400:       //h6
            
            
            
            break;
        case 1062:         //a
            
            break;
        case 1065:         //b
            
            break;
        case 516813021:    //big
            
            break;
        case 517992696:    //del
            
            break;
        case 799795:       //li
            
            break;
        case 803665:        //ol
            
            break;
        case 811375:       //ul
            
            break;
        case 526946229:    //sub
            
            break;
        case 526946355:    //sup
            
            break;
        default:
            break;
    }
  */

}


-(void)findstirng:(NSString*)string
{
    //head info
    if(head && title)
    {
        self.temp.BLhtmltitle=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    }
    
    if(head)
    {
        return;
    }
    //body info
    
    BOOL added=NO;
    if(rangelocation!=0 && [self currenttagneednewline])
    {
        added=YES;
        [temp.BLhtmlstr appendString:@"\n"];
        [self exterdicrangekeyforlength:1];
    }
    
    NSString* tag=[[indexarr lastObject]objectForKey:@"elementName"];
    
    
    if([tag hash]==525155994)    //pre
    {
        [temp.BLhtmlstr appendString:string];
        [self exterdicrangekeyforlength:[string length]];
        return;
    }
    
    string=[string stringByNormalizingWhitespace];//合并空格去除换行
    string=[string stringByReplacingHTMLEntities];//替换html字符标签
    
    
    
    
    
    if([tag hash]==1107)        //p
    {
        string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        [temp.BLhtmlstr appendFormat:@"　　%@",string];
        [self exterdicrangekeyforlength:[string length]+2];
        return;
    }
    else
    {
        
        if([tag  isEqualToString:@"li"])
        {
            string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            
            [temp.BLhtmlstr appendString:string];
            [self exterdicrangekeyforlength:[string length]];
            return;
        }
        if(added &&[string  isemputyhtmlstring])
        {
            NSRange x;
            x.location=[temp.BLhtmlstr length]-1;
            x.length=1;
            [temp.BLhtmlstr deleteCharactersInRange:x];
            [self exterdicrangekeyforlength:-1];
            neednewlineafter=YES;
        }
        else
        {
            [temp.BLhtmlstr appendString:string];
            [self exterdicrangekeyforlength:[string length]];
            
        }
        
    }


}





- (void)BLparser:(BLparser *)parser didEndElement:(NSString *)elementName
{
    
    
    [self findstirng:mutistring];
    
    
    
    [mutistring release];
    mutistring=[[NSMutableString string] retain];
    
    
    
    NSMutableDictionary*attributeDict=[[indexarr lastObject]objectForKey:@"attributeDict"];
    
    elementName=[elementName lowercaseString];
    if(title && [elementName isEqualToString:@"title"])
    {
        title=NO;
        return;
    }
    if(head && [elementName isEqualToString:@"head"])
    {
        head=NO;
        return;
    }
if(head || title)
{
    return;
}
    if([elementName isEqualToString:@"p"]||[elementName isEqualToString:@"li"]||[elementName isEqualToString:@"div"])
    {
        neednewlineafter=YES;
    }
    
    int j=0;
    for(int k = (int)[indexarr count]-1;k>0;k--)
    {
       if([[[self.indexarr objectAtIndex:k] objectForKey:@"elementName"]  isEqualToString:elementName])
       {
           j=k;
           break;
       }
    }
    if(j!=0)
    {
        NSRange remove;
        remove.location=j;
        remove.length=[indexarr count]-j;
        
        [self.indexarr removeObjectsInRange:remove];
    }
    
    NSString* paddingbot=[attributeDict objectForKey:@"margin-bottom"];
    if(paddingbot!=nil)
    {
        [temp.BLhtmlstr appendString:@"\n "];
        NSRange range;
        range.location=rangelocation+1;
        range.length=1;
        neednewlineafter=YES;
        
        [self exterdicrangekeyforlength:2];
        NSMutableDictionary*
        BLattributedic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:6]],@"key",[NSMutableArray arrayWithObject:[NSNumber numberWithInt:20]],@"value",[NSValue valueWithRange:range],@"range", nil];
        
        [self insertspedic:BLattributedic];
        
    }

}


- (void)BLparser:(BLparser *)parser foundCharacters:(NSString *)string
{
    
    [mutistring appendString:string ];
    
    
    
}


-(void)exterdicrangekeyforlength:(NSInteger)length
{
    rangelocation+=length;
    for(NSMutableDictionary* dic in indexarr)
    {
        NSValue* value=[[dic objectForKey:@"indexspe"]objectForKey:@"range"];
        if(value !=nil)
        {
            
            NSRange ran=[value rangeValue];
            ran.length=ran.length+length;
            [[dic objectForKey:@"indexspe"] setObject:[NSValue valueWithRange:ran] forKey:@"range"];
        }
    }
}



-(BOOL)currenttagneednewline
{
    if(neednewlineafter)
    {
        neednewlineafter=NO;
        return YES;
    }
    else
    {
        return NO;
    }
}

                        

                        
-(void)insertspedic:(NSMutableDictionary*)dic
{
    
    int key = 0;
    for(int i= (int)[indexarr count]-1;i>=0;i--)
    {
      if([[[indexarr objectAtIndex:i] objectForKey:@"indexspe"] objectForKey:@"range"]!=nil)
      {
          key=i;
          break;
      }
    }
    NSMutableDictionary* pardic=[[indexarr objectAtIndex:key] objectForKey:@"indexspe"];
    NSMutableArray*cell=[pardic objectForKey:@"spe"];

    if(cell==nil)
    {
        cell=[NSMutableArray array];
        [pardic setObject:cell forKey:@"spe"];
    }
    
   
    [cell addObject:dic];
    
}

-(NSString*)imadicisavaliable:(NSDictionary*)dic
{
    if(![dic objectForKey:@"src"])
    {
        return nil;
    }
    else
    {
        NSString* kk=[rootpath stringByDeletingLastPathComponent];
        NSURL* baseurl=[[[NSURL alloc]initFileURLWithPath:kk isDirectory:YES]autorelease];
        NSFileManager* filemanager=[NSFileManager defaultManager];
        NSString*str=[dic objectForKey:@"src"];
        NSURL* url=[NSURL URLWithString:str relativeToURL:baseurl];
        NSURL* ur=[url absoluteURL];
        NSString* path=[ur  path];
        if([filemanager fileExistsAtPath:path])
        {
            return path;
        }
        else
        {
            return nil;
        }
    }

    

}




@end
