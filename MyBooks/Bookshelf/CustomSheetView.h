//
//  CustomSheetView.h
//  OneWord
//
//  Created by wukai on 14-8-13.
//  Copyright (c) 2014年 jiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomSheetView;
@protocol CustomSheetViewDelegate <NSObject>

- (void)sheetView:(CustomSheetView *)view pressedButtonWithIndex:(NSInteger)index;

@end

@interface CustomSheetView : UIView

@property (nonatomic, assign) id <CustomSheetViewDelegate> delegate;

- (void)configureTheme;

@end
