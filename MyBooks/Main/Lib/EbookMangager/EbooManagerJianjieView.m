//
//  EbooManagerJianjieView.m
//  Smallebook
//
//  Created by lzq on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EbooManagerJianjieView.h"
@implementation EbooManagerJianjieView
@synthesize bookname,bookjianjie,bookinfor,delegate,nowdowning;
-(void)dealloc{
    [nowdowning release];
    [bookname release];
    [bookjianjie release];
    [bookinfor release];
    [super dealloc];
}
-(IBAction)CloseClick:(id)sender{
    self.view.alpha=1.0;
    [UIView animateWithDuration:0.75
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
                         self.view.alpha=0.0;
					 }
					 completion:^(BOOL finished){ 
                         [self.view removeFromSuperview];
                         [self release];
                     }];
}
-(IBAction)ActionClick:(id)sender{
    if (delegate && [(NSObject*)delegate respondsToSelector:@selector(ActionClick:)]) 
    {
        [self.delegate ActionClick:self.bookinfor]; 
    } 
    [self CloseClick:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bookname.text=[self.bookinfor objectForKey:@"title"];
    self.bookjianjie.text=[NSString stringWithFormat:@"作者：%@%\r\n分类：%@%\r\n字数：%@\r\n热度：%@\r\n简介：\r\n   %@\r\n",[self.bookinfor objectForKey:@"author"],[self.bookinfor objectForKey:@"tag"],[self.bookinfor objectForKey:@"words"],[self.bookinfor objectForKey:@"clicks"],[[[self.bookinfor objectForKey:@"summary"] stringByConvertingHTMLToPlainText] stringByReplacingOccurrencesOfString:@" " withString:@"\r\n    "]];
    if ([self.bookinfor objectForKey:@"status"] && [[self.bookinfor objectForKey:@"status"] intValue]==1) {
        self.nowdowning.enabled=NO;
        [self.nowdowning setTitle:@"已下载" forState:0];
    }else {
        self.nowdowning.enabled=YES;
        //[self.nowdowning setTitle:@"立即下载" forState:0];
    }
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIDeviceOrientationPortraitUpsideDown);
//}

@end
