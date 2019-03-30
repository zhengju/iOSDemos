//
//  ViewController.m
//  CallPhoneDemo
//
//  Created by zhengju on 2019/3/30.
//  Copyright © 2019年 zhengju. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)uRLRequesCallPhone:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)uRLTelprompCallPbone:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",@"10086"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)uRLTellCallPhone:(UIButton *)sender {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"10086"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}


@end
