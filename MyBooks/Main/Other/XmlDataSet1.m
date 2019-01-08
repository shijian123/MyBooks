//
//  RadioList.m
//  MyAACPlayer
//
//  Created by xiaogong on 09-9-11.
//  Copyright 2009 XunjieMobile . All rights reserved.
//

#import "XmlDataSet1.h"
@implementation XmlDataSet
@synthesize Rows;
@synthesize ParseError;
@synthesize XmlType;
@synthesize MutableRows;

- init
{	
	if(self=[super init]){
        self.MutableRows=[NSMutableArray array];
        self.Rows=[NSMutableArray array];
        return self;
    }
	return nil;
}

- (BOOL)LoadXml:(NSString *)url Xpath: (NSMutableArray*)xpath
{	
	self.ParseError=nil;
	self.XmlType=xpath;
	//NSLog(@"url=%@",Url);
	
	NSXMLParser *parser;
	NSMutableData *XMLNSMutableData;

	@try 
	{
		XMLNSMutableData=[[NSMutableData alloc] initWithContentsOfURL: [NSURL URLWithString:[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8) autorelease]]];
		
		parser =[[NSXMLParser alloc] initWithData: XMLNSMutableData];
	}
	@catch (NSException *e) 
	{
	self.ParseError=[NSString stringWithFormat:@"无法获取服务!name:%@ exception:%@",[e name],[e reason]];
	}
	@finally
	{
		
	}
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
	[XMLNSMutableData release];
	if([self.Rows count ]<=0)
	{
	
		return NO;	
	}
	else
	{
		
		return YES;
	}
}

- (BOOL)LoadNSMutableData:(NSMutableData *)XMLNSMutableData Xpath: (NSMutableArray*)xpath
{
	self.ParseError=nil;
	self.XmlType=xpath;
	NSXMLParser *parser;
	@try 
	{
		parser =[[NSXMLParser alloc] initWithData: XMLNSMutableData];
	
	}
	@catch (NSException * e) {
		self.ParseError=[NSString stringWithFormat:@"异常!name:%@ exception:%@",[e name],[e reason]];
	}
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
	if([self.Rows count ]<=0&&[self.MutableRows count]<=0)
	{
	return NO;	
	}
	else
	{
		return YES;
	}
	
}


///解析xml，节点开始阶段,如<book>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	for (int i=0 ; i<[self.XmlType count]; i++) {
		NSString *path=[NSString stringWithFormat:@"%@",[self.XmlType objectAtIndex:i]];
		if([elementName isEqualToString:path ])
		{
			[self.Rows addObject: attributeDict];
		}
	}


}
///文本值
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}
//结束节点如：</book>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{   
}
//xml错误处理,返回一个xml错误描述信息
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    self.ParseError=[NSString stringWithFormat:@"错误 %li,描述: %@, 行: %i, 列: %i", (long)[parseError code],[[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]];
}
 
-(void)dealloc
{
 	[MutableRows release];
	[Rows release];
	[XmlType release];
	[ParseError release];
	[super dealloc];
}
@end
