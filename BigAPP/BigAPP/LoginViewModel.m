//
//  LoginViewModel.m
//  BigAPP
//
//  Created by zhengju on 2019/12/30.
//  Copyright © 2019 zhengju. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    _btnEnableSignal = [RACSignal combineLatest:@[RACObserve(self,name),RACObserve(self,pwd)] reduce:^id(NSString *name,NSString*pwd){
        return @(name.length&&pwd.length>5);
    }];
    
    //模拟网络请求
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"组合参数，准备发送登录请求 -%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"开始请求");
            NSLog(@"请求成功");
            NSLog(@"处理数据");
            [subscriber sendNext:@"处理完成，数据给你"];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"结束了");
            }];
        }];
    }];
    
  
    
    [[_loginCommand.executing skip:1]subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"正在执行中...");
        }else{
            NSLog(@"执行结束了...");
        }
    }];
    
}
@end
