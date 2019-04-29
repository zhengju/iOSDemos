//
//  ProportionBottomView.m
//  ClipVideo
//
//  Created by leeco on 2018/11/7.
//  Copyright © 2018年 zsw. All rights reserved.
//

#import "OperationProportionView.h"
#import "UIControl+ZJBlocksKit.h"
#import "UIView+Frame.h"
@interface OperationProportionView()


@property(nonatomic, strong) UIScrollView * scrollView;

@property(nonatomic, strong) UIButton * selectedBtn;

@end

@implementation OperationProportionView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}
- (void)configureUI{
    self.backgroundColor = [UIColor blackColor];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 30)];
    title.textColor = [UIColor whiteColor];
    title.text = @"视频比例";
    [self addSubview:title];
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    
//    UIButton * duigouBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frameW-40, 5, 35, 35)];
//    [duigouBtn setImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
//    [self addSubview:duigouBtn];
//
//    [duigouBtn bk_addEventHandler:^(id sender) {
//        if ([self.delegate respondsToSelector:@selector(dismissAndSave:)]) {
//            [self.delegate dismissAndSave:self];
//        }
//    } forControlEvents:UIControlEventTouchUpInside];

    NSArray * titles = @[@"无",@"1:1",@"4:3",@"3:4",@"16:9",@"9:16",@"4:5",@"2:3",@"3:2",@"2:1",@"1:2"];
//    CGFloat w = (kScreenWidth -(4+1)*10)/5;
    
    
    CGFloat w = 60;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,70 , self.frameW, w)];
    self.scrollView.contentSize = CGSizeMake((w+10)*titles.count - 10, w);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    
    for (int i = 0; i < titles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i*(w+10), 0, w, w)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.tag = 100+i;
        __weak typeof(self) selfWeak = self;
        [button bk_addEventHandler:^(id sender) {
            if (selfWeak.selectedBtn != button) {
                selfWeak.selectedBtn.selected = NO;
                [selfWeak.selectedBtn setBackgroundColor:[UIColor grayColor]];
                selfWeak.selectedBtn = button;
                selfWeak.selectedBtn.selected = YES;
                [self.selectedBtn setBackgroundColor:[UIColor blueColor]];
            }
            if ([selfWeak.delegate respondsToSelector:@selector(proportionBottomView:)]) {
                [selfWeak.delegate proportionBottomView:button.tag-100];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        
        if (i == 0) {
            self.selectedBtn = button;
            self.selectedBtn.selected = YES;
            [self.selectedBtn setBackgroundColor:[UIColor blueColor]];
        }else{
            [button setBackgroundColor:[UIColor grayColor]];
        }
    }
}

@end
