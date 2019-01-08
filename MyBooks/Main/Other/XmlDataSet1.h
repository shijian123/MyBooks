
#import <UIKit/UIKit.h>
@interface XmlDataSet : NSObject {
	NSMutableArray *Rows;//xml行数句。
	NSString *ParseError;//xml解析错误描述信息
	NSMutableArray *XmlType;//模拟xpath.
	NSMutableArray *MutableRows;//用于混排列表第二个参数
}
@property(nonatomic,retain) NSMutableArray *Rows;
@property(nonatomic,retain) NSString *ParseError;
@property(nonatomic,retain) NSMutableArray *XmlType;
@property(nonatomic,retain) NSMutableArray *MutableRows;
- (BOOL)LoadXml:(NSString *)Url Xpath: (NSMutableArray*)xpath;//加载xml。这个url为服务器地址。Xpath:核心行节点：如：电台列表的:radioitem.歌曲列表：musicitem,歌曲详细信息:music 
- (BOOL)LoadNSMutableData:(NSMutableData *)XMLNSMutableData Xpath: (NSMutableArray*)xpath;

@end