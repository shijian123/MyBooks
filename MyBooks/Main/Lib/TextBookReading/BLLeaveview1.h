

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface BLLeaveview1 : UIView
{
    CGFloat MovePoint;
    BOOL  isVertical;
    BOOL  TouchFeetRight;
@private
    CALayer *contentLayer;
    CALayer *contentLayercontent;
    CALayer*  backLayer;
    CALayer* backcontentLayer;
    CALayer* backcontentshadow;
    CGSize pageSize;
    CAGradientLayer *contentLayerShadow;
	CAGradientLayer *backshadow;
	CAGradientLayer *bottomPageShadow;
    int shadewidth;
    int topshadewith;
    UIColor* shadecolor;
}
@property(retain,nonatomic)UIColor* shadecolor;
-(void)setcolorsss;
- (id)initWithFrame:(CGRect)frame point:(float)point;
- (void) setUpLayers;
- (void)setLayerFrames;
-(CGFloat)MovePoint;
-(void)setMovePoint:(CGFloat)MovePoint;
-(void)setContent:(CGImageRef)content;

@end
