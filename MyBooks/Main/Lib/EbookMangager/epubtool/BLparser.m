//
//  BLparser.m
//  BLsimpleparser
//
//  Created by BLapple on 13-4-23.
//  Copyright (c) 2013年 BLapple. All rights reserved.
//

#import "BLparser.h"
#import "BLparerbase.h"
#import "BLnsxmlparser.h"
//#import "BLhtmlparser.h"
@interface BLparser ()
{
    BLparerbase* parser;
}
-(BLparerbase*)parser;

-(void)setParser:(BLparerbase*)parser;

@end

@implementation BLparser
@synthesize delegate;

-(void)dealloc
{

    [delegate release];
    [parser release];
    [super dealloc];
}


- (id)initWithData:(NSData *)data parsertype:(BLParsertype)parsertype
{
if(self=[super init])
{
    switch (parsertype) {
        case BLdefaultparser:
            self.parser=[[[BLnsxmlparser alloc]initWithData:data ] autorelease];
            break;
        case BLNSXMLParser:
            self.parser=[[[BLnsxmlparser alloc]initWithData:data  ] autorelease];
            break;
//        case BLhtmlParser:
//            self.parser=[[[BLhtmlparser alloc]initWithData:data] autorelease];
//            break;
        default:
            self.parser=[[[BLnsxmlparser alloc]initWithData:data  ] autorelease];
            break;
    }
parser.Handler=self;
}
return self;
}

-(id)initWithData:(NSData*)data encoding:(NSStringEncoding)encoding parsertype:(BLParsertype)parsertype
{
    if(self=[super init])
    {
        switch (parsertype) {
            case BLdefaultparser:
                self.parser=[[[BLnsxmlparser alloc]initWithData:data encoding:encoding] autorelease];
                break;
            case BLNSXMLParser:
                self.parser=[[[BLnsxmlparser alloc]initWithData:data encoding:encoding] autorelease];
                break;
//            case BLhtmlParser:
//                self.parser=[[BLhtmlparser alloc]initwithdata:data encoding:encoding];
//                break;
            default:
                self.parser=[[[BLnsxmlparser alloc]initWithData:data  ] autorelease];
                break;
        }
        parser.Handler=self;
    }
    return self;
}

-(void)setDelegate:(id<BLparserdelegate>)_delegate
{
  if(delegate!=_delegate)
  {
      [delegate release];
      delegate=_delegate;
      [_delegate retain];
  }
    [parser setDelegate:delegate];

}

-(BLparerbase*)parser
{
    return parser;
}

-(void)setParser:(BLparerbase*)_parser
{
if(parser!=_parser)
{
    [parser release];
    parser=_parser;
    [_parser retain];
}
}


#pragma mark-func

-(BOOL)parse
{
return      [self.parser parse];

}
-(BOOL)isparsing
{
    
return      [self.parser isparsing];
}


-(void)stopparse
{
    
            [self.parser stopparse];
}









@end
