//
//  CustomSegmentedControl.h
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBookLocalStore.h"
@interface CustomSegmentedControlImages : NSObject
{
    NSString *defualtImagePath;
    NSString *checkImagePath;
}
+(id)initWithImages:(NSString*)InputdefualtImagePath CheckImagePath:(NSString*)InputcheckImagePath;
@property(nonatomic,retain)  NSString *defualtImagePath;
@property(nonatomic,retain)  NSString *checkImagePath;
@end
@protocol CustomSegmentedControlDelegate  ;
@interface CustomSegmentedControl : UIView
{
    NSInteger selectedSegmentIndex;
    NSArray *ImageItems;
    id <CustomSegmentedControlDelegate> delegate;
}
@property(nonatomic,assign )id <CustomSegmentedControlDelegate> delegate;
@property(nonatomic,retain)NSArray *ImageItems;
- (id)initWithFrame:(CGRect)frame items:(NSArray*)buttonImageItems;
- (void)ADDitems:(NSArray*)buttonImageItems;
-(void)setSelectedSegmentIndex:(NSInteger)selectedsegmentindex;
-(NSInteger)selectedSegmentIndex;
@end
@protocol CustomSegmentedControlDelegate  

- (void)SelectIndexChangedForCustomSegmentedControl:(NSUInteger)segmentIndex;  
 
@end  