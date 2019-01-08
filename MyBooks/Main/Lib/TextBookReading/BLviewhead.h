




@protocol BLviewdatasource <NSObject>
@required

-(UIView*)BLviewdatasourceViewForNextPage:(id)BLview;     //请求后页
-(UIView*)BLviewdatasourceViewForPrePage:(id)BLview;      //请求前页


@optional

-(UIView*)BLviewdatasourceViewNullAtleft:(id)BLview;//返回用于双倍页的空内容页
-(UIView*)BLviewdatasourceViewNullAtright:(id)BLview;//返回用于双倍页的空内容页

-(UIView*)BLviewdatasourceViewForCurrentPage:(id)BLview;

-(UIView*)BLviewdatasourceViewForCurrentPageAtleft:(id)BLview;
-(UIView*)BLviewdatasourceViewForCurrentPageAtright:(id)BLview;

-(UIView*)BLviewdatasourceViewForNextPageAtleft:(id)BLview;     //请求在左页的后一页

-(UIView*)BLviewdatasourceViewForNextPageAtright:(id)BLview;     //请求在右页的后一页

-(UIView*)BLviewdatasourceViewForPrePageAtleft:(id)BLview;     //请求在左页的前一页

-(UIView*)BLviewdatasourceViewForPrePageAtright:(id)BLview;    //请求在右页的前一页


-(void)BLviewdatasourceViewReachEnd:(id)BLview; //到达末页,产生事件 To reach the last page, that generated the event

-(void)BLviewdatasourceViewReachBegain:(id)BLview;//到达起始，产生事件 Arrive at the start, that generated the event

-(void)BLviewdatasourceCurrentPageChangedBy:(int)indexChangeCount;  //当前页改变


@end
@protocol BLMidclickdelegate <NSObject>

-(void)BLMidclicked;

@end


