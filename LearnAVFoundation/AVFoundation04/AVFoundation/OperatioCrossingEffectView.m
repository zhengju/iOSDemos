//
//  OperatioCrossingEffectView.m
//  ClipVideo
//
//  Created by zhengju on 2018/12/9.
//  Copyright © 2018年 zsw. All rights reserved.
//

#import "OperatioCrossingEffectView.h"
#import "ZJTransitionModel.h"



@interface OperatioCrossingEffectView()

@property(nonatomic, strong) UIScrollView * scrollView;

@property(nonatomic, strong) UIButton * selectedBtn;

@end

@implementation OperatioCrossingEffectView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}
- (void)configureUI{
    
    self.backgroundColor = [UIColor blackColor];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"转场动画";
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self).offset(5);
    }];
    
    
    //关闭按钮
    UIButton * dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frameW-40, 10, 35, 35)];
    [dismissBtn setImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
    [dismissBtn bk_addEventHandler:^(id sender) {
        if ([self.delegate respondsToSelector:@selector(dismissOperatioCrossingEffectView:)]) {
            [self.delegate dismissOperatioCrossingEffectView:self];
        }
    } forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:dismissBtn];
    //←↑→↓↖↙↗↘↕
    NSArray * titles = @[@"无",@"↙",@"←",@"→",@"↑",@"↓",@"溶解",@"←↕→",@"回",@"→|←",@"↓↑"];
    CGFloat w = 60;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(dismissBtn.frame)+30 , self.frameW, w)];
    self.scrollView.contentSize = CGSizeMake((w+10)*titles.count - 10, w);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i*(w+10), 0, w, w)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.tag = 100+i;
        WeakObj(self)
        [button bk_addEventHandler:^(id sender) {
            if (selfWeak.selectedBtn != button) {
                selfWeak.selectedBtn.selected = NO;
                [selfWeak.selectedBtn setBackgroundColor:[UIColor grayColor]];
                selfWeak.selectedBtn = button;
                selfWeak.selectedBtn.selected = YES;
                [self.selectedBtn setBackgroundColor:mainColor];
            }
            if ([selfWeak.delegate respondsToSelector:@selector(operatioCrossingEffectView:model:)]) {
                selfWeak.model.index = button.tag-100;
                [selfWeak.delegate operatioCrossingEffectView:button.tag-100 model:selfWeak.model];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        
        if (i == 0) {
            self.selectedBtn = button;
            self.selectedBtn.selected = YES;
            [self.selectedBtn setBackgroundColor:mainColor];
        }else{
            [button setBackgroundColor:[UIColor grayColor]];
        }
    }
}

- (void)setModel:(ZJTransitionModel *)model{
    _model = model;
    UIButton * button = [self viewWithTag:100+_model.index];
    
    if (self.selectedBtn != button) {
        self.selectedBtn.selected = NO;
        [self.selectedBtn setBackgroundColor:[UIColor grayColor]];
        self.selectedBtn = button;
        self.selectedBtn.selected = YES;
        [self.selectedBtn setBackgroundColor:mainColor];
    }
}
@end
