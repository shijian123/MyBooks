//
//  CYBookListCell.m
//  MyBooks
//
//  Created by zcy on 2018/5/10.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "CYBookListCell.h"

@interface CYBookListCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookInfo;

@end

@implementation CYBookListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CYBookListCell" owner:self options:nil] firstObject];
    }
    return self;
}

+ (instancetype)cellWithTaleView:(UITableView *)tableView{
    CYBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYBookListCell"];
    if (cell == nil) {
        cell = [[CYBookListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CYBookListCell"];
    }
    return cell;
}


- (void)setModel:(BmobObject *)model{
    _model = model;
    [self.bookImg sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"d_books.png"]];
    self.bookName.text = [model objectForKey:@"title"];
    self.bookAuthor.text = [model objectForKey:@"author"];
    self.bookInfo.text = [model objectForKey:@"intro"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
