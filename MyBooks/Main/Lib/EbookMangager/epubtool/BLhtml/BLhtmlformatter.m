//
//  BLhtmlformatter.m
//  BLsimpleparser
//
//  Created by BLapple on 13-5-3.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLhtmlformatter.h"

void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    
   
    
    NSString*ima=(NSString *)refCon;
    
    NSArray*arr=[ima componentsSeparatedByString:@";"];

//    NSString *imageName = [arr objectAtIndex:0];

     float height=[[arr objectAtIndex:2] floatValue];
    
   
    return height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    

    NSString*ima=(NSString *)refCon;
    
    NSArray*arr=[ima componentsSeparatedByString:@";"];
    
//    NSString *imageName = [arr objectAtIndex:0];
//    
//    UIImage* imag=[UIImage imageWithContentsOfFile:imageName];
    

    
    float width=[[arr objectAtIndex:1] floatValue];
    
 
    return  width;
}
@interface BLhtmlformatter()
-(void)applestylearr:(NSMutableArray*)arr;
-(void)applystyle:(NSMutableDictionary*)dic;
-(void)applystyleforkey:(NSNumber*)key value:(NSNumber*)value range:(NSRange)range;

-(void)appledefaultstyle;
@end


@implementation BLhtmlformatter
{
    NSInteger prelenth;
    
}
@synthesize pagesize,str,font,fontsize,spelinfodic;
-(void)dealloc
{
    if(framesetter!=NULL)
    {
        CFRelease(framesetter);
        framesetter=NULL;
    }
    [spelinfodic release];
    [str release];
    [font release];
    [super dealloc];
}

-(id)init
{
if(self=[super init])
{
    self.fontsize=20;
    self.font=[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20] ;
    prelenth=0;
    self.pagesize=[UIScreen mainScreen].bounds;
    framesetter=NULL;
}
    return self;
}
#pragma mark- 应用默认样式
-(void)appledefaultstyle
{
    //默认设置
    

    
    //字体，大小
    CTFontRef fontcustom=CTFontCreateWithName((CFStringRef)font.fontName,fontsize, NULL);
    [self.str addAttribute:(NSString*)kCTFontAttributeName value:(id)fontcustom range:NSMakeRange(0, [self.str length])];
    CFRelease(fontcustom);
    
    
    //字间距
    long number = 2;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    
    [self.str addAttribute:(NSString*)kCTKernAttributeName
                     value:(id)num
                     range:NSMakeRange(0, self.str.length)];
    
    CFRelease(num);
    
    
    
    //段间距
    CGFloat paragraphspacing = 10;
    
    
    //行间距
    CGFloat spacing =10;
    
    //换行模式
    
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
//    if(isstring)
//    {
//        lineBreak=kCTLineBreakByWordWrapping;
//    }
    //排版模式,尾标点
    CTLineBoundsOptions BoundsOptions=kCTLineBoundsUseHangingPunctuation;
    
     CTTextAlignment alignment = kCTTextAlignmentJustified;
    
    //首行缩进
    CGFloat topSpacing = fontsize*2+number*3;
    
    
    CTParagraphStyleSetting paraStyles[]=
    {{.spec = kCTParagraphStyleSpecifierParagraphSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&paragraphspacing},
        {.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment,.valueSize = sizeof(CGFloat), .value = (const void*)&spacing},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreak},
        {.spec = kCTParagraphStyleSpecifierLineBoundsOptions,.valueSize = sizeof(CTLineBoundsOptions), .value = (const void*)&BoundsOptions},
        {
            .spec = kCTParagraphStyleSpecifierAlignment,
            .value = &alignment,
            .valueSize = sizeof(CTTextAlignment),
        },
        {
            .spec = kCTParagraphStyleSpecifierFirstLineHeadIndent,
            .value = &topSpacing,
            .valueSize = sizeof(CGFloat),
        }
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paraStyles, 6);
    
    
    [self.str addAttribute:(NSString *)kCTParagraphStyleAttributeName
                     value:(id)paragraphStyle
                     range:NSMakeRange(0, self.str.length)];
    
    CFRelease(paragraphStyle);

}

-(CTFramesetterRef)framesetter
{
    return framesetter;
}
-(void)setFramesetter:(CTFramesetterRef)_frame
{
    if(_frame!=framesetter)
    {
        if(_frame!=NULL)
        {
            CFRetain(_frame);
        }
        if(framesetter!=NULL)
        {
            CFRelease(framesetter);
        }
        framesetter=_frame;
    }
}

#pragma mark-设置要分析的内容


-(void)setstrwithstr:(NSString*)_str prestr:(NSString*)pre
{
    isstring=YES;
    if(pre!=nil&& _str!=nil)
    {
    _str=[pre stringByAppendingString:_str];
    prelenth=[pre length];
    }
    else
    {
        prelenth=0;
    }
    
    
    
    if(_str==nil || [_str length]==0)
    {
        self.str=[[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        
        self.spelinfodic=[NSMutableDictionary dictionary];
        return ;
    }
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
	NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    _str=[reg stringByReplacingMatchesInString:_str  options:NSMatchingReportProgress  range:NSMakeRange(0, [_str length])  withTemplate:@"\n"];
	_str=[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if(_str==nil||_str.length==0)
    {
        _str=@" ";
    }
    
    self.str=[[[NSMutableAttributedString alloc]initWithString:_str] autorelease];
    [self.str beginEditing];
    [self appledefaultstyle];
    [self.str endEditing];

    
}

-(void)setstrwithhtml:(BLhtmlinfo*)info prestr:(NSString*)pre
{
    isstring=NO;
    if(pre!=nil&& info.BLhtmlstr!=nil)
    {
        NSMutableString* st= [[[NSMutableString alloc]initWithString:pre] autorelease];
        [st appendString:info.BLhtmlstr];
        info.BLhtmlstr=st;
        prelenth=[pre length];
    }
    else
    {
        prelenth=0;
    }
    if(info.BLhtmlstr==nil)
    {
        self.str=[[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        return ;
    }
    
    self.str=[[[NSMutableAttributedString alloc]initWithString:info.BLhtmlstr] autorelease];
    [self.str beginEditing];
    
    [self appledefaultstyle];
    
    
    
    [self applestylearr:[info.BLhtmlattributedic objectForKey:@"spe"]];
    
    
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    
    NSArray* rangearr= [reg matchesInString:self.str.string options:NSMatchingReportProgress range:NSMakeRange(0, [self.str.string length])];
    
    for(int i=[rangearr count]-1;i>=0;i--)
    {
        NSTextCheckingResult* result=[rangearr objectAtIndex:i];
        
        [self.str replaceCharactersInRange:[result range] withString:@"\n"];
        
    }
    [self.str endEditing];
}

-(void)setstrwithstr:(NSString*)_str
{
    if(_str==nil || [_str length]==0)
    {
        self.str=[[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        return ;
    }
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
	NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    _str=[reg stringByReplacingMatchesInString:_str  options:NSMatchingReportProgress  range:NSMakeRange(0, [_str length])  withTemplate:@"\n"];
	_str=[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if(_str==nil||_str.length==0)
    {
        _str=@" ";
    }
    
self.str=[[[NSMutableAttributedString alloc]initWithString:_str] autorelease];
    [self.str beginEditing];
    [self appledefaultstyle];
    [self.str endEditing];

    
}



-(void)gethtmlstr:(BLhtmlinfo*)info
{
    if(info.BLhtmlstr==nil)
    {
        self.str=[[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        return ;
    }
    
    self.str=[[[NSMutableAttributedString alloc]initWithString:info.BLhtmlstr] autorelease];
    [self.str beginEditing];
    
    [self appledefaultstyle];
    [self applestylearr:[info.BLhtmlattributedic objectForKey:@"spe"]];
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    
    NSArray* rangearr= [reg matchesInString:self.str.string options:NSMatchingReportProgress range:NSMakeRange(0, [self.str.string length])];
    
    for(int i=[rangearr count]-1;i>=0;i--)
    {
        NSTextCheckingResult* result=[rangearr objectAtIndex:i];
        
        [self.str replaceCharactersInRange:[result range] withString:@"\n"];
        
    }
    [self.str endEditing];


}


-(NSMutableDictionary*)formathtml:(BLhtmlinfo*)info
{
    if(info.BLhtmlstr==nil)
    {
        return nil;
    }

    self.str=[[[NSMutableAttributedString alloc]initWithString:info.BLhtmlstr] autorelease];
    [self.str beginEditing];

    [self appledefaultstyle];
    
    [self applestylearr:[info.BLhtmlattributedic objectForKey:@"spe"]];
    
    NSString *pattern=@"(\r|\n)+( | |　| |　| |　|　)*";
    NSRegularExpression *reg=[NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive  error:nil];
    
    NSArray* rangearr= [reg matchesInString:self.str.string options:NSMatchingReportProgress range:NSMakeRange(0, [self.str.string length])];
    
    for(int i=[rangearr count]-1;i>=0;i--)
    {
        NSTextCheckingResult* result=[rangearr objectAtIndex:i];
        
        [self.str replaceCharactersInRange:[result range] withString:@"\n"];
        
    }
    [self.str endEditing];
    
    
   NSMutableDictionary* ar= [self analysisstr:self.str];
    
    
    return ar;
    
}





-(void)applestylearr:(NSMutableArray*)arr
{
    if(arr==nil)
    {return;}
    
    NSMutableArray*mutiar=nil;
    
for(NSMutableDictionary* dic in arr)
{
    [self applystyle:dic];
    mutiar=[dic objectForKey:@"spe"];
    
    if(mutiar!=nil)
    {
        [self applestylearr:mutiar];
    }
}
}






-(void)applystyle:(NSMutableDictionary*)dic
{
    NSMutableArray* key=[dic objectForKey:@"key"];
    NSMutableArray* value=[dic objectForKey:@"value"];
    
    NSRange range=[[dic objectForKey:@"range"] rangeValue];
    for(int i=0;i<[key count];i++)
    {
        [self applystyleforkey:[key objectAtIndex:i] value:[value objectAtIndex:i] range:range];
    
    }
}


-(void)applystyleforkey:(NSNumber*)key value:(NSNumber*)value range:(NSRange)range
{
    //段首行margin
    CGFloat float1 = 0;
    
    //左间距
    CGFloat float2 = 0;
    
    //行宽
    CGFloat float3 = 0;
    
    range.location+=prelenth;
    
    CTParagraphStyleRef paragraphStyle=nil;
    
    CTTextAlignment alignment=kCTTextAlignmentJustified;
    
    CTFontRef fontcustom=nil;
    CTRunDelegateCallbacks imageCallbacks;
    CTFontRef fontt;
    UIFont* italifon;
    switch ([key intValue]) {
        case 1:
            float1=[value intValue];
            float2=[value intValue];
            CTParagraphStyleSetting paraStyles1[]
            ={
                {.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent,.valueSize = sizeof(CGFloat), .value = (const void*)&float1},
                {.spec = kCTParagraphStyleSpecifierHeadIndent,.valueSize = sizeof(CGFloat), .value = (const void*)&float2},
            };
            paragraphStyle= CTParagraphStyleCreate(paraStyles1, 2);
            
            
            break;
        case 2:
            float3=pagesize.size.width-[value intValue];
            CTParagraphStyleSetting paraStyles2[]
            ={
                 {.spec = kCTParagraphStyleSpecifierTailIndent,.valueSize = sizeof(CGFloat), .value = (const void*)&float3},
            };
            paragraphStyle= CTParagraphStyleCreate(paraStyles2, 1);
            
            
            
            break;
        case 3:
            alignment=(CTTextAlignment)[value intValue];
            CTParagraphStyleSetting paraStyles3[]
            ={
            {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
            };
            paragraphStyle= CTParagraphStyleCreate(paraStyles3, 1);
            

            break;
        case 4:
            fontcustom=CTFontCreateWithName((CFStringRef)[UIFont fontWithName:@"FZLTHJW--GB1-0" size:20].fontName,fontsize+[value intValue], NULL);
            [self.str addAttribute:(NSString*)kCTFontAttributeName value:(id)fontcustom range:range];
            CFRelease(fontcustom);
            
            return;

            break;
        case 5:
           
            imageCallbacks.version = kCTRunDelegateVersion1;
            imageCallbacks.dealloc = RunDelegateDeallocCallback;
            imageCallbacks.getAscent = RunDelegateGetAscentCallback;
            imageCallbacks.getDescent = RunDelegateGetDescentCallback;
            imageCallbacks.getWidth = RunDelegateGetWidthCallback;
            
            NSString*ima=(NSString *)value;
            
            NSArray*arr=[ima componentsSeparatedByString:@";"];
            
            float width=[[arr objectAtIndex:1]floatValue];
            float height=[[arr objectAtIndex:2]floatValue];
            
            if(width>pagesize.size.width-20 )
            {
                height=((pagesize.size.width-20)/width)*height;
                width=pagesize.size.width-20;
                
            }
            
            if(height>pagesize.size.height-20 )
            {
                width=((pagesize.size.height-20)/height)*width;
                height=pagesize.size.height-20;
                
            }
            value=[NSString stringWithFormat:@"%@;%f;%f",[arr objectAtIndex:0],width,height];
            
            
            
            CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, value);
            
            [self.str addAttribute:(NSString *)kCTRunDelegateAttributeName value:(id)runDelegate range:range];
            CFRelease(runDelegate);
            [self.str addAttribute:@"blima" value:(id)value range:range];
            return;
            
            break;
        case 6:
            float1=[value intValue];
            float2=[value intValue];
            CTParagraphStyleSetting paraStyles6[]
            ={
                {.spec = kCTParagraphStyleSpecifierMaximumLineHeight,.valueSize = sizeof(CGFloat), .value = (const void*)&float1},
                {.spec = kCTParagraphStyleSpecifierMinimumLineHeight,.valueSize = sizeof(CGFloat), .value = (const void*)&float2},
            };
            paragraphStyle= CTParagraphStyleCreate(paraStyles6, 2);
            
            
            break;
        case 7:
            [self.str addAttribute:@"BLdel"
                             value:(id)value
                             range:range];
            return;
            break;
        case 8:
            [self.str addAttribute:(NSString*)kCTSuperscriptAttributeName value:(id)[NSNumber numberWithInt:1]range:range];
            
//            [self.str addAttribute:@"sub"
//                             value:(id)value
//                             range:range];
            return;
            break;
        case 9:
            [self.str addAttribute:(NSString*)kCTSuperscriptAttributeName value:(id)[NSNumber numberWithInt:-1]range:range];
//            [self.str addAttribute:@"sup"
//                             value:(id)value
//                             range:range];
            return;
            break;
        case 10:
            
     italifon= [UIFont italicfontWithName:@"FZLTHJW--GB1-0" size:fontsize];
            fontt = CTFontCreateWithName((CFStringRef)italifon.fontName, fontsize, NULL);
            [self.str addAttribute:(id)kCTFontAttributeName value:(id)fontt range:range];
            
            CFRelease(fontt);
            
//            [self.str addAttribute:@"ini"
//                             value:(id)value
//                             range:range];
            return;
            break;
        case 11:
            [self.str addAttribute:@"hr"
                             value:(id)value
                             range:range];
            return;
            break;
        case 12:
//            [self.str addAttribute:(NSString *)kCTUnderlineStyleAttributeName
//                          value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
//                          range:range];
//            [self.str addAttribute:(NSString*)kCTUnderlineColorAttributeName value:(id)[[UIColor orangeColor] CGColor]range:range];
            
            
            return;
            break;
        default:
            return;
            break;
    }
    [self.str addAttribute:(NSString *)kCTParagraphStyleAttributeName
                  value:(id)paragraphStyle
                  range:range];
    
     CFRelease(paragraphStyle);
    
    
}







#pragma mark-解析

-(void)makecontenstr
{
    CTFramesetterRef temFrameRef=
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.str);
    self.framesetter =
    temFrameRef;
    CFRelease(temFrameRef);
}

-(NSMutableDictionary*)analysisstr:(NSMutableAttributedString*)attr
{

    NSMutableArray* PageFirstCharinChapter=[[[NSMutableArray alloc]init]autorelease];
    int attrlength=[attr length];
    int lengthcount=0;
    CTFramesetterRef temFrameRef=
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    self.framesetter=temFrameRef;
//    self.framesetter =
//    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    CFRelease(temFrameRef);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pagesize);
    
    NSMutableArray* spe=[NSMutableArray array];
    NSMutableArray* onespe;
    
    while (lengthcount<attrlength) {
        @autoreleasepool {
            
        onespe=[NSMutableArray array];
        
        CTFrameRef leftFrame=CTFramesetterCreateFrame(framesetter, CFRangeMake(lengthcount, 0), path, NULL);
      
        CFRange frameRange = CTFrameGetVisibleStringRange(leftFrame);
        NSString* number=[NSString stringWithFormat:@"%d,%d",(int)lengthcount,(int)frameRange.length];
        [PageFirstCharinChapter addObject:number];

        lengthcount+=frameRange.length;
            
            //计算特殊图形
            CFArrayRef lines = CTFrameGetLines(leftFrame);
            CGPoint lineOrigins[CFArrayGetCount(lines)];
            CTFrameGetLineOrigins(leftFrame, CFRangeMake(0, 0), lineOrigins);
            
            for (int i = 0; i < CFArrayGetCount(lines); i++) {
                CTLineRef line = CFArrayGetValueAtIndex(lines, i);
                CGFloat lineAscent;
                CGFloat lineDescent;
                CGFloat lineLeading;
                CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
                
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                for (int j = 0; j < CFArrayGetCount(runs); j++) {
                    CGFloat runAscent;
                    CGFloat runDescent;
                    CGPoint lineOrigin = lineOrigins[i];
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
//                    CGRect runRect;   //10号 blhtmlformatter.m nerver read
//                    runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//                    
//                    runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
                    
                    //            double offset=   CTLineGetPenOffsetForFlush(line, 0.25, 320);
                    //10号 blhtmlformatter.m nerver read
                    NSString*ima=[attributes objectForKey:@"blima"];
                    if(!ima)
                    {
                        continue;
                    }
                    NSArray*arr=[ima componentsSeparatedByString:@";"];
                    
                    
                    NSString *imageName = [arr objectAtIndex:0];
                    
                    float width=[[arr objectAtIndex:1] floatValue];
                    float height=[[arr objectAtIndex:2] floatValue];
                    
                    //图片渲染逻辑
                    if (imageName) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
                        if(!image)
                        {
                            NSString* catchstring=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSArray* conpo=  [imageName componentsSeparatedByString:@"/"];
                            int cathlocation=0;
                            for(int i=0;i<[conpo count];i++)
                            {
                                NSString* pathi=[conpo objectAtIndex:i];
                                if([[pathi lowercaseString]isEqualToString:@"caches"])
                                {
                                    cathlocation=i;
                                }
                            }
                            
                            for(int i=cathlocation+1;i<[conpo count];i++)
                            {
                                catchstring=[catchstring stringByAppendingPathComponent:[conpo objectAtIndex:i]];
                                
                            }
                            
                            imageName=catchstring;
                            image = [UIImage imageWithContentsOfFile:imageName];
                            
                        }

                        if (image) {
//                            CGRect imageDrawRect;
//                            imageDrawRect.size = CGSizeMake(width, height);
//                            imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
//                            imageDrawRect.origin.y = lineOrigin.y;
//                            imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x+pagesize.origin.x;
//                            imageDrawRect.origin.y = lineOrigin.y+pagesize.origin.y;
                            
                            //                    imageDrawRect.origin.x=offset;
//                            CGContextDrawImage(context, imageDrawRect, image.CGImage);
                            NSString* spestr=nil;
                            if(width>100)
                            {
                                spestr=[NSString stringWithFormat:@"blima|%@|%f;%f;%f;%f",imageName, pagesize.origin.x,lineOrigin.y+pagesize.origin.y,width,height];
                            }
                            else
                            {
                                spestr=[NSString stringWithFormat:@"blima|%@|%f;%f;%f;%f",imageName, lineOrigin.x/2+pagesize.origin.x,lineOrigin.y+pagesize.origin.y,width,height];
                                
                            }
                            [onespe addObject:spestr];
                            
                        }
                    }
                }
            }

        
        
            [spe addObject:onespe];
        
        
        CFRelease(leftFrame);
            }
    }
//    CFRelease(framesetter);
    CGPathRelease(path);
    
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:PageFirstCharinChapter,@"PageFirstCharinChapter",spe,@"spe", nil];
    
    
    self.spelinfodic=dic;
    
    return dic;



}

@end
