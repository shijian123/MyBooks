//
//  BookReadingBookMarkCell.h 
//  SimpleMagazine
//
//  Created by lzq on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookReadingBookMarkCell : UITableViewCell
{
     UIImageView*henxian;
     UILabel*chapterindextitle;
     UILabel *chaptertitle;
     UIImageView*tophenxian;

}
@property(nonatomic,retain)UIImageView*henxian;
@property(nonatomic,retain)UIImageView*tophenxian;
@property(nonatomic,retain)UILabel*chapterindextitle;
@property(nonatomic,retain)UILabel*chaptertitle;
@end
