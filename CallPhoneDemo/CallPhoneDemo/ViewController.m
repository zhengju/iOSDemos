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

/**
 iOS8:有弹框提示，点击确定，拨打电话(iOS8.3下测试)
 iOS11:有弹框提示，点击确定，拨打电话(iOS11.3.1下测试)
 iOS12:有弹框提示，点击确定，拨打电话(iOS12.0下测试)
 @param sender sender
 */
- (IBAction)uRLRequesCallPhone:(UIButton *)sender {
    NSMutableString * callPhone=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callPhone]]];
    [self.view addSubview:callWebview];
}

/**
 iOS8:有弹框提示，点击确定，拨打电话(iOS8.3下测试)
 iOS11:有弹框提示，点击确定，拨打电话(iOS11.3.1下测试)
 iOS12:有弹框提示，点击确定，拨打电话(iOS12.0下测试)
 @param sender sender
 */
- (IBAction)uRLTelprompCallPbone:(UIButton *)sender {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"10086"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

/**
 iOS8:未弹框提示，直接拨打电话(iOS8.3下测试)
 iOS11:有弹框提示，点击确定，拨打电话(iOS11.3.1下测试)
 iOS12:有弹框提示，点击确定，拨打电话(iOS12.0下测试)
 @param sender sender
 */
- (IBAction)uRLTellCallPhone:(UIButton *)sender {
    NSMutableString * callPhone=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    
   
}


@end
