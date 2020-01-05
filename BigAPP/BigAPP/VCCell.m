//
//  VCCell.m
//  BigAPP
//
//  Created by zhengju on 2019/12/20.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "VCCell.h"
#import "VCModel.h"
@interface VCCell()
@property(strong,nonatomic) UILabel * titleL;
@property(strong,nonatomic) UIImageView * icon;

@property(strong,nonatomic) NSString * urlString;
@end


@implementation VCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(VCModel *)model{
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:_model.iconURL] placeholderImage:[UIImage imageNamed:@""]];
    
    _titleL.text = _model.title;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.icon.backgroundColor = [UIColor redColor];
        [self addSubview:self.icon];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(105, 30, 100, 35)];
        [self addSubview:self.titleL];
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
