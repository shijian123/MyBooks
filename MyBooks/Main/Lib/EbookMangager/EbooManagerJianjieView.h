
#import <UIKit/UIKit.h>
@protocol EbooManagerJianjieViewClickEvent
-(void)ActionClick:(NSDictionary*)bookinfor;
@end
@interface EbooManagerJianjieView : UIViewController
{
    IBOutlet UILabel *bookname;
    IBOutlet UIButton *nowdowning;
    IBOutlet UITextView *bookjianjie;
    NSDictionary *bookinfor;
    id<EbooManagerJianjieViewClickEvent> delegate;
}
@property  (nonatomic,retain) UIButton *nowdowning;
@property  (nonatomic,retain) UILabel *bookname;
@property  (nonatomic,retain) UITextView *bookjianjie;
@property  (nonatomic,retain) NSDictionary *bookinfor;
@property  (nonatomic,assign) id<EbooManagerJianjieViewClickEvent> delegate;
-(IBAction)CloseClick:(id)sender;
-(IBAction)ActionClick:(id)sender;

@end
