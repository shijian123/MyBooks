//
//  listcell.h
//  BLReadEngineAl
//
//  Created by 3G 北邮 on 13-1-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listcell : UITableViewCell
{
    IBOutlet UIImageView* choosed;
    IBOutlet UILabel*     lab;
    IBOutlet UILabel*     index;
    IBOutlet   UIImageView* daytimeline;
    IBOutlet  UIImageView* nighttimeline;
    
}
@property(assign,nonatomic)UIImageView* choosed;
@property(assign)UILabel*     lab;
@property(assign)UIImageView* daytimeline;
@property(assign)UIImageView* nighttimeline;
@property(assign)UILabel*     index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  movde:(NSString*)divicemode  device:(NSString*)device;


@end
