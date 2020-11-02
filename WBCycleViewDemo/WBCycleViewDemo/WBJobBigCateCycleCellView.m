//
//  WBJobBigCateCycleCellView.m
//  WBCycleViewDemo
//
//  Created by zhengsw on 2020/10/26.
//

#import "MyCellView.h"

@interface MyCellView()
@property(nonatomic,strong)UIImageView *iconImg;
@property(nonatomic,strong)UILabel *titleLable;
@end

@implementation MyCellView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = 5;
    [self addSubview:self.iconImg];
    self.iconImg.alpha = 0.0;
    
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 110+5, 120-20, 25)];
    [self addSubview:self.titleLable];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.alpha = 0;

}

- (void)configData:(NSDictionary *)data {
    NSString * url = [data objectForKey:@"url"];
    
    if ([url hasPrefix:@"http"]) {

    }else {
        self.iconImg.image = [UIImage imageNamed:url];
    }
    NSString *title = [data objectForKey:@"title"];
    self.titleLable.text = title;
}

- (void)show {

    self.titleLable.alpha = 0;
    self.iconImg.alpha = 0.0;
    self.iconImg.transform = CGAffineTransformMakeScale( 0.6f, 0.6f);
    self.titleLable.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.4 animations:^{
        self.iconImg.transform = CGAffineTransformMakeScale( 1.0f, 1.0f);
        self.iconImg.alpha = 1.0;
        self.titleLable.alpha = 1;
        self.titleLable.transform = CGAffineTransformMakeScale(1.0, 1.0);

    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLable.alpha = 1;
        self.titleLable.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)hidden {
    self.iconImg.alpha = 1.0;
    self.titleLable.alpha = 1;

    self.titleLable.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.iconImg.transform = CGAffineTransformMakeScale( 1.0f, 1.0f);
    [UIView animateWithDuration:0.4 animations:^{
        self.iconImg.transform = CGAffineTransformMakeScale( 0.6f, 0.6f);
        self.iconImg.alpha = 0.0;
        self.titleLable.alpha = 0.0;
        self.titleLable.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLable.alpha = 0.0;
        self.titleLable.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
}

@end

