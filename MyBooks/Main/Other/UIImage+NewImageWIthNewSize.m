/*
 *  未考虑图片大小问题
 */
#import "UIImage+NewImageWIthNewSize.h"

@implementation UIImage (NewImageWIthNewSize)

- (UIImage*)dropImageRadius
{
    CGSize startSize = self.size;
    CGRect newRect = CGRectMake(7, 7, startSize.width-14, startSize.height-14);
    
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
    
    return newImage;
    
}
@end
