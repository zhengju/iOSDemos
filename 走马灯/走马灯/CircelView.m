//
//  CircelView.m
//  走马灯
//
//  Created by 58 on 2022/5/6.
//

#import "CircelView.h"

@interface CircelView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation CircelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        [self configUI];
        [self startTimer];
    }
    return self;
}

- (void)configUI {
    NSMutableArray *titles = [NSMutableArray array];
    self.titles = titles;
    for (int i=0; i<6; i++) {
        [titles addObject:[NSString stringWithFormat:@"%d走马灯效果",i]];
    }
    [titles addObject:@"0走马灯效果"];
    [titles addObject:@"1走马灯效果"];
    [titles addObject:@"2走马灯效果"];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 50, 150, 60)];
    [self addSubview:self.scrollView];
    
//    UIView *mengcengView = [UIView alloc]initWithFrame:CGRectMake(10, 50, 90, <#CGFloat height#>);
    
    CGFloat y = 0.0;
    for (int i = 0; i<titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 150, 25)];
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.cornerRadius = 12.5;
        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.text = titles[i];
        [self.scrollView addSubview:titleLabel];
        y = CGRectGetMaxY(titleLabel.frame)+5;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, y);
    self.scrollView.pagingEnabled = YES;
    
}
- (void)startTimer {
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"定时器走了");
        [self configScrollView];
    }];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)configScrollView {
    self.index++;
    if (self.index==self.titles.count-2) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.index=1;
    }
    [self.scrollView setContentOffset:CGPointMake(0, self.index*30) animated:YES];
}
@end
