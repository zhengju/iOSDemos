//
//  LoginController.m
//  BigAPP
//
//  Created by zhengju on 2019/12/30.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "LoginController.h"
#import "ReactiveCocoa.h"
#import "LoginViewModel.h"
@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *pwdF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(strong,nonatomic) LoginViewModel * viewModel;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.viewModel,name) = self.nameF.rac_textSignal;
    
    RAC(self.viewModel,pwd) = self.pwdF.rac_textSignal;
    
    RAC(self.loginBtn,enabled) = self.viewModel.btnEnableSignal;
    
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"登录成功，跳转页面");
    }];

    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        NSLog(@"点击登陆了呢 %@",x);
        [self.viewModel.loginCommand execute:@{@"name":self.nameF.text,@"pwd":self.pwdF.text}];
    }];
    
    //测试
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"send前..");
        [subscriber sendNext:@"12 34 45 67"];
        NSLog(@"send后..");
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号 销毁了...");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"信号订阅了.. %@",x);
    }];
    
}
- (IBAction)loginAction:(UIButton *)sender {
}

- (LoginViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[LoginViewModel alloc]init];
    }
    return _viewModel;
}

@end
