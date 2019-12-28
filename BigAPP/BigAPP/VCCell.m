//
//  VCCell.m
//  BigAPP
//
//  Created by zhengju on 2019/12/20.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "VCCell.h"

@implementation VCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.icon.backgroundColor = [UIColor redColor];
        [self addSubview:self.icon];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUrlString:(NSString *)urlString{
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
    
}
@end
