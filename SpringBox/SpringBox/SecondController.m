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
@property (nonatomic,strong) UIView *alertViewC;

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
        [self showAlertViewC];
        [self alert];
    });

}

- (void)alert {
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    config.priority = AlertPriority3;
    __weak typeof(self) weakSelf = self;
    [self.manager alertShowWithType:@"alertD" config:config show:^(BOOL isSuccess, NSString * _Nonnull message) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isSuccess) {
            [strongSelf _alertShow];
        }
    } dismiss:^(BOOL isSuccess, NSString * _Nonnull message) {
        
    }];

}

- (void)_alertShow {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是个提示弹框" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self _alertHidden];
       }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _alertHidden];
    }];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_alertHidden {
    [self.manager alertDissMissWithType:@"alertD"];
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
        titleL.text = @"这是大弹框B";
        [titleL setCenter:_alertViewB.center];
        [_alertViewB addSubview:titleL];
        [_alertViewB setCenter:self.view.center];
        [self.view addSubview:_alertViewB];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlertViewB)];
        [_alertViewB addGestureRecognizer:tap];
    }
    return _alertViewB;
}
- (UIView *)alertViewC {
    if (!_alertViewC) {
        _alertViewC = [[UIView alloc]initWithFrame:self.view.bounds];
        _alertViewC.backgroundColor = [UIColor grayColor];
        UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"这是大弹框C";
        [titleL setCenter:_alertViewC.center];
        [_alertViewC addSubview:titleL];
        [_alertViewC setCenter:self.view.center];
        [self.view addSubview:_alertViewC];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlertViewC)];
        [_alertViewC addGestureRecognizer:tap];
    }
    return _alertViewC;
}

- (void)showAlertView {
    
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    config.priority = 3;
//    config.isIntercept = NO;
    __weak typeof(self) weakSelf = self;
    [self.manager alertShowWithType:@"alert" config:config show:^(BOOL isSuccess, NSString * _Nonnull message) {
        if (isSuccess) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.alertView.hidden = NO;
        }
    } dismiss:^(BOOL isSuccess, NSString * _Nonnull message) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.alertView.hidden = YES;
        NSLog(@"alertView 来隐藏了 %@ %@",[NSThread currentThread],message);
    }];

}

- (void)hiddenAlertView {
    
    [self.manager alertDissMissWithType:@"alert"];
}

- (void)showAlertViewB {
    
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    config.priority = AlertPriority3;
    __weak typeof(self) weakSelf = self;
    [self.manager alertShowWithType:@"alertB" config:config show:^(BOOL isSuccess, NSString * _Nonnull message) {
        if (isSuccess) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.alertViewB.hidden = NO;
        }
    } dismiss:^(BOOL isSuccess, NSString * _Nonnull message) {
         __strong typeof(weakSelf) strongSelf = weakSelf;

        strongSelf.alertViewB.hidden = YES;
    }];

}

- (void)hiddenAlertViewB {
    
    [self.manager alertDissMissWithType:@"alertB"];
}


- (void)showAlertViewC {
    
    AlertConfig * config = [[AlertConfig alloc]initWithPatams:@{} activate:YES];
    config.priority = AlertPriority2;
    config.isIntercept = NO;
    __weak typeof(self) weakSelf = self;
    [self.manager alertShowWithType:@"alertC" config:config show:^(BOOL isSuccess, NSString * _Nonnull message) {
        if (isSuccess) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.alertViewC.hidden = NO;
        }else {
            NSLog(@"error is %@",message);
        }
    } dismiss:^(BOOL isSuccess, NSString * _Nonnull message) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.alertViewC.hidden = YES;
    }];
}

- (void)hiddenAlertViewC {
    [self.manager alertDissMissWithType:@"alertC"];
}

- (void)dealloc {
    [self.manager removeWithType:@"alert"];
    [self.manager removeWithType:@"alertB"];
    [self.manager removeWithType:@"alertC"];
    [self.manager removeWithType:@"alertD"];
    
}
@end
