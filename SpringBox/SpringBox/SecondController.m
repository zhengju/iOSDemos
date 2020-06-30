//
//  SecondController.m
//  SpringBox
//
//  Created by zhengsw on 2020/6/30.
//  Copyright © 2020 58. All rights reserved.
//

#import "SecondController.h"
#import "AlertManager.h"
@interface SecondController ()

@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIView *alertViewB;

@property (nonatomic,strong) AlertManager *manager;
@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二页面";
    self.manager = [AlertManager shareManager];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAlertView];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAlertViewB];
    });

}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _alertView.backgroundColor = [UIColor greenColor];
        UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        titleL.text = @"这是小弹框";
        [titleL setCenter:_alertView.center];
        [_alertView addSubview:titleL];
        [_alertView setCenter:self.view.center];
        [self.view addSubview:_alertView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlertView)];
        [_alertView addGestureRecognizer:tap];
    }
    return _alertView;
}

- (UIView *)alertViewB {
    if (!_alertViewB) {
        _alertViewB = [[UIView alloc]initWithFrame:self.view.bounds];
        _alertViewB.backgroundColor = [UIColor grayColor];
        UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"这是大弹框";
        [titleL setCenter:_alertViewB.center];
        [_alertViewB addSubview:titleL];
        [_alertViewB setCenter:self.view.center];
        [self.view addSubview:_alertViewB];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlertViewB)];
        [_alertViewB addGestureRecognizer:tap];
    }
    return _alertViewB;
}


- (void)showAlertView {
    
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    
//    config.isIntercept = NO;
    
    [self.manager alertShowWithType:@"alert" config:config success:^{
        self.alertView.hidden = NO;
    }];
}

- (void)hiddenAlertView {
    
    [self.manager alertDissMissWithType:@"alert" success:^{
        self.alertView.hidden = YES;
    }];
}

- (void)showAlertViewB {
    
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    
    [self.manager alertShowWithType:@"alertB" config:config  success:^{
        self.alertViewB.hidden = NO;
    }];
    
}

- (void)hiddenAlertViewB {
    
    [self.manager alertDissMissWithType:@"alertB" success:^{
        self.alertViewB.hidden = YES;
    }];
}

@end
