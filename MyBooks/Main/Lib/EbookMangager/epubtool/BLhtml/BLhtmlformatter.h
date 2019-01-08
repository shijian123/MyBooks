/*
vlaue               key
1                   左边距
2                   右边距
3                   对齐方式
4                   字体大小变化值  h1－h6 


5                   imag    路径；宽高
6                   行高 空行

7                   del
8                   sub
9                   sup
10                  ini
11                  hr
12                  a
*/

#import <Foundation/Foundation.h>
#import "BLhtmlinfo.h"
#import <CoreText/CoreText.h>
@interface BLhtmlformatter : NSObject
{
    CGFloat fontsize;
    CGRect  pagesize;
    UIFont *font;
    CTFramesetterRef framesetter;
    NSMutableAttributedString* str;
    NSMutableDictionary*spelinfodic;
    BOOL isstring;
}

@property(readwrite)CGRect  pagesize;
@property(readwrite)CGFloat fontsize;
@property(retain,nonatomic) UIFont *font;
@property(retain,nonatomic) NSMutableAttributedString* str;
@property(retain,nonatomic)NSMutableDictionary*spelinfodic;

-(CTFramesetterRef)framesetter;
-(void)setFramesetter:(CTFramesetterRef)frame;


-(void)gethtmlstr:(BLhtmlinfo*)info;

-(void)setstrwithstr:(NSString*)str;

-(NSMutableDictionary*)analysisstr:(NSMutableAttributedString*)str;


-(NSMutableDictionary*)formathtml:(BLhtmlinfo*)info;


-(void)setstrwithstr:(NSString*)str prestr:(NSString*)pre;

-(void)setstrwithhtml:(BLhtmlinfo*)info prestr:(NSString*)pre;

-(void)makecontenstr;

@end
